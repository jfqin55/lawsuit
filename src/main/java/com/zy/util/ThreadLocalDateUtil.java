package com.zy.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ThreadLocalDateUtil {
	
    private static ThreadLocal<DateFormat> threadLocal = new ThreadLocal<DateFormat>(); 
 
    public static DateFormat getDateFormat(){  
        DateFormat dateFormat = threadLocal.get();  
        if(dateFormat==null){  
            dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
            threadLocal.set(dateFormat);  
        }  
        return dateFormat;  
    }  

    public static String formatDate(Date date) throws ParseException {
        return getDateFormat().format(date);
    }

    public static Date parse(String strDate) throws ParseException {
        return getDateFormat().parse(strDate);
    }   
}