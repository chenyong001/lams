<!DOCTYPE html>

<%@ include file="/common/taglibs.jsp"%>

<script type="text/javascript" src="swfobject.js"></script>
<script type="text/javascript" src="resize.js"></script>
<script type="text/javascript" src="jquery.js"></script>

<script type="text/javascript">
<!--
	<c:set var="MindmapUser">
		<c:out value="${currentMindmapUser}" escapeXml="true"/>
	</c:set>

	flashvars = { xml: "${mindmapContentPath}", user: "${MindmapUser}", dictionary: "${localizationPath}" }
	
	$(window).resize(makeNice);

	embedFlashObject(700, 525);

	function embedFlashObject(x, y)
	{
		swfobject.embedSWF("mindmap.swf", "flashContent", x, y, "9.0.0", false, flashvars);
	}
-->
</script>

<html>
	<lams:head>
		<title><c:out value="${mindmapDTO.title}" escapeXml="false" />
		</title>
		<lams:css localLinkPath="../" />
	</lams:head>

	<body class="stripes">

			<div id="content">

				<h1>
					<c:out value="${mindmapDTO.title}" escapeXml="false" />
				</h1>

				<p>
					<c:out value="${mindmapDTO.instructions}" escapeXml="false" />
				</p>

				<c:set var="user" value="${mindmapUserDTO}" />
				
				<table>
					<tr>
						<th colspan="2">
							<c:out value="${user.firstName} ${user.lastName}" />

						</th>
					</tr>
								
					<tr>
						<td class="field-name" width="20%">
							<fmt:message key="label.mindmapEntry" />
						</td>
						<td>
							<center id="center12">
								<div id="flashContent">
									<fmt:message>message.enableJavaScript</fmt:message>
								</div>
							</center>
						</td>
					</tr>
					
					<c:if test="${!empty user.entryDTO.entry}">
						<tr>
							<td class="field-name" width="20%">
								<fmt:message key="label.notebookEntry" />
							</td>
							<td>
								<lams:out escapeHtml="true" value="${user.entryDTO.entry}" />
							</td>
						</tr>
					</c:if>
					
				</table>
				
			</div>
			<!--closes content-->

			<div id="footer">
			</div>
			<!--closes footer-->

	</body>
</html>
