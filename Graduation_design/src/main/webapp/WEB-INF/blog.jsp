<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>写博客</title>
<style>
	form {
		margin: 0;
	}
	textarea {
		display: block;
	}
</style>

<link rel="stylesheet" href="../libs/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<script src="../libs/jquery/jquery-1.8.3.js"></script>
<script src="../libs/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<!-- 富文本 -->
<link rel="stylesheet" href="../libs/kindeditor/themes/default/default.css" />
<script charset="utf-8" src="../libs/kindeditor/kindeditor-all.js"></script>
<script charset="utf-8" src="../libs/kindeditor/lang/zh-CN.js"></script>


<script>
		KindEditor.ready(function(K) {
			var editor1 = K.create('#myBlog', {
				resizeType : 1,
				allowImageUpload:true,
				uploadJson : '${contextPath.request.pageContext}/blogImgUpload.do',
				filePostName : 'file',
				allowFileManager : true,
				afterUpload: function(){this.sync();}, //图片上传后，将上传内容同步到textarea中
                afterBlur: function(){this.sync();},   ////失去焦点时，将上传内容同步到textarea中			
			});			
		});
		
		$(function(){
			$("#btn1").click(function(){				
				$("#flag").val(1);//给隐藏输入设值，表示发布博客				
			})
			$("#btn2").click(function(){				
				$("#flag").val(2);//给隐藏输入设值，表示发布博客				
			})
			//邀请好友的显示隐藏
			$("#invite").click(function(){
				if($("#inviteFriend").is(":hidden")){
					$("#inviteFriend").show();
				}else{
					$("#inviteFriend").hide();
				}
			})
		})
	</script>
</head>
<body>
		<jsp:include   page="head.jsp" flush="true"/>
		
<div class="container" style="margin-top:100px">
	<form action="/blogging.do" method="post" role="form">
		<div class="col-md-9">
								  	
			  	<div class="input-group ">
					<span class="input-group-addon">名称：</span>
					<input type="text" id="blogName"  name="blogName" class="form-control" placeholder="输入文章标题" required >
				</div>
				<br>
				<div>
		    		<textarea id="myBlog" name="content" style="width:100%;height:400px;visibility:hidden;"></textarea>
		  		</div>
		  		<input type="text" id="flag" name="flag" style="visibility:hidden">
		  		<br>
			  	<div class="btn-group btn-group-lg navbar-right">
					<button id="btn1" type="submit" class="btn btn-default">发布博客</button>
					<button id="btn2" type="submit" class="btn btn-default">取消</button>
				</div>		  			  				
		</div>
<!-- 		<用户部分，还没写> -->
		<div   class="col-md-3" style="margin-right:0px">					
			<div class="col-md-8 navbar-right" style=" margin-right:-10px">
				<a id="invite" class="btn">邀请好友评论</a><br><br>
				<div id ="inviteFriend" style="display:none;margin-right:40px" class="col-md-8 navbar-right" >
					<c:forEach items="${allFriends}" var="friend">
						 <label><input type="checkbox" name="invitedFriend" value="${friend.id}">${friend.name}</label><br>
					</c:forEach>
				</div>
			</div>

		</div>
	</form>
</div>

</body>
</html>