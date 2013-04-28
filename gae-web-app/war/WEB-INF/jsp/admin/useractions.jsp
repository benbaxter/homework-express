<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<script type="text/javascript">
	<!--
	
	function loadUsers() {
		loadStudents();
		loadInstructors();
		loadAdmins();
	}
	
	function addUser() {
		$.ajax({
			url : "/actions/admin/users/create",
			data : $("#addUserForm").serialize(),
			dataType : "json",
			type : "post",
			success : function(data) {
				if( data.Status == "Success" ) {
					$("#createUserErrors").hide();
					$("#addUserModel").modal("hide");
					$("#addUserForm")[0].reset();
					loadUsers();
				} else {
					$("#addUserReason").html(data.Reason);
					$("#createUserErrors").show();
				}
			},
			error : function(data) {
				
			}
		});
	}
	
	function deleteUser(userId) {
		$.ajax({
			url : "/actions/admin/users/delete/" + userId,
			dataType : "json",
			type : "get",
			success : function(data) {
				if( data.Status == "Success" ) {
					loadUsers();
				} else {
					$("#loadUserReason").html(data.Reason);
					$("#loadUserErrors").show();
				}
			}
		});
	}
	
	//-->
	</script>
	
	<script type="text/template" id="user-template">
      <tr>
		<td>
			<a href="/actions/profile/edit/\${UserId}"><i class="icon-pencil"></i></a>
			<a href="javascript: deleteUser(\${UserId})"><i class="icon-trash"></i></a>
		</td>
		<td>\${FirstName} \${LastName}</td>
	  </tr>
  </script>
</head>

<!-- Modal -->
<div id="addUserModel" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="addUserModelLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="addUserModelLabel">Create User</h3>
  </div>
  <div class="modal-body">
    <p>
		<form name="addUserForm" id="addUserForm" class="well" action="/actions/admin/users/create" method="post">
			<div class="alert alert-error" id="createUserErrors" style="display:none;">
	    		<span id="addUserReason"></span>
	    	</div>
			<label>Username</label> 
				<input type="text" name="username" class="span3" placeholder="Type your username" />
			<label>Password</label> 
				<input type="password" name="password" class="span3" placeholder="Type your password" />
			<label>Role</label>
				<select name="role" class="span3">
					<option value="Admin">Admin</option>
					<option value="Instructor">Instructor</option>
					<option value="Student">Student</option>
				</select> 
			<label>First Name</label> 
				<input type="text" name="firstname" class="span3" placeholder="Type your username" />
			<label>Last Name</label> 
				<input type="text" name="lastname" class="span3" placeholder="Type your password" />
			 <br />
		</form>
    </p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    <button class="btn btn-primary" onclick="javascript: addUser();">Create User</button>
  </div>
</div>
	