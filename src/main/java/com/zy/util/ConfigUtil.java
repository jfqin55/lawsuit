package com.zy.util;

import java.io.InputStream;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class ConfigUtil {

	private static Logger logger = LoggerFactory.getLogger(ConfigUtil.class);
	
	private static final String CONFIG_FILE = "config.properties";

	private static Properties props = new Properties();

	static {
		loadPropertiesFromConfigFile();//从配置文件中读取所有的属性
	}

	private static void loadPropertiesFromConfigFile() {
		try {
			InputStream in = ConfigUtil.class.getClassLoader().getResourceAsStream(CONFIG_FILE);
			props.load(in);
		} catch (Exception e) {
			logger.error("读取配置文件出错：" + CONFIG_FILE);
		}
	}
	
	private static String getValue(String key) {
		String prop = props.getProperty(key);
		if (prop == null) return null;
		return prop.trim();
	}

	public static String getString(String key) {
		return getValue(key);
	}
	
	public static int getInt(String key) {
		return Integer.parseInt(getValue(key));
	}
	
	public static boolean getBoolean(String key) {
		return Boolean.parseBoolean(getValue(key));
	}

}
