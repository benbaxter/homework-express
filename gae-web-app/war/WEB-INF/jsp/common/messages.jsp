<%@ include file="/WEB-INF/jsp/common/taglibs.jsp" %> 

<c:if test="${not empty messages}">
	<c:choose>
		<c:when test="${messageStatus == 'success'}">
			<div class="alert alert-block alert-success fade in">
		</c:when>
		<c:when test="${messageStatus == 'info'}">
			<div class="alert alert-block alert-info fade in">
		</c:when>
		<c:when test="${messageStatus == 'warning'}">
			<div class="alert alert-block alert-warning fade in">
		</c:when>
		<c:when test="${messageStatus == 'error'}">
			<div class="alert alert-block alert-error fade in">
		</c:when>
		<c:otherwise>
			<div class="clear">
		</c:otherwise>
	</c:choose>
		<button type="button" class="close" data-dismiss="alert">x</button>
		${messages}
	</div>
</c:if>