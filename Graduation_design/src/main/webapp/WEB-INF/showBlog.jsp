<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="http://cdn.sockjs.org/sockjs-0.3.min.js"></script>
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
			var commentContent = $("#comment2").val().trim();
			//如果评论没输入任何内容，则不发送请求，并隐藏输入框
			if(commentContent==null||commentContent==""){
				$("#DComment").hide();
				return false;
			} else {
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
			}
			
		})
	})
	
	//点击查看评论显示隐藏
	$(function(){
		//第一次进入该页时建立连接，使用websocket实时更新评论数据
		var webSocket = null;
		//判断浏览器是否支持websocket
		if('WebSocket' in window){
			webSocket = new WebSocket("ws:localhost:8080/websocket.do")
		}else{					
		    alert('Not support websocket')  
		}
		//连接发生错误的回调方法  
        webSocket.onerror = function(){  
          setMessageInnerHTML("error");  
        };
        //连接成功时发送博客id和当前用户id请求评论数据
		webSocket.onopen = function(){	
			var blogId = $("#blogId").text(); 
			var userId = $("#userId").text();
			var message =blogId+","+userId;
	        webSocket.send(message);
		}
       
		webSocket.onmessage = function(evnt) {
			var comments = JSON.parse(evnt.data);
			console.log(comments);
//             $("#msg").html($("#msg").html() + "<br/>" + evnt.data);
        };

        webSocket.onclose = function(evt) {
        	console.log("WebSocket连接关闭！");
		};
		 
		window.onbeforeunload = function(event) {
		    console.log("关闭WebSocket连接！");
		    webSocket.close();
		}
	      //控制折叠
		$("#content").click(function(){
			var content = $("#content").text();
			$("#commentContent").show();					
			if(content=="查看评论"){	  
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
				<a href="javascript:;"><span id="content">查看评论</span> <span  class="badge">${answerCount}</span></a>
							
			</div><br><br>
			<!--点击评论  -->
			<div id="DComment" class="input-group" style="display:none">				
				<input id ="comment2" class="form-control" placeholder="请勿散布有害言论">
				<span id="commentSubmit" class="input-group-addon"><a href="javascript:;">评论 </a></span>
			</div>
			
			<!--显示评论内容 -->
			<div id="commentContent" style="display:none">
				<c:forEach items="${comments}" var="comment">
					<div >
						<div>
							<img style="margin-top:10px" src="${comment.answerUser.src }"  width="41" height="34" class="img-circle img-thumbnail">
							<!-- 分三种情况，是博主，不是博主评论博客，不是博主，评论评论 -->
							<c:if test="${comment.answerUser.name.equals(bUser.name)}">
								<span style="font-size: 16px;margin-bmargin-bottom:-10px">(博主)回答：</span>
							</c:if>
							<c:if test="${comment.answeredUser==null&&!comment.answerUser.name.equals(bUser.name)}">
								<span style="font-size: 16px;margin-bmargin-bottom:-10px">${comment.answerUser.name}评论：</span>
							</c:if>
							<c:if test="${comment.answeredUser!=null&&!comment.answerUser.name.equals(bUser.name)}">
								<span style="font-size: 16px;margin-bmargin-bottom:-10px">${comment.answerUser.name}回复${comment.answeredUser.name}：</span>
							</c:if>
						</div>
						<span style="margin-left: 100px">${comment.comment_content }</span>
					</div>
					<br>
					<div >
					日期:${comment.date} &nbsp&nbsp&nbsp&nbsp
					<!--让它移上去变成手，并不会跳转  --> 
					<a href="javascript:;"><span >${comment.praiseStatus}</span> <span class="badge">${comment.praiseCount }</span></a>
					&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
					<a href="javascript:;"><span >写评论 </span></a> 
					&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp 
					<a href="javascript:;"><span >举报</span></a>							
					</div>
					<div Style="font-size: 15px;border-top:solid 1px gray;"></div>					
				</c:forEach>				
		</div>
		<!-- 一个隐藏的标签，便于jq获取博客的id -->
		<span id="blogId" style="display:none">${blog.id}</span>
		<span id="userId" style="display:none">${sessionScope.user.id}</span>
		<br><br>
	</div>
	</div>

</body>
</html>