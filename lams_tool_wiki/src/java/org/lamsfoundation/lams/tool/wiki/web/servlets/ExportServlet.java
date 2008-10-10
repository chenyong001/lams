/****************************************************************
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
 * ****************************************************************
 */

/* $Id$ */

package org.lamsfoundation.lams.tool.wiki.web.servlets;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.lamsfoundation.lams.notebook.model.NotebookEntry;
import org.lamsfoundation.lams.tool.ToolAccessMode;
import org.lamsfoundation.lams.tool.wiki.dto.WikiDTO;
import org.lamsfoundation.lams.tool.wiki.dto.NotebookEntryDTO;
import org.lamsfoundation.lams.tool.wiki.dto.WikiSessionDTO;
import org.lamsfoundation.lams.tool.wiki.dto.WikiUserDTO;
import org.lamsfoundation.lams.tool.wiki.model.Wiki;
import org.lamsfoundation.lams.tool.wiki.model.WikiSession;
import org.lamsfoundation.lams.tool.wiki.model.WikiUser;
import org.lamsfoundation.lams.tool.wiki.service.IWikiService;
import org.lamsfoundation.lams.tool.wiki.service.WikiServiceProxy;
import org.lamsfoundation.lams.tool.wiki.util.WikiException;
import org.lamsfoundation.lams.usermanagement.dto.UserDTO;
import org.lamsfoundation.lams.web.servlet.AbstractExportPortfolioServlet;
import org.lamsfoundation.lams.web.session.SessionManager;
import org.lamsfoundation.lams.web.util.AttributeNames;

public class ExportServlet extends AbstractExportPortfolioServlet {

    private static final long serialVersionUID = -2829707715037631881L;

    private static Logger logger = Logger.getLogger(ExportServlet.class);

    private final String FILENAME = "wiki_main.html";

    private IWikiService wikiService;

    protected String doExport(HttpServletRequest request, HttpServletResponse response, String directoryName,
	    Cookie[] cookies) {

	if (wikiService == null) {
	    wikiService = WikiServiceProxy.getWikiService(getServletContext());
	}

	try {
	    if (StringUtils.equals(mode, ToolAccessMode.LEARNER.toString())) {
		request.getSession().setAttribute(AttributeNames.ATTR_MODE, ToolAccessMode.LEARNER);
		doLearnerExport(request, response, directoryName, cookies);
	    } else if (StringUtils.equals(mode, ToolAccessMode.TEACHER.toString())) {
		request.getSession().setAttribute(AttributeNames.ATTR_MODE, ToolAccessMode.TEACHER);
		doTeacherExport(request, response, directoryName, cookies);
	    }
	} catch (WikiException e) {
	    logger.error("Cannot perform export for wiki tool.");
	}

	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
		+ request.getContextPath();
	writeResponseToFile(basePath + "/pages/export/exportPortfolio.jsp", directoryName, FILENAME, cookies);

	return FILENAME;
    }

    protected String doOfflineExport(HttpServletRequest request, HttpServletResponse response, String directoryName,
	    Cookie[] cookies) {
	if (toolContentID == null && toolSessionID == null) {
	    logger.error("Tool content Id or and session Id are null. Unable to activity title");
	} else {
	    if (wikiService == null) {
		wikiService = WikiServiceProxy.getWikiService(getServletContext());
	    }

	    Wiki content = null;
	    if (toolContentID != null) {
		content = wikiService.getWikiByContentId(toolContentID);
	    } else {
		WikiSession session = wikiService.getSessionBySessionId(toolSessionID);
		if (session != null)
		    content = session.getWiki();
	    }
	    if (content != null) {
		activityTitle = content.getTitle();
	    }
	}
	return super.doOfflineExport(request, response, directoryName, cookies);
    }

    private void doLearnerExport(HttpServletRequest request, HttpServletResponse response, String directoryName,
	    Cookie[] cookies) throws WikiException {

	logger.debug("doExportLearner: toolContentID:" + toolSessionID);

	// check if toolContentID available
	if (toolSessionID == null) {
	    String error = "Tool Session ID is missing. Unable to continue";
	    logger.error(error);
	    throw new WikiException(error);
	}

	WikiSession wikiSession = wikiService.getSessionBySessionId(toolSessionID);

	Wiki wiki = wikiSession.getWiki();

	UserDTO lamsUserDTO = (UserDTO) SessionManager.getSession().getAttribute(AttributeNames.USER);

	WikiUser wikiUser = wikiService.getUserByUserIdAndSessionId(new Long(lamsUserDTO.getUserID()), toolSessionID);

	//NotebookEntry wikiEntry = wikiService.getEntry(wikiUser.getEntryUID());

	// construct dto's
	WikiDTO wikiDTO = new WikiDTO();
	wikiDTO.setTitle(wiki.getTitle());
	wikiDTO.setInstructions(wiki.getInstructions());

	WikiSessionDTO sessionDTO = new WikiSessionDTO();
	sessionDTO.setSessionName(wikiSession.getSessionName());
	sessionDTO.setSessionID(wikiSession.getSessionId());

	// If the user hasn't put in their entry yet, wikiEntry will be null;
	//WikiUserDTO userDTO = wikiEntry != null ? new WikiUserDTO(wikiUser, wikiEntry) : new WikiUserDTO(wikiUser);

	//sessionDTO.getUserDTOs().add(userDTO);
	wikiDTO.getSessionDTOs().add(sessionDTO);

	request.getSession().setAttribute("wikiDTO", wikiDTO);
    }

    private void doTeacherExport(HttpServletRequest request, HttpServletResponse response, String directoryName,
	    Cookie[] cookies) throws WikiException {

	logger.debug("doExportTeacher: toolContentID:" + toolContentID);

	// check if toolContentID available
	if (toolContentID == null) {
	    String error = "Tool Content ID is missing. Unable to continue";
	    logger.error(error);
	    throw new WikiException(error);
	}

	Wiki wiki = wikiService.getWikiByContentId(toolContentID);

	WikiDTO wikiDTO = new WikiDTO(wiki);

	// add the wikiEntry for each user in each session

	/*
	for (WikiSessionDTO session : wikiDTO.getSessionDTOs()) {
	    for (WikiUserDTO user : session.getUserDTOs()) {
		NotebookEntry entry = wikiService.getEntry(user.getEntryUID());
		if (entry != null) {
		    NotebookEntryDTO entryDTO = new NotebookEntryDTO(entry);
		    user.setEntryDTO(entryDTO);
		}
	    }
	}
	*/

	request.getSession().setAttribute("wikiDTO", wikiDTO);
    }

}
