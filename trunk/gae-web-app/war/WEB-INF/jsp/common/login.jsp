<%@ include file="/WEB-INF/jsp/common/taglibs.jsp" %> 

<div class="container">
	<!-- Main hero unit for a primary marketing message or call to action -->
	<div class="maincontent clearfix">
		<div class="pull-left span5">
			<h1>Welcome to Homework Express</h1>
			<p>A one stop resource for students and instructors to collaborate</p>
		</div>
		<div class="pull-right">
			<form:form modelAttribute="user" class="well" action="/actions/login" method="post">
				<c:if test="${not empty errors}">
					<p class="text-error">
						<c:out value="${errors}" />
					</p>
				</c:if>
				<label>Username</label> 
					<form:input path="username" class="span3" placeholder="Type your username" />
				<label>Password</label> 
					<form:password path="password" class="span3" placeholder="Type your password" />
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
