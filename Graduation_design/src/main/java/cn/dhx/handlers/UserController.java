package cn.dhx.handlers;

import java.io.File;
import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import cn.dhx.beans.User;
import cn.dhx.service.IUserService;


@Controller
public class UserController{
	@Autowired
	@Qualifier("UserService")
	private IUserService service;

	public void setService(IUserService service) {
		this.service = service;
	}
	
	//注册
	@RequestMapping("/register.do")
	public String register(String name,String email,String password,
			String password2,HttpServletRequest request,HttpSession session){
		if(service.checkName(name)){				//用户名不存在,可用
			User user = new User();
			user.setName(name);
			user.setPassword(password);
			user.setEmail(email);
			//用户默认权限为2,表示普通用户
			user.setPermissions(2);
			//用户可用性默认为1，表示可用
			user.setIsavailable(1);
			//用户头像默认路径
			user.setSrc("../img/default.jpg");
			service.register(user);
			//获取用户的全部信息
			User newUser=service.getUser(name);
			session.setAttribute("user", newUser);
			return "/toIndex.do";
		}else{										//用户名已存在，不可用
			//用于数据回显
			String msg="用户名已存在，请更换";
			request.setAttribute("name", name);
			request.setAttribute("email", email);
			request.setAttribute("password", password);
			request.setAttribute("password2", password2);
			request.setAttribute("msg", msg);
			return "/WEB-INF/register.jsp";
		}
		
		
	}
	
	//登录
	@RequestMapping("/login.do")
	public String login(String name,String password,HttpServletRequest request,
			HttpSession session){
		if(service.checkName(name)){				//用户名不存在，无法登录
			//用于数据回显
			String msg="你输入的用户名不存在，请更换或注册";
			request.setAttribute("name", name);
			request.setAttribute("password", password);
			request.setAttribute("msg", msg);
			return "/WEB-INF/login.jsp";
		}else{
			if(service.checkPassword(name,password)){	//密码正确
				User user = service.getUser(name);
				session.setAttribute("user", user);
				return "toIndex.do";
			}else{										//密码错误
				String msg="你输入的用户名或密码错误，请重新输入";
				request.setAttribute("name", name);
				request.setAttribute("password", password);
				request.setAttribute("msg", msg);
				return "/WEB-INF/login.jsp";
			}
		}
	}
	//修改个人信息
	@RequestMapping("/changeInfo.do")
	public String changeInfo(int age,String telephone,String sex,HttpServletRequest request){
		HttpSession session = request.getSession();
		User user=(User) session.getAttribute("user");
		user.setAge(age);
		user.setTelephone(telephone);
		user.setSex(sex);
		service.updateUserInfo(user);
		return "/toMyCenter.do";
	}
	
	/**
	 * 头像图片上传
	 * @throws IOException 
	 */
	@RequestMapping(value ="/saveHeaderPic.do", method = RequestMethod.POST)
	public void saveHeaderPic(@RequestParam("upload-file") CommonsMultipartFile file,
			HttpServletRequest request, HttpServletResponse response) throws IOException {
	        String msg="";
	    try {
	    	//获取新文件名
	    	String newImg=new Date().getTime()+file.getOriginalFilename();
	        // 流读取文件只能用绝对路径
			//动态获取拼接绝对路径
	        String path=request.getServletContext().getRealPath("/img/")+"/"+newImg;
//	        String path="C:\\Users\\Administrator\\git\\graduation_design\\Graduation_design\\src\\main\\webapp\\img/"+new Date().getTime()+file.getOriginalFilename();
	        
	        File newFile=new File(path);
	        //通过CommonsMultipartFile的方法直接写文件
	        file.transferTo(newFile);
	        
	        //拼接用于存储的相对路径
	        String src="../img/"+newImg;
	        
	        HttpSession session = request.getSession();
	        User user = (User)session.getAttribute("user");
	        //更新路径
	        service.updateImg(user.getName(),src);
	        
	        
	      //如果原图片不是默认图片，便删除
	        if(!user.getSrc().equals("../img/default.jpg")){
	        	String[] delFileName=user.getSrc().split("img/");
	        	String delPath=request.getServletContext().getRealPath("/img/")+"\\"+delFileName[1];
	        	
	        	File delFile = new File(delPath);
	        	//删除文件
	        	if(delFile.exists()&&delFile.isFile())
	        		delFile.delete();
	        }
	        user.setSrc(src);
	        msg = "1";	        
	    } catch (IllegalStateException e) {
	        
	        e.printStackTrace();
	    }
	    response.getWriter().write(msg);
	}

}
