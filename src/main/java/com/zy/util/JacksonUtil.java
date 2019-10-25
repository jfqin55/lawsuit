package com.zy.util;

import java.text.SimpleDateFormat;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JacksonUtil {
	
	private static ObjectMapper objectMapper = new ObjectMapper();

	static {
		objectMapper.configure(JsonParser.Feature.ALLOW_COMMENTS, true);// JsonParser是json转java对象的配置类
        objectMapper.configure(JsonParser.Feature.ALLOW_UNQUOTED_FIELD_NAMES, true);// 允许json中属性不加引号
        objectMapper.configure(JsonParser.Feature.ALLOW_SINGLE_QUOTES, true);// 允许json中引号用单引号表示
        objectMapper.configure(JsonParser.Feature.ALLOW_UNQUOTED_CONTROL_CHARS, true);
		objectMapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
		objectMapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"));// 配置默认的日期转换格式
		objectMapper.setSerializationInclusion(Include.NON_NULL);// 忽略对象中值为null的字段，对Map、List可能不管用
//		// 处理首字母大写的问题
//		objectMapper.setPropertyNamingStrategy(new PropertyNamingStrategy() {  
//		    private static final long serialVersionUID = 1L;
//		    // 反序列化时调用  
//		    @Override  
//		    public String nameForSetterMethod(MapperConfig<?> config,  
//		            AnnotatedMethod method, String defaultName) {  
//		        return method.getName().substring(3);
//		    }  
//		    // 序列化时调用  
//		    @Override  
//		    public String nameForGetterMethod(MapperConfig<?> config,  
//		            AnnotatedMethod method, String defaultName) {  
//		        return method.getName().substring(3);
//		    }  
//		});
	}
	
	public static synchronized <T> T readValue(String json, Class<T> valueType) throws Exception {
	    return objectMapper.readValue(json, valueType);
	}

	public static synchronized String writeValueAsString(Object bean) {
	    try {
	        return objectMapper.writeValueAsString(bean);
        } catch (Exception e) {
            return null;
        }
	}
	
	public static synchronized byte[] writeValueAsBytes(Object bean) throws Exception {
	    return objectMapper.writeValueAsBytes(bean);
	}
	
	public static synchronized <T> T readValueAsList(String json, Class<?> collectionClass, Class<?> elementClass) throws Exception {
	    return objectMapper.readValue(json, getCollectionType(collectionClass, elementClass));
	}
	
	/**
 	* 获取泛型的Collection Type  
	* @param collectionClass  集合类
	* @param elementClasses 元素类   
	*/   
	private static synchronized JavaType getCollectionType(Class<?> collectionClass, Class<?>... elementClasses) {   
		return objectMapper.getTypeFactory().constructParametricType(collectionClass, elementClasses);   
	}

}
