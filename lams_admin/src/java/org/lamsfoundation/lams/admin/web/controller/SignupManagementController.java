package org.lamsfoundation.lams.admin.web.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.lamsfoundation.lams.admin.web.form.SignupManagementForm;
import org.lamsfoundation.lams.signup.model.SignupOrganisation;
import org.lamsfoundation.lams.signup.service.ISignupService;
import org.lamsfoundation.lams.usermanagement.Organisation;
import org.lamsfoundation.lams.usermanagement.service.IUserManagementService;
import org.lamsfoundation.lams.util.MessageService;
import org.lamsfoundation.lams.util.WebUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 *
 *
 *
 *
 *
 *
 */
@RequestMapping("/signupManagement")
public class SignupManagementController {

    private static Logger log = Logger.getLogger(SignupManagementController.class);
    private static ISignupService signupService = null;
    private static IUserManagementService userManagementService = null;

    @Autowired
    private WebApplicationContext applicationContext;

    @Autowired
    @Qualifier("adminMessageService")
    private MessageService adminMessageService;

    @RequestMapping("/start")
    public String execute(@ModelAttribute SignupManagementForm signupForm, HttpServletRequest request,
	    HttpServletResponse response) {

	try {
	    if (signupService == null) {
		WebApplicationContext wac = WebApplicationContextUtils
			.getRequiredWebApplicationContext(applicationContext.getServletContext());
		signupService = (ISignupService) wac.getBean("signupService");
	    }
	    if (userManagementService == null) {
		WebApplicationContext wac = WebApplicationContextUtils
			.getRequiredWebApplicationContext(applicationContext.getServletContext());
		userManagementService = (IUserManagementService) wac.getBean("userManagementService");
	    }

	    String action = WebUtil.readStrParam(request, "action", true);

	    if (StringUtils.equals(action, "list") || request.getAttribute("CANCEL") != null) {
		// do nothing
	    } else if (StringUtils.equals(action, "edit")) {
		return edit(signupForm, request);
	    } else if (StringUtils.equals(action, "add")) {
		return add(signupForm, request);
	    } else if (StringUtils.equals(action, "delete")) {
		return delete(request);
	    }

	    List signupOrganisations = signupService.getSignupOrganisations();
	    request.setAttribute("signupOrganisations", signupOrganisations);
	} catch (Exception e) {
	    log.error(e.getMessage(), e);
	    request.setAttribute("error", e.getMessage());
	}

	return "signupmanagement/list";
    }

    @RequestMapping(path = "/edit", method = RequestMethod.POST)
    public String edit(@ModelAttribute SignupManagementForm signupForm, HttpServletRequest request) throws Exception {

	Integer soid = WebUtil.readIntParam(request, "soid", false);

	if (soid != null && soid > 0) {
	    SignupOrganisation signup = (SignupOrganisation) userManagementService.findById(SignupOrganisation.class,
		    soid);
	    if (signup != null) {
		signupForm.setSignupOrganisationId(signup.getSignupOrganisationId());
		signupForm.setOrganisationId(signup.getOrganisation().getOrganisationId());
		signupForm.setAddToLessons(signup.getAddToLessons());
		signupForm.setAddAsStaff(signup.getAddAsStaff());
		signupForm.setAddWithAuthor(signup.getAddWithAuthor());
		signupForm.setAddWithMonitor(signup.getAddWithMonitor());
		signupForm.setCourseKey(signup.getCourseKey());
		signupForm.setBlurb(signup.getBlurb());
		signupForm.setDisabled(signup.getDisabled());
		signupForm.setLoginTabActive(signup.getLoginTabActive());
		signupForm.setContext(signup.getContext());
		request.setAttribute("signupForm", signupForm);

		List organisations = signupService.getOrganisationCandidates();
		request.setAttribute("organisations", organisations);

		return "signupmanagement/add";
	    }
	}
	return null;
    }

    @RequestMapping(path = "/add", method = RequestMethod.POST)
    public String add(@ModelAttribute SignupManagementForm signupForm, HttpServletRequest request) throws Exception {

	// check if form submitted
	if (signupForm.getOrganisationId() != null && signupForm.getOrganisationId() > 0) {
	    MultiValueMap<String, String> errorMap = new LinkedMultiValueMap<>();

	    // validate
	    if (!StringUtils.equals(signupForm.getCourseKey(), signupForm.getConfirmCourseKey())) {
		errorMap.add("courseKey", adminMessageService.getMessage("error.course.keys.unequal"));
	    }
	    if (signupService.contextExists(signupForm.getSignupOrganisationId(), signupForm.getContext())) {
		errorMap.add("context", adminMessageService.getMessage("error.context.exists"));
	    }

	    if (!errorMap.isEmpty()) {
		request.setAttribute("errorMap", errorMap);
	    } else {
		// proceed
		SignupOrganisation signup;
		if (signupForm.getSignupOrganisationId() != null && signupForm.getSignupOrganisationId() > 0) {
		    // form was editing existing
		    signup = (SignupOrganisation) userManagementService.findById(SignupOrganisation.class,
			    signupForm.getSignupOrganisationId());
		} else {
		    signup = new SignupOrganisation();
		    signup.setCreateDate(new Date());
		}
		signup.setAddToLessons(signupForm.isAddToLessons());
		signup.setAddAsStaff(signupForm.isAddAsStaff());
		signup.setAddWithAuthor(signupForm.isAddWithAuthor());
		signup.setAddWithMonitor(signupForm.isAddWithMonitor());
		signup.setDisabled(signupForm.isDisabled());
		signup.setLoginTabActive(signupForm.isLoginTabActive());
		signup.setOrganisation((Organisation) userManagementService.findById(Organisation.class,
			signupForm.getOrganisationId()));
		signup.setCourseKey(signupForm.getCourseKey());
		signup.setBlurb(signupForm.getBlurb());
		signup.setContext(signupForm.getContext());
		userManagementService.save(signup);

		return "forward:signupManagement/list.do";
	    }
	} else {
	    // form not submitted, default values
	    signupForm.setBlurb("Register your LAMS account for this group using the form below.");
	}

	List organisations = signupService.getOrganisationCandidates();
	request.setAttribute("organisations", organisations);

	return "signupmanagement/add";
    }

    @RequestMapping(path = "/delete", method = RequestMethod.POST)
    public String delete(HttpServletRequest request) throws Exception {

	Integer soid = WebUtil.readIntParam(request, "soid");

	if (soid != null && soid > 0) {
	    userManagementService.deleteById(SignupOrganisation.class, soid);
	}

	return "redirect:signupManagement/list.do";
    }
}
