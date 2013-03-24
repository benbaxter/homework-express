<!Doctype html>
<html>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<head>
	<title><decorator:title default="Homework Express"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="/css/bootstrap-responsive.min.css"/>
	<script src="/js/jquery-1.9.1.min.js" type="text/javascript"></script>
	<script src="/js/bootstrap.min.js" type="text/javascript"></script>
	<script src="/js/jquery.tmpl.js" type="text/javascript"></script>
	<decorator:head/>
</head>
	<body>
		<br />
		<jsp:include page="/WEB-INF/jsp/common/navbar.jsp" />
		<div class="container-fluid">
			<jsp:include page="/WEB-INF/jsp/common/messages.jsp" />
			<decorator:body/>
		</div>
		<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
	</body>
</html>
 