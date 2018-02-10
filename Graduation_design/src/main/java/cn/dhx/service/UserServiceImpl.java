package cn.dhx.service;

import cn.dhx.beans.User;
import cn.dhx.dao.IUserDao;

public class UserServiceImpl implements IUserService {
	private IUserDao dao;
	

	public IUserDao getDao() {
		return dao;
	}

	public void setDao(IUserDao dao) {
		this.dao = dao;
	}

	@Override
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
	@Override
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
