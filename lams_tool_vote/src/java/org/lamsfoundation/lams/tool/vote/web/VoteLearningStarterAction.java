/***************************************************************************
 * Copyright (C) 2005 LAMS Foundation (http://lamsfoundation.org)
 * =============================================================
 * License Information: http://lamsfoundation.org/licensing/lams/2.0/
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2.0
 * as published by the Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301
 * USA
 * 
 * http://www.gnu.org/licenses/gpl.txt
 * ***********************************************************************/

/**
 * 
 * @author Ozgur Demirtas
 *
 * <lams base path>/<tool's learner url>&userId=<learners user id>&toolSessionID=123&mode=teacher

 * Tool Session:
 *
 * A tool session is the concept by which which the tool and the LAMS core manage a set of learners interacting with the tool. 
 * The tool session id (toolSessionID) is generated by the LAMS core and given to the tool.
 * A tool session represents the use of a tool for a particulate activity for a group of learners. 
 * So if an activity is ungrouped, then one tool session exist for for a tool activity in a learning design.
 *
 * More details on the tool session id are covered under monitoring.
 * When thinking about the tool content id and the tool session id, it might be helpful to think about the tool content id 
 * relating to the definition of an activity, whereas the tool session id relates to the runtime participation in the activity.

 *  
 * Learner URL:
 * The learner url display the screen(s) that the learner uses to participate in the activity. 
 * When the learner accessed this user, it will have a tool access mode ToolAccessMode.LEARNER.
 *
 * It is the responsibility of the tool to record the progress of the user. 
 * If the tool is a multistage tool, for example asking a series of questions, the tool must keep track of what the learner has already done. 
 * If the user logs out and comes back to the tool later, then the tool should resume from where the learner stopped.
 * When the user is completed with tool, then the tool notifies the progress engine by calling 
 * org.lamsfoundation.lams.learning.service.completeToolSession(Long toolSessionID, User learner).
 *
 * If the tool's content DefineLater flag is set to true, then the learner should see a "Please wait for the teacher to define this part...." 
 * style message.
 * If the tool's content RunOffline flag is set to true, then the learner should see a "This activity is not being done on the computer. 
 * Please see your instructor for details."
 *
 * ?? Would it be better to define a run offline message in the tool? We have instructions for the teacher but not the learner. ??
 * If the tool has a LockOnFinish flag, then the tool should lock learner's entries once they have completed the activity. 
 * If they return to the activity (e.g. via the progress bar) then the entries should be read only.
 * 

 <!--Learning Starter Action: initializes the Learning module -->
 <action 	path="/learningStarter" 
 type="org.lamsfoundation.lams.tool.vote.web.VoteLearningStarterAction" 
 name="VoteLearningForm" 
 scope="request"
 validate="false"
 unknown="false"
 input="/learningIndex.jsp"> 

 <forward
 name="loadLearner"
 path="/learning/AnswersContent.jsp"
 redirect="false"
 />

 <forward
 name="learnerReport"
 path="/monitoring/LearnerRep.jsp"
 redirect="false"
 />

 <forward
 name="viewAnswers"
 path="/learning/ViewAnswers.jsp"
 redirect="false"
 />

 <forward
 name="redoQuestions"
 path="/learning/RedoQuestions.jsp"
 redirect="false"
 />

 <forward
 name="runOffline"
 path="/learning/RunOffline.jsp"
 redirect="false"
 />

 <forward
 name="exitPage"
 path="/learning/ExitLearning.jsp"
 redirect="false"
 />

 <forward
 name="allNominations"
 path="/learning/AllNominations.jsp"
 redirect="false"
 />

 <forward
 name="preview"
 path="/learning/Preview.jsp"
 redirect="false"
 />

 <forward
 name="learningStarter"
 path="/learningIndex.jsp"
 redirect="false"
 />


 <forward
 name="defineLater"
 path="/learning/defineLater.jsp"
 redirect="false"
 />

 <forward
 name="notebook"
 path="/learning/Notebook.jsp"
 redirect="false"
 />   

 <forward
 name="errorList"
 path="/VoteErrorBox.jsp"
 redirect="false"
 />
 </action>  


 * 
 */

/**
 *
 * Note:  Because of Voting learning reporting structure, Show Learner Report is always ON even if in authoring it is set to false.
 */

package org.lamsfoundation.lams.tool.vote.web;

import java.io.IOException;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TimeZone;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.struts.Globals;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.lamsfoundation.lams.notebook.model.NotebookEntry;
import org.lamsfoundation.lams.notebook.service.CoreNotebookConstants;
import org.lamsfoundation.lams.tool.vote.VoteAppConstants;
import org.lamsfoundation.lams.tool.vote.VoteApplicationException;
import org.lamsfoundation.lams.tool.vote.VoteComparator;
import org.lamsfoundation.lams.tool.vote.VoteGeneralLearnerFlowDTO;
import org.lamsfoundation.lams.tool.vote.VoteGeneralMonitoringDTO;
import org.lamsfoundation.lams.tool.vote.VoteUtils;
import org.lamsfoundation.lams.tool.vote.pojos.VoteContent;
import org.lamsfoundation.lams.tool.vote.pojos.VoteQueContent;
import org.lamsfoundation.lams.tool.vote.pojos.VoteQueUsr;
import org.lamsfoundation.lams.tool.vote.pojos.VoteSession;
import org.lamsfoundation.lams.tool.vote.pojos.VoteUsrAttempt;
import org.lamsfoundation.lams.tool.vote.service.IVoteService;
import org.lamsfoundation.lams.tool.vote.service.VoteServiceProxy;
import org.lamsfoundation.lams.usermanagement.dto.UserDTO;
import org.lamsfoundation.lams.util.DateUtil;
import org.lamsfoundation.lams.util.MessageService;
import org.lamsfoundation.lams.web.session.SessionManager;
import org.lamsfoundation.lams.web.util.AttributeNames;

public class VoteLearningStarterAction extends Action implements VoteAppConstants {
    static Logger logger = Logger.getLogger(VoteLearningStarterAction.class.getName());

    /*
     * By now, the passed tool session id MUST exist in the db through the calling of: public void
     * createToolSession(Long toolSessionID, Long toolContentId) by the container.
     * 
     * 
     * make sure this session exists in tool's session table by now.
     */
    @Override
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
	    HttpServletResponse response) throws IOException, ServletException, VoteApplicationException {

	VoteUtils.cleanUpSessionAbsolute(request);

	Map mapQuestionsContent = new TreeMap(new VoteComparator());
	Map mapAnswers = new TreeMap(new VoteComparator());

	IVoteService voteService = VoteServiceProxy.getVoteService(getServlet().getServletContext());
	VoteLearningStarterAction.logger.debug("retrieving voteService from session: " + voteService);

	VoteGeneralLearnerFlowDTO voteGeneralLearnerFlowDTO = new VoteGeneralLearnerFlowDTO();
	VoteLearningForm voteLearningForm = (VoteLearningForm) form;

	voteLearningForm.setRevisitingUser(new Boolean(false).toString());
	voteLearningForm.setUserEntry("");
	voteLearningForm.setCastVoteCount(0);
	voteLearningForm.setMaxNominationCountReached(new Boolean(false).toString());
	voteLearningForm.setActivityRunOffline(new Boolean(false).toString());

	voteGeneralLearnerFlowDTO.setRevisitingUser(new Boolean(false).toString());
	voteGeneralLearnerFlowDTO.setUserEntry("");
	voteGeneralLearnerFlowDTO.setCastVoteCount("0");
	voteGeneralLearnerFlowDTO.setMaxNominationCountReached(new Boolean(false).toString());
	voteGeneralLearnerFlowDTO.setActivityRunOffline(new Boolean(false).toString());

	/*
	 * save time zone information to session scope.
	 */
	VoteUtils.saveTimeZone(request);
	ActionForward validateParameters = validateParameters(request, mapping, voteLearningForm);
	VoteLearningStarterAction.logger.debug("validateParameters: " + validateParameters);
	if (validateParameters != null) {
	    return validateParameters;
	}

	String toolSessionID = voteLearningForm.getToolSessionID();
	VoteLearningStarterAction.logger.debug("retrieved toolSessionID: " + toolSessionID);

	/*
	 * by now, we made sure that the passed tool session id exists in the db as a new record Make sure we can
	 * retrieve it and the relavent content
	 */

	VoteSession voteSession = voteService.retrieveVoteSession(new Long(toolSessionID));
	VoteLearningStarterAction.logger.debug("retrieving voteSession: " + voteSession);

	if (voteSession == null) {
	    VoteUtils.cleanUpSessionAbsolute(request);
	    VoteLearningStarterAction.logger.debug("error: The tool expects voteSession.");
	    return mapping.findForward(VoteAppConstants.ERROR_LIST);
	}

	/*
	 * find out what content this tool session is referring to get the content for this tool session Each passed
	 * tool session id points to a particular content. Many to one mapping.
	 */
	VoteContent voteContent = voteSession.getVoteContent();
	VoteLearningStarterAction.logger.debug("using voteContent: " + voteContent);

	if (voteContent == null) {
	    VoteUtils.cleanUpSessionAbsolute(request);
	    VoteLearningStarterAction.logger.debug("error: The tool expects voteContent.");
	    persistInRequestError(request, "error.content.doesNotExist");
	    return mapping.findForward(VoteAppConstants.ERROR_LIST);
	}

	/*
	 * The content we retrieved above must have been created before in Authoring time. And the passed tool session
	 * id already refers to it.
	 */
	setupAttributes(request, voteContent, voteLearningForm, voteGeneralLearnerFlowDTO);

	VoteLearningStarterAction.logger.debug("using TOOL_CONTENT_ID: " + voteContent.getVoteContentId());
	voteLearningForm.setToolContentID(voteContent.getVoteContentId().toString());
	voteGeneralLearnerFlowDTO.setToolContentID(voteContent.getVoteContentId().toString());

	VoteLearningStarterAction.logger.debug("using TOOL_CONTENT_UID: " + voteContent.getUid());
	voteLearningForm.setToolContentUID(voteContent.getUid().toString());
	voteGeneralLearnerFlowDTO.setToolContentUID(voteContent.getUid().toString());

	String userID = voteLearningForm.getUserID();
	VoteLearningStarterAction.logger.debug("userID: " + userID);

	VoteLearningStarterAction.logger.debug("is tool reflective: " + voteContent.isReflect());
	voteGeneralLearnerFlowDTO.setReflection(new Boolean(voteContent.isReflect()).toString());
	VoteLearningStarterAction.logger.debug("reflection subject: " + voteContent.getReflectionSubject());
	String reflectionSubject = VoteUtils.replaceNewLines(voteContent.getReflectionSubject());
	voteGeneralLearnerFlowDTO.setReflectionSubject(reflectionSubject);

	VoteLearningStarterAction.logger.debug("is vote lockOnFinish: " + voteContent.isLockOnFinish());

	/*
	 * Is the request for a preview by the author? Preview The tool must be able to show the specified content as if
	 * it was running in a lesson. It will be the learner url with tool access mode set to ToolAccessMode.AUTHOR 3
	 * modes are: author teacher learner
	 */
	/* ? CHECK THIS: how do we determine whether preview is requested? Mode is not enough on its own. */

	VoteLearningStarterAction.logger.debug("before checking for preview voteGeneralLearnerFlowDTO: "
		+ voteGeneralLearnerFlowDTO);
	request.setAttribute(VoteAppConstants.VOTE_GENERAL_LEARNER_FLOW_DTO, voteGeneralLearnerFlowDTO);

	/* handle PREVIEW mode */
	String mode = voteLearningForm.getLearningMode();
	VoteLearningStarterAction.logger.debug("mode: " + mode);
	if (mode != null && mode.equals("author")) {
	    VoteLearningStarterAction.logger.debug("Author requests for a preview of the content.");
	    VoteLearningStarterAction.logger.debug("existing voteContent:" + voteContent);

	    commonContentSetup(request, voteService, voteContent, voteGeneralLearnerFlowDTO);

	    VoteLearningStarterAction.logger.debug("preview voteGeneralLearnerFlowDTO: " + voteGeneralLearnerFlowDTO);
	    request.setAttribute(VoteAppConstants.VOTE_GENERAL_LEARNER_FLOW_DTO, voteGeneralLearnerFlowDTO);
	}

	/*
	 * by now, we know that the mode is either teacher or learner check if the mode is teacher and request is for
	 * Learner Progress
	 */

	String learnerProgressUserId = request.getParameter(VoteAppConstants.USER_ID);
	VoteLearningStarterAction.logger.debug("learnerProgressUserId: " + learnerProgressUserId);

	if (learnerProgressUserId != null && mode.equals("teacher")) {
	    VoteQueUsr voteQueUsr = voteService.getVoteUserBySession(new Long(learnerProgressUserId), voteSession
		    .getUid());

	    if (voteQueUsr != null) {

		Long sessionUid = voteQueUsr.getVoteSessionId();

		VoteLearningStarterAction.logger.debug("start building MAP_GENERAL_CHECKED_OPTIONS_CONTENT");
		String toolContentId = voteLearningForm.getToolContentID();
		VoteLearningStarterAction.logger.debug("toolContentId: " + toolContentId);

		putMapQuestionsContentIntoRequest(request, voteService, voteQueUsr);

		VoteLearningStarterAction.logger.debug("geting user answers for user uid and sessionUid"
			+ voteQueUsr.getUid() + " " + sessionUid);
		Set userAttempts = voteService.getAttemptsForUserAndSessionUseOpenAnswer(voteQueUsr.getUid(),
			sessionUid);
		VoteLearningStarterAction.logger.debug("userAttempts: " + userAttempts);
		request.setAttribute(VoteAppConstants.LIST_GENERAL_CHECKED_OPTIONS_CONTENT, userAttempts);

	    } else {
		request.setAttribute(VoteAppConstants.MAP_GENERAL_CHECKED_OPTIONS_CONTENT, new TreeMap(
			new VoteComparator()));
		request.setAttribute(VoteAppConstants.LIST_GENERAL_CHECKED_OPTIONS_CONTENT, new HashSet());
	    }

	    VoteLearningStarterAction.logger
		    .debug("since this is progress view, present a screen which can not be edited");
	    voteLearningForm.setReportViewOnly(new Boolean(true).toString());
	    voteGeneralLearnerFlowDTO.setReportViewOnly(new Boolean(true).toString());
	    voteGeneralLearnerFlowDTO.setLearningMode(mode);
	    putNotebookEntryIntoVoteGeneralLearnerFlowDTO(voteService, voteGeneralLearnerFlowDTO, toolSessionID,
		    learnerProgressUserId);

	    VoteGeneralMonitoringDTO voteGeneralMonitoringDTO = new VoteGeneralMonitoringDTO();
	    MonitoringUtil.prepareChartData(request, voteService, null, voteContent.getVoteContentId().toString(),
		    voteSession.getUid().toString(), voteGeneralLearnerFlowDTO, voteGeneralMonitoringDTO,
		    getMessageService());
	    
	    boolean isGroupedActivity = voteService.isGroupedActivity(new Long(voteLearningForm.getToolContentID()));
		request.setAttribute("isGroupedActivity", isGroupedActivity);

	    VoteLearningStarterAction.logger.debug("fwd'ing to: " + VoteAppConstants.EXIT_PAGE);
	    return mapping.findForward(VoteAppConstants.EXIT_PAGE);
	}

	/* by now, we know that the mode is learner */
	putNotebookEntryIntoVoteGeneralLearnerFlowDTO(voteService, voteGeneralLearnerFlowDTO, toolSessionID, userID);

	/*
	 * find out if the content is set to run offline or online. If it is set to run offline , the learners are
	 * informed about that.
	 */
	boolean isRunOffline = VoteUtils.isRunOffline(voteContent);
	VoteLearningStarterAction.logger.debug("isRunOffline: " + isRunOffline);
	if (isRunOffline == true) {
	    VoteUtils.cleanUpSessionAbsolute(request);
	    VoteLearningStarterAction.logger.debug("warning to learner: the activity is offline.");
	    voteLearningForm.setActivityRunOffline(new Boolean(true).toString());
	    voteGeneralLearnerFlowDTO.setActivityRunOffline(new Boolean(true).toString());

	    VoteLearningStarterAction.logger
		    .debug("runOffline voteGeneralLearnerFlowDTO: " + voteGeneralLearnerFlowDTO);
	    request.setAttribute(VoteAppConstants.VOTE_GENERAL_LEARNER_FLOW_DTO, voteGeneralLearnerFlowDTO);
	    // return (mapping.findForward(ERROR_LIST));
	    VoteLearningStarterAction.logger.debug("fwding to :" + VoteAppConstants.RUN_OFFLINE);
	    return mapping.findForward(VoteAppConstants.RUN_OFFLINE);
	}

	/* find out if the content is being modified at the moment. */
	boolean isDefineLater = VoteUtils.isDefineLater(voteContent);
	VoteLearningStarterAction.logger.debug("isDefineLater: " + isDefineLater);
	if (isDefineLater == true) {
	    VoteUtils.cleanUpSessionAbsolute(request);
	    return mapping.findForward(VoteAppConstants.DEFINE_LATER);
	}

    //	check if there is submission deadline
    Date submissionDeadline = voteContent.getSubmissionDeadline();
    
    if (submissionDeadline != null) {
    	
    	request.setAttribute(VoteAppConstants.ATTR_SUBMISSION_DEADLINE, submissionDeadline);
    	HttpSession ss = SessionManager.getSession();
    	UserDTO learnerDto = (UserDTO) ss.getAttribute(AttributeNames.USER);
    	TimeZone learnerTimeZone = learnerDto.getTimeZone();
    	Date tzSubmissionDeadline = DateUtil.convertToTimeZoneFromDefault(learnerTimeZone, submissionDeadline);
    	Date currentLearnerDate = DateUtil.convertToTimeZoneFromDefault(learnerTimeZone, new Date());
    	voteGeneralLearnerFlowDTO.setSubmissionDeadline(tzSubmissionDeadline);	 
    	
    	//calculate whether deadline has passed, and if so forward to "runOffline"
    	if (currentLearnerDate.after(tzSubmissionDeadline)) {
    		return mapping.findForward(RUN_OFFLINE);
    		
    	}
    	
    }
  

	/*
	 * fetch question content from content
	 */
	mapQuestionsContent = LearningUtil.buildQuestionContentMap(request, voteService, voteContent, null);
	VoteLearningStarterAction.logger.debug("mapQuestionsContent: " + mapQuestionsContent);

	request.setAttribute(VoteAppConstants.MAP_QUESTION_CONTENT_LEARNER, mapQuestionsContent);
	VoteLearningStarterAction.logger.debug("MAP_QUESTION_CONTENT_LEARNER: "
		+ request.getAttribute(VoteAppConstants.MAP_QUESTION_CONTENT_LEARNER));
	request.setAttribute(VoteAppConstants.MAP_OPTIONS_CONTENT, mapQuestionsContent);

	/*
	 * verify that userId does not already exist in the db. If it does exist, that means, that user already
	 * responded to the content and his answers must be displayed read-only
	 * 
	 */

	VoteLearningStarterAction.logger.debug("userID:" + userID);

	VoteLearningStarterAction.logger.debug("voteSession uid :" + voteSession.getUid());
	VoteQueUsr voteQueUsr = voteService.getVoteUserBySession(new Long(userID), voteSession.getUid());
	VoteLearningStarterAction.logger.debug("voteQueUsr:" + voteQueUsr);

	if (voteQueUsr != null) {
	    VoteLearningStarterAction.logger.debug("voteQueUsr is available in the db:" + voteQueUsr);
	    Long queUsrId = voteQueUsr.getUid();
	    VoteLearningStarterAction.logger.debug("queUsrId: " + queUsrId);
	} else {
	    VoteLearningStarterAction.logger.debug("voteQueUsr is not available in the db:" + voteQueUsr);
	}

	String learningMode = voteLearningForm.getLearningMode();
	VoteLearningStarterAction.logger.debug("users learning mode is: " + learningMode);

	/*
	 * the user's session id AND user id exists in the tool tables goto this screen if the OverAll Results scren has
	 * been already called up by this user
	 */
	if (voteQueUsr != null && voteQueUsr.isFinalScreenRequested()) {
	    Long sessionUid = voteQueUsr.getVoteSessionId();
	    VoteLearningStarterAction.logger.debug("users sessionUid: " + sessionUid);
	    VoteSession voteUserSession = voteService.getVoteSessionByUID(sessionUid);
	    VoteLearningStarterAction.logger.debug("voteUserSession: " + voteUserSession);
	    String userSessionId = voteUserSession.getVoteSessionId().toString();
	    VoteLearningStarterAction.logger.debug("userSessionId: " + userSessionId);
	    VoteLearningStarterAction.logger.debug("current toolSessionID: " + toolSessionID);

	    if (toolSessionID.toString().equals(userSessionId)) {
		VoteLearningStarterAction.logger
			.debug("the learner has already responsed to this content, just generate a read-only report. Use redo questions for this.");

		VoteLearningStarterAction.logger.debug("start building MAP_GENERAL_CHECKED_OPTIONS_CONTENT");
		String toolContentId = voteLearningForm.getToolContentID();
		VoteLearningStarterAction.logger.debug("toolContentId: " + toolContentId);

		putMapQuestionsContentIntoRequest(request, voteService, voteQueUsr);

		boolean isResponseFinalised = voteQueUsr.isResponseFinalised();
		VoteLearningStarterAction.logger.debug("isResponseFinalised: " + isResponseFinalised);
		if (isResponseFinalised) {
		    VoteLearningStarterAction.logger
			    .debug("since the response is finalised present a screen which can not be edited");
		    voteLearningForm.setReportViewOnly(new Boolean(true).toString());
		    voteGeneralLearnerFlowDTO.setReportViewOnly(new Boolean(true).toString());
		}

		VoteLearningStarterAction.logger.debug("geting user answers for user uid and sessionUid"
			+ voteQueUsr.getUid() + " " + sessionUid);
		Set userAttempts = voteService.getAttemptsForUserAndSessionUseOpenAnswer(voteQueUsr.getUid(),
			sessionUid);
		VoteLearningStarterAction.logger.debug("userAttempts: " + userAttempts);
		request.setAttribute(VoteAppConstants.LIST_GENERAL_CHECKED_OPTIONS_CONTENT, userAttempts);

		VoteGeneralMonitoringDTO voteGeneralMonitoringDTO = new VoteGeneralMonitoringDTO();
		MonitoringUtil.prepareChartData(request, voteService, null, voteContent.getVoteContentId().toString(),
			voteSession.getUid().toString(), voteGeneralLearnerFlowDTO, voteGeneralMonitoringDTO,
			getMessageService());

		String isContentLockOnFinish = voteLearningForm.getLockOnFinish();
		VoteLearningStarterAction.logger.debug("isContentLockOnFinish: " + isContentLockOnFinish);
		if (isContentLockOnFinish.equals(new Boolean(true).toString()) && isResponseFinalised == true) {
		    VoteLearningStarterAction.logger.debug("user with session id: " + userSessionId
			    + " should not redo votes. session  is locked.");
		    VoteLearningStarterAction.logger.debug("fwd'ing to: " + VoteAppConstants.EXIT_PAGE);
		    return mapping.findForward(VoteAppConstants.EXIT_PAGE);
		}

		VoteLearningStarterAction.logger
			.debug("the user's session id AND user id exists in the tool tables go to redo questions. "
				+ toolSessionID + " voteQueUsr: " + voteQueUsr + " user id: "
				+ voteQueUsr.getQueUsrId());
		voteLearningForm.setRevisitingUser(new Boolean(true).toString());
		voteGeneralLearnerFlowDTO.setRevisitingUser(new Boolean(true).toString());
		VoteLearningStarterAction.logger.debug("preparing chart data for readonly mode");

		VoteLearningStarterAction.logger.debug("view-only voteGeneralLearnerFlowDTO: "
			+ voteGeneralLearnerFlowDTO);
		request.setAttribute(VoteAppConstants.VOTE_GENERAL_LEARNER_FLOW_DTO, voteGeneralLearnerFlowDTO);

		if (isContentLockOnFinish.equals(new Boolean(false).toString()) && isResponseFinalised == true) {
		    VoteLearningStarterAction.logger.debug("isContentLockOnFinish is false, enable redo of votes : ");
		    VoteLearningStarterAction.logger.debug("fwd'ing to: " + VoteAppConstants.REVISITED_ALL_NOMINATIONS);
		    return mapping.findForward(VoteAppConstants.REVISITED_ALL_NOMINATIONS);
		}

		VoteLearningStarterAction.logger.debug("fwd'ing to: " + VoteAppConstants.ALL_NOMINATIONS);
		return mapping.findForward(VoteAppConstants.ALL_NOMINATIONS);
	    }
	}
	VoteLearningStarterAction.logger.debug("presenting standard learner screen..");
	return mapping.findForward(VoteAppConstants.LOAD_LEARNER);
    }

    private void putNotebookEntryIntoVoteGeneralLearnerFlowDTO(IVoteService voteService,
	    VoteGeneralLearnerFlowDTO voteGeneralLearnerFlowDTO, String toolSessionID, String userID) {
	VoteLearningStarterAction.logger.debug("attempt getting notebookEntry: ");
	NotebookEntry notebookEntry = voteService.getEntry(new Long(toolSessionID),
		CoreNotebookConstants.NOTEBOOK_TOOL, VoteAppConstants.MY_SIGNATURE, new Integer(userID));

	VoteLearningStarterAction.logger.debug("notebookEntry: " + notebookEntry);

	if (notebookEntry != null) {
	    String notebookEntryPresentable = VoteUtils.replaceNewLines(notebookEntry.getEntry());
	    voteGeneralLearnerFlowDTO.setNotebookEntry(notebookEntryPresentable);
	}
    }

    /**
     * Build the attempts map and put it in the request, based on the supplied user. If the user is null then the map
     * will be set but it will be empty TODO This shouldn't go in the request, it should go in our special session map.
     */
    private void putMapQuestionsContentIntoRequest(HttpServletRequest request, IVoteService voteService,
	    VoteQueUsr voteQueUsr) {
	List attempts = null;
	if (voteQueUsr != null) {
	    attempts = voteService.getAttemptsForUser(voteQueUsr.getUid());
	}
	VoteLearningStarterAction.logger.debug("attempts: " + attempts);

	Map localMapQuestionsContent = new TreeMap(new VoteComparator());

	if (attempts != null) {

	    Iterator listIterator = attempts.iterator();
	    int order = 0;
	    while (listIterator.hasNext()) {
		VoteUsrAttempt attempt = (VoteUsrAttempt) listIterator.next();
		VoteLearningStarterAction.logger.debug("attempt: " + attempt);
		VoteQueContent voteQueContent = attempt.getVoteQueContent();
		VoteLearningStarterAction.logger.debug("voteQueContent: " + voteQueContent);
		order++;
		if (voteQueContent != null) {
		    String entry = voteQueContent.getQuestion();
		    VoteLearningStarterAction.logger.debug("entry: " + entry);

		    String voteQueContentId = attempt.getVoteQueContentId().toString();
		    VoteLearningStarterAction.logger.debug("voteQueContentId: " + voteQueContentId);
		    if (entry != null) {
			if (entry.equals("sample nomination") && voteQueContentId.equals("1")) {
			    VoteLearningStarterAction.logger
				    .debug("this nomination entry points to a user entered nomination: "
					    + attempt.getUserEntry());
			    localMapQuestionsContent.put(new Integer(order).toString(), attempt.getUserEntry());
			} else {
			    VoteLearningStarterAction.logger
				    .debug("this nomination entry points to a standard nomination: "
					    + voteQueContent.getQuestion());
			    localMapQuestionsContent.put(new Integer(order).toString(), voteQueContent.getQuestion());
			}
		    }
		}
	    }
	}

	request.setAttribute(VoteAppConstants.MAP_GENERAL_CHECKED_OPTIONS_CONTENT, localMapQuestionsContent);
	VoteLearningStarterAction.logger.debug("end building MAP_GENERAL_CHECKED_OPTIONS_CONTENT: "
		+ localMapQuestionsContent);
    }

    /**
     * sets up question and candidate answers maps commonContentSetup(HttpServletRequest request, VoteContent
     * voteContent)
     * 
     * @param request
     * @param voteContent
     */
    protected void commonContentSetup(HttpServletRequest request, IVoteService voteService, VoteContent voteContent,
	    VoteGeneralLearnerFlowDTO voteGeneralLearnerFlowDTO) {
	Map mapQuestionsContent = LearningUtil.buildQuestionContentMap(request, voteService, voteContent, null);
	VoteLearningStarterAction.logger.debug("mapQuestionsContent: " + mapQuestionsContent);

	request.setAttribute(VoteAppConstants.MAP_QUESTION_CONTENT_LEARNER, mapQuestionsContent);
	VoteLearningStarterAction.logger.debug("MAP_QUESTION_CONTENT_LEARNER: "
		+ request.getAttribute(VoteAppConstants.MAP_QUESTION_CONTENT_LEARNER));
	VoteLearningStarterAction.logger.debug("voteContent has : " + mapQuestionsContent.size() + " entries.");
	voteGeneralLearnerFlowDTO.setTotalQuestionCount(new Long(mapQuestionsContent.size()).toString());
    }

    /**
     * sets up session scope attributes based on content linked to the passed tool session id
     * setupAttributes(HttpServletRequest request, VoteContent voteContent)
     * 
     * @param request
     * @param voteContent
     */
    protected void setupAttributes(HttpServletRequest request, VoteContent voteContent,
	    VoteLearningForm voteLearningForm, VoteGeneralLearnerFlowDTO voteGeneralLearnerFlowDTO) {

	VoteLearningStarterAction.logger.debug("IS_CONTENT_IN_USE: " + voteContent.isContentInUse());

	Map mapGeneralCheckedOptionsContent = new TreeMap(new VoteComparator());
	request.setAttribute(VoteAppConstants.MAP_GENERAL_CHECKED_OPTIONS_CONTENT, mapGeneralCheckedOptionsContent);
	/*
	 * Is the tool activity been checked as Run Offline in the property inspector?
	 */
	VoteLearningStarterAction.logger.debug("IS_TOOL_ACTIVITY_OFFLINE: " + voteContent.isRunOffline());

	VoteLearningStarterAction.logger.debug("advanced properties maxNominationCount: "
		+ voteContent.getMaxNominationCount());
	VoteLearningStarterAction.logger.debug("advanced properties isAllowText(): "
		+ new Boolean(voteContent.isAllowText()).toString());
	VoteLearningStarterAction.logger.debug("advanced properties isRunOffline(): "
		+ new Boolean(voteContent.isRunOffline()).toString());
	VoteLearningStarterAction.logger.debug("advanced properties isLockOnFinish(): "
		+ new Boolean(voteContent.isLockOnFinish()).toString());

	voteLearningForm.setActivityTitle(voteContent.getTitle());
	voteLearningForm.setActivityInstructions(voteContent.getInstructions());
	voteLearningForm.setActivityRunOffline(new Boolean(voteContent.isRunOffline()).toString());
	voteLearningForm.setMaxNominationCount(voteContent.getMaxNominationCount());
	voteLearningForm.setMinNominationCount(voteContent.getMinNominationCount());	
	voteLearningForm.setAllowTextEntry(new Boolean(voteContent.isAllowText()).toString());
	voteLearningForm.setShowResults(new Boolean(voteContent.isShowResults()).toString());
	voteLearningForm.setLockOnFinish(new Boolean(voteContent.isLockOnFinish()).toString());

	voteGeneralLearnerFlowDTO.setActivityTitle(voteContent.getTitle());
	voteGeneralLearnerFlowDTO.setActivityInstructions(voteContent.getInstructions());
	voteGeneralLearnerFlowDTO.setActivityRunOffline(new Boolean(voteContent.isRunOffline()).toString());
	voteGeneralLearnerFlowDTO.setMaxNominationCount(voteContent.getMaxNominationCount());
	voteGeneralLearnerFlowDTO.setMinNominationCount(voteContent.getMinNominationCount());	
	voteGeneralLearnerFlowDTO.setAllowTextEntry(new Boolean(voteContent.isAllowText()).toString());
	voteGeneralLearnerFlowDTO.setLockOnFinish(new Boolean(voteContent.isLockOnFinish()).toString());
	voteGeneralLearnerFlowDTO.setActivityTitle(voteContent.getTitle());
	voteGeneralLearnerFlowDTO.setActivityInstructions(voteContent.getInstructions());
    }

    protected ActionForward validateParameters(HttpServletRequest request, ActionMapping mapping,
	    VoteLearningForm voteLearningForm) {
	/*
	 * obtain and setup the current user's data
	 */

	String userID = "";
	HttpSession ss = SessionManager.getSession();
	VoteLearningStarterAction.logger.debug("ss: " + ss);

	if (ss != null) {
	    UserDTO user = (UserDTO) ss.getAttribute(AttributeNames.USER);
	    if (user != null && user.getUserID() != null) {
		userID = user.getUserID().toString();
		VoteLearningStarterAction.logger.debug("retrieved userId: " + userID);
		voteLearningForm.setUserID(userID);
	    }
	}

	/*
	 * process incoming tool session id and later derive toolContentId from it.
	 */
	String strToolSessionId = request.getParameter(AttributeNames.PARAM_TOOL_SESSION_ID);
	long toolSessionID = 0;
	if (strToolSessionId == null || strToolSessionId.length() == 0) {
	    VoteUtils.cleanUpSessionAbsolute(request);
	    // persistInRequestError(request, "error.toolSessionId.required");
	    return mapping.findForward(VoteAppConstants.ERROR_LIST);
	} else {
	    try {
		toolSessionID = new Long(strToolSessionId).longValue();
		VoteLearningStarterAction.logger.debug("passed TOOL_SESSION_ID : " + new Long(toolSessionID));
		voteLearningForm.setToolSessionID(new Long(toolSessionID).toString());
	    } catch (NumberFormatException e) {
		VoteUtils.cleanUpSessionAbsolute(request);
		// persistInRequestError(request, "error.sessionId.numberFormatException");
		VoteLearningStarterAction.logger.debug("add error.sessionId.numberFormatException to ActionMessages.");
		return mapping.findForward(VoteAppConstants.ERROR_LIST);
	    }
	}

	/* mode can be learner, teacher or author */
	String mode = request.getParameter(VoteAppConstants.MODE);
	VoteLearningStarterAction.logger.debug("mode: " + mode);

	if (mode == null || mode.length() == 0) {
	    VoteUtils.cleanUpSessionAbsolute(request);
	    VoteLearningStarterAction.logger.error("mode missing: ");
	    return mapping.findForward(VoteAppConstants.ERROR_LIST);
	}

	if (!mode.equals("learner") && !mode.equals("teacher") && !mode.equals("author")) {
	    VoteUtils.cleanUpSessionAbsolute(request);
	    VoteLearningStarterAction.logger.error("mode invalid: ");
	    return mapping.findForward(VoteAppConstants.ERROR_LIST);
	}
	VoteLearningStarterAction.logger.debug("session LEARNING_MODE set to:" + mode);
	voteLearningForm.setLearningMode(mode);

	return null;
    }

    boolean isSessionCompleted(String userSessionId, IVoteService voteService) {
	VoteLearningStarterAction.logger.debug("userSessionId:" + userSessionId);
	VoteSession voteSession = voteService.retrieveVoteSession(new Long(userSessionId));
	VoteLearningStarterAction.logger.debug("retrieving voteSession: " + voteSession);
	VoteLearningStarterAction.logger.debug("voteSession status : " + voteSession.getSessionStatus());
	if (voteSession.getSessionStatus() != null && voteSession.getSessionStatus().equals(VoteAppConstants.COMPLETED)) {
	    VoteLearningStarterAction.logger.debug("this session is COMPLETED voteSession status : " + userSessionId
		    + "->" + voteSession.getSessionStatus());
	    return true;
	}
	return false;
    }

    /**
     * persists error messages to request scope
     * 
     * @param request
     * @param message
     */
    public void persistInRequestError(HttpServletRequest request, String message) {
	ActionMessages errors = new ActionMessages();
	errors.add(Globals.ERROR_KEY, new ActionMessage(message));
	VoteLearningStarterAction.logger.debug("add " + message + "  to ActionMessages:");
	saveErrors(request, errors);
    }

    /**
     * Return ResourceService bean.
     */
    private MessageService getMessageService() {
	return VoteServiceProxy.getMessageService(getServlet().getServletContext());
    }
}
