<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		addAnotherFile();
	});
		
	function addAnotherFile() {
		$("#file-input-template").tmpl().appendTo( $("#fileInputs") );
	}
	
	function prepareData() {
		
		$.each($("[name=files]"), function(index, value) {
			if( value == "" ) {
				return false;
			}
		});
		
		$.each($("[name=isMain]"), function(index, value) {
			if( value.checked ) {
				var fileName = $("[name=files]")[index].value.replace(/^.*[\\\/]/, '');
				$("#containsMain").val(fileName);
			}
		});
	}
	
	//-->
	</script>
	
	<script type="text/template" id="file-input-template">
		<label class="radio">
			<input type="radio" name="isMain" />
			Contains Main
			<input name="files" type="file" />
		</label>			
  </script>
</head>

<body>
	<div class="container-fluid maincontent">
		<h2 id="mainContentTitle">${assignment.name}</h2>
		<p>
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
		<form method="post" name="submitAssignmentForm"
			enctype="multipart/form-data" action="${submitUrl}"
			onsubmit="prepareData();">
			<p class="text-error">
				<c:if test="${not empty error}">
					<c:out value="${error}" />
				</c:if>
			</p>
			<input name="callbackurl" type="hidden" value="${callBackUrl}" /> <input
				type="hidden" name="userid" value="${user.userId}" /> <input
				type="hidden" name="assignmentid" value="${assignment.id}" /> <input
				type="hidden" name="containsMain" id="containsMain" />

			<div id="fileInputs"></div>

			<br /> <a class="btn"
				href="<c:url value="/actions/student/course/${courseid}/assignment/${assignment.id}" />">Cancel</a>
			<a class="btn btn-inverse" href="javascript: addAnotherFile()">Add
				Another File</a>
			<button class="btn btn-primary">Submit</button>
		</form>
		</p>
	</div>

</body>