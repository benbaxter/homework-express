<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<body>
	<div class="container-fluid maincontent">
		<div class="row-fluid">
			<div class="tabbable"> <!-- Only required for left/right tabs -->
			  <ul class="nav nav-tabs">
			    <li class="active"><a href="#tab1" data-toggle="tab">Courses</a></li>
			    <li><a href="#instructorTab" data-toggle="tab">Instructors</a></li>
			    <li><a href="#studentTab" data-toggle="tab">Students</a></li>
			    <li><a href="#adminTab" data-toggle="tab">Administrators</a></li>
			  </ul>
			  <div class="tab-content">
			    <div class="tab-pane active" id="tab1">
			      <p>
			      	<jsp:include page="/WEB-INF/jsp/admin/courses.jsp" />
			      </p>
			    </div>
			    <div class="tab-pane" id="instructorTab">
			      <p><jsp:include page="/WEB-INF/jsp/admin/instructors.jsp" /></p>
			    </div>
			    <div class="tab-pane" id="studentTab">
			      <p><jsp:include page="/WEB-INF/jsp/admin/students.jsp" /></p>
			    </div>
			    <div class="tab-pane" id="adminTab">
			      <p><jsp:include page="/WEB-INF/jsp/admin/admins.jsp" /></p>
			    </div>
			  </div>
			</div>
		</div>
		<!--/row-->
	</div>
	<jsp:include page="/WEB-INF/jsp/admin/useractions.jsp" />
	
</body>