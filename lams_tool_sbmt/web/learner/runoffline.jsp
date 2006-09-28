<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
        "http://www.w3.org/TR/html4/strict.dtd">

<%@include file="/common/taglibs.jsp"%>
<c:set var="sessionMap" value="${sessionScope[sessionMapID]}"/>

<html:html>
<head>

	<%@ include file="/common/header.jsp"%>

	<script type="text/javascript">
		function finish(){
			var finishUrl= "<html:rewrite page='/learner.do?method=finish&sessionMapID=${sessionMapID}'/>";
			location.href= finishUrl;
		}
		function notebook(){
			var finishUrl= "<html:rewrite page='/learning/newReflection.do?sessionMapID=${sessionMapID}'/>";
			location.href= finishUrl;
		}
	</script>
</head>

<body class="stripes">

		<h1>
			<fmt:message key="activity.title"></fmt:message>
		</h1>

		<div id="content">
			<table>
				<tr>
					<td>
						<p>
							<fmt:message key="run.offline.message" />
						</p>
					</td>
				</tr>
			</table>
			
			<div class="right-buttons">
				<c:choose>
					<c:when test="${sessionMap.reflectOn}">
						<html:button property="continueButton" onclick="javascript:notebook();" disabled="${sessionMap.finishLock}"  styleClass="button">
							<fmt:message key="label.continue" />
						</html:button>
					</c:when>
					<c:otherwise>
						<html:button property="finishButton" onclick="javascript:finish();" disabled="${sessionMap.finishLock}" styleClass="button">
							<fmt:message key="button.finish" />
						</html:button>
					</c:otherwise>
				</c:choose>				
			</div>
		</div>
		<div id="footer"></div>

</body>
</html:html>
