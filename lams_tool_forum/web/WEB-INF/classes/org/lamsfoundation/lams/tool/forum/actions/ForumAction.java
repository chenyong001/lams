package org.lamsfoundation.lams.tool.forum.actions;

import org.apache.log4j.Logger;
import org.apache.struts.action.*;
import org.lamsfoundation.lams.tool.forum.core.GenericObjectFactoryImpl;
import org.lamsfoundation.lams.tool.forum.core.PersistenceException;
import org.lamsfoundation.lams.tool.forum.persistence.Forum;
import org.lamsfoundation.lams.tool.forum.persistence.Message;
import org.lamsfoundation.lams.tool.forum.persistence.Attachment;
import org.lamsfoundation.lams.tool.forum.service.ForumManager;
import org.lamsfoundation.lams.tool.forum.forms.ForumForm;
import org.lamsfoundation.lams.tool.forum.forms.MessageForm;
import org.lamsfoundation.lams.tool.forum.util.ContentHandler;
import org.lamsfoundation.lams.contentrepository.CrNodeVersionProperty;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.File;
import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: conradb
 * Date: 10/06/2005
 * Time: 12:18:57
 * To change this template use File | Settings | File Templates.
 */
public class ForumAction extends Action {
  private static Logger log = Logger.getLogger(ForumAction.class.getName());
  private ForumManager forumManager;

  public void setForumManager(ForumManager forumManager) {
      this.forumManager = forumManager;
  }

  public ForumAction() {
       this.forumManager = (ForumManager) GenericObjectFactoryImpl.getInstance().lookup("forumManager");
      //GenericObjectFactoryImpl.getInstance().configure(this);
  }
	public final ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response) throws Exception {
  		String param = mapping.getParameter();
	  	if (param.equals("createForum")) {
       		return createForum(mapping, form, request, response);
        }
	  	if (param.equals("editForum")) {
       		return editForum(mapping, form, request, response);
        }
	  	if (param.equals("getForum")) {
       		return getForum(mapping, form, request, response);
        }
	  	if (param.equals("deleteForum")) {
       		return deleteForum(mapping, form, request, response);
        }
	  	if (param.equals("createTopic")) {
       		return createTopic(mapping, form, request, response);
        }
        if (param.equals("instructions")) {
       		return saveInstructions(mapping, form, request, response);
        }
        if (param.equals("deleteAttachment")) {
       		return deleteAttachment(mapping, form, request, response);
        }
        if (param.equals("deleteTopic")) {
       		return deleteTopic(mapping, form, request, response);
        }
        if (param.equals("advanced")) {
            return mapping.findForward("success");
        }
		return mapping.findForward("error");
    }

    public ActionForward createForum(ActionMapping mapping,
                                              ActionForm form,
                                              HttpServletRequest request,
                                              HttpServletResponse response)
            throws IOException, ServletException, Exception {
        ForumForm forumForm = (ForumForm) form;
        Forum forum = forumForm.getForum();

        Map topics = (Map) request.getSession().getAttribute("topics");
        forum = this.forumManager.createForum(forum, forumForm.getAttachments(), topics);
        forumForm.setForum(forum);

        //populate topics with new topics
        List topicList = this.forumManager.getTopics(forum.getId());
        topics = new HashMap();
        Iterator it = topicList.iterator();
        while (it.hasNext()) {
            Message message = (Message) it.next();
            topics.put(message.getSubject(), message);
        }

        request.getSession().setAttribute("topics", topics);
        request.getSession().setAttribute("topicList", topicList);
        return mapping.findForward("success");
  }

  public ActionForward editForum(ActionMapping mapping,
                                              ActionForm form,
                                              HttpServletRequest request,
                                              HttpServletResponse response)
            throws IOException, ServletException, Exception {
        ForumForm forumForm = (ForumForm) form;
        Forum forum = forumForm.getForum();
        Map topics = (Map) request.getSession().getAttribute("topics");
        this.forumManager.editForum(forum, forumForm.getAttachments(), topics);
        return mapping.findForward("success");
  }

  public ActionForward getForum(ActionMapping mapping,
                                              ActionForm form,
                                              HttpServletRequest request,
                                              HttpServletResponse response)
          throws IOException, ServletException, Exception {
        Long forumId = new Long((String) request.getParameter("forumId"));
        Forum forum = forumManager.getForum(forumId);
        List topicList = this.forumManager.getTopics(forum.getId());
        ForumForm forumForm = new ForumForm();

        forumForm.setForum(forum);
        request.getSession().setAttribute("forum", forumForm);

        Map topics = new HashMap();
        Iterator it = topicList.iterator();
        while (it.hasNext()) {
            Message message = (Message) it.next();
            topics.put(message.getSubject(), message);
        }

        request.getSession().setAttribute("topics", topics);
        request.getSession().setAttribute("topicList", topicList);

        List attachmentList = new ArrayList();
        Collection entries = forum.getAttachments();
        it = entries.iterator();
        while (it.hasNext()) {
            Attachment attachment = (Attachment) it.next();
            ContentHandler handler = new ContentHandler();
            Set properties = handler.getFileProperties(attachment.getUuid());
            Iterator propIt = properties.iterator();
            while (propIt.hasNext()) {
                CrNodeVersionProperty property = (CrNodeVersionProperty) propIt.next();
                if ("FILENAME".equals(property.getName())) {
                    attachment.setName(property.getValue());
                }
                if ("TYPE".equals(property.getName())) {
                    attachment.setType(property.getValue());
                }
                if ("MIMETYPE".equals(property.getName())) {
                    attachment.setContentType(property.getValue());
                }
            }
            attachmentList.add(attachment);
        }
        request.getSession().setAttribute("attachmentList", attachmentList);
        return mapping.findForward("success");
  }

  public ActionForward deleteForum(ActionMapping mapping,
                                              ActionForm form,
                                              HttpServletRequest request,
                                              HttpServletResponse response)
          throws IOException, ServletException, Exception {
        Long forumId = new Long((String) request.getParameter("forumId"));
        forumManager.deleteForum(forumId);
        return (mapping.findForward("success"));
  }

   public ActionForward createTopic(ActionMapping mapping,
                                              ActionForm form,
                                              HttpServletRequest request,
                                              HttpServletResponse response)
          throws IOException, ServletException, PersistenceException {
        MessageForm messageForm = (MessageForm) form;
        Message message = messageForm.getMessage();
        Map topics = (Map) request.getSession().getAttribute("topics");
        if (topics ==  null) {
            topics = new HashMap();
        }
        topics.put(message.getSubject(), message);
        request.getSession().setAttribute("topics", topics);
        request.getSession().setAttribute("topicList", new ArrayList(topics.values()));
        return mapping.findForward("success");
    }

    public ActionForward saveInstructions(ActionMapping mapping,
                                              ActionForm form,
                                              HttpServletRequest request,
                                              HttpServletResponse response)
          throws IOException, ServletException, PersistenceException {
        ForumForm forumForm = (ForumForm) form;
        Collection entries = forumForm.getAttachments().values();
        List attachmentList = new ArrayList(entries);
        request.getSession().setAttribute("attachmentList", attachmentList);
        return mapping.findForward("success");
    }

    public ActionForward deleteAttachment(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ActionForward forward = new ActionForward();
		forward.setPath(mapping.getInput());
        String fileName = (String) request.getParameter("fileName");
        String type = (String) request.getParameter("type");
        ForumForm forumForm = (ForumForm) form;
        Map attachments = forumForm.getAttachments();
        Attachment attachment = (Attachment) attachments.remove(fileName + "-" + type);
        ContentHandler.deleteFile(attachment.getUuid());
        if (attachment.getId() != null) {
            this.forumManager.deleteForumAttachment(attachment.getId());
        }
        List attachmentList = new ArrayList(attachments.values());
        request.getSession().setAttribute("attachmentList", attachmentList);
        return mapping.findForward("success");
    }

    public ActionForward deleteTopic(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws PersistenceException {
        String topicName = (String) request.getParameter("topicName");
        Map topics = (Map) request.getSession().getAttribute("topics");
        Message topic = (Message) topics.remove(topicName);
        if (topic.getId() != null) {
            this.forumManager.deleteMessage(topic.getId());
        }
        request.getSession().setAttribute("topics", topics);
        request.getSession().setAttribute("topicList", new ArrayList(topics.values()));
        return mapping.findForward("success");
    }

}
