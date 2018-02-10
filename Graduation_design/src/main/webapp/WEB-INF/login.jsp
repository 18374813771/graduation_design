<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登录</title>
<style>
      .int{ height: 30px; text-align: left; width: 600px; } 
      label{ width: 200px; margin-left: 20px; } 
      .high{ color: red; } 
      .msg{ font-size: 13px; } 
      .onError{ color: red; } 
      .onSuccess{ color: green; } 
</style>
<link rel="stylesheet" href="../libs/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<script src="../libs/jquery/jquery-1.8.3.js"></script>
<script src="../libs/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script>
	$(function(){

		$("#name").blur(function(){
			$("#d1").find(".msg").remove(); //删除以前的提示				
			var nameVal=$.trim(this.value);
			var regName=/[~#^&!*()<>:;[]’”{}   ]/;
			if(nameVal==""||nameVal.length<3||regName.test(nameVal)){
				var errorMessage="姓名非空，长度6位以上，不包含特殊字符！";
				
				$("#d1").append("<span class='msg onError'>" + errorMessage + "</span>");		
			}
			else{
                   var okMsg=" 输入正确";
                   $("#d1").find(".high").remove();
                   $("#d1").append("<span class='msg onSuccess'>" + okMsg + "</span>");
               }
			
		})
		
		$("#password1").blur(function(){
			$("#d3").find(".msg").remove(); //删除以前的提示
				var password1=$.trim(this.value);	           
				if(password1==""||password1.length<6){
					var errorMessage=" 密码长度6位以上";
					$("#d3").append("<span class='msg onError'>" + errorMessage + "</span>");		
				}
				else{
	                   var okMsg=" 输入正确";
	                   $("#d3").find(".high").remove();
	                   $("#d3").append("<span class='msg onSuccess'>" + okMsg + "</span>");
	               }
		})
	
		$("#bt1").click(function(){
		    
		    $("form .required:input").trigger("blur"); 
		    var numError = $("form .onError").length;
		    if(numError){
		        return false;
		    }
		   
		});
	});


</script>
</head>
<body>

	<div class="col-sm-offset-2 col-sm-8" style="padding: 100px 100px 10px;">
		<form class="bs-example bs-example-form" action="${pageContext.request.contextPath}/login.do" method="post" role="form">
			<div class="text-center">
				<h1 ><span style="color:olive;" >微博客平台</span></h1><br><br>
			</div>
			<br>
			
			<div class="input-group">
				<span class="input-group-addon">请输入用户名：</span>
				<input type="text" id="name" value="${name}" name="name" class="form-control" placeholder="姓名非空，长度6位以上，不包含特殊字符！" required >
			</div>
			<div id="d1" class="col-sm-offset-2 col-sm-8"></div>
			<br>
			<br>
			
			<div class="input-group">
				<span class="input-group-addon">请输入密码：&nbsp&nbsp&nbsp </span>
				<input type="password" id="password1" value="${password}" name="password" required class="form-control" placeholder="密码长度至少6位">
			</div>
			<div id="d3" class="col-sm-offset-2 col-sm-8"></div>
			<br>
			<br>
			<br>
			
			
			
			<div class="col-sm-offset-4 col-sm-8"><span style="color:red">${msg}</span></div>
			<br>
			<br>
			
			
			<div class="col-sm-offset-0 col-sm-12">
				<button type="submit" id="bt1" class="btn btn-info btn-block">登录</button>
			</div>
			<br>
			<br>
			<div class="col-sm-offset-5 col-sm-12"><span>没有账号？<a href="/toRegister.do">注册</a></span></div>
		</form>
	</div>
	
</body>
</html>