package com.zy.util;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.InputStream;
import java.io.InputStreamReader;

public class StreamUtil {

	public static byte[] readInputStream(InputStream inputStream) throws Exception {
	    ByteArrayOutputStream baos = new ByteArrayOutputStream();
	    try {
	        byte[] buffer = new byte[4096];  
	        int len = 0;  
	        while ((len = inputStream.read(buffer)) != -1) {  
	            baos.write(buffer, 0, len);  
	        }
	        return baos.toByteArray();
        } finally {
            closeStream(baos);
            closeStream(inputStream);
        }
	}
	
	public static String readInputStream(InputStream inputStream, String encoding) throws Exception {
	    BufferedReader br = null;
        try {
            br = new BufferedReader(new InputStreamReader(inputStream, encoding));
            StringBuilder sb = new StringBuilder();
            String line = null;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            return sb.toString();
        } finally {
            closeStream(br);
        }
	}
	
	public static byte[] readFixLengthFromInputStream(BufferedInputStream inputStream, int count) throws Exception {
	    try {
	        byte[] bytes = new byte[count];  
	        int readCount = 0; // 已经成功读取的字节的个数  
	        while(readCount < count){  
	            int read = inputStream.read(bytes, readCount, count - readCount);
	            if(read == -1) break;
	            readCount += read;
	        }  
	        return bytes;
        } finally {
            closeStream(inputStream);
        }
		
	}
	
	public static void closeStream(Closeable closeable) {
	    try {
            if(closeable != null) closeable.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
	}
	
}
