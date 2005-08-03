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

/*
 * Created on Jul 14, 2005
 */
package org.lamsfoundation.lams.tool.noticeboard.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
//import org.apache.struts.action.Action;
import org.lamsfoundation.lams.web.action.LamsAction;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.lamsfoundation.lams.tool.noticeboard.NbApplicationException;
import org.lamsfoundation.lams.tool.noticeboard.NoticeboardConstants;
import org.lamsfoundation.lams.tool.noticeboard.NoticeboardContent;
import org.lamsfoundation.lams.tool.noticeboard.web.NbMonitoringForm;
import org.lamsfoundation.lams.tool.noticeboard.util.NbWebUtil;

import org.lamsfoundation.lams.tool.noticeboard.service.INoticeboardService;
import org.lamsfoundation.lams.tool.noticeboard.service.NoticeboardServiceProxy;

/**
 * @author mtruong
 */

/**
 * Creation Date: 14-07-05
 *  
 * ----------------XDoclet Tags--------------------
 * 
 * @struts:action path="/starter/monitor" name="NbMonitoringForm" scope="session" type="org.lamsfoundation.lams.tool.noticeboard.web.NbMonitoringStarterAction"
 *               validate="false" 
 * @struts.action-exception key="error.exception.NbApplication" scope="request"
 *                          type="org.lamsfoundation.lams.tool.noticeboard.NbApplicationException"
 *                          path=".error"
 *                          handler="org.lamsfoundation.lams.tool.noticeboard.web.CustomStrutsExceptionHandler"
 * @struts.action-exception key="error.exception.NbApplication" scope="request"
 *                          type="java.lang.NullPointerException"
 *                          path=".error"
 *                          handler="org.lamsfoundation.lams.tool.noticeboard.web.CustomStrutsExceptionHandler"
 * @struts:action-forward name="monitorPage" path=".monitoringContent"
 * ----------------XDoclet Tags--------------------
 */

public class NbMonitoringStarterAction extends LamsAction {
    
    static Logger logger = Logger.getLogger(NbMonitoringStarterAction.class.getName());
   
    
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NbApplicationException {

        //get the list of tool sessionId's and put them in session 
        NbMonitoringForm monitorForm = (NbMonitoringForm)form;
        
        INoticeboardService nbService = NoticeboardServiceProxy.getNbService(getServlet().getServletContext());
        monitorForm.reset();
        NbWebUtil.cleanMonitoringSession(request);
        Long toolContentId = NbWebUtil.convertToLong(request.getParameter(NoticeboardConstants.TOOL_CONTENT_ID));
        
        if (toolContentId == null)
		{
		    String error = "Unable to continue. Tool content id missing";
		    logger.error(error);
			throw new NbApplicationException(error);
		}
        monitorForm.setToolContentId(toolContentId.toString());
        
        request.getSession().setAttribute(NoticeboardConstants.TOOL_CONTENT_ID_INMONITORMODE, toolContentId);
        
        NoticeboardContent content = nbService.retrieveNoticeboard(toolContentId);
        NbWebUtil.copyValuesIntoSession(request, content);
        
        
        
        //get the list of tool session ids
        
        return mapping.findForward(NoticeboardConstants.MONITOR_PAGE);
    }
   
   
}