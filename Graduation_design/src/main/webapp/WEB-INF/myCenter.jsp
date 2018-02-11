<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="IE=9" /> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>个人中心</title>

<link rel="stylesheet" href="../libs/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<script src="../libs/jquery/jquery-1.8.3.js"></script>
<script src="../libs/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="../libs/css/amazeui.min.css">
<link rel="stylesheet" href="../libs/css/amazeui.cropper.css">
<link rel="stylesheet" href="../libs/css/custom_up_img.css">
<link rel="stylesheet" type="text/css" href="../libs/css/font-awesome.4.6.0.css">
<script src="../libs/js/amazeui.min.js" charset="utf-8"></script>
<script src="../libs/js/cropper.min.js" charset="utf-8"></script>
<style type="text/css">
	.up-img-cover {width: 100px;height: 100px;}
	.up-img-cover img{width: 100%;}
	.up-img-txt label{font-weight: 100;margin-top: 50px;}
 </style>
</head>
<body>

	<div class="col-sm-offset-2 col-sm-8" style="padding: 100px 100px 10px;">
		<form class="bs-example bs-example-form" action="${pageContext.request.contextPath}/changeInfo.do" method="post" role="form">
			<div class="text-center">
				<h1 ><span style="color:olive;" >个人中心</span></h1><br><br>
			</div>
			 <div  class="col-sm-offset-5 col-sm-4">
				<div class="up-img-cover "  id="up-img-touch" >				
	    			<img style="margin-top:-20px" data-am-popover="{content: '点击更换头像', trigger: 'hover focus'}" src="../img/default.jpg"  width="105" height="80" class="img-circle img-thumbnail">
	   			</div>
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
	
	<!--图片上传框-->
    	<div class="am-modal am-modal-no-btn up-modal-frame" tabindex="-1" id="up-modal-frame">
		  <div class="am-modal-dialog up-frame-parent up-frame-radius">
		    <div class="am-modal-hd up-frame-header">
		       <label>修改头像</label>
		      <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
		    </div>
		    <div class="am-modal-bd  up-frame-body">
		      <div class="am-g am-fl">
		      	
		      	<div class="am-form-group am-form-file">
			      <div class="am-fl">
			        <button type="button" class="am-btn am-btn-default am-btn-sm">
			          <i class="am-icon-cloud-upload"></i> 选择要上传的文件</button>
			      </div>
			      <input type="file" id="upload-file" name="upload-file" class="up-img-file">
			   	</div>
		      </div>
		      <div class="am-g am-fl">
		      	<div class="up-pre-before up-frame-radius">
		      		<img alt="" src="" class="up-img-show" id="up-img-show" >
		      	</div>
		      	<div class="up-pre-after up-frame-radius">
		      	</div>
		      </div>
		      <div class="am-g am-fl">
   				<div class="up-control-btns">
				<span id="ok">选择</span>
   				</div>
	    	  </div>
		      
		    </div>
		  </div>
		</div>
    	
		
		<!--警告框-->
		<div class="am-modal am-modal-alert" tabindex="-1" id="up-modal-alert">
		  <div class="am-modal-dialog">
		    <div class="am-modal-hd">信息</div>
		    <div class="am-modal-bd"  id="alert_content">
		              成功了
		    </div>
		    <div class="am-modal-footer">
		      <button >确定</button>
		    </div>
		  </div>
		</div>
<script>
	$(document).ready(function(){
       $("#up-img-touch").click(function(){
       		  $("#up-modal-frame").modal({});
       });
	});
	$(function() {
	   'use strict';
	   var $image = $('#up-img-show');
	   $image.cropper({
	       aspectRatio: '1',
	       autoCropArea:0.8,
	       preview: '.up-pre-after',
	       responsive:true,
	   });
	
	   $("#ok").click(function(){		
			var formData = new FormData();
			formData.append("upload-file",$("#upload-file")[0].files[0]); 
			$.ajax({
	           type: "post",
	           //dataType: "text",
	           url: "${pageContext.request.contextPath}/saveHeaderPic.do",
	           data: formData,
	           async: false,  
	           cache: false,  
	           contentType: false,  
	           processData: false,
	           success: function (data) {
	           	alert(data);
	           },
	           error: function(data) { 
	        	   return false;
// 	            alert("error:"+data.responseText);
	            }
	       });
	       return false;
		})   
	
	   
	   var $inputImage = $('.up-modal-frame .up-img-file');
	   var URL = window.URL || window.webkitURL;
	   var blobURL;
	
	   if (URL) {
	       $inputImage.change(function () {
	       	
	           var files = this.files;
	           var file;
	
	           if (files && files.length) {
	              file = files[0];
	
	              if (/^image\/\w+$/.test(file.type)) {
	                   blobURL = URL.createObjectURL(file);
	                   $image.one('built.cropper', function () {
	                       // Revoke when load complete
	                      URL.revokeObjectURL(blobURL);
	                   }).cropper('reset').cropper('replace', blobURL);
	//                    $inputImage.val('');
	               } else {
	                   window.alert('Please choose an image file.');
	               }
	           }
	       });
	   } else {
	       $inputImage.prop('disabled', true).parent().addClass('disabled');
	   }
	   
	   //上传图片
	   $('.up-modal-frame .up-btn-ok').on('click',function(){
	   	var $modal_loading = $('#up-modal-loading');
	   	var $modal_alert = $('#up-modal-alert');
	   	var img_src=$image.attr("src");
	   	if(img_src==""){
	   		set_alert_info("没有选择上传的图片");
	   		$modal_alert.modal();
	   		return false;
	   	}
	   	
	   	$modal_loading.modal();
	   	
	   });
	   
	});
		
	function set_alert_info(content){
		$("#alert_content").html(content);
	}
  
   </script>
</body>
</html>