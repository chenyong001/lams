/****************************************************************
 * Copyright (C) 2005 LAMS Foundation (http://lamsfoundation.org)
 * =============================================================
 * License Information: http://lamsfoundation.org/licensing/lams/2.0/
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation.
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
/* $$Id$$ */
package org.lamsfoundation.lams.tool.spreadsheet.dao.hibernate;

import java.util.List;

import org.lamsfoundation.lams.tool.spreadsheet.dao.SpreadsheetUserDAO;
import org.lamsfoundation.lams.tool.spreadsheet.model.SpreadsheetUser;


public class SpreadsheetUserDAOHibernate extends BaseDAOHibernate implements SpreadsheetUserDAO{
	
	private static final String FIND_BY_USER_ID_CONTENT_ID = "from " + SpreadsheetUser.class.getName() + " as u where u.userId =? and u.spreadsheet.contentId=?";
	private static final String FIND_BY_USER_ID_SESSION_ID = "from " + SpreadsheetUser.class.getName() + " as u where u.userId =? and u.session.sessionId=?";
	private static final String FIND_BY_SESSION_ID = "from " + SpreadsheetUser.class.getName() + " as u where u.session.sessionId=?";

	public SpreadsheetUser getUserByUserIDAndSessionID(Long userID, Long sessionId) {
		List list = this.getHibernateTemplate().find(FIND_BY_USER_ID_SESSION_ID,new Object[]{userID,sessionId});
		if(list == null || list.size() == 0)
			return null;
		return (SpreadsheetUser) list.get(0);
	}

	public SpreadsheetUser getUserByUserIDAndContentID(Long userId, Long contentId) {
		List list = this.getHibernateTemplate().find(FIND_BY_USER_ID_CONTENT_ID,new Object[]{userId,contentId});
		if(list == null || list.size() == 0)
			return null;
		return (SpreadsheetUser) list.get(0);
	}

	public List<SpreadsheetUser> getBySessionID(Long sessionId) {
		return this.getHibernateTemplate().find(FIND_BY_SESSION_ID,sessionId);
	}


}
