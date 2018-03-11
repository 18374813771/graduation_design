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

<title>博客详情</title>
<script type="text/javascript">
	$(function(){
		$("div img").addClass('img-responsive');
		$("#praise").click(function(){
			var praise=$("#praise").text();			
			var blogId=$("#blogId").text();
			//如果是点赞
			if(praise=="点赞"){												
				
				$.ajax({
					type :"POST",
					url  :"${pageContext.request.contextPath}/ajaxPraise.do?time"+new Date().getTime(),
					data :{
							"blogId":blogId
					},
					
					success : function(backData){
						//把json字符串转出json对象
						var jsonData=JSON.parse(backData);
						//console.dir(backData);
						//var count = j.count
						//更改点赞数量
						$("#praiseCount").html(jsonData.count);
						$("#praise").html("已赞");
						
					},
					error:function(){
						alert("错误信息");
					}
				})
			}else{
				$("#praise").html("点赞");
			}
			
		})
	})
</script>
</head>
<body>
	<jsp:include   page="head.jsp" flush="true"/>
	<div class="container" style="margin-top:100px">
		<div class="col-md-9" style="margin-left:100px; margin-top:20px;">			
			<div Style="font-size: 20px;border-bottom:solid 1px green;">
				<div>
					<img style="margin-top:-20px" src="${bUser.src}"  width="82" height="68" class="img-circle img-thumbnail">
				 	<button type="button" style="background-color:#fff;margin-left:50px">+关注</button>
				 	<div style="margin-left:700px">阅读量 :${blog.read_count}</div>
				 	<div>博主：${bUser.name}</div>
				 </div>
			</div>
			<br>
			<!--博客标题  -->
			<div align="center"><span Style="font-size: 20px;">${blog.blog_name}</span></div>
			<br>
			<!-- 博客内容 -->
			<div>
			  	${blog.blog_content}
			</div>
			<br><br>
			<!-- 底部信息 -->
			<div Style="font-size: 15px;border-top:solid 1px green;">
				发布日期:${blog.date} &nbsp&nbsp&nbsp&nbsp 
				<a href="#"><span id="praise">点赞</span> <span id="praiseCount" class="badge">0</span></a>
				&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				<a href="#">写评论 </a> 
				&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp 
				<a href="#">查看评论 <span class="badge">0</span></a>
							
			</div>
		</div>
		<span id="blogId" style="display:none">${blog.id}</span>
	</div>
	<br><br><br>
</body>
</html>