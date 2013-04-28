<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<head>
	<script src="http://ajax.cdnjs.com/ajax/libs/underscore.js/1.1.6/underscore-min.js"></script>
  
	<script type="text/javascript">
	<!--
	$(document).ready(function() {
		loadUsers();
		setUpTypeaheadInstructor();
	});
		
	function loadUsers() {
		$.ajax({
			url : "/actions/admin/${usertype}",
				
			beforeSend: function (xhr) { 
				//xhr.setRequestHeader ("Authorization", make_base_auth(getCookie("username"), getCookie("password")));
				xhr.setRequestHeader ("Authorization", "Basic ${basicauthorization}");
				xhr.setRequestHeader ("username", getCookie("username"));
			},
			success : function(data) {
				if( data[0].Status == "Success" ) {
					$("#user-template").tmpl( data[1] ).appendTo( $("#userList").empty() );
				} else {
					$("#loadUserReason").html(data[0].Reason);
					$("#loadUserErrors").show();
				}
			}
		});
	}
	
	function setUpTypeaheadInstructor() {
		$('#username').typeahead({
		    source: function (query, process) {
		    	$.ajax({
					url : "/actions/admin/instructors/names",
					type: 'get',
		            data: {query: query},
		            dataType: 'json',
					success : function(data) {
						return typeof data == 'undefined' ? false : process(data);
					}
		    	});
		    }
		});
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

<body>
	<div class="container-fluid">
		<div class="row-fluid">
			<div class="span3">
				<jsp:include page="/WEB-INF/jsp/admin/sidebar.jsp" />
				<!--/.well -->
			</div>
			<!--/span-->
			<div class="span9">
				<div class="hero-unit">
					<h2 id="mainContentTitle">${title}</h2>
					<p>
					<div class="alert alert-error" id="loadUserErrors" style="display:none;">
			    		<span id="loadUserReason"></span>
			    	</div>
					<a href="#addUserModel" role="button" 
						class="btn btn-info btn-small" data-toggle="modal">
						<i class="icon-plus"></i>Add ${subject}
					</a>
					<table class="table table-hover table-bordered table-striped"
						width="100%">
						<thead>
							<tr>
								<th>Actions</th>
								<th>Name</th>
							</tr>
						</thead>
						<tbody id="userList">
							<tr><td>Could not load users</td></tr>
						</tbody>
					</table>
					</p>
				</div>
			</div>
			<!--/span-->
		</div>
		<!--/row-->
	</div>
	
 
<!-- Modal -->
<div id="addUserModel" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="addUserModelLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="addUserModelLabel">Create User</h3>
  </div>
  <div class="modal-body">
    <p>
    <!-- 
    	<form class="well" action="#" method="post" name="addUserForm" id="addUserForm">
			<label>User ID</label> 
				<input name="userid" class="span3" placeholder="userid" />
			<label>User Names</label> 
				<input name="usernames" id="instructorName1" class="span3" 
					placeholder="Who will instruct the course?"
					data-provide="typeahead" /> <br />
				<input name="usernames" id="instructorName2" class="span3" 
					placeholder="Who will instruct the course?"
					data-provide="typeahead" /> <br />
				<input name="usernames" id="instructorName3" class="span3" 
					placeholder="Who will instruct the course?"
					data-provide="typeahead" /> <br />
				<input name="usernames" id="instructorName4" class="span3" 
					placeholder="Who will instruct the course?"
					data-provide="typeahead" />
					
					<br /> <br />
				<input type="file" name="files[0]" id="files[0]" class="span3" />
				<input type="file" name="files[1]" id="files[1]" class="span3" />
		</form>
		-->
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
	
</body>