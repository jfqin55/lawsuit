package com.zy.util;

import org.apache.commons.lang3.StringUtils;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;


public class RedisUtil {

	private static JedisPool jedisPool = null;

	public static void initRedis(String host, int port, int maxTotal, String auth){
		try {
			JedisPoolConfig config = new JedisPoolConfig();

			config.setJmxEnabled(false);//是否启用pool的jmx管理功能,默认true

			//MBean ObjectName = new ObjectName("org.apache.commons.pool2:type=GenericObjectPool,name=" + "pool" + i); 默认"pool"
			  config.setJmxNamePrefix("pool");
			
			  config.setLifo(true);//是否启用后进先出,默认true
			
			  config.setMaxIdle(2);//最大空闲连接数,默认8个
			
			  config.setMaxTotal(maxTotal);//最大连接数,默认8个
			  
			  config.setBlockWhenExhausted(true);//连接耗尽时是否阻塞,false报异常,ture阻塞直到超时,默认true
			
			  //获取连接时的最大等待毫秒数(如果设置为阻塞时BlockWhenExhausted),如果超时就抛异常,如果小于零则阻塞不确定的时间,默认-1
			  config.setMaxWaitMillis(60000);
			
			  //设置的逐出策略类名,默认DefaultEvictionPolicy(当连接超过最大空闲时间,或连接数超过最大空闲连接数)
			  config.setEvictionPolicyClassName("org.apache.commons.pool2.impl.DefaultEvictionPolicy");
			  
			  config.setMinEvictableIdleTimeMillis(1800000);//逐出连接的最小空闲时间,默认1800000毫秒(30分钟)
			
			  config.setMinIdle(1);//最小空闲连接数,默认0
			
			  config.setNumTestsPerEvictionRun(3);//每次逐出检查时,逐出的最大数目,默认3
			
			  //对象空闲多久后逐出,当空闲时间>该值 且 空闲连接>最大空闲数 时直接逐出,不再根据MinEvictableIdleTimeMillis判断  (默认逐出策略)
			  config.setSoftMinEvictableIdleTimeMillis(1800000);
			
			  config.setTestOnBorrow(true);//在获取连接的时候检查有效性,默认false
			  config.setTestOnReturn(true);
			  
			  config.setTestWhileIdle(true);//在空闲时检查有效性,默认false
			
			  config.setTimeBetweenEvictionRunsMillis(-1);//逐出扫描的时间间隔(毫秒),如果为负数,则不运行逐出线程,默认-1
	          
	          String realAuth = StringUtils.isBlank(auth) ? null : auth.trim();
	          
	          jedisPool = new JedisPool(config, host, port, 0, realAuth);
	          
		}catch(Exception e){
          e.printStackTrace();
		}
      
	}

	public synchronized static Jedis getJedis(){
		Jedis jedis = null;
		try{
			if(jedisPool != null){
				jedis = jedisPool.getResource();
				return jedis;
			}
		}catch(Exception e){
			e.printStackTrace();
			if(jedis != null) jedis.close();
		}
		return null;
	}
	
	public static void main(String[] args) {
		RedisUtil.initRedis("127.0.0.1", 6379, 8, null);
		Jedis jedis = RedisUtil.getJedis();
		jedis.del("oyk");
		jedis.lpush("oyk", "1");
		jedis.lpush("oyk", "2");
		jedis.lpush("oyk", "3");
//		jedis.brpop(0, "oyk");
		System.out.println(jedis.lrange("oyk", -50, -1));
	}

}
