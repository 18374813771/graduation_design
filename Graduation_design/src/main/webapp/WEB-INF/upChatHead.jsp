<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>jQuery头像裁剪插件cropbox</title>

<link rel="stylesheet" href="../libs/css/style.css" type="text/css" />

</head>

<body>

<script type="text/javascript" src="../libs/js/jquery-1.11.1.min.js"></script> 

<script type="text/javascript" src="../libs/js/cropbox.js"></script>

<div class="container">

  <div class="imageBox">

    <div class="thumbBox"></div>

    <div class="spinner" style="display: none"></div>

  </div>

  <div class="action"> 

    <!-- <input type="file" id="file" style=" width: 200px">-->

    <div class="new-contentarea tc"> <a href="javascript:void(0)" class="upload-img">

      <label for="upload-file">请先选择图片...</label>

      </a>

      <input type="file" class="" name="upload-file" id="upload-file" />

    </div>

    <input type="button"   class="Btnsty_peyton" value="OK">

    <input type="button" id="btnZoomIn" class="Btnsty_peyton" value="+"  >

    <input type="button" id="btnZoomOut" class="Btnsty_peyton" value="-" >

  </div>

  <div class="cropped"></div>

</div>

<script type="text/javascript">

 

$(window).load(function() {

	//$('#btnCrop').click();$("#idName").css("cssText","background-color:red!important");

	

	//$(".imageBox").css("cssText","background-position:88px 88px!important");$(".imageBox").css("cssText","background-size:222px 222px!important");

	var options =

	{

		thumbBox: '.thumbBox',

		spinner: '.spinner',

		imgSrc: ''

	}

	var cropper = $('.imageBox').cropbox(options);

	var img="";

	$('#upload-file').on('change', function(){

		var reader = new FileReader();

		reader.onload = function(e) {

			options.imgSrc = e.target.result;

			cropper = $('.imageBox').cropbox(options);

			getImg();

		}

		reader.readAsDataURL(this.files[0]);

		this.files = [];

		//getImg();

	})

	$('#btnCrop').on('click', function(){

		alert("图片上传喽");

	})

	function getImg(){

		img = cropper.getDataURL();

		$('.cropped').html('');

		$('.cropped').append('<img src="'+img+'" align="absmiddle" style="width:180px;margin-top:4px;border-radius:180px;box-shadow:0px 0px 12px #7E7E7E;"><p>180px*180px</p>');

		$('.cropped').append('<img src="'+img+'" align="absmiddle" style="width:128px;margin-top:4px;border-radius:128px;box-shadow:0px 0px 12px #7E7E7E;"><p>128px*128px</p>');

		$('.cropped').append('<img src="'+img+'" align="absmiddle" style="width:64px;margin-top:4px;border-radius:64px;box-shadow:0px 0px 12px #7E7E7E;" ><p>64px*64px</p>');

		}

		

	$(".imageBox").on("mouseup",function(){

 		getImg();

  		});

		

		

	$('#btnZoomIn').on('click', function(){

		cropper.zoomIn();

	})

	$('#btnZoomOut').on('click', function(){

		cropper.zoomOut();

	})

});

</script>

</body>

</html>