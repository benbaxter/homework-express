<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		//loadCourses();
		//setUpTypeaheadInstructor();
	});
		
	function loadCourses() {
		$.ajax({
			url : "/actions/admin/courses",
				
			beforeSend: function (xhr) { 
				xhr.setRequestHeader ("Authorization", make_base_auth(getCookie("username"), getCookie("password")));
				xhr.setRequestHeader ("username", getCookie("username"));
			},
			success : function(data) {
				$("#course-template").tmpl( data ).appendTo( $("#courseList").empty() );
				$("#mainContentTitle").html("Courses");
			},
			error : function(data) {
				
			}
		});
	}
	
	function setUpTypeaheadInstructor() {
		$('#instructorName').typeahead({
		    source: function (query, process) {
		    	$.ajax({
					url : "/actions/admin/instructors/names",
					type: 'get',
		            data: {query: query},
		            dataType: 'json',
					success : function(data) {
						return typeof data == 'undefined' ? false : process(data);
					}
		    	});
		    }
		});
	}
	
	function createCourse() {
		$.ajax({
			url : "/actions/admin/courses/create",
			data : $("#createCourseForm").serialize(),
			dataType : "json",
			type : "post",
			success : function(data) {
				if( data.status == "success" ) {
					$("#createClassErrors").hide();
					$("#createCourseModel").modal("hide");
					loadCourses();
				} else {
					$("#createCourseReason").html(data.reason);
					$("#createClassErrors").show();
				}
			},
			error : function(data) {
				
			}
		});
	}
	
	//-->
	</script>
	
	<script type="text/template" id="course-template">
      <tr>
		<td>
			<a href="#"><i class="icon-pencil"></i></a>
			<a href="#"><i class="icon-trash"></i></a>
		</td>
		<td>\${name}</td>
		<td>\${instructor.name}</td>
		<td>\${description}</td>
	  </tr>
  </script>
</head>

	<h2 id="mainContentTitle">Could not load section</h2>
	<p>
	<a href="#createCourseModel" role="button" 
		class="btn btn-info btn-small" data-toggle="modal">
		<i class="icon-plus"></i>Create New Course
	</a>
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
    	<form class="well" action="#" method="post" name="createCourseForm" id="createCourseForm">
	    	<div class="alert alert-error" id="createClassErrors" style="display:none;">
	    		There was an error while creating the course.<br />
	    		<span id="createCourseReason"></span>
	    	</div>
			<label>Name</label> 
				<input name="name" class="span3" placeholder="Name" />
			<label>Instructor</label> 
				<input name="instructorName" id="instructorName" class="span3" 
					placeholder="Who will instruct the course?"
					data-provide="typeahead" />
			<label>Description</label> 
				<textarea name="description" class="span3" cols="100" rows="5" 
					placeholder="Tell more about this wonderful course"></textarea>
		</form>
    </p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    <button class="btn btn-primary" onclick="createCourse();">Create Course</button>
  </div>
</div>
	
