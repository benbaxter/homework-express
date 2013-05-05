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
					$("#mainContentTitle").html(data[1].Name);
					$("#assignmentDescription").html(data[1].Description);
					$("#assignmentDescription").html(data[1].Description);
					$("#assignmentDueDate").html("Due Date: " + formatDateFromServerMMddyy(data[1].DueDate));
					$("#assignmentFinalSubmitDate").html("Final Submt Date: " + formatDateFromServerMMddyy(data[1].FinalSubmitDate));
				} else {
					$("#loadAssignmentReason").html(data[0].Reason);
					$("#loadAssignmentErrors").show();
				}
			}
		});
	}
	
	function prepareData() {
		
		$.each($("[name=outputFile]"), function(index, value) {
			if( value == "" ) {
				return false;
			}
		});
		
//		$.each($("[name=isMain]"), function(index, value) {
//			if( value.checked ) {
//			var fileName = $("[name=files]")[index].value.replace(/^.*[\\\/]/, '');
//				$("#containsMain").val(fileName);
//			}
//		});
	}
	
	//-->
	</script>
	
</head>

<body>
	<div class="container-fluid maincontent">
		<h2 id="mainContentTitle"></h2>
		<p>
		<div class="controls controls-row" width="100%">
			<span class="span4 text-left" id="assignmentDescription"></span>
			<div class="span4 text-right">
				<span class="span4" id="assignmentDueDate"></span>
				<span class="span4" id="assignmentFinalSubmitDate"></span>
			</div>
		</div>
		<div class="alert alert-error" id="loadAssignmentErrors"
			style="display: none;">
			<span id="loadAssignmentReason"></span>
		</div>
		<form method="post" name="submitTestForm" class="form-horizontal"
			enctype="multipart/form-data" action="${submitUrl}"
			onsubmit="prepareData();">
			<p class="text-error">
				<c:if test="${not empty error}">
					<c:out value="${error}" />
				</c:if>
			</p>
			<input name="callbackurl" type="hidden" value="${callbackUrl}" /> 
			<input type="hidden" name="courseid" value="${courseid}" />
			<input type="hidden" name="userid" value="${user.userId}" />  
			<input type="hidden" name="assignmentid" value="${assignmentid}" /> 
			<div class="control-group">
				<label class="control-label" for="name">Name</label>
			    <div class="controls">
					<input type="text" name="name" placeholder="Name" /> 
			    </div>
			</div>
			<div class="control-group">
				<label class="control-label" for="description">Description</label>
			    <div class="controls">
					<textarea cols="30" rows="3" name="description" placeholder="Describe the test case."></textarea>
			    </div>
			</div>
			<div class="control-group">
				<label class="control-label" for="files">Output File</label>
			    <div class="controls">
					<input name="files" type="file" placeholder="Choose an output file" />
			    </div>
			</div>
			<div class="control-group">
				<label class="control-label" for="files">Input File</label>
			    <div class="controls">
					<input name="files" type="file" placeholder="Choose an input file" />
			    </div>
			</div>
			<div class="control-group">
				<label class="control-label" for="inputType">Input File Type</label>
			    <div class="controls">
					<select name="inputType">
						<option value="">Select the type for the input</option>
						<option value="InstructorTestInput">Standard Input</option>
						<option value="InstructorTestInputFile">Input File</option>
					</select>
			    </div>
			</div>
			<div class="control-group">
				<div class="controls">
			    	<a class="btn" href="<c:url value="/actions/instructor/courses/${courseid}/assignment/${assignmentid}" />">Cancel</a>
					<button class="btn btn-primary">Submit</button>
			    </div>
			</div>
		</form>
		</p>
	</div>

</body>