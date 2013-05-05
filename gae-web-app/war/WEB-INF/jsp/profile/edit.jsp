<%@ include file="/WEB-INF/jsp/common/taglibs.jsp" %> 

<body>

<div class="container">
	<!-- Main hero unit for a primary marketing message or call to action -->
	<div class="maincontent clearfix">
		<div class="pull-left span5">
			<h2>Update the account in Homework Express</h2>
			<p>A one stop resource for students and instructors to collaborate</p>
		</div>
		<div class="pull-right" id="userContent">
			<form:form modelAttribute="user" class="well" action="/actions/profile/edit" method="post">
				<p class="text-error">
		    		<c:if test="${not empty error}">
		    			<c:out value="${error}" />
		    		</c:if>
		    	</p>
		    	<form:hidden path="userId" />
				<form:hidden path="role" />
				<label>Username</label> 
					<form:input path="username" class="span3" placeholder="Change your username" disabled="true" />
				<label>First Name</label> 
					<form:input path="firstName" class="span3" placeholder="Change your first name" />
				<label>Last Name</label> 
					<form:input path="lastName" class="span3" placeholder="Change your last name" />
				 <br />
				<form:hidden path="username" />
				<button type="submit" class="btn">Update</button>
			</form:form>
		</div>
	</div>
</div>

</body>