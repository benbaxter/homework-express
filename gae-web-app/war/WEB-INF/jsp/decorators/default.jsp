<!Doctype html>
<html>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<head>
	<title><decorator:title default="Homework Express"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="/css/bootstrap-responsive.min.css"/>
	<style type="text/css">
	body {
		background-color: #E3E9ED;
	}

	.maincontent {
		background-color: #fff;
		padding: 50px;
		margin-bottom: 30px;
		font-size: 16px;
		font-weight: 200;
		line-height: 30px;
		color: inherit;
		-webkit-border-radius: 6px;
		-moz-border-radius: 6px;
		border-radius: 6px;
	}
	
	.assignment-result {
		background-color: #e3e9ed;
		border-color: #000;
		margin-bottom: 10px;
		-webkit-border-radius: 6px;
		-moz-border-radius: 6px;
		border-radius: 6px;
	}
	
	.table-clickable tbody tr:hover {
	    cursor: pointer;
	}
	</style>
	
	<script src="/js/jquery-1.9.1.min.js" type="text/javascript"></script>
	<script src="/js/bootstrap.min.js" type="text/javascript"></script>
	<script src="/js/jquery.tmpl.js" type="text/javascript"></script>
	<script src="http://ajax.cdnjs.com/ajax/libs/underscore.js/1.1.6/underscore-min.js"></script>
	<script type="text/javascript">
	<!--
	function getCookie(c_name) {
		var i, x, y, ARRcookies = document.cookie.split(";");
		for (i = 0; i < ARRcookies.length; i++) {
			x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="));
			y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1);
			x = x.replace(/^\s+|\s+$/g, "");
			if (x == c_name) {
				return unescape(y);
			}
		}
	}
	
	function make_base_auth(user, password) {
	  var tok = user + ':' + password;
	  //var hash = Base64.encode(tok);
	  return "Basic " + tok;
	}
	//-->
	</script>
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
 