package org.lamsfoundation.lams.web;

import java.io.IOException;
import java.util.Date;
import java.util.Calendar;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.mail.internet.AddressException;
import javax.mail.MessagingException;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.apache.log4j.Logger;
import org.hibernate.id.IdentifierGenerator;
import org.hibernate.id.UUIDHexGenerator;
import org.hibernate.Hibernate;
import org.hibernate.id.Configurable;


import org.lamsfoundation.lams.usermanagement.User;
import org.lamsfoundation.lams.usermanagement.ForgotPasswordRequest;
import org.lamsfoundation.lams.usermanagement.service.IUserManagementService;
import org.lamsfoundation.lams.util.Configuration;
import org.lamsfoundation.lams.util.FileUtilException;
import org.lamsfoundation.lams.util.MessageService;
import org.lamsfoundation.lams.util.Emailer;


/**
 * Servlet to handle forgot password requests
 * 
 * This servlet handles two type of requests, one to save the request and send an email to the user,
 * and one to save the new password
 * @author lfoxton
 *
 * @web:servlet name="forgotPasswordServlet"
 * @web:servlet-mapping url-pattern="/ForgotPasswordRequest"
 */
public class ForgotPasswordServlet extends HttpServlet
{
	private static Logger log = Logger.getLogger(ForgotPasswordServlet.class);
	
	// states
	public static String SMTP_SERVER_NOT_SET 		= "error.support.email.not.set";
	public static String EMAIL_DOES_NOT_MATCH 		= "error.email.does.not.match";
	public static String USER_NOT_FOUND 			= "error.user.not.found";
	public static String PASSWORD_REQUEST_EXPIRED 	= "error.password.request.expired";
	public static String SUCCESS_REQUEST_EMAIL 		= "forgot.password.email.sent";
	public static String SUCCESS_CHANGE_PASS 		= "heading.password.changed.screen";
	
	public static int MILLISECONDS_IN_A_DAY 	= 86400000;
	
	private static String STATE = "&state=";
	private static String LANGUAGE_KEY = "&languageKey=";
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) 
		throws ServletException, IOException 
	{
		String method = request.getParameter("method");
		
		if (method.equals("requestEmail"))
		{
			String login = request.getParameter("login");
			String email = request.getParameter("email");
			handleEmailRequest(login, email, response);
		}
		else if (method.equals("requestPasswordChange"))
		{
			String newPassword 			= request.getParameter("newPassword");
			String key 					= request.getParameter("key"); 
			handlePasswordChange(newPassword, key, response);
		}
		else
		{
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
		}
		
	}
	
	/**
	 * Handles the first step of the forgot login process, sending the email to the user.
	 * An email is sent with a link and key attached to identify the forgot login request
	 * @param login
	 * @param email
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void handleEmailRequest(String login, String email, HttpServletResponse response)
		throws ServletException, IOException
	{

		int success=0;
		String languageKey = "";
		
		
		
		boolean err = false;
		
		if (login==null||login.equals("")||email==null||email.equals(""))
		{
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		String SMPTServer = Configuration.get("SMTPServer");
		String supportEmail = Configuration.get("LamsSupportEmail");
		
		
		
		if (SMPTServer==null||SMPTServer.equals("")||supportEmail==null||supportEmail.equals(""))
		{
			// Validate SMTP not set up
			languageKey = this.SMTP_SERVER_NOT_SET;
		}
		else
		{
			WebApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(this.getServletContext());
			IUserManagementService userService = (IUserManagementService) ctx.getBean("userManagementService");
			MessageService messageService = (MessageService)ctx.getBean("centralMessageService");
	
			if (userService.getUserByLogin(login)!=null)
			{
				User user = userService.getUserByLogin(login);
				
				if (user.getEmail().equals(email))
				{
					// generate a key for the request
					String key = generateUniqueKey();
					
					// all good, save the request in the db
					ForgotPasswordRequest fp = new ForgotPasswordRequest();
					fp.setRequestDate(new Date());
					fp.setUserId(user.getUserId());
					fp.setRequestKey(key);
					userService.save(fp);
					
					// Constructing the body of the email
					String body = messageService.getMessage("forgot.password.email.body")
						+ "\n\n"
						+ Configuration.get("ServerURL")
						+ "forgotPasswordChange.jsp?key="
						+ key;
	
					// send the email
					try{
						  Emailer.sendFromSupportEmail(
							messageService.getMessage("forgot.password.email.subject"),
							email,
							body
							);
						  languageKey = this.SUCCESS_REQUEST_EMAIL;
						  success = 1;
					}
					catch (AddressException e) 
			        {
						// failure handling
						log.debug(e);
						response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			        } 
			        catch (MessagingException e) 
			        {
			        	// failure handling 
			        	log.debug(e);
			        	response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			        }
					catch (Exception e)
					{
						// failure handling
						log.debug(e);	
						response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					}
	
				}
				else
				{
					// validate email does not match user
					languageKey = this.EMAIL_DOES_NOT_MATCH;
				}
				
			}
			else
			{
				// validate user is not found
				languageKey = this.USER_NOT_FOUND;
			}
		}

		response.sendRedirect(Configuration.get("ServerURL") + "forgotPasswordProc.jsp?" + 
				STATE + 
				success + 
				LANGUAGE_KEY + 
				languageKey);

	}
	
	/**
	 * Updates the user's password
	 * @param key the key of the forgot password request
	 */
	public void handlePasswordChange(String newPassword, String key, HttpServletResponse response)
		throws ServletException, IOException
	{
		int success=0;
		String languageKey = "";
		
		if (key==null||key.equals("")||newPassword==null||newPassword.equals(""))
		{
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		
		WebApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(this.getServletContext());
		IUserManagementService userService = (IUserManagementService) ctx.getBean("userManagementService");
		
		ForgotPasswordRequest fp = userService.getForgotPasswordRequest(key);
		long cutoffTime = fp.getRequestDate().getTime() + MILLISECONDS_IN_A_DAY;
		Date now = new Date();
	    long nowLong = now.getTime();

		if (nowLong < cutoffTime)
		{
			User user = (User)userService.findById(User.class, fp.getUserId());
			userService.updatePassword(user.getLogin(), newPassword);
			languageKey = this.SUCCESS_CHANGE_PASS;
			success = 1;
		}
		else
		{
			// validate password request expired
			languageKey = this.PASSWORD_REQUEST_EXPIRED;
		}
		
		response.sendRedirect(Configuration.get("ServerURL") + "forgotPasswordProc.jsp?" + 
				STATE + 
				success + 
				LANGUAGE_KEY + 
				languageKey);
	}
	
	/**
	 * Generates the unique key used for the forgot password request
	 * @return a unique key
	 * @throws FileUtilException
	 * @throws IOException
	 */
	public static String generateUniqueKey()
	{
		String newUniqueContentFolderID = null;
		Properties props = new Properties();
		
		IdentifierGenerator uuidGen = new UUIDHexGenerator();
		( (Configurable) uuidGen).configure(Hibernate.STRING, props, null);
		
		return ((String) uuidGen.generate(null, null)).toLowerCase();
	}
	
}
