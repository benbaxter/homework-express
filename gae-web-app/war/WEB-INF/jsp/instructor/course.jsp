<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

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
		      	<jsp:include page="/WEB-INF/jsp/instructor/course-assignment.jsp" />
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
		      	<jsp:include page="/WEB-INF/jsp/instructor/course-student.jsp" />
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

</body>