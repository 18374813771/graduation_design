package cn.dhx.dao;

import cn.dhx.beans.User;

public interface IUserDao {
	public void insertUser(User user);

	public User getUserInfo(String name);

	public void updateUserInfo(User user);

	public void updateImg(String name,String src);
}
