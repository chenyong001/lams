<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
		"http://www.w3.org/TR/html4/loose.dtd">

<%@ include file="/common/taglibs.jsp" %>
<html>
	<body class="stripes">
		<html:form action="/authoring/init.do?mode=${mode}" method="post" styleId="startForm">
			<html:hidden property="spreadsheet.contentId"/>
			<html:hidden property="sessionMapID" styleId="ssss"/>
		</html:form>
		
		<script type="text/javascript">
			document.getElementById("startForm").submit();
		</script>
	<body class="stripes">
</html>
