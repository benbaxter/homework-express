<%@ include file="/WEB-INF/jsp/common/taglibs.jsp" %> 

<div class="container">
	<!-- Main hero unit for a primary marketing message or call to action -->
	<div class="hero-unit clearfix">
		<div class="pull-left span5">
			<h2>Update your account in Homework Express</h2>
			<p>A one stop resource for students and instructors to collaborate</p>
		</div>
		<div class="pull-right" id="userContent">
			<dl class="dl-horizontal">
			  <dt>Username</dt>
			  <dd>${user.username}</dd>
			  <dt>Password</dt>
			  <dd>****</dd>
			  <dt>Role</dt>
			  <dd>${user.role}</dd>
			  <dt>Name</dt>
			  <dd>${user.name}</dd>
			  <dt>First Name</dt>
			  <dd>${user.firstName}</dd>
			  <dt>Last Name</dt>
			  <dd>${user.lastName}</dd>
			</dl>
		</div>
	</div>
</div>
<!-- /container -->
