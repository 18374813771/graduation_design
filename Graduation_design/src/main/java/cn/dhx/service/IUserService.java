package cn.dhx.service;

import cn.dhx.beans.User;

public interface IUserService {
	public void register(User user);
	public Boolean checkName(String name);
	public boolean checkPassword(String name, String password);
	public User getUser(String name);
	public void updateUserInfo(User user);
}
