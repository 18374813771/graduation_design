<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>个人中心</title>

<link rel="stylesheet" href="../libs/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<script src="../libs/jquery/jquery-1.8.3.js"></script>
<script src="../libs/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script>

</script>
</head>
<body>

	<div class="col-sm-offset-2 col-sm-8" style="padding: 100px 100px 10px;">
		<form class="bs-example bs-example-form" action="${pageContext.request.contextPath}/changeInfo.do" method="post" role="form">
			<div class="text-center">
				<h1 ><span style="color:olive;" >个人中心</span></h1><br><br>
			</div>
			<div  class="text-center"> 
				<a href="/toUpChatHead.do"><img style="margin-top:-20px" src="../img/default.jpg"  width="105" height="80" class="img-circle img-thumbnail"></a>
			</div>
			<br>
			<div  class="col-md-6">
				<div class="input-group">
					<span class="input-group-addon">用户名：</span>
					<input type="text" id="name" value="${user.name}" name="name" class="form-control" disabled >
				</div>
				<div id="d1" class="col-sm-offset-2 col-sm-8"></div>
				<br>
				
				
					
				<div class="input-group">
					<span class="input-group-addon">年龄： </span>
					<input type="text" id="age" value="${user.age}" name="age" class="form-control" >
				</div>
				<br>
				<c:if test="${!user.sex.equals('女')}">
					<div>				
						&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp性别：
					    <label>
					        <input type="radio" name="sex" id="sex1" value="男" checked> 男
					    </label>
					    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp				
					    <label>
					        <input type="radio" name="sex" id="sex2" value="女">女
					    </label>					
					</div>
				</c:if>
				<c:if test="${user.sex.equals('女')}">
					<div>				
						&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp性别：
					    <label>
					        <input type="radio" name="sex" id="sex1" value="男" > 男
					    </label>
					    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp				
					    <label>
					        <input type="radio" name="sex" id="sex2" value="女" checked>女
					    </label>					
					</div>
				</c:if>
			</div>
		
			<div  class="col-md-6">
				<div class="input-group">
					<span class="input-group-addon">邮箱：</span>
					<input type="text" id="email" value="${user.email}" name="email" class="form-control" disabled >
				</div>
				<div id="d1" class="col-sm-offset-2 col-sm-8"></div>
				<br>
				
				<div class="input-group">
					<span class="input-group-addon">电话号码： </span>
					<input type="text" id="telephone" value="${user.telephone}" name="telephone" class="form-control" >
				</div>
				<br>	
				
			</div>
			
			<br><br><br><br><br><br><br><br>	
			
			<div class="col-sm-offset-0 col-sm-12">
				<button type="submit" id="bt1" class="btn btn-info btn-block">修改</button>
			</div>
		</form>
	</div>
	
</body>
</html>