<!DOCTYPE html>

<%@ include file="/common/taglibs.jsp"%>
<lams:html>
<lams:head>
	<title><fmt:message key="label.learning.title" /></title>
	<%@ include file="/common/header.jsp"%>
	
	<style media="screen,projection" type="text/css">
		html, body {
			height: 100%;
			margin: 0;
		}
	 	.fullHeight {
			height: 100%;
	 	}

	 	.item-content {
	 		padding: 5px;
	 	}

	 	.item-instructions {
	 		margin-bottom: 15px;
	 		padding-bottom: 10px;
	 		border-bottom: 1px solid #ddd;
	 	}
	 		 	
	 	.embedded-title {
	 		clear: both;
	 		font-weight: 500;
	 		font-size: larger;
	 	}
	 	
	 	.embedded-description {
	 		padding: 0.5em;
	 	}
	 	
	 	.embedded-file {
	 		text-align: center;
	 		margin: auto;
	 	}
	 	
	 	.embedded-file img {
	 		max-width: 800px;
	 	}
	 	
	 	.embedded-file video {
	 		width: 100%;
	 	}
	 	
	 	.embedded-file embed {
	 		width: 100%;
			height: 100%;
	 	}
	</style>

	<c:set var="sessionMap" value="${sessionScope[sessionMapID]}" />
	<c:set var="toolSessionID" value="${sessionMap.toolSessionID}" />
	
	<lams:JSImport src="includes/javascript/rsrcembed.js" relative="true" />
	<script>
		$(document).ready(function(){
			$('#item-panel').load("<c:url value="/itemReviewContent.do"/>?sessionMapID=${sessionMapID}&mode=${mode}&toolSessionID=${toolSessionID}&itemIndex=${itemIndex}&itemUid=${itemUid}");
 		});
	</script>
</lams:head>

<body class="stripes fullHeight">
	<lams:Page title="${title}" type="learner" hideProgressBar="true" fullScreen="true">
		<div id="item-panel" class="fullHeight"></div>
	</lams:Page>
</body>

</lams:html>