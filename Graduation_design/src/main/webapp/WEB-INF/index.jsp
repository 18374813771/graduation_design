<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script src="../libs/jquery/jquery-1.8.3.js"></script>
<title>主页</title>
<script >
	$(function(){
		$("#searchUser").click(function(){
			if($("#oneUserInfo").is(":hidden")){
			}else{
				$("#oneUserInfo").hide();
			}
			//清空用户不存在的提示
			$("#noneUserWarning").html("");
			var userName = $("#userText").val();
			$.ajax({
				type:"POST",
				url :"${pageContext.request.contextPath}/searchUser.do?time="+new Date().getTime(),
				data:{
					"userName": userName				
				},
			success : function(backData){					
				if(backData!=null&&backData!=""){
					var data = JSON.parse(backData);
					if(data.isMe=="是"){
						$("#noneUserWarning").html("查你自己干嘛");
					}else{
						var user = JSON.parse(data.jUser);
						$("#userId").html(user.id);
						$("#userName").html(user.name);
						$("#userSex").html(user.sex);
						$("#userAge").html(user.age);
						if(user.isavailable==1){
							$("#userIsavailable").html("可用");
						}else{
							$("#userIsavailable").html("已冻结，不可用");
						}
						
						$("#focus").html(data.focusStatus);
						$("#friend").html(data.friendStatus);
						
						$("#oneUserInfo").show();
					}					
				}else{
					$("#noneUserWarning").html("您查找的用户不存在");
				}
			},
			error : function(){
				console.log("用户搜索错误")	
			}
			})
		})
		//添加关注事件
		$("#focus").click(function(){
			var by_follower= $("#userId").text();
			var focusStatus = $(this).text();
			$.ajax({
				type:"POST",
				url :"${pageContext.request.contextPath}/focus_on.do?time="+new Date().getTime(),
				data:{
					"by_follower":by_follower,
					"focusStatus":focusStatus
				},
				success : function(backData){
					$("#focus").html(backData);
				},
				error : function(){
					console.log("添加关注错误");
				}
			})
		})
		
		//请求添加好友
		$("#friend").click(function(){
			var fid= $("#userId").text();
			var friendStatus = $(this).text();
			if(friendStatus=="添加好友"){
				$.ajax({
					type:"POST",
					url :"${pageContext.request.contextPath}/addFriend.do?time="+new Date().getTime(),
					data:{
						"fid":fid,
					},
					success : function(backData){
						$("#friend").html("好友请求已发出");
					},
					error : function(){
						console.log("添加好友错误");
					}
				})
			}
	
		})
		
	})
	
</script>
</head>
<body >
	<jsp:include   page="head.jsp" flush="true"/>
	
	<div class="container" style="margin-top:100px;">
		<div class="col-md-7" style="margin-left:100px; margin-top:20px;">
					
			<c:forEach items="${blogs}" var="blog">
				<div>
					<a style="color:black" href="/toShowBlog.do?id=${blog.id}">
						<span style="font-size: 22px">${blog.blog_name}</span>
					</a>
					<br>
					<span>发布日期:${blog.date} &nbsp阅读量 :${blog.read_count} &nbsp获赞数 :${blog.praise_count}</span>
				</div>
				<br>
			</c:forEach>
		</div>
		
  
		<!-- 好友部分 -->
		<div  class="col-md-3 navbar-right" >
			<div class="col-md-11 navbar-right" >
				<div  class="input-group" >				
					<input id="userText" class="form-control" placeholder="userName">
					<span id="searchUser" class="input-group-addon"><a href="javascript:;">搜用户 </a></span>
				</div>
				<br>
				<span id="noneUserWarning"></span>
				<div id="oneUserInfo" class ="text-center" style="background-color:#E3E3E3;display:none">
				  	<br>
				  	编号：<span id="userId"></span><br>
				  	用户名：<span id="userName"></span><br>
					性别：<span id="userSex"></span><br>
					年龄：<span id="userAge"></span><br>
					账号状态：<span id="userIsavailable"></span><br>
					<a id="focus" class="btn" href="javascript:;"></a><br>
				  	<a id="friend" class="btn" href="javascript:;"></a><br>				  	
				  	<br>
				</div>
				
			</div>
		</div>
	</div>
	
	<!--分页 -->
	<div class="text-center" style="width: 380px; margin: 0 auto;">
		<ul class="pagination" style="text-align: center; margin-top: 10px;">
			<!-- 上一页 -->
			<!-- 判断当前页是否是第一页 -->
			<c:if test="${pageBean.currentPage==1 }">
				<li class="disabled">
					<a href="javascript:void(0);" aria-label="Previous">
						<span aria-hidden="true">&laquo;</span>
					</a>
				</li>
			</c:if>
			<c:if test="${pageBean.currentPage!=1 }">
				<li>
					<a href="/toIndex.do?currentPage=${pageBean.currentPage-1}&blogInfo=${blogInfo}" aria-label="Previous">
						<span aria-hidden="true">&laquo;</span>
					</a>
				</li>
			</c:if>	
					
			<c:forEach begin="1" end="${pageBean.totalPage }" var="page">
				<!-- 判断当前页 -->
				<c:if test="${pageBean.currentPage==page }">
					<li class="active"><a href="javascript:void(0);">${page}</a></li>
				</c:if>
				<c:if test="${pageBean.currentPage!=page }">
					<li><a href="/toIndex.do?currentPage=${page}&blogInfo=${blogInfo}">${page}</a></li>
				</c:if>
			
			</c:forEach>
			
			<!-- 判断当前页是否是最后一页 -->
			<c:if test="${pageBean.currentPage==pageBean.totalPage }">
				<li class="disabled">
					<a href="javascript:void(0);" aria-label="Next"> 
						<span aria-hidden="true">&raquo;</span>
					</a>
				</li>
			</c:if>
			<c:if test="${pageBean.currentPage!=pageBean.totalPage }">
				<li>
					<a href="/toIndex.do?currentPage=${pageBean.currentPage+1}&blogInfo=${blogInfo}" aria-label="Next"> 
						<span aria-hidden="true">&raquo;</span>
					</a>
				</li>
			</c:if>
		
		</ul>
	</div>
	<!-- 分页结束 -->
</body>
</html>