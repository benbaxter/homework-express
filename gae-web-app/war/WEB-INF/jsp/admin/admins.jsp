<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		loadAdmins();
	});
	
	$('a[data-toggle="tab"]').on('shown', function (e) {
		loadAdmins();
	})
	
	function loadAdmins() {
		$.ajax({
			url : "/actions/admin/admins",
			success : function(data) {
				if( data[0].Status == "Success" ) {
					if( data[1].length > 0 ) {
						$("#user-template").tmpl( data[1] ).appendTo( $("#adminList").empty() );
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

	<h2 id="mainContentTitle">Administrators</h2>
	<p>
	<div class="alert alert-error" id="loadUserErrors"
		style="display: none;">
		<span id="loadUserReason"></span>
	</div>
	<a href="#addUserModel" role="button" class="btn btn-info btn-small"
		data-toggle="modal"> <i class="icon-plus"></i> Add Administrator
	</a>
	<table class="table table-hover table-bordered table-striped"
		width="100%">
		<thead>
			<tr>
				<th>Actions</th>
				<th>Name</th>
			</tr>
		</thead>
		<tbody id="adminList">
			<tr>
				<td>There are no administrators</td>
			</tr>
		</tbody>
	</table>
	</p>
