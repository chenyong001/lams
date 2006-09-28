<%@ include file="/includes/taglibs.jsp"%>
<html:form action="/learning/replyTopic.do" focus="message.subject" onsubmit="return validateMessageForm(this);" enctype="multipart/form-data">
	<html:hidden property="sessionMapID"/>
	<c:set var="formBean" value="<%= request.getAttribute(org.apache.struts.taglib.html.Constants.BEAN_KEY) %>" />
	<c:set var="sessionMapID" value="${formBean.sessionMapID}"/>
	<c:set var="sessionMap" value="${sessionScope[sessionMapID]}"/>
	
	
	<div id="content">
	
	<h1>
		${sessionMap.title}
	</h1>
	
	
		<h2>
			<fmt:message key="title.message.reply" />
		</h2>
	
		<html:errors property="error" />
			<%@ include file="/jsps/learning/message/topicreplyform.jsp"%>
	
	</div>
</html:form>


