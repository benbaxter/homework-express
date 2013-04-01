<%@ include file="/WEB-INF/jsp/common/taglibs.jsp" %> 


<div class="container">
	<!-- Main hero unit for a primary marketing message or call to action -->
	<div class="hero-unit clearfix">
		<div class="pull-left span5">
			<h2>Update your account in Homework Express</h2>
			<p>A one stop resource for students and instructors to collaborate</p>
		</div>
		<div class="pull-right" id="userContent">
			<form:form modelAttribute="user" class="well" action="/actions/profile/edit" method="post">
				<label>Username</label> 
					<form:input path="username" class="span3" placeholder="Change your username" />
				<label>Password</label> 
					<form:password path="password" showPassword="true" class="span3" placeholder="Change your password" />
				<label>Role (for testing only)</label>
					<form:select path="role" class="span3">
						<form:option value="ADMIN">Admin</form:option>
						<form:option value="INSTRUCTOR">Instructor</form:option>
						<form:option value="STUDENT">Student</form:option>
					</form:select> 
				<label>Name</label> 
					<form:input path="name" class="span3" placeholder="Change your name" />
				<label>First Name</label> 
					<form:input path="firstName" class="span3" placeholder="Change your first name" />
				<label>Last Name</label> 
					<form:input path="lastName" class="span3" placeholder="Change your last name" />
					<form:hidden path="userId" class="span3" />
				 <br />
				<button type="submit" class="btn">Update</button>
			</form:form>
		</div>
	</div>
</div>