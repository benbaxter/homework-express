<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		loadCourses();
		setUpTypeaheadInstructor();
	});
		
	function loadCourses() {
		$.ajax({
			url : "/actions/admin/courses",
			success : function(data) {
				if( data[0].Status == "Success" ) {
					$("#course-template").tmpl( data[1] ).appendTo( $("#courseList").empty() );
				} else {
					$("#loadCourseReason").html(data[0].Reason);
					$("#loadCourseErrors").show();
				}
			}
		});
	}
	
	var students;
	function setUpTypeaheadInstructor() {
		$('#instructorName').typeahead({
			minLength: 0,
	        items: 9999,
		    source: function (query, process) {
		    	$.ajax({
					url : "/actions/admin/instructors",
					type: 'get',
		            data: {query: query},
		            dataType: 'json',
					success : function(data) {
						students = data[1];
						var results = _.map(data[1], function(d) {
		                   return d.FirstName + " " + d.LastName;
		                });
		                process(results);
					}
		    	});
		    },
	        updater: function(id) {
	            var user = _.find(students, function(u) {
	                return id == (u.FirstName + " " + u.LastName);
	            });
	            $("#instructorId").val(user.UserId);
	            return id;
	        }
		});
	}
	
	function createCourse() {
		if( $("#instructorId").val() != "" ) {
			$.ajax({
				url : "/actions/admin/courses/add",
				data : $("#createCourseForm").serialize(),
				dataType : "json",
				type : "post",
				success : function(data) {
					if( data.Status == "Success" ) {
						$("#createCourseErrors").hide();
						$("#createCourseModel").modal("hide");
						loadCourses();
					} else {
						$("#createCourseReason").html(data.reason);
						$("#createCourseErrors").show();
					}
				}
			});
		} else {
			$("#createCourseReason").html("Student ID must be entered");
			$("#createCourseErrors").show();
		}
	}
	
	function deleteCourse(id) {
		$("#loadCourseErrors").hide();
		$.ajax({
			url : "/actions/instructor/course/" + id + "/delete",
			dataType : "json",
			type : "get",
			success : function(data) {
				if( data.Status == "Success" ) {
					loadCourses();
				} else {
					$("#loadCourseReason").html(data.Reason);
					$("#loadCourseErrors").show();
				}
			}
		});
	}
	
	//-->
	</script>
	
	<script type="text/template" id="course-template">
      <tr>
		<td>
			<a href="/actions/instructor/courses/\${Id}"><i class="icon-pencil"></i></a>
			<a href="javascript: deleteCourse(\${Id})"><i class="icon-trash"></i></a>
		</td>
		<td>\${Name}</td>
		<td>\${Instructor.FirstName} \${Instructor.LastName}</td>
		<td>\${Description}</td>
	  </tr>
  </script>
</head>

	<h2 id="mainContentTitle">Courses</h2>
	<p>
	<a href="#createCourseModel" role="button" 
		class="btn btn-info btn-small" data-toggle="modal">
		<i class="icon-plus"></i> New Course
	</a>
	<div class="alert alert-error" id="loadCourseErrors" style="display:none;">
   		<span id="loadCourseReason"></span>
   	</div>
	<table class="table table-hover table-bordered table-striped"
		width="100%">
		<thead>
			<tr>
				<th>Actions</th>
				<th>Name</th>
				<th>Instructor</th>
				<th>Description</th>
			</tr>
		</thead>
		<tbody id="courseList">
			<tr><td>Could not load courses</td></tr>
		</tbody>
	</table>
	</p>
 
 
 <!-- Modal -->
<div id="createCourseModel" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="createCourseModelLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="createCourseModelLabel">Create Course</h3>
  </div>
  <div class="modal-body">
    <p>
		<form name="createCourseForm" id="createCourseForm" class="well" action="#" method="post">
			<div class="alert alert-error" id="createCourseErrors" style="display:none;">
	    		<span id="createCourseReason"></span>
	    	</div>
			<label>Name</label> 
				<input name="name" class="span9" placeholder="Name" />
			<label>Description</label>
				<textarea cols="50" rows="2" name="description" id="addCourseDescription" class="span9" placeholder="Tell us a little about the course"></textarea>
			<label>Instructor Name</label> 
				<input name="instructorName" id="instructorName" class="span9" 
					placeholder="Who will instruct the course?"
					data-provide="typeahead" />
			<label>Instructor ID</label> 
				<input name="instructorId" id="instructorId" class="span9" />
			 <br /> 	
		</form>
    </p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    <button class="btn btn-primary" onclick="javascript: createCourse();">Create Course</button>
  </div>
</div>
	
