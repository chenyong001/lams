<%@ include file="/includes/taglibs.jsp" %>

<html:errors property="error" />
<div align="center">
<html:form action="/learning/replyTopic.do" focus="message.subject"
	onsubmit="return validateMessageForm(this);"  enctype="multipart/form-data">
<fieldset>
<%@ include file="/jsps/message/topicreplyform.jsp" %>
 </fieldset>
 </html:form>
</div>
