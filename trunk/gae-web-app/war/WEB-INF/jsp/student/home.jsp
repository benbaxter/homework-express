<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<style type="text/css">
	.table tbody tr:hover {
	    cursor: pointer;
	}
	</style>

	<script src="http://ajax.cdnjs.com/ajax/libs/underscore.js/1.1.6/underscore-min.js"></script>
  
	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		loadCourses();
	});
		
	function loadCourses() {
		$.ajax({
			url : "/actions/student/${user.userId}/courses",
			success : function(data) {
				if( data[0].Status == "Success" ) {
					$("#course-template").tmpl( data[1] ).appendTo( $("#courseList").empty() );
				} else {
					$("#loadUserReason").html(data[0].Reason);
					$("#loadUserErrors").show();
				}
			}
		});
	}
	
	//-->
	</script>
	
	<script type="text/template" id="course-template">
      <tr onclick="javascript: document.location.href='/actions/student/courses/\${Id}'">
		<td>\${Name}</td>
		<td>\${Instructor.FirstName} \${Instructor.LastName}</td>
		<td>\${Description}</td>
	  </tr>
  </script>
</head>

<body>
	<div class="container-fluid">
		<div class="hero-unit">
			<h2 id="mainContentTitle">Courses</h2>
			<p>
			<table class="table table-hover table-bordered table-striped"
				width="100%">
				<thead>
					<tr>
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
		</div>
	</div>
		
</body>