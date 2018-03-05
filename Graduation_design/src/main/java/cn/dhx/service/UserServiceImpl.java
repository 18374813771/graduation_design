package cn.dhx.service;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;

import cn.dhx.beans.User;
import cn.dhx.dao.IUserDao;
import cn.dhx.jedis.JedisClient;
@Service(value="UserService")
public class UserServiceImpl implements IUserService {
	@Resource(name="IUserDao")
	private IUserDao dao;
	@Resource(name="JedisClientPool")
	private JedisClient jedisClient;
	
	public void setJedisClient(JedisClient jedisClient) {
		this.jedisClient = jedisClient;
	}
	public void setDao(IUserDao dao) {
		this.dao = dao;
	}
	//aop使用默认的事务
	@Transactional
	public void register(User user) {
		ObjectMapper jackson = new ObjectMapper();
		//添加数据库
		dao.insertUser(user);
		try{
			//把user对象转化为json字符串
			String userJson = jackson.writeValueAsString(user);
			//把数据加入缓存
			jedisClient.hset("user",user.getName(), userJson);
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	//判断用户名是否存在
	public Boolean checkName(String name){
		if(getUser(name)!=null){
			return false;
		}
		return true;
	}

	//判断密码是否一致
	public boolean checkPassword(String name, String password) {
		User user = getUser(name);
		if(user.getPassword().equals(password)){
			return true;
		}
		return false;
	}
	
	//获取用户信息
	@Override
	public User getUser(String name) {
		//创建一个ObjectMapper操作json
		ObjectMapper jackson = new ObjectMapper();
		//先查缓存
		try{
			//查询出一个json类型的字符串
			String jsonUser=jedisClient.hget("user", name);
			
			if(StringUtils.isNotBlank(jsonUser)){				
				//反射把json字符串转化成对象
				User user = jackson.readValue(jsonUser, User.class);
				return user;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		//缓存中没有则去数据库中查
		User user = dao.getUserInfo(name);
		if(user!=null){
			try{
				//把user对象转化为json字符串
				String userJson = jackson.writeValueAsString(user);
				//把数据加入缓存
				jedisClient.hset("user", name, userJson);
				
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		return user;
	}
	
	//更新用户信息
	@Override
	public void updateUserInfo(User user) {
		dao.updateUserInfo(user);
		//删除该user的缓存，再次用到时重新建立
		jedisClient.hDel("user",user.getName());
		
	}

	//更新头像
	public void updateImg(String name,String src) {
		dao.updateImg(name,src);
		//删除该user的缓存，再次用到时重新建立
		jedisClient.hDel("user",name);
	}
}
