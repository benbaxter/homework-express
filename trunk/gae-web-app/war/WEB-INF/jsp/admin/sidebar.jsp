<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<div class="well sidebar-nav">
	<ul class="nav nav-list">
		<c:set var="adminLink" value="/actions/admin/users/admins"/>
		<c:set var="instructorLink" value="/actions/admin/users/instructors"/>
		<c:set var="studentLink" value="/actions/admin/users/students"/>
		<c:choose>
		  <c:when test="${sidebar == 'courses'}">
		  	<li class="active"><a href="<c:url value="/actions/admin/home"/>">Courses</a></li>
			<li><a href="<c:url value="${instructorLink}" />">Instructors</a></li>
			<li><a href="<c:url value="${studentLink}" />">Students</a></li>
			<li><a href="<c:url value="${adminLink}" />">Administrators</a></li>
		  </c:when>
		  <c:when test="${sidebar == 'instructors'}">
		  	<li><a href="<c:url value="/actions/admin/home"/>">Courses</a></li>
			<li class="active"><a href="<c:url value="${instructorLink}" />">Instructors</a></li>
			<li><a href="<c:url value="${studentLink}" />">Students</a></li>
			<li><a href="<c:url value="${adminLink}" />">Administrators</a></li>
		  </c:when>
		  <c:when test="${sidebar == 'admin'}">
		  	<li><a href="<c:url value="/actions/admin/home"/>">Courses</a></li>
			<li><a href="<c:url value="${instructorLink}" />">Instructors</a></li>
			<li><a href="<c:url value="${studentLink}" />">Students</a></li>
			<li class="active"><a href="<c:url value="${adminLink}" />">Administrators</a></li>
		  </c:when>
		  <c:otherwise>
		  	<li><a href="<c:url value="/actions/admin/home"/>">Courses</a></li>
			<li><a href="<c:url value="${instructorLink}" />">Instructors</a></li>
			<li class="active"><a href="<c:url value="${studentLink}" />">Students</a></li>
			<li><a href="<c:url value="${adminLink}" />">Administrators</a></li>
		  </c:otherwise>
		</c:choose>

	</ul>
</div>
