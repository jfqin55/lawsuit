package com.zy.util;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by Administrator on 2015/1/4.
 */
public class RequestUtil {

    public static Object getAttribute(HttpServletRequest request, String key){
        return request.getAttribute(key);
    }

    public static void setAtrribute(HttpServletRequest request, String key, Object value){
        request.setAttribute(key, value);
    }

    public static Object getSessionAttribute(HttpServletRequest request, String key){
        return request.getSession().getAttribute(key);
    }

    public static void setSessionAtrribute(HttpServletRequest request, String key, Object value){
        request.getSession().setAttribute(key, value);
    }
    
    public static void removeSessionAtrribute(HttpServletRequest request, String key){
    	request.getSession().removeAttribute(key);
    }
    
}
