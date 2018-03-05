package cn.dhx.jedis;


public interface JedisClient {
	//存放hash
	public long hset(String key,String field,String value);
	public String hget(String key,String field);
	public long hDel(String key,String field);
}
