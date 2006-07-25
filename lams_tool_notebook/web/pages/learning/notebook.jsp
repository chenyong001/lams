<%@ include file="/common/taglibs.jsp"%>

<h1 class="no-tabs-below">
	${notebookDTO.title}
</h1>
<div id="header-no-tabs-learner"></div>
<div id="content-learner">
	<c:if test="${mode == 'learner' || mode == 'author'}">
		<html:form action="/learning" method="post">

			<table>
				<tr>
					<td>
						${notebookDTO.instructions}
					</td>
				</tr>
				
				<c:if test="${not contentEditable}">
					<tr>
						<td>
							
						</td>
					</tr>
				</c:if>


				<tr>
					<td>
						<div>
							<html:textarea property="entryText" readonly="${not contentEditable}" rows="5" cols="66"></html:textarea>
						</div>
					</td>
				</tr>

				<tr>
					<td class="right-buttons">
						<html:hidden property="dispatch" value="finishActivity" />
						<html:hidden property="toolSessionID" />
						<html:submit styleClass="button">
							<fmt:message>button.finish</fmt:message>
						</html:submit>
					</td>
				</tr>
			</table>
		</html:form>
	</c:if>
</div>
<div id="footer-learner"></div>
