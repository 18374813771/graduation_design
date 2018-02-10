package cn.dhx.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.dhx.beans.User;
import cn.dhx.dao.IUserDao;
@Service("UserService")
public class UserServiceImpl implements IUserService {
	@Resource(name="IUserDao")
	private IUserDao dao;
	

	public void setDao(IUserDao dao) {
		this.dao = dao;
	}
	
	@Override
	@Transactional
	public void register(User user) {
		dao.insertUser(user);
		
	}
	//判断用户名是否存在
	public Boolean checkName(String name){
		if(dao.getUserInfo(name)!=null){
			return false;
		}
		return true;
	}

	//判断密码是否一致
	public boolean checkPassword(String name, String password) {
		User user = dao.getUserInfo(name);
		if(user.getPassword().equals(password)){
			return true;
		}
		return false;
	}
	
	//获取用户信息
	@Override
	public User getUser(String name) {
		return dao.getUserInfo(name);
	}
	
	//更新用户信息
	@Override
	public void updateUserInfo(User user) {
		dao.updateUserInfo(user);
		
	}
}
