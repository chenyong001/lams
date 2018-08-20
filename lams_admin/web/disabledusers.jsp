<!DOCTYPE html>

<%@ include file="/taglibs.jsp"%>

<lams:html>
<lams:head>
	<c:set var="title"><fmt:message key="admin.user.management"/></c:set>
	<title>${title}</title>

	<lams:css/>
	<link rel="stylesheet" href="<lams:LAMSURL/>/admin/css/admin.css" type="text/css" media="screen">
	<link rel="stylesheet" href="<lams:LAMSURL/>css/jquery-ui-smoothness-theme.css" type="text/css" media="screen">
	<script language="JavaScript" type="text/JavaScript" src="<lams:LAMSURL/>/includes/javascript/changeStyle.js"></script>
	<link rel="shortcut icon" href="<lams:LAMSURL/>/favicon.ico" type="image/x-icon" />
</lams:head>
    
<body class="stripes">
	<c:set var="subtitle"><fmt:message key="admin.list.disabled.users"/></c:set>	
	<c:if test="${not empty subtitle}">
		<c:set var="title">${title}: <fmt:message key="${subtitle}"/></c:set>
	</c:if>
	
	<lams:Page type="admin" title="${title}">
		<p><a href="<lams:LAMSURL/>/admin/sysadminstart.do" class="btn btn-default"><fmt:message key="sysadmin.maintain" /></a></p>

		<table class="table table-striped table-condensed">
		<tr>
			<th></th>
			<th><fmt:message key="admin.user.login"/></th>
			<th><fmt:message key="admin.user.title"/></th>
			<th><fmt:message key="admin.user.first_name"/></th>
			<th><fmt:message key="admin.user.last_name"/></th>
			<th></th>
		</tr>
		<c:forEach var="user" items="${users}">
			<tr>
				<td>
					<c:out value="${user.userId}" />
				</td>
				<td>
					<c:out value="${user.login}" />
				</td>
				<td>
					<c:out value="${user.title}" />
				</td>
				<td>
					<c:out value="${user.firstName}" />
				</td>
				<td>
					<c:out value="${user.lastName}" />
				</td>
				<td>
					<a href="user/enable.do?userId=<c:out value="${user.userId}"/>" class="btn btn-default btn-sm"><fmt:message key="admin.enable"/></a>
				</td>		
			</tr>
		</c:forEach>
		</table>
	</lams:Page>

</body>
</lams:html>



