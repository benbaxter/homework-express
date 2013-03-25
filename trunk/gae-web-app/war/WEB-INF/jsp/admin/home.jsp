<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<script src="http://ajax.cdnjs.com/ajax/libs/underscore.js/1.1.6/underscore-min.js"></script>
  
	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		loadCourses();
	});
	
	
	//This is an example of using server side data
	//We can use this now to mock up the server call
	//but we could use local instead until the .Net is built
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

	
	//This is an example of using 'local' data
	var newCoursesObj = [
   		{ name: "The Red Violin", description: "new d" },
   		{ name: "Eyes Wide Shut", description: "new d" },
   		{ name: "The Inheritance", description: "new d" }
   	];
	function newCourses() {
		$.ajax({
			url : "/actions/admin/courses",
			success : function(data) {
				$("#course-template").tmpl( newCoursesObj ).appendTo( $("#courseList").empty() );
			},
			error : function(data) {
				
			}
		});
	}
	
	//-->
	</script>
	
	<script type="text/template" id="course-template">
      <tr><td>\${name}</td><td>\${description}</td></tr>
  </script>
</head>

<body>
	<div class="container-fluid">
		<div class="row-fluid">
			<div class="span3">
				<jsp:include page="/WEB-INF/jsp/admin/sidebar.jsp" />
				<!--/.well -->
			</div>
			<!--/span-->
			<div class="span9">
				<div class="row-fluid">
					<div class="span4">
						<h2>Courses</h2>
						<p>
						<ul class="nav nav-list">
							<li class="nav-header">Top 5</li>
							<li><a href="#">INF 101</a></li>
							<li><a href="#">INF 102</a></li>
							<li><a href="#">CIT 101</a></li>
							<li><a href="#">CSC 101</a></li>
							<li><a href="#">CSC 103</a></li>
						</ul>
						</p>
						<p>
							<a class="btn" href="javascript:loadCourses();">See All &raquo;</a> 
							<a class="btn" href="#">Add &raquo;</a>
						</p>
					</div>
					<!--/span-->
					<div class="span4">
						<h2>Instructors</h2>
						<p>
						<ul class="nav nav-list">
							<li class="nav-header">Top 3</li>
							<li><a href="#">Dr. Newell</a></li>
							<li><a href="#">Dr. Doyle</a></li>
							<li><a href="#">Dr. Ward</a></li>
						</ul>
						</p>
						<p>
							<a class="btn" href="#">See All &raquo;</a> <a class="btn"
								href="#">Add &raquo;</a>
						</p>
					</div>
					<!--/span-->
					<div class="span4">
						<h2>Students</h2>
						<p>
						<ul class="nav nav-list">
							<li class="nav-header">Top 3</li>
							<li><a href="#">Adil</a></li>
							<li><a href="#">Mike</a></li>
							<li><a href="#">Tom</a></li>
						</ul>
						</p>
						<p>
							<a class="btn" href="#">See All &raquo;</a> <a class="btn"
								href="#">Add &raquo;</a>
						</p>
					</div>
					<!--/span-->
				</div>
				<!--/row-->
				<div class="hero-unit">
					<h2 id="mainContentTitle">Could not load section</h2>
					<p>
					<table class="table table-hover table-bordered table-striped"
						width="100%">
						<thead>
							<tr>
								<th>Name</th>
								<th>Description</th>
							</tr>
						</thead>
						<tbody id="courseList">
							<tr><td>Could not load courses</td></tr>
						</tbody>
					</table>
					</p>
					<p>
						<a href="javascript:newCourses();" class="btn btn-primary btn-large">Add &raquo;</a>
					</p>
				</div>
			</div>
			<!--/span-->
		</div>
		<!--/row-->
	</div>
</body>