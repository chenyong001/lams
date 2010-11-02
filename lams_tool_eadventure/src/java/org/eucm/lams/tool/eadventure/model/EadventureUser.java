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
package org.eucm.lams.tool.eadventure.model;

import java.util.Date;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.log4j.Logger;
import org.lamsfoundation.lams.usermanagement.dto.UserDTO;
/**
 * Eadventure
 * @author Dapeng Ni
 *
 * @hibernate.class  table="tl_eueadv10_user"
 *
 */
public class EadventureUser implements Cloneable{
	private static final long serialVersionUID = -7043502180037866257L;
	private static Logger log = Logger.getLogger(EadventureUser.class);
	
    private Long uid;
	private Long userId;
	private String firstName;
	private String lastName;
	private String loginName;
	private boolean sessionFinished;
	
	private EadventureSession session;
	private Eadventure eadventure;
	
	//=============== NON Persisit value: for display use ===========
	//the user access some reousrce item date time. Use in monitoring summary page
	private Date accessDate;
	
	public EadventureUser(){
	}
	public EadventureUser(UserDTO user, EadventureSession session){
		this.userId = new Long(user.getUserID().intValue());
		this.firstName = user.getFirstName();
		this.lastName = user.getLastName();
		this.loginName = user.getLogin();
		this.session = session;
		this.eadventure = null;
		this.sessionFinished = false;
	}
	public EadventureUser(UserDTO user, Eadventure content){
		this.userId = new Long(user.getUserID().intValue());
		this.firstName = user.getFirstName();
		this.lastName = user.getLastName();
		this.loginName = user.getLogin();
		this.session = null;
		this.eadventure = content;
		this.sessionFinished = false;
	}
	/**
	 * Clone method from <code>java.lang.Object</code>
	 */
	public Object clone(){
  		
		EadventureUser user = null;
  		try{
  			user = (EadventureUser) super.clone();
  			user.setUid(null);
  			//never clone session
  			user.setSession(null);
		} catch (CloneNotSupportedException e) {
			log.error("When clone " + EadventureUser.class + " failed");
		}
  		
  		return user;
  	}
//  **********************************************************
  	//		Get/Set methods
//  **********************************************************
	/**
	 * @hibernate.id generator-class="native" type="java.lang.Long" column="uid"
	 * @return Returns the uid.
	 */
	public Long getUid() {
		return uid;
	}
	/**
	 * @param uid The uid to set.
	 */
	public void setUid(Long userID) {
		this.uid = userID;
	}

	/**
	 * @hibernate.property column="user_id" length="20"
	 * @return Returns the userId.
	 */
	public Long getUserId() {
		return userId;
	}
	/**
	 * @param userId
	 *            The userId to set.
	 */
	public void setUserId(Long userID) {
		this.userId = userID;
	}

	/**
	 * @hibernate.property length="255" column="last_name"
	 * @return
	 */
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	/**
	 * @hibernate.property length="255" column="first_name"
	 * @return
	 */
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	

	/**
	 * @hibernate.property column="login_name"
	 * @return
	 */
	public String getLoginName() {
		return loginName;
	}

	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}
	/**
	 * @hibernate.many-to-one column="session_uid"
	 * 			cascade="none"
	 * @return
	 */
	public EadventureSession getSession() {
		return session;
	}

	public void setSession(EadventureSession session) {
		this.session = session;
	}
	/**
	 * @hibernate.many-to-one column="eadventure_uid"
	 * 			cascade="none"
	 * @return
	 */
	public Eadventure getEadventure() {
		return eadventure;
	}
	public void setEadventure(Eadventure content) {
		this.eadventure = content;
	}
	/**
	 * @hibernate.property column="session_finished"
	 * @return
	 */
	public boolean isSessionFinished() {
		return sessionFinished;
	}

	public void setSessionFinished(boolean sessionFinished) {
		this.sessionFinished = sessionFinished;
	}
	
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!(obj instanceof EadventureUser))
			return false;

		final EadventureUser user = (EadventureUser) obj;
		
		return new EqualsBuilder().append(this.uid, user.uid).append(this.firstName, user.firstName)
			.append(this.lastName,user.lastName).append(this.loginName, user.loginName).isEquals();
		
	}

	public int hashCode() {
		return new HashCodeBuilder().append(uid).append(firstName)
		.append(lastName).append(loginName)
		.toHashCode();
	}
	public Date getAccessDate() {
		return accessDate;
	}
	public void setAccessDate(Date accessDate) {
		this.accessDate = accessDate;
	}


}
