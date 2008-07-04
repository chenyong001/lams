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

/* $$Id$$ */  
package org.lamsfoundation.lams.tool.spreadsheet.model;

import java.util.Date;
/**
 * Spreadsheet
 * @author Andrey Balan
 *
 * @hibernate.class  table="tl_lasprd10_user_edited_spreadsheet"
 *
 */
public class UserEditedSpreadsheet {

	private Long uid;
	private String userEditedSpreadsheet;
	private SpreadsheetMark mark;
	
	
    /**
     * @hibernate.id column="uid" generator-class="native"
     */
	public Long getUid() {
		return uid;
	}
	public void setUid(Long uid) {
		this.uid = uid;
	}
	
	/**
	 * @hibernate.property column="user_edited_spreadsheet" type="text"
	 * 
	 * 
	 * @return
	 */
	public String getUserEditedSpreadsheet() {
		return userEditedSpreadsheet;
	}
	public void setUserEditedSpreadsheet(String userEditedSpreadsheet) {
		this.userEditedSpreadsheet = userEditedSpreadsheet;
	}
	
    /**
     * @hibernate.id column="mark_id"
     */
	public SpreadsheetMark getMark() {
		return mark;
	}
	public void setMark(SpreadsheetMark mark) {
		this.mark = mark;
	}
}
