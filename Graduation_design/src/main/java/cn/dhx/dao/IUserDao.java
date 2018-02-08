package cn.dhx.dao;

import cn.dhx.beans.User;

public interface IUserDao {
	public void insertUser(User user);

	public User checkName(String name);
}
