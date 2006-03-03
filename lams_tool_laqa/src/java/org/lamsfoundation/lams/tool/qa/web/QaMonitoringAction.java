/*
 *Copyright (C) 2005 LAMS Foundation (http://lamsfoundation.org)
 *
 *This program is free software; you can redistribute it and/or modify
 *it under the terms of the GNU General Public License as published by
 *the Free Software Foundation; either version 2 of the License, or
 *(at your option) any later version.
 *
 *This program is distributed in the hope that it will be useful,
 *but WITHOUT ANY WARRANTY; without even the implied warranty of
 *MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *GNU General Public License for more details.
 *
 *You should have received a copy of the GNU General Public License
 *along with this program; if not, write to the Free Software
 *Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
 *USA
 *
 *http://www.gnu.org/licenses/gpl.txt
 */

 /**
 * @author Ozgur Demirtas
 */

package org.lamsfoundation.lams.tool.qa.web;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.Globals;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.lamsfoundation.lams.tool.exception.ToolException;
import org.lamsfoundation.lams.tool.qa.QaAppConstants;
import org.lamsfoundation.lams.tool.qa.QaContent;
import org.lamsfoundation.lams.tool.qa.QaUsrResp;
import org.lamsfoundation.lams.tool.qa.service.IQaService;
import org.lamsfoundation.lams.web.action.LamsDispatchAction;
import org.lamsfoundation.lams.web.util.AttributeNames;


public class QaMonitoringAction extends LamsDispatchAction implements QaAppConstants
{
	static Logger logger = Logger.getLogger(QaMonitoringAction.class.getName());

	public static String SELECTBOX_SELECTED_TOOL_SESSION ="selectBoxSelectedToolSession";
	public static Integer READABLE_TOOL_SESSION_COUNT = new Integer(1);
 
    public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) 
        throws IOException, ServletException, ToolException{
    	logger.debug("dispatching unspecified...");
	 	return null;
    }
        
    
	/**
	 * switches to Stats tab of the Monitoring url
	 * getStats(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException,
                                         ServletException
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws IOException
	 * @throws ServletException
	 */
    public ActionForward getStats(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException,
                                         ServletException
	{
    	logger.debug("dispatching getStats..." + request);
    	request.getSession().setAttribute(EDIT_RESPONSE, new Boolean(false));
    	
    	request.getSession().setAttribute(CURRENT_MONITORING_TAB, "stats");
 		return (mapping.findForward(LOAD_MONITORING));
	}

    
    /**
     * switches to instructions tab of the monitoring url.
     * getInstructions(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException,
                                         ServletException
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws IOException
     * @throws ServletException
     */
    public ActionForward getInstructions(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException,
                                         ServletException
	{
    	logger.debug("dispatching getInstructions..." + request);
    	request.getSession().setAttribute(EDIT_RESPONSE, new Boolean(false));

    	request.getSession().setAttribute(CURRENT_MONITORING_TAB, "instructions");
	 	return (mapping.findForward(LOAD_MONITORING));
	}

    
    /**
     * switches to summary tab of the monitoring url
     * getSummary(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException,
                                         ServletException
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws IOException
     * @throws ServletException
     */
    public ActionForward getSummary(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException,
                                         ServletException
	{
    	logger.debug("dispatching getSummary..." + request);
    	request.getSession().setAttribute(EDIT_RESPONSE, new Boolean(false));
    	
    	IQaService qaService = (IQaService)request.getSession().getAttribute(TOOL_SERVICE);
    	logger.debug("qaService: " + qaService);
		
    	Long toolContentId =(Long) request.getSession().getAttribute(TOOL_CONTENT_ID);
	    logger.debug("toolContentId: " + toolContentId);
	    
	    QaContent qaContent=qaService.loadQa(toolContentId.longValue());
		logger.debug("existing qaContent:" + qaContent);
		
    	/* this section is related to summary tab. Starts here. */
		Map summaryToolSessions=MonitoringUtil.populateToolSessions(request, qaContent, qaService);
		logger.debug("summaryToolSessions: " + summaryToolSessions);
		if (summaryToolSessions.isEmpty())
		{
			/* inform in the Summary tab that the tool has no active sessions */
			request.setAttribute(USER_EXCEPTION_NO_TOOL_SESSIONS, new Boolean(true));
		}
		 
		request.getSession().setAttribute(SUMMARY_TOOL_SESSIONS, summaryToolSessions);
	    logger.debug("SUMMARY_TOOL_SESSIONS: " + request.getSession().getAttribute(SUMMARY_TOOL_SESSIONS));
	    /* ends here. */
    	
 		request.getSession().setAttribute(CURRENT_MONITORING_TAB, "summary");   
 		return (mapping.findForward(LOAD_MONITORING));
	}

    /**
     * gets called when the user selects a group from dropdown box in the summary tab 
     * submitSession(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException,
                                         ServletException
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws IOException
     * @throws ServletException
     */
    public ActionForward submitSession(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException,
                                         ServletException
	{
    	logger.debug("dispatching submitSession...");
    	request.getSession().setAttribute(EDIT_RESPONSE, new Boolean(false));
    	
    	QaMonitoringForm qaMonitoringForm = (QaMonitoringForm) form;
	 	String currentMonitoredToolSession=qaMonitoringForm.getSelectedToolSessionId(); 
	    logger.debug("currentMonitoredToolSession: " + currentMonitoredToolSession);
	    
	    if (currentMonitoredToolSession.equals("All"))
	    {
		    request.getSession().setAttribute(SELECTION_CASE, new Long(2));
	    }
	    else
	    {
	    	/* SELECTION_CASE == 1 indicates a selected group other than "All" */
		    request.getSession().setAttribute(SELECTION_CASE, new Long(1));
	    }
	    logger.debug("SELECTION_CASE: " + request.getSession().getAttribute(SELECTION_CASE));
	    
	    
	    request.getSession().setAttribute(CURRENT_MONITORED_TOOL_SESSION, currentMonitoredToolSession);
	    logger.debug("CURRENT_MONITORED_TOOL_SESSION: " + request.getSession().getAttribute(CURRENT_MONITORED_TOOL_SESSION));
	    
    	return (mapping.findForward(LOAD_MONITORING));	
	}

	
    public ActionForward editResponse(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException,
                                         ServletException
	{
    	logger.debug("dispatching editResponse...");
    	
    	QaMonitoringForm qaMonitoringForm = (QaMonitoringForm) form;
	 	
	    String responseId=qaMonitoringForm.getResponseId();
	    logger.debug("responseId: " + responseId);
	    request.getSession().setAttribute(EDIT_RESPONSE, new Boolean(true));
	    request.getSession().setAttribute(EDITABLE_RESPONSE_ID, responseId);
	    
	    refreshUserInput(request);
	    
	    return (mapping.findForward(LOAD_MONITORING));	
	}
    

    public ActionForward updateResponse(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException,
                                         ServletException
	{
    	logger.debug("dispatching updateResponse...");

    	IQaService qaService = (IQaService)request.getSession().getAttribute(TOOL_SERVICE);
    	logger.debug("qaService: " + qaService);

    	QaMonitoringForm qaMonitoringForm = (QaMonitoringForm) form;
	 	
	    String responseId=qaMonitoringForm.getResponseId();
	    logger.debug("responseId: " + responseId);
	    
	    String updatedResponse=request.getParameter("updatedResponse");
	    logger.debug("updatedResponse: " + updatedResponse);
	    QaUsrResp qaUsrResp= qaService.retrieveQaUsrResp(new Long(responseId).longValue());
	    logger.debug("qaUsrResp: " + qaUsrResp);
	    qaUsrResp.setAnswer(updatedResponse);
	    qaService.updateQaUsrResp(qaUsrResp);
	    logger.debug("response updated.");
	    
	    request.getSession().setAttribute(EDIT_RESPONSE, new Boolean(false));
	    
	    refreshUserInput(request);
	    return (mapping.findForward(LOAD_MONITORING));	
	}

    
    public ActionForward deleteResponse(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException,
                                         ServletException
	{
    	logger.debug("dispatching deleteResponse...");
    	request.getSession().setAttribute(EDIT_RESPONSE, new Boolean(false));

    	IQaService qaService = (IQaService)request.getSession().getAttribute(TOOL_SERVICE);
    	logger.debug("qaService: " + qaService);

    	QaMonitoringForm qaMonitoringForm = (QaMonitoringForm) form;
	 	
	    String responseId=qaMonitoringForm.getResponseId();
	    logger.debug("responseId: " + responseId);
	    
	    QaUsrResp qaUsrResp= qaService.retrieveQaUsrResp(new Long(responseId).longValue());
	    logger.debug("qaUsrResp: " + qaUsrResp);
	  
	    qaService.removeUserResponse(qaUsrResp);
	    logger.debug("response deleted.");
	    
	    logger.debug("CURRENT_MONITORED_TOOL_SESSION: " + request.getSession().getAttribute(CURRENT_MONITORED_TOOL_SESSION));
	    
	    refreshUserInput(request);
    	return (mapping.findForward(LOAD_MONITORING));	
	}


    public void refreshUserInput(HttpServletRequest request)
    {
    	IQaService qaService = (IQaService)request.getSession().getAttribute(TOOL_SERVICE);
    	logger.debug("qaService: " + qaService);
        
        Long toolContentId =(Long) request.getSession().getAttribute(TOOL_CONTENT_ID);
        logger.debug("toolContentId: " + toolContentId);
        
        QaContent qaContent=qaService.loadQa(toolContentId.longValue());
    	logger.debug("existing qaContent:" + qaContent);
    	
        List listMonitoredAnswersContainerDTO=MonitoringUtil.buildGroupsQuestionData(request, qaContent);
        request.getSession().setAttribute(LIST_MONITORED_ANSWERS_CONTAINER_DTO, listMonitoredAnswersContainerDTO);
        logger.debug("LIST_MONITORED_ANSWERS_CONTAINER_DTO: " + request.getSession().getAttribute(LIST_MONITORED_ANSWERS_CONTAINER_DTO));
    }
    
    
	/**
     * persists error messages to request scope
     * persistError(HttpServletRequest request, String message)
     * @param request
     * @param message
     */
	public void persistError(HttpServletRequest request, String message)
	{
		ActionMessages errors= new ActionMessages();
		errors.add(Globals.ERROR_KEY, new ActionMessage(message));
		logger.debug("add " + message +"  to ActionMessages:");
		saveErrors(request,errors);	    	    
	}
  
	
    /**
     * boolean isOnlyContentIdAvailable(HttpServletRequest request)
     * @param request
     * @return boolean
     */
    public boolean isOnlyContentIdAvailable(HttpServletRequest request)
    {
        boolean existsContentId=false;
        String strToolContentId=request.getParameter(AttributeNames.PARAM_TOOL_CONTENT_ID);
        if ((strToolContentId != null) && (strToolContentId.length() > 0))
            existsContentId=true;
        
        boolean existsToolSession=false;
        for (int toolSessionIdCounter=1; toolSessionIdCounter < MAX_TOOL_SESSION_COUNT.intValue(); toolSessionIdCounter++)
        {
            String strToolSessionId=request.getParameter(AttributeNames.PARAM_TOOL_SESSION_ID + toolSessionIdCounter);
            if ((strToolSessionId != null) && (strToolSessionId.length() > 0))
            {
                existsToolSession=true;
            }
        }
        
        if (existsContentId && (!existsToolSession))
        {
            logger.debug("OnlyContentIdAvailable");
            return true;
        }
        else
        {
            logger.debug("Not OnlyContentIdAvailable");
            return false;
        }
    }

}