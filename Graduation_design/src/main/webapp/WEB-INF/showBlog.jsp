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
		//点赞
		$("#praise").click(function(){
			var praise=$("#praise").text();			
			var blogId=$("#blogId").text();
			//如果是点赞
			if(praise=="点赞"){												
				
				$.ajax({
					type :"POST",
					url  :"${pageContext.request.contextPath}/ajaxPraise.do?time="+new Date().getTime(),
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
				$.ajax({
					type :"POST",
					url  :"${pageContext.request.contextPath}/ajaxNotPraise.do?time="+new Date().getTime(),
					data :{
							"blogId":blogId
					},
					
					success : function(backData){
						//把json字符串转出json对象
						var jsonData=JSON.parse(backData);
						
						//更改点赞数量
						$("#praiseCount").html(jsonData.count);
						$("#praise").html("点赞");
						
					},
					error:function(){
						alert("错误信息");
					}
				})				
			}			
		});		
	})
	
	$(function(){
		//点击'评论',显示，隐藏输入框
		$("#comment").click(function(){
			if($("#DComment").is(":hidden")){
				$("#DComment").show();
			}else{
				$("#DComment").hide();
			}			
		});
		//评论，提交数据
		$("#commentSubmit").click(function(){
			var commentContent = $("#comment2").val();
			//如果评论没输入任何内容，则不发送请求，并隐藏输入框
			if(commentContent==null){
				$("#DComment").hide();
				return ;
			}
			var blogId=$("#blogId").text();
			$.ajax({
				type :"POST",
				url  :"${pageContent.request.contentPath}/commentSubmit.do?time="+new Date().getTime(),
				data :{
					"commentCotent" : commentContent,
					"blogId" : blogId
				},
				success : function(backData){
					$("#DComment").hide();
					//隐藏评论输入框
					//显示评论
				},
				error   : function(){
					console.log("错误信息");
				}
			});
		})
	})
	
	//点击查看评论显示隐藏
	$(function(){
		$("#content").click(function(){
			var content = $("#content").text();
			if(content=="查看评论"){
				$("#commentContent").show();
				$("#content").html("折叠评论");
			}else{
				$("#commentContent").hide();
				$("#content").html("查看评论");
			}
		})
	})
</script>
</head>
<body style="background-color:#e9eff6;">
	<jsp:include   page="head.jsp" flush="true"/>
	<div class="container" style="margin-top:100px;">
		<div class="col-md-9" style="margin-left:100px; margin-top:-20px;background-color:white;">			
			<div Style="font-size: 20px;border-bottom:solid 1px green;">
				<div>
					<img style="margin-top:20px" src="${bUser.src}"  width="82" height="68" class="img-circle img-thumbnail">
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
				<!--让它移上去变成手，并不会跳转  --> 
				<a href="javascript:;"><span id="praise">${praiseStatus}</span> <span id="praiseCount" class="badge">${blog.praise_count}</span></a>
				&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				<a href="javascript:;"><span id="comment">写评论 </span></a> 
				&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp 
				<a href="javascript:;"><span id="content">查看评论</span> <span  class="badge">0</span></a>
							
			</div><br><br>
			<!--点击评论  -->
			<div id="DComment" class="input-group" style="display:none">				
				<input id ="comment2" class="form-control" placeholder="请勿散布有害言论">
				<span id="commentSubmit" class="input-group-addon"><a href="javascript:;">评论 </a></span>
			</div>
			
			<!--显示评论内容 -->
			<div id="commentContent" style="display:none">
				<div >
					<div>
						<img style="margin-top:10px" src="${bUser.src}"  width="41" height="34" class="img-circle img-thumbnail">
						<span style="font-size: 20px;margin-bmargin-bottom:-10px">xxx评论：</span>
					</div>
					<span style="margin-left: 100px">一楼</span>
				</div>
				<br>
				<div >
				发布日期:${blog.date} &nbsp&nbsp&nbsp&nbsp
				<!--让它移上去变成手，并不会跳转  --> 
				<a href="javascript:;"><span >点赞</span> <span class="badge">0</span></a>
				&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				<a href="javascript:;"><span >不喜欢</span> <span class="badge">0</span></a>
				&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
				<a href="javascript:;"><span >写评论 </span></a> 
				&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp 
				<a href="javascript:;"><span >举报</span></a>							
				</div>
				<div Style="font-size: 15px;border-top:solid 1px gray;"></div>
				
				<div >
					<div>
						<img style="margin-top:10px" src="${bUser.src}"  width="41" height="34" class="img-circle img-thumbnail">
						<span style="font-size: 20px;margin-bmargin-bottom:-10px">xxx评论：</span>
					</div>
					<span style="margin-left: 100px">二楼</span>
				</div>
				<br>
				<div Style="font-size: 15px;border-top:solid 1px gray;"></div><br>
				<br><br>
			</div>
		</div>
		<!-- 一个隐藏的标签，便于jq获取博客的id -->
		<span id="blogId" style="display:none">${blog.id}</span>
	</div>
	<br><br>
	
</body>
</html>