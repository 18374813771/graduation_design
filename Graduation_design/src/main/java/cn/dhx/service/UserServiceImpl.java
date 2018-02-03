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

}
