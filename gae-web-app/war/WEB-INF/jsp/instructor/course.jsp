<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
<style type="text/css">
 .modal-body { overflow: visible }
</style>

<script type="text/javascript">
<!--
$(document).ready(function() {
	setUpTypeaheadStudents();
});

var users;
function setUpTypeaheadStudents() {
	$('#studentName').typeahead({
		minLength: 0,
        items: 9999,
	    source: function (query, process) {
	    	$.ajax({
				url : "/actions/instructor/student-names",
				type: 'get',
	            data: {query: query},
	            dataType: 'json',
				success : function(data) {
					//var d = typeof data == 'undefined' ? false : process(data);
					users = data;
					var results = _.map(data, function(data) {
	                   return data.firstName + " " + data.lastName;
	                });
	                process(results);
				}
	    	});
	    },
        updater: function(id) {
            var user = _.find(users, function(u) {
                return id == (u.firstName + " " + u.lastName);
            });
            $("#studentId").val(user.userId);
            return id;
        }
	});
}

function addStudent() {
	if( $("#studentId").val() != "" ) {
		$.ajax({
			url : "/actions/instructor/course/${course.id}/add/student",
			data : $("#addStudentForm").serialize(),
			dataType : "json",
			type : "post",
			success : function(data) {
				if( data.Status == "Success" ) {
					$("#addStudentErrors").hide();
					$("#addStudentModel").modal("hide");
					$("#addStudentForm")[0].reset();
					loadStudents();
				} else {
					$("#addStudentReason").html(data.Reason);
					$("#addStudentErrors").show();
				}
			}
		});	
	} else {
		$("#addStudentReason").html("Student ID must be entered");
		$("#addStudentErrors").show();
	}
}

function loadStudents() {
	$.ajax({
		url : "/actions/instructor/course/${course.id}/students",
		success : function(data) {
			if( data[0].Status == "Success" ) {
				$("#student-template").tmpl( data[1].Users ).appendTo( $("#studentList").empty() );
			} else {
				$("#loadUserReason").html(data[0].Reason);
				$("#loadUserErrors").show();
			}
		}
	});
}

//-->
</script>

<script type="text/template" id="student-template">
<tr>
<td><a href="javascript: dropStudentFromCLass(\${UserId})"><i class="icon-trash"></i></a></td>
<td>\${FirstName}  \${LastName}</td>
</tr>
</script>

</head>

<body>
	<div class="container-fluid maincontent">
		<h2 id="mainContentTitle">${course.name}</h2>
		<p>
		<div class="controls controls-row">
			<span class="span4">${course.description}</span> 
		</div>
		<div class="text-right">
			<a class="btn btn-inverse"
				href="<c:url value="/actions/instructor/home" />">Go Back</a>
		</div>
		<div class="accordion" id="accordion2">
		  <div class="accordion-group">
		    <div class="accordion-heading">
		      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseOne">
		        Assignments
		      </a>
		    </div>
		    <div id="collapseOne" class="accordion-body collapse in">
		      <div class="accordion-inner">
		      	<c:if test="${not empty course.assignments}">
		      		<div class="text-right">
						<a class="btn btn-primary"
							href="<c:url value="/actions/instructor/home" />"><i class="icon-plus"></i> Add Assignment</a>
					</div>
		        	<table class="table table-hover table-bordered table-striped table-clickable"
						width="100%">
						<thead>
							<tr>
								<th>Actions</th>
								<th>Assignment</th>
								<th>Description</th>
								<th>Due Date</th>
								<th>Final Due Date</th>
							</tr>
						</thead>
						<tbody id="assignmentList">
							<c:forEach var="ass" items="${course.assignments}">
								<tr
									onclick="javascript: document.location.href='/actions/instructor/course/${course.id}/assignment/${ass.id}'">
									<td>
									<a href="/actions/instructor/assigment/${ass.id}/edit"><i class="icon-pencil"></i></a>
									<a href="javascript: deleteAssignment(${ass.id})"><i class="icon-trash"></i></a>
									</td>
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
					</c:if>
					<div class="text-right">
						<a class="btn btn-primary"
							href="<c:url value="/actions/instructor/home" />"><i class="icon-plus"></i> Add Assignment</a>
					</div>
		      </div>
		    </div>
		  </div>
		  <div class="accordion-group">
		    <div class="accordion-heading">
		      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseTwo">
		        Students
		      </a>
		    </div>
		    <div id="collapseTwo" class="accordion-body collapse">
		      <div class="accordion-inner">
		      	<div class="alert alert-error" id="loadUserErrors"
					style="display: none;">
					<span id="loadUserReason"></span>
				</div>
		      	<c:if test="${not empty course.students}">
		      		<div class="text-right">
						<a class="btn btn-primary"
							href="#addStudentModel" data-toggle="modal">
							<i class="icon-plus"></i> Add Student
						</a>
					</div>
			        <table class="table table-hover table-bordered table-striped"
							width="100%">
							<thead>
								<tr>
									<th>Actions</th>
									<th>Name</th>
								</tr>
							</thead>
							<tbody id="studentList">
								<c:forEach var="student" items="${course.students}">
									<tr>
										<td><a href="javascript: dropStudentFromCLass(${student.userId})"><i class="icon-trash"></i></a></td>
										<td>${student.firstName}  ${student.lastName}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</c:if>
					<div class="text-right">
						<a class="btn btn-primary" data-toggle="modal"
							href="#addStudentModel"><i class="icon-plus"></i> Add Student</a>
					</div>
		      </div>
		    </div>
		  </div>
		</div>
		<div class="text-right">
			<a class="btn btn-inverse"
				href="<c:url value="/actions/instructor/home" />">Go Back</a>
		</div>
		</p>
	</div>


<!-- Modal -->
<div id="addStudentModel" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="addStudentModelLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="addStudentModelLabel">Add Student</h3>
  </div>
  <div class="modal-body">
    <p>
		<form name="addStudentForm" id="addStudentForm" class="well" action="/actions/admin/users/create" method="post">
			<div class="alert alert-error" id="addStudentErrors" style="display:none;">
	    		<span id="addStudentReason"></span>
	    	</div>
			<label>Student Name</label> 
				<input type="text" name="studentName" id="studentName" class="span3" placeholder="Type the student's name" />
			<label>Student ID</label> 
				<input type="text" name="studentId" id="studentId" class="span3 disabled" placeholder="Type the student's ID" />
			 <br />
		</form>
    </p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    <button class="btn btn-primary" onclick="javascript: addStudent();">Add Student</button>
  </div>
</div>
	

</body>