<%@ include file="/WEB-INF/jsp/common/taglibs.jsp" %> 

<footer id="footer">
	<div class="navbar navbar-inverse navbar-static-bottom">
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
				<a href="${homeUrl}"><i class="icon-home"></i>Home</a></li>
	        </ul>
	    	<ul class="nav pull-right">
	    		<li style="padding-top:10px; color: yellow">Designed by Yellow Team</li>
	        </ul>
	      </div><!--/.nav-collapse -->
	    </div>
	  </div>
	</div>
</footer>