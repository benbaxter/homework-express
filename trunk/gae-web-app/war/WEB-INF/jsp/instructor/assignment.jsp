<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>

	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		loadAssignment();
	});
		
	function loadAssignment() {
		$.ajax({
			url : "/actions/instructor/assignment/${assignmentid}/view",
			success : function(data) {
				if( data[0].Status == "Success" ) {
					data[1].DueDate = formatDateFromServer(data[1].DueDate);
					data[1].FinalSubmitDate = formatDateFromServer(data[1].FinalSubmitDate);
					$("#assignment-meta-data-template").tmpl( data[1] ).appendTo( $("#assignment-meta-data").empty() );
					$("#mainContentTitle").html(data[1].Name);
					
					$.each(data[1].Tests, function(index, value) {
						var fileType = "";
						if( data[1].Tests[index].InputFile.FileType == "InstructorTestInput" ) {
							fileType = "Standard Input";
						} else if (data[1].Tests[index].InputFile.FileType == "InstructorTestInputFile" ) {
							fileType = "Input File";
						}
						data[1].Tests[index].InputFile.FileType = fileType;
					});
					$("#test-file-list-template").tmpl( data[1].Tests ).appendTo( $("#testFileList").empty() );
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
					//$('#status-message').html("Compiled Canceled.");
					$('#cancelProcessBtn').addClass("disabled")
				}
			});
		} else {
			$.ajax({
				url : "/actions/student/assignment/${assignment.id}/cancel-program",
				success : function(data) {
					//$('#status-message').html("Program Canceled.");
					$('#cancelProcessBtn').addClass("disabled")	
				}
			});
		}
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

  <script type="text/template" id="assignment-meta-data-template">
	<tr>
		<td>\${Description}</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Due Date: \${DueDate}</td>
		<td>Final Submit Date: \${FinalSubmitDate}</td>
	</tr>
  </script>
	
	<script type="text/template" id="test-file-list-template">
	<tr>
		<td>
			<a href="/actions/instructor/courses/${courseid}/assignment/${assignmentid}/test/\${Id}"><i class="icon-pencil"></i></a>
			<a href="javascript: deleteTest(\${Id})"><i class="icon-trash"></i></a>
		</td>
		<td>\${Name}</td>
		<td>\${Description}</td>
		<td>\${InputFile.FileName}</td>
		<td>\${InputFile.FileType}</td>
		<td>\${OutputFile.FileName}</td>
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
		<h2 id="mainContentTitle"></h2>
		<table class="table">
			<tbody id="assignment-meta-data">
				<tr><td></td></tr>
			</tbody>
		</table>
		<div class="alert alert-error" id="loadAssignmentErrors"
			style="display: none;">
			<span id="loadAssignmentReason"></span>
		</div>
		
		<div class="text-right">
			<a class="btn btn-inverse"
				href="<c:url value="/actions/instructor/courses/${courseid}" />">Go Back</a>
		</div>
		Test Files
		<table class="table table-hover table-bordered table-striped"
			width="100%">
			<thead>
				<tr>
					<th>Actions</th>
					<th>Name</th>
					<th>Description</th>
					<th>Input File</th>
					<th>Type</th>
					<th>Output File</th>
				</tr>
			</thead>
			<tbody id="testFileList">
				<tr>
					<td>You have not uploaded any test files yet.</td>
				</tr>
			</tbody>
		</table>
		<div class="text-right">
			<a class="btn btn-primary"
				href="<c:url value="/actions/student/course/${courseid}/assignment/${assignmentid}/uploadTestFile" />">Upload Tests</a>
		</div>
		<br /><br />
		
		<div class="text-right">
			<a class="btn btn-inverse"
				href="<c:url value="/actions/instructor/courses/${courseid}" />">Go Back</a>
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