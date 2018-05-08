<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../libs/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<title>头部导航</title>
<script type="text/javascript">
 	$(function(){
 		$("div img").addClass('img-responsive');
 		
 		$("#btn").click(function(){
 			console.log($("#inp").text());
 		})
 	})
 
 </script>
 </head>
 <body >
	<nav class="navbar navbar-default navbar-fixed-top" style="height: 80px" role="navigation">
	    <div class="container-fluid">
		    <div class="navbar-header">
		        <h2>微博客平台</h2>
		    </div>
	
		    <div class="navbar-text navbar-right">
		      	<form class="navbar-form navbar-left" action="toIndex.do" method="post">
			        <div class="form-group">
			          <input id="inp" name="blogInfo" type="text" class="form-control" placeholder="Search">
			        </div>
			        <button id="btn" type="submit" class="btn btn-default">搜博客</button>
		      	</form>
		        <ul class="nav navbar-nav">
		        	<li><h4  class="navbar-text"><a href="/toIndex.do">首页</a></h4></li>
		        	<li ><h4  class="navbar-text"><a href="/toBlog.do">写博客</a></h4></li>
		        	<!-- 管理员账号才显示 -->
		        	<c:if test="${user.permissions==1}">
		        		<li ><h4  class="navbar-text"><a href="/toReportManage.do">举报管理</a></h4></li>
		        	</c:if>
		        	<li ><h4  class="navbar-text"><a href="/toSocial.do">社交</a></h4></li>
		        	<li ><h4  class="navbar-text"><a href="/toMessage.do">消息</a></h4></li>
		        	
		        	<c:if test="${user==null}">
		        		<li><a href="/toMyCenter.do">
		        		<img  style="margin-top:-20px;width:50px;height:50px" src="../img/default.jpg" class="img-circle img-thumbnail"></a></li>
		        	</c:if>
		        	<c:if test="${user!=null}">
		        		<li><a style="display:flex;flex-direction: column;align-items: center;" href="/toMyCenter.do">
		        		<img style="margin-top:-20px;width:50px;height:50px" src="${user.src}"  class="img-circle img-thumbnail">${user.name}</a></li>
		        	</c:if>
		           
		            <li ><h4  class="navbar-text"><a href="/toLogin.do">登录</a></h4></li>
		            <li ><h4  class="navbar-text"><a href="/toRegister.do">注册</a></h4></li>
		           
		        </ul>
		    </div>
	    </div>
	</nav>
</body>