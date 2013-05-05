<%@ include file="/WEB-INF/jsp/common/taglibs.jsp" %> 

<div class="container">
	<!-- Main hero unit for a primary marketing message or call to action -->
	<div class="maincontent clearfix">
		<div class="pull-left span5">
			<h2>Your account in Homework Express has been updated</h2>
		</div>
		<div class="pull-right" id="userContent">
			<dl class="dl-horizontal">
			  <dt>Username</dt>
			  <dd>${user.username}</dd>
			  <dt>First Name</dt>
			  <dd>${user.firstName}</dd>
			  <dt>Last Name</dt>
			  <dd>${user.lastName}</dd>
			</dl>
		</div>
	</div>
</div>
<!-- /container -->
