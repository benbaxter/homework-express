<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
<style type="text/css">
 .modal-body { 
 	overflow: visible;
 	overflow-y: scroll; 
 }
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

function addAssignment() {
	$("#loadAssignmentsErrors").hide();
	$.ajax({
		url : "/actions/instructor/course/${course.id}/assignment/add",
		data : $("#addAssignmentForm").serialize(),
		dataType : "json",
		type : "post",
		success : function(data) {
			if( data.Status == "Success" ) {
				$("#addAssignmentErrors").hide();
				$("#addAssignmentModel").modal("hide");
				$("#addAssignmentForm")[0].reset();
				loadAssignments();
			} else {
				$("#addAssignmentReason").html(data.Reason);
				$("#addAssignmentErrors").show();
			}
		}
	});	
}

function loadAssignments() {
	$.ajax({
		url : "/actions/instructor/course/${course.id}/students",
		success : function(data) {
			if( data[0].Status == "Success" ) {
				$.each(data[1].Assignments, function(index, value) {
					data[1].Assignments[index].DueDate = formatDateFromServer(value.DueDate);
					data[1].Assignments[index].FinalSubmitDate = formatDateFromServer(value.FinalSubmitDate);
				});
				$("#assignment-template").tmpl( data[1].Assignments ).appendTo( $("#assignmentList").empty() );
			} else {
				$("#loadAssignmentsReason").html(data[0].Reason);
				$("#loadAssignmentsErrors").show();
			}
		}
	});
}

function deleteAssignment(id) {
	$("#loadAssignmentsErrors").hide();
	$.ajax({
		url : "/actions/instructor/course/${course.id}/assignment/" + id + "/delete",
		dataType : "json",
		type : "get",
		success : function(data) {
			if( data.Status == "Success" ) {
				loadAssignments();
			} else {
				$("#loadAssignmentsReason").html(data.Reason);
				$("#loadAssignmentsErrors").show();
			}
		}
	});
}

//-->
</script>

<script type="text/template" id="assignment-template">
<tr>
<td>
<a href="/actions/instructor/courses/${course.id}/assignment/\${Id}"><i class="icon-pencil"></i></a>
<a href="javascript: deleteAssignment(\${Id})"><i class="icon-trash"></i></a>
</td>
<td>\${Name}</td>
<td>\${Description}</td>
<td>\${DueDate}</td>
<td>\${FinalSubmitDate}</td>
</tr>
</script>

</head>
		      	<div class="alert alert-error" id="loadAssignmentsErrors"
					style="display: none;">
					<span id="loadAssignmentsReason"></span>
				</div>
				<c:set var="dispaly" value="none" />
		      	<c:if test="${not empty course.students}">
		      		<c:set var="dispaly" value="" />
				</c:if>
		      	<div id="assignmentSection" style="display : ${display};">
		      		<div class="text-right" style="margin-bottom: 10px;">
						<a class="btn btn-primary" data-toggle="modal"
							href="#addAssignmentModel"><i class="icon-plus"></i> Add Assignment</a>
					</div>
		        	<table class="table table-hover table-bordered table-striped"
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
								<tr>
									<td>
									<a href="/actions/instructor/courses/${course.id}/assignment/${ass.id}"><i class="icon-pencil"></i></a>
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
					</div>
					<div class="text-right">
						<a class="btn btn-primary" data-toggle="modal"
							href="#addAssignmentModel"><i class="icon-plus"></i> Add Assignment</a>
					</div>

<!-- Modal -->
<div id="addAssignmentModel" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="addAssignmentModelLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="addAssignmentModelLabel">Add Assignment</h3>
  </div>
  <div class="modal-body" data-spy="scroll">
    <p>
		<form name="addAssignmentForm" id="addAssignmentForm" class="well" action="/actions/admin/users/create" method="post">
			<div class="alert alert-error" id="addAssignmentErrors" style="display:none;">
	    		<span id="addAssignmentReason"></span>
	    	</div>
			<label>Name</label> 
				<input type="text" name="name" class="span3" placeholder="Type the assignment's name" />
			<label>Description</label> 
				<textarea cols="50" rows="2" name="description" class="span3" placeholder="Tell us a little about the assignment"></textarea>
			<label>Due Date (mm/dd/yyyy)</label> 
				<input type="text" name="dueDate" class="span3" placeholder="Type the assignment's due date" />	
			<label>Final Due Date (mm/dd/yyyy)</label> 
				<input type="text" name="finalDate" class="span3" placeholder="Type the assignment's final due date" />	
			 <br />
		</form>
    </p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    <button class="btn btn-primary" onclick="javascript: addAssignment();">Add Assignment</button>
  </div>
</div>
	