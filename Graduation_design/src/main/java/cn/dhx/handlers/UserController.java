package cn.dhx.handlers;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
			String password2,HttpServletRequest request){
		if(service.checkName(name)){
			User user = new User();
			user.setName(name);
			user.setPassword(password);
			user.setEmail(email);
			service.register(user);
			return "/WEB-INF/login.jsp";
		}else{
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
	//主页
	@RequestMapping("/toIndex.do")
	public String index(){
		
		return "/WEB-INF/register.jsp";
	}

}
