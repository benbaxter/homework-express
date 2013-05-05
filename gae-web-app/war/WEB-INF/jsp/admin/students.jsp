<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		loadStudents();
	});
	
	$('a[data-toggle="tab"]').on('shown', function (e) {
	  loadStudents();
	})
	
	function loadStudents() {
		$.ajax({
			url : "/actions/admin/students",
			success : function(data) {
				if( data[0].Status == "Success" ) {
					if( data[1].length > 0 ) {
						$("#user-template").tmpl( data[1] ).appendTo( $("#studentList").empty() );
					}
				} else {
					$("#loadUserReason").html(data[0].Reason);
					$("#loadUserErrors").show();
				}
			}
		});
	}

	//-->
	</script>
</head>

<h2 id="mainContentTitle">Students</h2>
<p>
<div class="alert alert-error" id="loadUserErrors"
	style="display: none;">
	<span id="loadUserReason"></span>
</div>
<a href="#addUserModel" role="button" class="btn btn-info btn-small"
	data-toggle="modal"> <i class="icon-plus"></i> Add Student
</a>
<table class="table table-hover table-bordered table-striped"
	width="100%">
	<thead>
		<tr>
			<th>Actions</th>
			<th>Name</th>
		</tr>
	</thead>
	<tbody id="studentList">
		<tr>
			<td>There are no students</td>
		</tr>
	</tbody>
</table>
</p>