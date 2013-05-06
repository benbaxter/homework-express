<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<link rel="stylesheet" type="text/css" href="/css/Diff.css" />
	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		loadAssignment();
	});
		
	var tests;
	function loadAssignment() {
		$.ajax({
			url : "/actions/student/course/${courseid}/assignment/${assignmentid}.json",
			success : function(data) {
				if( data[0].Status == "Success" ) {
					if( data[1].TestResults.length > 0 ) {
						$.each(data[1].TestResults, function(index, value) {
							data[1].TestResults[index].Date = formatDateFromServerMMddyy(value.Date);
							data[1].TestResults[index].index = index;
						});
						$("#result-template").tmpl( data[1].TestResults ).appendTo( $("#testResultData").empty() );
						tests = data[1].TestResults;
					} else {
						$("#testResultData").html("There are no results until something is run.")
					}
				} else {
					$("#loadAssignmentReason").html(data[0].Reason);
					$("#loadAssignmentErrors").show();
				}
			}
		});
	}
	
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
				    //$("#result-template").tmpl( data.result ).appendTo( $("#compileResultData").empty() );
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
				if( done == "InProgress") {
					setTimeout(checkTestProgramStatus(),3000);
				} else {
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
						data.results[index].index = index;
					});
					$("#result-2-template").tmpl( data.results ).appendTo( $("#testResultData").empty() );
					tests = data.results;
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
	
	function openCompare(index) {
		$.each(tests, function(i, value) {
			if( value.index == index ) {
				$("#compare-body").html(value.HtmlCompare);
			}
		});
		$("#compareModel").modal('show');
	}
	
	function openCompare2(index) {
		$.each(tests, function(i, value) {
			if( value.index == index ) {
				$("#compare-body").html(value.compare);
			}
		});
		$("#compareModel").modal('show');
	}
	
	//-->
	</script>

	<script type="text/template" id="result-template">
	<tr>
		<td>\${index}</td>
		<td>\${Message}</td>
		<td><a href="javascript: openCompare(\${index});">View Compare</a></td>
	</tr>
   </script>

	<script type="text/template" id="result-2-template">
	<tr>
		<td>\${index}</td>
		<td>\${message}</td>
		<td><a href="javascript: openCompare2(\${index});">View Compare</a></td>
	</tr>
   </script>
	
<%--
	<script type="text/template" id="result-template">
	<div>
		    <span class="pull-right" id="compare\${index}">
				\${HtmlCompare}
		    </span>
		</div>
	<br />
   </script>
 --%>	
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
		<div class="alert alert-error" id="loadAssignmentErrors"
			style="display: none;">
			<span id="loadAssignmentReason"></span>
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
				<a class="btn btn-info" href="#resultsModel" data-toggle="modal">View Results</a>
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

<div id="resultsModel" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Results</h3>
  </div>
  <div class="modal-body">
  	<div id="result-body">
	   <table class="table table-hover table-bordered table-striped" width="100%">
			<thead>
				<tr>
					<th>Test</th>
					<th>Result</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody id="testResultData">
		</tbody>
		</table>
	</div>
  </div>
  <div class="modal-footer">
    <button class="btn btn-inverse" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>

<div id="compareModel" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Compare</h3>
  </div>
  <div class="modal-body">
  	<div id="compare-body">
	</div>
  </div>
  <div class="modal-footer">
    <button class="btn btn-inverse" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>

</body>