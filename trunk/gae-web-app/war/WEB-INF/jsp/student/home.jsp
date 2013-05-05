<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
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
	<div class="container-fluid maincontent">
		<h2 id="mainContentTitle">Courses</h2>
		<p>
		<table
			class="table table-hover table-bordered table-striped table-clickable"
			width="100%">
			<thead>
				<tr>
					<th>Name</th>
					<th>Instructor</th>
					<th>Description</th>
				</tr>
			</thead>
			<tbody id="courseList">
				<tr>
					<td colspan="3">You do not have any courses</td>
				</tr>
			</tbody>
		</table>
		</p>
	</div>

</body>