<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>

	<script type="text/javascript">
	<!--
	
	var currentProcessRunning;
	
	function prepareModalForProcessInformation() {
		$('#waitingModel').modal('show');
		$('#cancelProcessBtn').removeClass("disabled");
		$("#processing-template").tmpl().appendTo( $("#status-message").empty() );
	}
	
	
	function compileProgram() {
		prepareModalForProcessInformation();
		currentProcessRunning = "compile";
		$.ajax({
			url : "/actions/student/assignment/${assignment.id}/compile-program",
			success : function(data) {
				if( data.Status == "Success" ) {
					checkCompileStatus();
				}
			}
		});
	}

	function checkCompileStatus() {
		$.ajax({
			url : "/actions/student/assignment/${assignment.id}/compile-status",
			success : function(data) {
				var done = data[1].Status;
				while(done == "InProgress") {
					done = checkCompileStatus();
				}
				if( done && done != "InProgress" ){
					$('#status-message').html(data[1].Message);
					$('#cancelProcessBtn').addClass("disabled");
					getCompileResult();
				}
			}
		});
	}
	
	function getCompileResult() {
		$.ajax({
			url : "/actions/student/assignment/${assignment.id}/compile-result",
			success : function(data) {
				if( data.result ) {
					data.result.date = formatDate(data.result.date);
				    $("#result-template").tmpl( data.result ).appendTo( $("#resultData").empty() );
				}
			}
		});
	}
	
	
	function testProgram() {
		prepareModalForProcessInformation();
		currentProcessRunning = "test-program";
		$.ajax({
			url : "/actions/student/assignment/${assignment.id}/run-program",
			success : function(data) {
				if( data.Status == "Success" ) {
					checkTestProgramStatus();
				}
			}
		});
	}

	function checkTestProgramStatus() {
		$.ajax({
			url : "/actions/student/assignment/${assignment.id}/run-program-status",
			success : function(data) {
				var done = data[1].Status;
				while(done == "InProgress") {
					done = checkTestProgramStatus();
				}
				if( done && done != "InProgress" ){
					$('#status-message').html(data[1].Message);
					$('#cancelProcessBtn').addClass("disabled");
					getTestProgramResult();
				}
			}
		});
	}
	
	function getTestProgramResult() {
		$.ajax({
			url : "/actions/student/assignment/${assignment.id}/run-program-result",
			success : function(data) {
				if( data.result ) {
					data.result.date = formatDate(data.result.date);
				    $("#result-template").tmpl( data.result ).appendTo( $("#resultData").empty() );
				}
			}
		});
	}
	
	function cancelProcess(){
		if( currentProcessRunning == "compile" ) {
			$.ajax({
				url : "/actions/student/assignment/${assignment.id}/compilestatus",
				success : function(data) {
					
				}
			});
		} else {
			
		}
	}
	
	function formatDate(millis) {
		var d = new Date(millis);
	    var date = d.getDate();
	    var month = d.getMonth() + 1; //Months are zero based
	    var year = d.getFullYear();
	    var hour = d.getHours();
	    if( hour > 12 ) {
	    	hour -= 12;
	    }
	    if ( hour == 0 ) {
	    	hour = 12;
	    }
	    var minute = d.getMinutes();
	    var second = d.getSeconds();
	    var pretty = month + "-" + date + "-" + year + " " + hour + ":" + minute + ":" + second;
	    return pretty;
	}
	
	//-->
	</script>

	<script type="text/template" id="result-template">
	<tr>
		<th>Result</th>
		<td>\${result}</td>
		<th>Error</th>
		<td class="control-group error"><span class="control-label">\${error}</span></td>
	</tr>
	<tr>
		<th>Message</th>
		<td>\${message}</td>
		<th>Date Last Ran</th>
		<td>\${date}</td>
	</tr>
  </script>
	
	<script type="text/template" id="processing-template">
		<div class="progress progress-striped active">
		  <div class="bar" style="width: 100%;"></div>
		</div>
	</script>

</head>

<body>
	<div class="container-fluid maincontent">
		<h2 id="mainContentTitle">${assignment.name}</h2>
		<div class="controls controls-row" width="100%">
			<span class="span4 text-left">${assignment.description}</span>
			<div class="span4 text-right">
				<span class="span4">Due Date: <fmt:formatDate
						value="${assignment.dueDate}" type="both" pattern="MM-dd-yyyy" /></span>
				<span class="span4">Final Submit Date: <fmt:formatDate
						value="${assignment.finalSubmitDate}" type="both"
						pattern="MM-dd-yyyy" /></span>
			</div>
		</div>
		<c:if test="${not empty assignment.results}">
			<c:if test="${not empty assignment.results.result}">
				<c:set var="result" value="${assignment.results}" />
				<div class="assignment-result">
					<table class="table table-bordered">
						<tbody id="resultData">
							<tr>
								<th>Result</th>
								<td>${result.result}</td>
								<th>Error</th>
								<td class="control-group error"><span class="control-label">${result.error}</span></td>
							</tr>
							<tr>
								<th>Message</th>
								<td>${result.message}</td>
								<th>Date Last Ran</th>
								<td><fmt:formatDate value="${result.date}" type="both" pattern="MM-dd-yyyy hh:mm:ss" /></td>
							</tr>
						</tbody>
					</table>
				</div>
			</c:if>
		</c:if>
		<table class="table table-hover table-bordered table-striped"
			width="100%">
			<thead>
				<tr>
					<th>Main</th>
					<th>File</th>
					<th>Date Submitted</th>
				</tr>
			</thead>
			<tbody id="fileList">
				<c:choose>
					<c:when test="${not empty assignment.files}">
						<c:forEach var="file" items="${assignment.files}">
							<tr>
								<td><c:if test="${file.fileType == 'StudentCodeMain'}">
										<i class="icon-ok"></i>
									</c:if></td>
								<td><c:out value="${file.name}" /></td>
								<td><fmt:formatDate value="${file.dateSubmitted}"
										type="both" pattern="MM-dd-yyyy" /></td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td>You have not submitted any files yet.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
		<div class="text-right">
			<a class="btn btn-inverse"
				href="<c:url value="/actions/student/courses/${courseid}" />">Cancel</a>
			<c:if test="${not empty assignment.files}">
				<a class="btn btn-success" href="javascript: compileProgram();">Compile</a>
				<a class="btn btn-success" href="javascript: testProgram();">Test</a>
			</c:if>
			<a class="btn btn-primary"
				href="<c:url value="/actions/student/course/${courseid}/assignment/${assignment.id}/submit" />">Submit</a>
		</div>
	</div>
	
<div id="waitingModel" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Processing</h3>
  </div>
  <div class="modal-body">
  	<div id="status-message">
	    
	</div>
  </div>
  <div class="modal-footer">
  	<a class="btn" id="cancelProcessBtn" href="javascript: cancelProcess();">Cancel</a>
    <button class="btn btn-inverse" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>
</body>