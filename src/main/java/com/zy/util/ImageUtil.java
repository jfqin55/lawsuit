package com.zy.util;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.util.FileCopyUtils;

public class ImageUtil {
	
	public static HashMap<String, String> saveImage(HttpSession session, byte[] imageBytes) {
		HashMap<String, String> map = new HashMap<String, String>();
        String basePath = "/usr/local/nginx/html/freelyOrder_img/";
//		String basePath = this.getClass().getResource("/").getPath();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String ymd = sdf.format(new Date());
        String extPath = File.separator + ymd + File.separator;
        basePath = basePath + extPath;
        File file = new File(basePath);
        if (!file.exists()) {
            file.mkdirs();
        }

        String fileExt = "jpg";
        String srcPath = "";

        // 图片重命名
        SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
        String newFileName = df.format(new Date()) + "_" + new Random().nextInt(1000) + "." + fileExt;
        File uploadFile = new File(basePath + newFileName);
        srcPath = extPath + newFileName;
        srcPath = StringUtils.replace(srcPath, "\\", "/");

        System.out.println("-----------------------------------basePath:" + basePath);

        try {
            byte[] imgBytes = imageBytes;

            FileCopyUtils.copy(imgBytes, uploadFile);
            map.put("url", srcPath);
            map.put("previewUrl", "http://182.92.107.223:80/freelyOrder_img" + srcPath);
            map.put("previewUrl", srcPath);
            System.out.println("----------url---------" + srcPath);
            System.out.println("-------previewUrl----------" + "http://182.92.107.223:80/freelyOrder_img" + srcPath);
            map.put("error", "0");
        } catch (Exception e) {
            map.put("error", "1");
            map.put("message", "");
            e.printStackTrace();
        }
        return map;
    }

}
