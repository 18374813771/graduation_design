package cn.dhx.handlers;


import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import cn.dhx.beans.User;
import cn.dhx.service.IBlogService;

@Controller
public class BlogController {
	@Autowired
	@Qualifier("blogService")
	private IBlogService service;
	
	//博客编辑文件上传
	@RequestMapping(value="/blogImgUpload.do")
	@ResponseBody
	public String blogImgUpload(@RequestParam("file") MultipartFile file,HttpServletRequest request){
		
		String filename = file.getOriginalFilename();

		//拼接上传后的文件名
		String newFile=new Date().getTime()+filename;
		//拼接服务器路径
		String path="http://localhost:8080/blogImg/"+newFile;
		
		//上传文件的用的路径
		String uploadPath=request.getServletContext().getRealPath("/blogImg/")+"/"+newFile;

		//复制文件
		File imgFile=new File(uploadPath);
		try {
			file.transferTo(imgFile);
		}  catch (IOException e) {			
			e.printStackTrace();
		}
		
		Map<String, Object> result = new HashMap<>();
        result.put("error",0);

        result.put("url",path);
        ObjectMapper mapper = new ObjectMapper();  
        String string = null;
		try {
			//map转json
			string = mapper.writeValueAsString(result);
		} catch (JsonProcessingException e) {
			
			e.printStackTrace();
		}
        return string;
	}
	
	//处理博客
	@RequestMapping("/blogging.do")
	public String blogging(HttpServletRequest request){
		//用户是否提交flag==1为提交，flag==2为取消
		String strFlag=request.getParameter("flag");
		int flag=Integer.parseInt(strFlag);
		//用户取消后返回主页
		if(flag==2){
			return "/toIndex.do";
		}
		//文章名称
		String blogName=(String) request.getParameter("blogName");
		//原文章内容
		String content=(String) request.getParameter("content");
		
		
		//获取用户用到的图片列表
		List<String> images = service.getRealImages(content);
		
		//如果上传了图片
		if(!images.isEmpty()){
			//动态获取临时文件夹绝对路径
	        String oldPath=request.getServletContext().getRealPath("/blogImg/")+"/";
	        //动态获取真实文件夹绝对路径
	        String newPath=request.getServletContext().getRealPath("/realBlogImg/")+"/";
			//处理图片，把用户用到的图片从临时目录移到真实目录
			service.disposeImages(images,oldPath,newPath);
			//替换内容
			content = service.replaceContent(content);
			
		}
		//从session中获取用户id
		HttpSession session=request.getSession();
		User user=(User) session.getAttribute("user");
		Integer uid=user.getId();
		//执行新增博客操作
		service.insertBlog(blogName,content,uid);
		return "/toMyCenter.do";
	}
}
