<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../libs/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<script src="../libs/jquery/jquery-1.8.3.js"></script>
<script src="../libs/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

<title>头部导航</title>
 <script type="text/javascript">
 	$(function(){
 		$("div img").addClass('img-responsive');
 	})
 
 </script>
</head>
<body>
	<nav class="navbar navbar-default navbar-fixed-top" style="height: 80px" role="navigation">
	    <div class="container-fluid">
		    <div class="navbar-header">
		        <h2>微博客平台</h2>
		    </div>
	
		    <div class="navbar-text navbar-right">
		        <ul class="nav navbar-nav">
		        	<li><h4  class="navbar-text"><a href="/toIndex.do">首页</a></h4></li>
		        	<li ><h4  class="navbar-text"><a href="/toBlog.do">写博客</a></h4></li>
		        	<li ><h4  class="navbar-text"><a href="#">社交</a></h4></li>
		        	<li ><h4  class="navbar-text"><a href="#">消息</a></h4></li>
		        	<c:if test="${user==null}">
		        		<li><a href="/toMyCenter.do"><img style="margin-top:-20px" src="../img/default.jpg"  width="50" height="40" class="img-circle img-thumbnail"></a></li>
		        	</c:if>
		        	<c:if test="${user!=null}">
		        		<li><a href="/toMyCenter.do"><img style="margin-top:-20px" src="${user.src}"  width="50" height="40" class="img-circle img-thumbnail"></a></li>
		        	</c:if>
		            <li>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</li>
		            <li ><h4  class="navbar-text"><a href="/toLogin.do">登录</a></h4></li>
		            <li ><h4  class="navbar-text"><a href="/toRegister.do">注册</a></h4></li>
		           
		        </ul>
		    </div>
	    </div>
	</nav>
</body>
</html>