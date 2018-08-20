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
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 * USA
 *
 * http://www.gnu.org/licenses/gpl.txt
 * ****************************************************************
 */

package org.lamsfoundation.lams.admin.web.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.lamsfoundation.lams.admin.AdminConstants;
import org.lamsfoundation.lams.admin.service.AdminServiceProxy;
import org.lamsfoundation.lams.admin.web.dto.LinkBean;
import org.lamsfoundation.lams.usermanagement.Role;
import org.lamsfoundation.lams.usermanagement.service.IUserManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.WebApplicationContext;

/**
 * @author jliew
 *
 */
@Controller
public class SysAdminStartController {

    private static IUserManagementService service;

    @Autowired
    private WebApplicationContext applicationContext;

    @RequestMapping(path = "/sysadminstart", method = RequestMethod.POST)
    public String execute(HttpServletRequest request) throws Exception {

	service = AdminServiceProxy.getService(applicationContext.getServletContext());

	ArrayList<Object[]> groupedLinks = new ArrayList<>();

	if (request.isUserInRole(Role.SYSADMIN)) {
	    ArrayList<LinkBean> links = new ArrayList<>();
	    links.add(new LinkBean("config.do", "sysadmin.config.settings.edit"));
	    links.add(new LinkBean("timezonemanagement.do", "admin.timezone.title"));
	    links.add(new LinkBean("loginmaintain.do", "sysadmin.maintain.loginpage"));
	    links.add(new LinkBean("signupManagement.do", "admin.signup.title"));
	    links.add(new LinkBean("serverlist.do", "sysadmin.maintain.external.servers"));
	    links.add(new LinkBean("ltiConsumerManagement.do", "label.manage.tool.consumers"));
	    links.add(new LinkBean("toolcontentlist.do", "sysadmin.tool.management"));
	    links.add(new LinkBean("themeManagement.do", "admin.themes.title"));
	    links.add(new LinkBean("sessionmaintain.do?method=list", "sysadmin.maintain.session"));
	    groupedLinks.add(new Object[] { AdminConstants.START_CONFIG_LINKS, links });

	    links = new ArrayList<>();
	    links.add(new LinkBean("logevent.do", "label.event.log"));
	    links.add(new LinkBean("cleanup.do", "sysadmin.batch.temp.file.delete"));
	    links.add(new LinkBean("cleanupPreviewLessons.do", "sysadmin.batch.preview.lesson.delete"));
	    links.add(new LinkBean("statistics.do", "admin.statistics.title"));
	    groupedLinks.add(new Object[] { AdminConstants.START_MONITOR_LINKS, links });

	    links = new ArrayList<>();
	    links.add(new LinkBean("usersearch.do", "admin.user.find"));
	    links.add(new LinkBean("importgroups.do", "sysadmin.import.groups.title"));
	    links.add(new LinkBean("importexcel.do", "admin.user.import"));
	    links.add(new LinkBean("disabledmanage.do", "admin.list.disabled.users"));
	    links.add(new LinkBean("ldap.do", "sysadmin.ldap.configuration"));
	    groupedLinks.add(new Object[] { AdminConstants.START_COURSE_LINKS, links });

	} else if (service.isUserGlobalGroupAdmin()) {
	    ArrayList<LinkBean> links = new ArrayList<>();
	    links.add(new LinkBean("usersearch.do", "admin.user.find"));
	    links.add(new LinkBean("importgroups.do", "sysadmin.import.groups.title"));
	    links.add(new LinkBean("importexcel.do", "admin.user.import"));
	    links.add(new LinkBean("disabledmanage.do", "admin.list.disabled.users"));
	    groupedLinks.add(new Object[] { AdminConstants.START_COURSE_LINKS, links });

	} else {
	    request.setAttribute("errorName", "SysAdminStartAction");
	    request.setAttribute("errorMessage", AdminServiceProxy
		    .getMessageService(applicationContext.getServletContext()).getMessage("error.authorisation"));
	    return "error";
	}

	request.setAttribute("groupedLinks", groupedLinks);
	return "sysadmin";
    }

}
