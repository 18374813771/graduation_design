package cn.dhx.jedis;


import java.util.Map;

public interface JedisClient {
	//存放hash
	public long hset(String key,String field,String value);
	public String hget(String key,String field);
	public long hDel(String key,String field);
	public Map<String,String> hgetAllValues(String key);
}
