package com.zy.util;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;

/**
 *	动态获取jar包所在目录
 */
public class ClassPathUtil {

	public static File getJarParentFile(){
		try {
			URL daoutilJarUrl = ClassPathUtil.class.getProtectionDomain().getCodeSource().getLocation();
			return new File(daoutilJarUrl.toURI()).getParentFile();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null ;
	}
	
	public static File getJarParentFile(Class clazz){
		try {
			URL daoutilJarUrl = clazz.getProtectionDomain().getCodeSource().getLocation();
			return new File(daoutilJarUrl.toURI()).getParentFile();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null ;
	}
}
