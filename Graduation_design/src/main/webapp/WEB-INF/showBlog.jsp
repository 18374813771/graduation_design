<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="../libs/jquery/jquery-1.8.3.js"></script>
<script src="http://cdn.sockjs.org/sockjs-0.3.min.js"></script>
<link rel="stylesheet" href="../libs/bootstrap-3.3.7-dist/css/bootstrap.min.css">

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
        
        //连接成功时，send消息，请求数据
		webSocket.onopen = function(){	
			var blogId = $("#blogId").text();
			webSocket.send(blogId);
			$.ajax({
				type :"POST",
				url  :"${pageContent.request.contentPath}/getComments.do?time="+new Date().getTime(),
				data :{
					"blogId" : blogId
				},
				success : function(backData){
					var comments = JSON.parse(backData);
					var bUserName = $("#bUserName").text();
					
					//把原来的东西清空
					$("#commentContent").html("");
					//用append动态添加数据
					for(i=0;i< comments.length;i++){
						
						$("#commentContent").append("<img style=\"margin-top:10px\" src="+comments[i].answerUser.src+"  width=\"41\" height=\"34\" class=\"img-circle img-thumbnail\">")
						if(comments[i].answerUser.name==bUserName&&comments[i].answeredUser.name==bUserName&&comments[i].style=="blog"){
							$("#commentContent").append("<span style=\"font-size: 16px;margin-bmargin-bottom:-10px\">(博主) 回答：</span>");
						}else 
						if(comments[i].answeredUser.name==bUserName&&comments[i].answerUser.name!=bUserName){
// 							console.log(comments[i].answeredUser.name+","+bUserName+","+comments[i].answerUser.name);
							$("#commentContent").append("<span style=\"font-size: 16px;margin-bmargin-bottom:-10px\">"+comments[i].answerUser.name+" 评论：</span>");
						}else{
							$("#commentContent").append("<span style=\"font-size: 16px;margin-bmargin-bottom:-10px\">"+comments[i].answerUser.name+" 回复 "+comments[i].answeredUser.name+"：</span>")
						}
						$("#commentContent").append("<br><span style=\"margin-left: 100px\">"+comments[i].comment_content+"</span></div><br><br>");
						$("#commentContent").append("<div class=\"oneComment\">"+
								"日期:"+comments[i].date+"&nbsp&nbsp&nbsp&nbsp"+						 
								"<a href=\"javascript:;\"><span id=\"praiseStatus_"+comments[i].id+"\">"+comments[i].praiseStatus+"</span>"+
								"<span id=\"praiseCount_"+comments[i].id+"\" class=\"badge\">"+comments[i].praiseCount+"</span></a>"+
								"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"+
								"<a href=\"javascript:;\"><span id=\"writeComment_"+comments[i].id+"q"+comments[i].topId+"q"+comments[i].answerUser.id+"\">写评论 </span></a>"+ 
								"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"+ 
								"<a href=\"javascript:;\"><span id=\"report_"+comments[i].id+"\">举报</span></a>"+							
								"<div Style=\"font-size: 15px;border-top:solid 1px gray;\"></div>"+
								//隐藏的评论输入框
								"<div id=\"divComment_"+comments[i].id+"q"+comments[i].topId+"q"+comments[i].answerUser.id+"\" class=\"input-group\" style=\"display:none\">"+				
								"<input id=\"inputComment_"+comments[i].id+"q"+comments[i].topId+"q"+comments[i].answerUser.id+"\" class=\"form-control\" placeholder=\"回复"+comments[i].answerUser.name+"\">"+
								"<span id=\"submitComment_"+comments[i].id+"q"+comments[i].topId+"q"+comments[i].answerUser.id+"\" class=\"input-group-addon\"><a href=\"javascript:;\">评论 </a></span>"+
								"</div>")
						
						
					}
				},
				error   : function(){
					console.log("错误信息");
				}
			})
		}
        //处理解析生成组件的点击事件
        $("#commentContent .oneComment a span").live('click',function(){
        	var blogId = $("#blogId").text();
        	
        	var id = $(this).attr("id");
        	var data = id.split("_");
        	var style = data[0];
        	//根据style判断是哪个组件
        	if(style=="praiseStatus"){//点击的是点赞
        		var currentStatus = $(this).text();//知道当前是点赞还是已赞
        		$.ajax({
        			type : "POST",
        			url  : "${pageContext.request.contextPath}/blogCommentParise.do?time="+new Date().getTime(),
        			data :{
        					"id" : data[1],
        					"currentStatus":currentStatus
        			},
        			success:function(backData){       				
        				//把json字符串转出json对象
						var jsonData=JSON.parse(backData);
						var praiseCountSpanId ="\#praiseCount_"+data[1]+"";						
						//改变赞的状态
						$("\#"+id).html(jsonData.praiseStatus)
 						//更改点赞数量
						$(praiseCountSpanId).html(jsonData.praiseCount);
        			},
        			error  : function(){
						console.log("错误信息");
					}
        		})       		
        	}else if(style=="writeComment"){
        		//评论框的div的名称
        		var divComment = "\#divComment_"+data[1];
        		//评论输入框的id
        		var inputComment = "inputComment_"+data[1];
        		//评论提交按钮的id
        		var submitCommentId = "\#submitComment_"+data[1];
        		//判断评论框div是否显示
				if($(divComment).is(":hidden")){
					$(divComment).show();
				}else{
					$(divComment).hide();
				}
		
				$(submitCommentId).click(function(){
					//评论输入框数据并去除空格,必须要写到点击事件中
					var inputCommentVal = $('#'+inputComment).val();
					
					//若输入为空，就不发送请求，并隐藏输入框
					if(inputCommentVal==null||inputCommentVal==""){
						$(divComment).hide();
					}else{console.log("success");
						var data1 = data[1].split("q");
						
						$.ajax({
							type : "POST",
							url  :"${pageContext.request.contextPath}/subOneComment.do?time="+new Date().getTime(),
							data : {
								"id" : data1[0],
								"topId": data1[1],
								"uid":data1[2],
								"commentContent" : inputCommentVal
							},
							success : function(backData){
								//评论成功的调函数
								$(divComment).hide();
							},
							error  : function(){
								alert("评论错误信息");
							}
						})
					}
				})
				
        	}else if(style=="report"){
        		var commentId = data[1];
				$.ajax({
					type:"POST",
					url :"${pageContent.request.contentPath}/report.do?time="+new Date().getTime(),
					data:{
						"commentId":commentId
					},
					success :function(backData){
						$("#report_"+commentId).html("举报成功")
					},
					error : function(){
						console.log("举报错误");
					}
				})
        	}
        	
        })
        
       
       
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
				var uid = $("#bUserId").text();
				$.ajax({
					type :"POST",
					url  :"${pageContent.request.contentPath}/commentSubmit.do?time="+new Date().getTime(),
					data :{
						"uid" : uid,
						"commentCotent" : commentContent,
						"blogId" : blogId
					},
					success : function(backData){
						$("#DComment").hide();
						
					},
					error   : function(){
						console.log("错误信息");
					}
				});
			}
			
		})
	
        //接受到服务器端传来的信息后，执行ajax操作
		webSocket.onmessage = function(evt) {
			  console.log(evt.data)
			  var blogId=$("#blogId").text();
			  $.ajax({
					type :"POST",
					url  :"${pageContent.request.contentPath}/getComments.do?time="+new Date().getTime(),
					data :{
						"blogId" : blogId
					},
					success : function(backData){
						var comments = JSON.parse(backData);
						var bUserName = $("#bUserName").text();
						
						//把原来的东西清空
						$("#commentContent").html("");
						//用append动态添加数据
						for(i=0;i< comments.length;i++){
							
							$("#commentContent").append("<img style=\"margin-top:10px\" src="+comments[i].answerUser.src+"  width=\"41\" height=\"34\" class=\"img-circle img-thumbnail\">")
							if(comments[i].answerUser.name==bUserName&&comments[i].answeredUser.name==bUserName){
								$("#commentContent").append("<span style=\"font-size: 16px;margin-bmargin-bottom:-10px\">(博主) 回答：</span>");
							}else 
							if(comments[i].answeredUser.name==bUserName&&comments[i].answerUser.name!=bUserName){
								$("#commentContent").append("<span style=\"font-size: 16px;margin-bmargin-bottom:-10px\">"+comments[i].answerUser.name+" 评论：</span>");
							}else{
								$("#commentContent").append("<span style=\"font-size: 16px;margin-bmargin-bottom:-10px\">"+comments[i].answerUser.name+" 回复 "+comments[i].answeredUser.name+"：</span>")
							}
							$("#commentContent").append("<br><span style=\"margin-left: 100px\">"+comments[i].comment_content+"</span></div><br><br>");
							$("#commentContent").append("<div class=\"oneComment\">"+
									"日期:"+comments[i].date+"&nbsp&nbsp&nbsp&nbsp"+						 
									"<a href=\"javascript:;\"><span id=\"praiseStatus_"+comments[i].id+"\">"+comments[i].praiseStatus+"</span>"+
									"<span id=\"praiseCount_"+comments[i].id+"\" class=\"badge\">"+comments[i].praiseCount+"</span></a>"+
									"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"+
									"<a href=\"javascript:;\"><span id=\"writeComment_"+comments[i].id+"q"+comments[i].topId+"q"+comments[i].answerUser.id+"\">写评论 </span></a>"+ 
									"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"+ 
									"<a href=\"javascript:;\"><span id=\"report_"+comments[i].id+"\">举报</span></a>"+							
									"<div Style=\"font-size: 15px;border-top:solid 1px gray;\"></div>"+
									//隐藏的评论输入框
									"<div id=\"divComment_"+comments[i].id+"q"+comments[i].topId+"q"+comments[i].answerUser.id+"\" class=\"input-group\" style=\"display:none\">"+				
									"<input id=\"inputComment_"+comments[i].id+"q"+comments[i].topId+"q"+comments[i].answerUser.id+"\" class=\"form-control\" placeholder=\"回复"+comments[i].answerUser.name+"\">"+
									"<span id=\"submitComment_"+comments[i].id+"q"+comments[i].topId+"q"+comments[i].answerUser.id+"\" class=\"input-group-addon\"><a href=\"javascript:;\">评论 </a></span>"+
									"</div>")
							

						}
					},
					error   : function(){
						console.log("错误信息");
					}
				})
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
		//添加关注
		$("#focus_on").click(function(){
			var by_follower= $("#bUserId").text();
			var focusStatus = $(this).text();
			$.ajax({
				type:"POST",
				url :"${pageContext.request.contextPath}/focus_on.do?time="+new Date().getTime(),
				data:{
					"by_follower":by_follower,
					"focusStatus":focusStatus
				},
				success : function(backData){
					$("#focus_on").html(backData);
				},
				error : function(){
					console.log("添加关注错误");
				}
			})
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
				 	<c:if test="${bUser.name!=sessionScope.user.name}">
				 		<button type="button" id="focus_on" style="background-color:#fff;margin-left:50px">${focusStatus}</button>
				 	</c:if>
				 	<div style="margin-left:700px">阅读量 :${blog.read_count}</div>
				 	<div >博主：<span id="bUserName">${bUser.name}</span></div>
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
			</div>
		<!-- 一个隐藏的标签，便于jq获取博客的id -->
		<span id="blogId" style="display:none">${blog.id}</span>
		<span id="bUserId" style="display:none">${bUser.id}</span>
		<br><br>
	</div>
	</div>

</body>
</html>