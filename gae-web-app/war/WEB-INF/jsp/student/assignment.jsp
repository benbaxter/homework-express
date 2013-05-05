<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>

	<script type="text/javascript">
	<!--
	
	var currentProcessRunning;
	
	function prepareModalForProcessInformation() {
		$("#results-section").show();
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
				while( done == "InProgress") {
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
				    $("#result-template").tmpl( data.result ).appendTo( $("#compileResultData").empty() );
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
				while( done == "InProgress") {
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
				if( data.results ) {
					$.each(data.results, function(index, value) {
						data.results[index].date = formatDate(value.date); 
					});
				    $("#result-template").tmpl( data.results ).appendTo( $("#testResultData").empty() );
				}
			}
		});
	}
	
	function cancelProcess(){
		if( currentProcessRunning == "compile" ) {
			$.ajax({
				url : "/actions/student/assignment/${assignment.id}/cancel-compile",
				success : function(data) {
					$('#cancelProcessBtn').addClass("disabled")
				}
			});
		} else {
			$.ajax({
				url : "/actions/student/assignment/${assignment.id}/cancel-program",
				success : function(data) {
					$('#cancelProcessBtn').addClass("disabled")	
				}
			});
		}
	}
	
	//-->
	</script>

	<script type="text/template" id="result-template">
	<tr>
	<td>Status: \${message}
	<br />
	Date Last Ran: 
	\${date}
	</td>
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
		<c:set var="displayResults" value="none" />
		<c:if test="${not empty assignment.testResults}">
			<c:if test="${not empty assignment.compileResult}">
				<c:set var="displayResults" value="" />
			</c:if>
		</c:if>
			<div class="assignment-result" id="results-section" style="display: ${displayResults}">
				<c:set var="compileResult" value="${assignment.compileResult}" />
				Compile Results
				<table class="table table-bordered">
					<tbody id="compileResultData">
						<tr>
							<td>Status: ${compileResult.message}
							<br />
							Date Last Ran: 
							<fmt:formatDate value="${compileResult.date}" type="both" pattern="MM-dd-yyyy hh:mm:ss" />
							</td>
						</tr>
					</tbody>
				</table>
				Test Results
				<table class="table table-bordered">
					<tbody id="testResultData">
					<c:set var="counter" value="0" />
						<c:forEach var="testResult" items="${assignment.testResults}">
							<c:if test="${counter % 3 == 0}">
								<tr>
							</c:if>
								<td>
								${testResult.compare}
								<br />
								Date Last Ran: <fmt:formatDate value="${testResult.date}" type="both" pattern="MM-dd-yyyy hh:mm:ss" />
								</td>
							<c:if test="${counter % 3 == 2}">
								</tr>
							</c:if>
							<c:set var="counter" value="${counter + 1}" />
						</c:forEach>
					</tr>
					</tbody>
				</table>
			</div>
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
							<td colspan="3">You have not submitted any files yet.</td>
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
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">�</button>
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