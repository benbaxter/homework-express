<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<body>
	<div class="container-fluid maincontent">
		<h2 id="mainContentTitle">${course.name}</h2>
		<p>
		<div class="controls controls-row">
			<span class="span4">${course.description}</span> <span class="span4">${course.instructor.firstName}
				${course.instructor.lastName}</span>
		</div>
		<table class="table table-hover table-bordered table-striped table-clickable"
			width="100%">
			<thead>
				<tr>
					<th>Assignment</th>
					<th>Description</th>
					<th>Due Date</th>
					<th>Final Due Date</th>
				</tr>
			</thead>
			<tbody id="assignmentList">
				<c:forEach var="ass" items="${course.assignments}">
					<tr
						onclick="javascript: document.location.href='/actions/student/course/${course.id}/assignment/${ass.id}'">
						<td>${ass.name}</td>
						<td>${ass.description}</td>
						<td><fmt:formatDate value="${ass.dueDate}" type="both"
								pattern="MM-dd-yyyy" /></td>
						<td><fmt:formatDate value="${ass.finalSubmitDate}"
								type="both" pattern="MM-dd-yyyy" /></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="text-right">
			<a class="btn btn-inverse"
				href="<c:url value="/actions/student/home" />">Go Back</a>
		</div>
		</p>
	</div>

</body>