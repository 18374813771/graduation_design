package cn.dhx.jedis;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
@Service(value="JedisClientPool")
public class JedisClientPool implements JedisClient {
	//注入redis连接池对象
	@Resource(name="JedisPool")
	private JedisPool jedisPool;
	private Jedis jedis;
		
	public void setJedisPool(JedisPool jedisPool) {
		this.jedisPool = jedisPool;
	}



	//添加一个hash类型数据
	public long hset(String key, String field, String value) {
		jedis = jedisPool.getResource();
		//若设置一个新域则返回一，覆盖原有的返回0
		long flag=jedis.hset(key, field, value);
		jedis.close();
		return flag;
	}

	//查询hash中的数据
	public String hget(String key, String field) {
		jedis = jedisPool.getResource();
		String value=jedis.hget(key, field);
		jedis.close();
		return value;
	}



	//删除hash中的指定的域
	public long hDel(String key, String field) {
		jedis = jedisPool.getResource();
		long delCount=jedis.hdel(key, field);
		jedis.close();
		return delCount;
	}


	/**
	 * 获取此key下所有的field-value
	 * */
	@Override
	public Map<String,String> hgetAllValues(String key) {
		jedis = jedisPool.getResource();
		Map<String,String> allValues = jedis.hgetAll(key);
		jedis.close();
		
//		jedisPool.returnResource(jedis);
		return allValues;
	}
	
}
