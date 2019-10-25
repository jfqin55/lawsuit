package com.zy.util;

import org.slf4j.Logger;

public class LogUtil {
	
//	public static void println(String str){
//		System.out.println("-------------" + str + "-------------");
//	}
	
	public static void warn(Logger logger, String str){
		logger.warn("-------------" + str + "-------------");
	}
	
	public static void error(Logger logger, String str){
		logger.error("-------------" + str + "-------------");
	}
	
}
