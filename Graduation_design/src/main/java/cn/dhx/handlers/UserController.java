package cn.dhx.handlers;

import javax.annotation.Resource;

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
	public String register(String name,String password){
		User user = new User();
		user.setName(name);
		user.setPassword(password);
		service.register(user);
		return "/WEB-INF/login.jsp";
	}
	
	@RequestMapping("/toIndex.do")
	public String index(){
		
		return "/WEB-INF/register.jsp";
	}

}
