package com.zy.web.sys;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.OutputStream;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;
import com.zy.util.CaptchaUtil;
import com.zy.util.RequestUtil;

@Controller
@RequestMapping("/captcha")
public class CaptchaImageController {
	
	@RequestMapping("image.json")
	public void image(HttpServletRequest request, HttpServletResponse response) {
		// 设置相应类型,告诉浏览器输出的内容为图片
		response.setContentType("image/jpeg");
		// 不缓存此内容
		response.setHeader("Pragma", "No-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expire", 0);
		try {
			CaptchaUtil tool = new CaptchaUtil();
			StringBuffer code = new StringBuffer();
			BufferedImage image = tool.genRandomCodeImage(code);
			RequestUtil.removeSessionAtrribute(request, "captcha");
			RequestUtil.setSessionAtrribute(request, "captcha", code.toString());
			// 将内存中的图片通过流动形式输出到客户端
			ImageIO.write(image, "JPEG", response.getOutputStream());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping("imageTest.json")
	public void imageTest(HttpServletRequest request, HttpServletResponse response) {
		response.setContentType("image/jpeg");
		response.setContentType("image/jpeg");
		response.setHeader("Pragma","No-cache");
        response.setHeader("Cache-Control","no-cache");
        response.setDateHeader("Expires", 0);
        
		BufferedImage image = new BufferedImage(60, 20,
				BufferedImage.TYPE_INT_RGB);
		Random r = new Random();
		Graphics g = image.getGraphics();
		Font font = new Font("Default",Font.PLAIN,15);
		g.setFont(font);
		//g.setColor(new Color(r.nextInt(255), r.nextInt(255), r.nextInt(255)));
		g.fillRect(0, 0, 60, 20);
		//g.setColor(new Color(0,0,0));
		g.setColor(Color.BLUE);
		int x = 1000 + r.nextInt(9000);
		String number = String.valueOf(x); 
		
		g.drawString(number, 10, 15);
		//System.out.println(number);
		RequestUtil.setSessionAtrribute(request, "captcha", number);

		OutputStream os = null;
		try{
			os = response.getOutputStream();
			JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(os);
			encoder.encode(image);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try {
				os.flush();
				os.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
			
		}
	}

}
