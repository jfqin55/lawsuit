package com.zy.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Md5Util {
	
	private static Logger logger = LoggerFactory.getLogger(Md5Util.class);

	private static char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

	/**
	 * @param data
	 * @return 32位大写md5
	 */
	public static String getMd5(byte[] data) {
		try {
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			byte[] digest = md5.digest(data);
			
			// 把密文转换成十六进制的字符串形式
			int j = digest.length;
			char str[] = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = digest[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}
			return new String(str);
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * @param data
	 * @return 32位大写md5
	 */
	public static String getMd5(String str){
		try {
			return getMd5(str.getBytes(Constant.CHARSET_NAME));
		} catch (UnsupportedEncodingException e) {
			logger.error("获取MD5异常", e);
			e.printStackTrace();
			return null;
		}
	}

}
