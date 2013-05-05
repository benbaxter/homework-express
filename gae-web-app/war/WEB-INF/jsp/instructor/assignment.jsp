<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>

	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		loadAssignment();
	});
		
	var students;
	function loadAssignment() {
		$.ajax({
			url : "/actions/instructor/assignment/${assignmentid}/view",
			success : function(data) {
				if( data[0].Status == "Success" ) {
					data[1].DueDate = formatDateFromServer(data[1].DueDate);
					data[1].FinalSubmitDate = formatDateFromServer(data[1].FinalSubmitDate);
					$("#assignment-meta-data-template").tmpl( data[1] ).appendTo( $("#assignment-meta-data").empty() );
					$("#mainContentTitle").html(data[1].Name);
					formatFileType(data[1]);
					$("#test-file-list-template").tmpl( data[1].Tests ).appendTo( $("#testFileList").empty() );
					students = data[1].Students;
					formatStudentBooleanFields(data[1]);
					$("#student-list-template").tmpl( data[1].Students ).appendTo( $("#studentList").empty() );
				} else {
					$("#loadAssignmentReason").html(data[0].Reason);
					$("#loadAssignmentErrors").show();
				}
			}
		});
	}
	
	
	function formatFileType(data) {
		$.each(data.Tests, function(index, value) {
			if( data.Tests[index].InputFile ) {
				var fileType = "";
				if( data.Tests[index].InputFile.FileType == "InstructorTestInput" ) {
					fileType = "Standard Input";
				} else if (data.Tests[index].InputFile.FileType == "InstructorTestInputFile" ) {
					fileType = "Input File";
				}
				data.Tests[index].InputFile.FileType = fileType;
			} else {
				data.Tests[index].InputFile = new Object();
				data.Tests[index].InputFile.FileType = "";
			}
			
			if( ! data.Tests[index].OutputFile ) {
				data.Tests[index].OutputFile = new Object();
				data.Tests[index].OutputFile = "";
			}
		});
	}
	
	function formatStudentBooleanFields(data) {
		$.each(data.Students, function(index, value) {
			data.Students[index].Submitted = getImageForBoolean(value.Submitted);
			data.Students[index].Compiled = getImageForBoolean(value.Compiled);
			data.Students[index].Ran = getImageForBoolean(value.Ran);
			data.Students[index].Passed = getImageForBoolean(value.Passed);
		});
	}
	
	function getImageForBoolean(bool) {
		if( bool ) {
			return "icon-ok";
		} else {
			return "icon-remove";
		}
	}
	
	function prepareForProcessInformation(id, type) {
		var o = new Object();
		o.id = id;
		o.type = type;
		$("#processing-template").tmpl( o ).appendTo( $("#"+ type + id).empty() );
	}


	function compileAllPrograms() {
		$.each(students, function(index, value) {
			compileProgram(value.UserId);
		});
	}
	
	function compileProgram(id) {
		prepareForProcessInformation(id, "compile");
		$.ajax({
			url : "/actions/instructor/assignment/${assignmentid}/student/" + id + "/compile-program",
			success : function(data) {
				if( data.Status == "Success" ) {
					checkCompileStatus(id);
				}
			}
		});
	}

	function checkCompileStatus(id) {
		$.ajax({
			url : "/actions/instructor/assignment/${assignmentid}/student/" + id + "/compile-status",
			success : function(data) {
				var done = data[1].Status;
				while( done == "InProgress") {
					done = checkCompileStatus(id);
				}
				if( done && done != "InProgress" ){
					getCompileResult(id);
				}
			}
		});
	}
	
	function getCompileResult(id) {
		$.ajax({
			url : "/actions/instructor/assignment/${assignmentid}/student/" + id + "/compile-result",
			success : function(data) {
				if( data.result ) {
					var o = new Object();
					if( data.result.result == "Success" ) {
						o.status = getImageForBoolean(true); 
					} else {
						o.status = getImageForBoolean(false);
					}
					o.id = id;
				    $("#compile-cell-template").tmpl( o ).appendTo( $("#compile" + id).empty() );
				}
			}
		});
	}
	
	function testAllPrograms() {
		$.each(students, function(index, value) {
			testProgram(value.UserId);
		});
	}
	
	function testProgram(id) {
		$("#passed" + id).empty();
		$("#ran" + id).attr("colspan", 2);
		$("#passed" + id).hide();
		prepareForProcessInformation(id, "ran");
		$.ajax({
			url : "/actions/instructor/assignment/${assignmentid}/student/" + id + "/run-program",
			success : function(data) {
				if( data.Status == "Success" ) {
					checkTestProgramStatus(id);
				}
			}
		});
	}

	function checkTestProgramStatus(id) {
		$.ajax({
			url : "/actions/instructor/assignment/${assignmentid}/student/" + id + "/run-program-status",
			success : function(data) {
				var done = data[1].Status;
				while( done == "InProgress") {
					done = checkTestProgramStatus(id);
				}
				if( done && done != "InProgress" ){
					getTestProgramResult(id);
				}
			}
		});
	}
	
	function getTestProgramResult(id) {
		$.ajax({
			url : "/actions/instructor/assignment/${assignmentid}/student/" + id + "/run-program-result",
			success : function(data) {
				$("#ran" + id).attr("colspan", 1);
				$("#passed" + id).show();
				var o = new Object();
				o.id = id;
			    $.each(data.results, function(index, value) {
					o.status |= (value.result == "PassTest"); 
				});
				o.status = getImageForBoolean(o.status);
				$("#passed-cell-template").tmpl( o ).appendTo( $("#passed" + id).empty() );
				 $.each(data.results, function(index, value) {
						o.status |= value.hasRan; 
				});
				o.status = getImageForBoolean(o.status);
			    $("#ran-cell-template").tmpl( o ).appendTo( $("#ran" + id).empty() );
			}
		});
	}
	
	function cancelProcess(id, type){
		if( type == "compile" ) {
			$.ajax({
				url : "/actions/instructor/assignment/${assignmentid}/student/" + id + "/cancel-compile",
				success : function(data) {
					var o = new Object();
					o.status = "icon-remove";
					$("#compile-cell-template").tmpl( o ).appendTo( $("#compile" + id).empty() );
				}
			});
		} else {
			$.ajax({
				url : "/actions/instructor/assignment/${assignmentid}/student/" + id + "/cancel-program",
				success : function(data) {
					var o = new Object();
					o.id = id;
					o.status = "icon-remove";
					$("#ran-cell-template").tmpl( o ).appendTo( $("#ran" + id).empty() );
					$("#passed-cell-template").tmpl( o ).appendTo( $("#passed" + id).empty() );
				}
			});
		}
	}
	
	function getStudent(id){
		var stud; 
		$.each(students, function(index, value) {
			if( value.UserId == id ) {
				stud = value;
			}
		});
		return stud;
	}
	
	function editStudent(id) {
		$("#updateStudentReason").html();
		$("#updateStudentErrors").hide();
		$("#updateStudentModel").modal('show');
		var stud = getStudent(id);
		$("#studentid").val(id);
		$("#studentName").val(stud.FirstName + " " + stud.LastName);
		if( stud.OverrideDate ) {
			if(stud.OverrideDate.indexOf("-") > -1) {
				$("#overrideDate").val(stud.OverrideDate);			
			} else {
				$("#overrideDate").val(formatDateFromServeryyyyMMdd(stud.OverrideDate));
			}
		}
	}

	function updateStudent() {
		if( $("#overrideDate").val() != "" ) {
			$.ajax({
				url : "/actions/instructor/assignment/${assignmentid}/student/" 
						+ $("#studentid").val() + "/update",
				data : $("#updateStudentForm").serialize(),
				dataType : "json",
				type : "get",
				success : function(data) {
					if( data.Status == "Success" ) {
						$.each(students, function(index, value) {
							if( value.UserId == $("#studentid").val() ) {
								students[index].OverrideDate =  $("#overrideDate").val();
							}
						});
						javascript: document.forms['updateStudentForm'].reset();
						$("#updateStudentModel").modal('hide');
					} else {
						$("#updateStudentReason").html(data.Reason);
						$("#updateStudentErrors").show();
					}
				}
			});
		} else {
			$("#updateStudentReason").html("Date must be entered");
			$("#updateStudentErrors").show();
		}
	}
	
	function deleteTest(id) {
		$.ajax({
			url : "/actions/instructor/assignment/${assignmentid}/test/" + id + "/delete",
			dataType : "json",
			type : "get",
			success : function(data) {
				if( data.Status == "Success" ) {
					loadAssignment();
				} else {
					$("#loadAssignmentReason").html(data.Reason);
					$("#loadAssignmentErrors").show();
				}
			}
		});
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
			<a href="javascript: deleteTest(\${Id})"><i class="icon-trash"></i></a>
		</td>
		<td>\${Name}</td>
		<td>\${Description}</td>
		<td>\${InputFile.FileName}</td>
		<td>\${InputFile.FileType}</td>
		<td>\${OutputFile.FileName}</td>
	</tr>
  </script>
	
  <script type="text/template" id="student-list-template">
	<tr>
		<td>
			<a href="javascript: editStudent(\${UserId})"><i class="icon-pencil"></i></a>
		</td>
		<td>\${FirstName} \${LastName}</td>
		<td><i class="\${Submitted}"></i></td>
		<td id="compile\${UserId}"><i class="\${Compiled}"></i>
		<a href="javascript: compileProgram(\${UserId});" class="pull-right"><i class=" icon-play"></i></a>
		</td>
		<td id="ran\${UserId}"><i class="\${Ran}"></i>
		<a href="javascript: testProgram(\${UserId});" class="pull-right"><i class=" icon-play"></i></a>
		</td>		
		<td id="passed\${UserId}"><i class="\${Passed}"></i></td>
	</tr>
  </script>	
  
  <script type="text/template" id="compile-cell-template">
	<i class="\${status}"></i>
	<a href="javascript: compileProgram(\${id});" class="pull-right"><i class=" icon-play"></i></a>
  </script>	
  
  <script type="text/template" id="ran-cell-template">
	<i class="\${status}"></i>
	<a href="javascript: testProgram(\${id});" class="pull-right"><i class=" icon-play"></i></a>
  </script>	
  
  <script type="text/template" id="passed-cell-template">
	<i class="\${status}"></i>
  </script>	
  
	<script type="text/template" id="processing-template">
		<div class="progress progress-striped active" style="margin-bottom: 0px;">
		  <div class="bar" style="width: 90%;"></div><a href="javascript: cancelProcess(\${id}, '\${type}')"><i class='icon-remove'></i></a>
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
		<c:set var="goBackUrl" value="/actions/instructor/courses/${courseid}" />
		<div class="text-right">
			<a class="btn btn-inverse"
				href="${goBackUrl}">Go Back</a>
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
					<td colspan="6">You have not uploaded any test files yet.</td>
				</tr>
			</tbody>
		</table>
		<div class="text-right">
			<a class="btn btn-primary"
				href="<c:url value="/actions/instructor/course/${courseid}/assignment/${assignmentid}/uploadTestFile" />">Upload Tests</a>
			<a class="btn btn-inverse"
				href="${goBackUrl}">Go Back</a>
		</div>
		<div>
		<div class="pull-right">
			<a class="btn btn-success compileAllPrograms" href="javascript: compileAllPrograms();">Compile All</a>
			<a class="btn btn-success testAllPrograms" href="javascript: testAllPrograms();">Test All</a>
			<a class="btn btn-inverse"
				href="${goBackUrl}">Go Back</a>
		</div>
		<div class="pull-left">
			Students
		</div>
		</div>
		<table class="table table-hover table-bordered table-striped"
			width="100%">
			<thead>
				<tr>
					<th>Actions</th>
					<th>Name</th>
					<th>Submitted</th>
					<th>Compiled</th>
					<th>Ran</th>
					<th>Passed</th>
				</tr>
			</thead>
			<tbody id="studentList">
				<tr>
					<td colspan="6">There are no students who have this assignment.</td>
				</tr>
			</tbody>
		</table>
		<div class="text-right">
			<a class="btn btn-success compileAllPrograms" href="javascript: compileAllPrograms();">Compile All</a>
			<a class="btn btn-success testAllPrograms" href="javascript: testAllPrograms();">Test All</a>
			<a class="btn btn-primary" href="${reportUrl}">Download Report</a>
			<a class="btn btn-inverse"
				href="${goBackUrl}">Go Back</a>
		</div>
		
	</div>
	
<div id="updateStudentModel" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Update Student</h3>
  </div>
  <div class="modal-body">
    <form name="updateStudentForm" id="updateStudentForm" class="well" action="#" method="post">
		<div class="alert alert-error" id="updateStudentErrors" style="display:none;">
    		<span id="updateStudentReason"></span>
    	</div>
    	<input type="hidden" name="studentid" id="studentid"  />
		<label>Name</label> 
			<input type="text" class="disabled" id="studentName" class="span5" disabled="disabled" />
		<label>Override Submit Date</label> 
			<input type="date" id="overrideDate" name="overrideDate" class="span5" />
		 <br />
	</form>
  </div>
  <div class="modal-footer">
  	<a class="btn" data-dismiss="modal" href="#">Cancel</a>
    <a class="btn btn-inverse" aria-hidden="true" href="javascript: updateStudent();">Update</a>
  </div>
</div>
</body>