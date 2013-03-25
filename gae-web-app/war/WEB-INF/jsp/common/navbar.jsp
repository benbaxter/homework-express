<%@ include file="/WEB-INF/jsp/common/taglibs.jsp" %> 

<div class="navbar navbar-inverse navbar-fixed-top">
  <div class="navbar-inner">

    <div class="container-fluid">
      <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>
      <a class="brand" href="#">Homework Express</a>
      <div class="nav-collapse collapse">
        <ul class="nav">
	        <c:choose>
				<c:when test="${navPage eq 'home'}">
					<li class="active">
				</c:when>
				<c:otherwise>
					<li>
				</c:otherwise>
			</c:choose>
			<a href="${homeUrl}"><i class="icon-home"></i>Home</a>
			</li>
         	<li><a href="#classes">Classes</a></li>
          	<li><a href="#students">Students</a></li>
        </ul>
    	<ul class="nav pull-right">
			<c:choose>
				<c:when test="${not empty user}">
					<c:choose>
						<c:when test="${navPage eq 'profile'}">
							<li class="active">
						</c:when>
						<c:otherwise>
							<li>
						</c:otherwise>
					</c:choose>
					<a href="/actions/profile/edit/${user.userId}">Hello, ${user.username}</a></li>       
					<li><a href="${logoutUrl}" class="navbar-link">Logout</a></li>
				</c:when>  
				<c:otherwise>
	              <li><a href="${loginUrl}" class="navbar-link">Sign in</a></li>
				</c:otherwise>
			</c:choose> 
        </ul>
      </div><!--/.nav-collapse -->
    </div>
  </div>
</div>

<br /><br />