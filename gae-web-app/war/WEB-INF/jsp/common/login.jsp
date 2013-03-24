<%@ include file="/WEB-INF/jsp/common/taglibs.jsp" %> 

<div class="container">
	<!-- Main hero unit for a primary marketing message or call to action -->
	<div class="hero-unit clearfix">
		<div class="pull-left span5">
			<h1>Welcome to Homework Express</h1>
			<p>A one stop resource for students and instructors to collaborate</p>
		</div>
		<div class="pull-right">
			<form:form modelAttribute="user" class="well" action="/actions/login" method="post">
				<label>Username</label> 
					<input type="text" name="username" class="span3" placeholder="Type your username" />
				<label>Password</label> 
					<input type="password" name="password" class="span3" placeholder="Type your password" />
				<!-- future work?
				<label class="checkbox">
					<input type="checkbox" name="rememberMe" />Remember me
				</label>
				 -->
				 <br />
				<button type="submit" class="btn">Log me in</button>
			</form:form>
		</div>
	</div>
</div>
<!-- /container -->
