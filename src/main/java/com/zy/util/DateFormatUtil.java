package com.zy.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class DateFormatUtil {
	
    private static ThreadLocal<DateFormat> threadLocal_file = new ThreadLocal<DateFormat>();
    
    public static DateFormat getDateFormat_file(){  
        DateFormat dateFormat = threadLocal_file.get();  
        if(dateFormat==null){  
            dateFormat = new SimpleDateFormat("yyyy-MM-dd-HHmmss");  
            threadLocal_file.set(dateFormat);  
        }  
        return dateFormat;  
    }
    
    private static ThreadLocal<DateFormat> standard = new ThreadLocal<DateFormat>();
    
    public static DateFormat standard(){  
        DateFormat dateFormat = standard.get();  
        if(dateFormat==null){  
            dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
            standard.set(dateFormat);  
        }  
        return dateFormat;  
    }
    
    private static ThreadLocal<DateFormat> threadLocal_yyyyMMdd = new ThreadLocal<DateFormat>();
    
    public static DateFormat getDateFormat_yyyyMMdd(){  
        DateFormat dateFormat = threadLocal_yyyyMMdd.get();  
        if(dateFormat==null){  
            dateFormat = new SimpleDateFormat("yyyy年MM月dd日");  
            threadLocal_yyyyMMdd.set(dateFormat);  
        }  
        return dateFormat;  
    }
    
    
    private static ThreadLocal<DateFormat> threadLocal_yyyyMMddHHmmss = new ThreadLocal<DateFormat>();
    
    public static DateFormat getDateFormat_yyyyMMddHHmmss(){  
        DateFormat dateFormat = threadLocal_yyyyMMddHHmmss.get();  
        if(dateFormat==null){  
            dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");  
            threadLocal_yyyyMMddHHmmss.set(dateFormat);  
        }  
        return dateFormat;  
    }
    
    private static ThreadLocal<DateFormat> threadLocal_yyyyMM = new ThreadLocal<DateFormat>();
    
    public static DateFormat getDateFormat_yyyyMM(){  
        DateFormat dateFormat = threadLocal_yyyyMM.get();  
        if(dateFormat==null){  
            dateFormat = new SimpleDateFormat("yyyy-MM");  
            threadLocal_yyyyMM.set(dateFormat);  
        }  
        return dateFormat;  
    }

}