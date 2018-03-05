package cn.dhx.handlers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/*
 * 用于页面跳转的类
 * */
@Controller
public class JumpController {
	//去主页
	@RequestMapping("/toIndex.do")
	public String toIndex(){
		
		return "/WEB-INF/index.jsp";
	}
	//去注册页面
	@RequestMapping("/toRegister.do")
	public String toRegister(){
		
		return "/WEB-INF/register.jsp";
	}
	//去注册页面
	@RequestMapping("/toLogin.do")
	public String toLogin(){
		
		return "/WEB-INF/login.jsp";
	}
	
	//去个人中心
	@RequestMapping("/toMyCenter.do")
	public String toMyCenter(){
		
		return "/WEB-INF/myCenter.jsp";
	}
	//写博客页面
	@RequestMapping("/toBlog.do")
	public String toBlog(){
		return "/WEB-INF/blog.jsp";
	}
}
