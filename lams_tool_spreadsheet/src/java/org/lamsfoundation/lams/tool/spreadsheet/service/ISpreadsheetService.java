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
package org.lamsfoundation.lams.tool.spreadsheet.service;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;

import org.apache.struts.upload.FormFile;
import org.lamsfoundation.lams.contentrepository.IVersionedNode;
import org.lamsfoundation.lams.notebook.model.NotebookEntry;
import org.lamsfoundation.lams.tool.spreadsheet.dto.ReflectDTO;
import org.lamsfoundation.lams.tool.spreadsheet.dto.StatisticDTO;
import org.lamsfoundation.lams.tool.spreadsheet.dto.Summary;
import org.lamsfoundation.lams.tool.spreadsheet.model.Spreadsheet;
import org.lamsfoundation.lams.tool.spreadsheet.model.SpreadsheetAttachment;
import org.lamsfoundation.lams.tool.spreadsheet.model.SpreadsheetSession;
import org.lamsfoundation.lams.tool.spreadsheet.model.SpreadsheetUser;

/**
 * @author Andrey Balan
 * 
 * Interface that defines the contract that all ShareSpreadsheet service provider must follow.
 */
public interface ISpreadsheetService{
	
	/**
	 * Get <code>Spreadsheet</code> by toolContentID.
	 * @param contentId
	 * @return
	 */
	Spreadsheet getSpreadsheetByContentId(Long contentId);
	/**
	 * Get a cloned copy of  tool default tool content (Spreadsheet) and assign the toolContentId of that copy as the 
	 * given <code>contentId</code> 
	 * @param contentId
	 * @return
	 * @throws SpreadsheetApplicationException
	 */
	Spreadsheet getDefaultContent(Long contentId) throws SpreadsheetApplicationException;
	
	/**
	 * Upload instruciton file into repository.
	 * @param file
	 * @param type
	 * @return
	 * @throws UploadSpreadsheetFileException
	 */
	SpreadsheetAttachment uploadInstructionFile(FormFile file, String type) throws UploadSpreadsheetFileException;
	
	//********** user methods *************
	/**
	 * Save or update SpreadsheetUser in database, mostly for saving userEditedSpreadsheet.
	 * 
	 * @param user user which did modifications to spreadsheet
	 */
	void saveOrUpdateUser(SpreadsheetUser spreadsheetUser);
	
	/**
	 * Get user by given userID and toolContentID.
	 * @param long1
	 * @return
	 */
	SpreadsheetUser getUserByIDAndContent(Long userID, Long contentId); 

	/**
	 * Get user by sessionID and UserID
	 * @param long1
	 * @param sessionId
	 * @return
	 */
	SpreadsheetUser getUserByIDAndSession(Long long1, Long sessionId); 
	
//	/**
//	 * Get user list by sessionId and itemUid
//	 * 
//	 * @param sessionId
//	 * @param uid
//	 * @return
//	 */
//	List<SpreadsheetUser> getUserListBySessionItem(Long sessionId, Long itemUid);

	//********** Repository methods ***********************
	/**
	 * Delete file from repository.
	 */
	void deleteFromRepository(Long fileUuid, Long fileVersionId) throws SpreadsheetApplicationException ;

	/**
	 * Save or update spreadsheet into database.
	 * @param Spreadsheet
	 */
	void saveOrUpdateSpreadsheet(Spreadsheet Spreadsheet);
	/**
	 * Delete reource attachment(i.e., offline/online instruction file) from database. This method does not
	 * delete the file from repository.
	 * 
	 * @param attachmentUid
	 */
	void deleteSpreadsheetAttachment(Long attachmentUid);
	
	/**
	 * Get spreadsheet which is relative with the special toolSession.
	 * @param sessionId
	 * @return
	 */
	Spreadsheet getSpreadsheetBySessionId(Long sessionId);
	/**
	 * Get spreadsheet toolSession by toolSessionId
	 * @param sessionId
	 * @return
	 */
	SpreadsheetSession getSpreadsheetSessionBySessionId(Long sessionId);

	/**
	 * Save or update spreadsheet session.
	 * @param resSession
	 */
	void saveOrUpdateSpreadsheetSession(SpreadsheetSession resSession);
	
	/**
	 * If success return next activity's url, otherwise return null.
	 * @param toolSessionId
	 * @param userId
	 * @return
	 */
	String finishToolSession(Long toolSessionId, Long userId)  throws SpreadsheetApplicationException;

	/**
	 * Return monitoring summary list. The return value is list of spreadsheet summaries for each groups.
	 * @param contentId
	 * @return
	 */
	List<Summary> getSummary(Long contentId);
	
	/**
	 * Return monitoring statistic list. The return value is list of statistics for each groups.
	 * @param contentId
	 * @return
	 */
	List<StatisticDTO> getStatistics(Long contentId);

	/**
	 * Get spreadsheet item <code>Summary</code> list according to sessionId and skipHide flag.
	 *  
	 * @param sessionId
	 * @param skipHide true, don't get spreadsheet item if its <code>isHide</code> flag is true.
	 * 				  Otherwise, get all spreadsheet item  
	 * @return
	 */
	public List<Summary> exportBySessionId(Long sessionId, boolean skipHide);
	public List<List<Summary>> exportByContentId(Long contentId);

	/**
	 * Create refection entry into notebook tool.
	 * @param sessionId
	 * @param notebook_tool
	 * @param tool_signature
	 * @param userId
	 * @param entryText
	 */
	public Long createNotebookEntry(Long sessionId, Integer notebookToolType, String toolSignature, Integer userId, String entryText);
	/**
	 * Get reflection entry from notebook tool.
	 * @param sessionId
	 * @param idType
	 * @param signature
	 * @param userID
	 * @return
	 */
	public NotebookEntry getEntry(Long sessionId, Integer idType, String signature, Integer userID);

	/**
	 * @param notebookEntry
	 */
	public void updateEntry(NotebookEntry notebookEntry);
	
	/**
	 * Get Reflect DTO list grouped by sessionID.
	 * @param contentId
	 * @return
	 */
	Map<Long, Set<ReflectDTO>> getReflectList(Long contentId, boolean setEntry);

	/**
	 * Get user by UID
	 * @param uid
	 * @return
	 */
	SpreadsheetUser getUser(Long uid);
}

