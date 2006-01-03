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
package org.lamsfoundation.lams.tool.mc;

import java.util.List;


/**
 * <p> DTO that holds monitored user data for jsp purposes
 * </p>
 * 
 * @author Ozgur Demirtas
 */
public class McMonitoredUserDTO 
{
	private String uid;
	
	private String attemptTime;
	
	private String timeZone;
	
	private String userName;
	
	private String isCorrect;
	
	private String response;
	/**
	 * @return Returns the attemptTime.
	 */
	public String getAttemptTime() {
		return attemptTime;
	}
	/**
	 * @param attemptTime The attemptTime to set.
	 */
	public void setAttemptTime(String attemptTime) {
		this.attemptTime = attemptTime;
	}
	/**
	 * @return Returns the isCorrect.
	 */
	public String getIsCorrect() {
		return isCorrect;
	}
	/**
	 * @param isCorrect The isCorrect to set.
	 */
	public void setIsCorrect(String isCorrect) {
		this.isCorrect = isCorrect;
	}
	/**
	 * @return Returns the response.
	 */
	public String getResponse() {
		return response;
	}
	/**
	 * @param response The response to set.
	 */
	public void setResponse(String response) {
		this.response = response;
	}
	/**
	 * @return Returns the timeZone.
	 */
	public String getTimeZone() {
		return timeZone;
	}
	/**
	 * @param timeZone The timeZone to set.
	 */
	public void setTimeZone(String timeZone) {
		this.timeZone = timeZone;
	}
	/**
	 * @return Returns the uid.
	 */
	public String getUid() {
		return uid;
	}
	/**
	 * @param uid The uid to set.
	 */
	public void setUid(String uid) {
		this.uid = uid;
	}
	/**
	 * @return Returns the userName.
	 */
	public String getUserName() {
		return userName;
	}
	/**
	 * @param userName The userName to set.
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}
}
