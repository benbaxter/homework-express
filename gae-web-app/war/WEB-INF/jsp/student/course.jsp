<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<style type="text/css">
	.table tbody tr:hover {
	    cursor: pointer;
	}
	</style>
</head>

<body>
	<div class="container-fluid">
		<div class="hero-unit">
			<h2 id="mainContentTitle">${course.name}</h2>
			<p>
			<div class="controls controls-row">
			  <span class="span4">${course.description}</span>
			  <span class="span4">${course.instructor.firstName} ${course.instructor.lastName}</span>
			</div>
			<table class="table table-hover table-bordered table-striped" width="100%">
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
						<tr onclick="javascript: document.location.href='/actions/student/course/${course.id}/assignment/${ass.id}'">
							<td>${ass.name}</td>
							<td>${ass.description}</td>
							<td><fmt:formatDate value="${ass.dueDate}" type="both" pattern="MM-dd-yyyy" /></td>
							<td><fmt:formatDate value="${ass.finalSubmitDate}" type="both" pattern="MM-dd-yyyy" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			</p>
		</div>
	</div>
		
</body>