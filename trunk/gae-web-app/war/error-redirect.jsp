<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>

<c:url value="/actions/something-bad-happened" var="errorUrl" />
<c:redirect url="${errorUrl}"/>