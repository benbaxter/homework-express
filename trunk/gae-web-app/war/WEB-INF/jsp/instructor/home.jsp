<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		loadCourses();
	});
		
	function loadCourses() {
		$.ajax({
			url : "/actions/instructor/${user.userId}/courses",
			success : function(data) {
				if( data[0].Status == "Success" ) {
					if( data[1].length > 0 ) {
						$("#course-template").tmpl( data[1] ).appendTo( $("#courseList").empty() );
					}
				} else {
					$("#loadUserReason").html(data[0].Reason);
					$("#loadUserErrors").show();
				}
			}
		});
	}
	

	function addCourse() {
		$.ajax({
			url : "/actions/instructor/course/add",
			data : $("#addCourseForm").serialize(),
			dataType : "json",
			type : "post",
			success : function(data) {
				if( data.Status == "Success" ) {
					$("#addCourseErrors").hide();
					$("#addCourseModel").modal("hide");
					$("#addCourseForm")[0].reset();
					loadCourses();
				} else {
					$("#addCourseReason").html(data.Reason);
					$("#addCourseErrors").show();
				}
			}
		});	
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
		<td>\${Description}</td>
	  </tr>
  </script>
</head>

<body>
	<div class="container-fluid maincontent">
		<h2 id="mainContentTitle">Courses</h2>
		<p>
		<a class="btn btn-primary" href="#addCourseModel" data-toggle="modal"><i class="icon-plus"></i> Add Course</a>
		<div class="alert alert-error" id="loadCourseErrors" style="display:none;">
    		<span id="loadCourseReason"></span>
    	</div>
		<table
			class="table table-hover table-bordered table-striped"
			width="100%">
			<thead>
				<tr>
					<th>Actions</th>
					<th>Name</th>
					<th>Description</th>
				</tr>
			</thead>
			<tbody id="courseList">
				<tr>
					<td colspan="3">You have no courses</td>
				</tr>
			</tbody>
		</table>
		</p>
	</div>

<!-- Modal -->
<div id="addCourseModel" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="addCourseModelLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="addCourseModelLabel">Add Course</h3>
  </div>
  <div class="modal-body">
    <p>
		<form name="addCourseForm" id="addCourseForm" class="well" action="#" method="post">
			<div class="alert alert-error" id="addCourseErrors" style="display:none;">
	    		<span id="addCourseReason"></span>
	    	</div>
			<label>Name</label> 
				<input type="text" name="name" id="addCoursename" class="span5" placeholder="Type the course's name" />
			<label>Description</label> 
				<textarea cols="50" rows="8" name="description" id="addCourseDescription" class="span5" placeholder="Tell us a little about the course"></textarea>
			 <br />
		</form>
    </p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    <button class="btn btn-primary" onclick="javascript: addCourse();">Add Course</button>
  </div>

</div>
	

</body>