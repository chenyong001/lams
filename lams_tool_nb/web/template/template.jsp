<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
        "http://www.w3.org/TR/html4/strict.dtd">

<%@ include file="/includes/taglibs.jsp"%>

<c:set var="lams">
	<lams:LAMSURL />
</c:set>
<c:set var="tool">
	<lams:WebAppURL />
</c:set>

<lams:html>
<head>
	<lams:headItems />
	<title><fmt:message key="activity.title" /></title>
</head>

<body class="stripes">

		<h1>
			<fmt:message key="activity.title" />
		</h1>

		<div id="content">
			<tiles:insert attribute="content" />
		</div>

		<div id="footer">
		</div>

</body>
</lams:html>
