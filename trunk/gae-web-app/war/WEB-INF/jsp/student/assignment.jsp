<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<body>
	<div class="container-fluid">
		<div class="hero-unit">
			<h2 id="mainContentTitle">${assignment.name}</h2>
			<p>
			<div class="controls controls-row" width="100%">
			   <span class="span4 text-left">${assignment.description}</span>
				<div class="span4 text-right">
				  <span class="span4">Due Date: <fmt:formatDate value="${assignment.dueDate}" type="both" pattern="MM-dd-yyyy" /></span>
				  <span class="span4">Final Submit Date: <fmt:formatDate value="${assignment.finalSubmitDate}" type="both" pattern="MM-dd-yyyy" /></span>
				</div>
			</div>
			<table class="table table-hover table-bordered table-striped" width="100%">
				<thead>
					<tr>
						<th>Main</th>
						<th>File</th>
						<th>Date Submitted</th>
					</tr>
				</thead>
				<tbody id="fileList">
					<c:choose>
						<c:when test="${not empty assignment.files}">
							<c:forEach var="file" items="${assignment.files}">
								<tr>
									<td>
										<c:if test="${file.fileType == 'StudentCodeMain'}">
											<i class="icon-ok"></i>
										</c:if>
									</td>
									<td><c:out value="${file.name}" /></td>
									<td><fmt:formatDate value="${file.dateSubmitted}" type="both" pattern="MM-dd-yyyy" /></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td>You have not submitted any files yet.</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			<div class="text-right">
				<a class="btn" href="<c:url value="/actions/student/courses/${courseid}" />">Cancel</a>
				<c:if test="${not empty assignment.files}">
					<a class="btn  btn-inverse">Compile</a>
				</c:if>
				<a class="btn btn-primary" href="/actions/student/course/${courseid}/assignment/${assignment.id}/submit">Submit</a>
			</div>
			</p>
		</div>
	</div>
		
</body>