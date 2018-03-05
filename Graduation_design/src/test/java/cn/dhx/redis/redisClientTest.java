package cn.dhx.redis;

import org.junit.Test;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

public class redisClientTest {
	
	@Test
	public void testClent(){
		//创建jedis连接池
		JedisPool jedisPool = new JedisPool("192.168.88.129",6379);
		//获取jedis
		Jedis jedis = jedisPool.getResource();
		//输入连接密码
//		jedis.auth("125190");
		System.out.println("服务器正在运行："+jedis.ping());
	}
}
