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
package org.lamsfoundation.lams.tool.mc.dao.hibernate;

import java.util.List;

import org.hibernate.FlushMode;
import org.lamsfoundation.lams.tool.mc.dao.IMcUploadedFileDAO;
import org.lamsfoundation.lams.tool.mc.pojos.McContent;
import org.lamsfoundation.lams.tool.mc.pojos.McUploadedFile;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 * @author Ozgur Demirtas
 */

public class McUploadedFileDAO extends HibernateDaoSupport implements IMcUploadedFileDAO {

    private static final String GET_UPLOADED_FILES = "from McUploadedFile mcUploadedFile where mcUploadedFile.mcContent.mcContentId = :contentId";

    public McUploadedFile getUploadedFileById(long submissionId) {
	return (McUploadedFile) this.getHibernateTemplate().load(McUploadedFile.class, new Long(submissionId));
    }

    /**
     * 
     * return null if not found
     */
    public McUploadedFile loadUploadedFileById(long submissionId) {
	return (McUploadedFile) this.getHibernateTemplate().get(McUploadedFile.class, new Long(submissionId));
    }

    public void updateUploadFile(McUploadedFile mcUploadedFile) {
	this.getSession().setFlushMode(FlushMode.AUTO);
	this.getHibernateTemplate().update(mcUploadedFile);
    }

    public void saveUploadFile(McUploadedFile mcUploadedFile) {
	this.getSession().setFlushMode(FlushMode.AUTO);
	this.getHibernateTemplate().save(mcUploadedFile);
    }

    public void createUploadFile(McUploadedFile mcUploadedFile) {
	this.getSession().setFlushMode(FlushMode.AUTO);
	this.getHibernateTemplate().save(mcUploadedFile);
    }

    public void UpdateUploadFile(McUploadedFile mcUploadedFile) {
	this.getSession().setFlushMode(FlushMode.AUTO);
	this.getHibernateTemplate().update(mcUploadedFile);
    }

    public void removeUploadFile(Long submissionId) {
	if (submissionId != null) {

	    String query = "from uploadedFile in class org.lamsfoundation.lams.tool.mc.pojos.McUploadedFile"
		    + " where uploadedFile.submissionId = ?";
	    Object obj = this.getSession().createQuery(query).setLong(0, submissionId.longValue()).uniqueResult();
	    if (obj != null) {
		this.getSession().setFlushMode(FlushMode.AUTO);
		this.getHibernateTemplate().delete(obj);
	    }
	}
    }

    public List<McUploadedFile> retrieveMcUploadedFiles(McContent mc) {
	List<McUploadedFile> listFilenames = (List<McUploadedFile>) (getHibernateTemplate().findByNamedParam(
		GET_UPLOADED_FILES, "contentId", mc.getMcContentId()));
	return listFilenames;
    }

    public void deleteUploadFile(McUploadedFile mcUploadedFile) {
	this.getSession().setFlushMode(FlushMode.AUTO);
	this.getHibernateTemplate().delete(mcUploadedFile);
    }

    public void flush() {
	this.getHibernateTemplate().flush();
    }

}