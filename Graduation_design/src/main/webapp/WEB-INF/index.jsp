<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>主页</title>
</head>
<body>
	<jsp:include   page="head.jsp" flush="true"/>
	<div class="container" style="margin-top:100px">
		<div class="col-md-9" style="margin-left:100px; margin-top:20px">			
			<c:forEach items="${blogs}" var="blog">
				<div>
					<a href="/toShowBlog.do?id=${blog.id}">
						<span style="font-size: 22px">${blog.blog_name}</span>
					</a>
					<br>
					<span>发布日期:${blog.date} &nbsp阅读量 :${blog.read_count} &nbsp点赞数 :${blog.praise_count}</span>
				</div>
				<br>
			</c:forEach>
			
		</div>
	</div>
</body>
</html>