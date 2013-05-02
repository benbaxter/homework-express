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
				$("#loadStudentsReason").html(data[0].Reason);
				$("#loadStudentsErrors").show();
			}
		}
	});
}

function dropStudentFromClass(id) {
	$("#loadStudentsErrors").hide();
	$.ajax({
		url : "/actions/instructor/course/${course.id}/student/" + id + "/delete",
		dataType : "json",
		type : "get",
		success : function(data) {
			if( data.Status == "Success" ) {
				loadStudents();
			} else {
				$("#loadStudentsReason").html(data.Reason);
				$("#loadStudentsErrors").show();
			}
		}
	});
}

//-->
</script>

<script type="text/template" id="student-template">
<tr>
<td><a href="javascript: dropStudentFromClass(\${UserId})"><i class="icon-trash"></i></a></td>
<td>\${FirstName}  \${LastName}</td>
</tr>
</script>

</head>
	      	<div class="alert alert-error" id="loadStudentsErrors"
					style="display: none;">
					<span id="loadStudentsReason"></span>
				</div>
				<c:set var="dispaly" value="none" />
		      	<c:if test="${not empty course.students}">
		      		<c:set var="dispaly" value="" />
				</c:if>
		      	<div id="studentSection" style="display : ${display}">
		      		<div class="text-right">
						<a class="btn btn-primary"
							href="#addStudentModel" data-toggle="modal">
							<i class="icon-plus"></i> Add Student
						</a>
					</div>
					<div class="alert alert-error" id="addStudentErrors" style="display:none;">
			    		<span id="addStudentReason"></span>
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
										<td><a href="javascript: dropStudentFromClass(${student.userId})"><i class="icon-trash"></i></a></td>
										<td>${student.firstName}  ${student.lastName}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="text-right">
						<a class="btn btn-primary" data-toggle="modal"
							href="#addStudentModel"><i class="icon-plus"></i> Add Student</a>
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
	
