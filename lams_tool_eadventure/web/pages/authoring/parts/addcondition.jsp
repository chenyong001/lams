<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
		"http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/common/taglibs.jsp"%>

<lams:html>
	<lams:head>
		<%@ include file="/common/header.jsp"%>
		<lams:css style="tabbed" />
		

	</lams:head>
	<body class="tabpart">
		<!-- Basic Info Form-->
		<%@ include file="/common/messages.jsp"%>
		<html:form action="/authoring/saveOrUpdateCondition" method="post" styleId="eadventureConditionForm" focus="name" >
			<html:hidden property="sessionMapID" />
			<html:hidden property="position" />
			
			<!-- ver si se usa mas abajo, sino quitar-->
			<c:set var="formBean" value="<%=request.getAttribute(org.apache.struts.taglib.html.Constants.BEAN_KEY)%>" />					
	        <c:set var="sessionMapID" value="${formBean.sessionMapID}" />

			<h2 class="no-space-left">
				<fmt:message key="label.authoring.conditions.add.condition" />
			</h2>

			<div class="field-name">
            	<fmt:message key="label.authoring.conditions.condition.name" />
			</div>

			<div class="small-space-bottom">
         		<html:text property="name" size="55"/>
			</div>
		
			
			<div id="expression">
				<%@ include file="/pages/authoring/parts/expression.jsp"%>
			</div>
		</html:form>

		<lams:ImgButtonWrapper>
			<a href="#" onclick="eadventureConditionForm.submit();" class="button-add-item"><fmt:message
					key="button.add" /> </a>
			<a href="javascript:;" onclick="window.top.hideConditionMessage();"
				class="button space-left"><fmt:message key="label.cancel" /> </a>
		</lams:ImgButtonWrapper>
	</body>
</lams:html>
