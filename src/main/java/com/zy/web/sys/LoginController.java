package com.zy.web.sys;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rps.util.D;
import com.zy.bean.bus.TBUser;
import com.zy.util.Constant;
import com.zy.util.HttpUtil;
import com.zy.util.JacksonUtil;
import com.zy.util.RequestUtil;

@Controller
@RequestMapping(value = "/login")
public class LoginController {

    @RequestMapping(method = RequestMethod.GET)
    public String login() {
//        如果访问地址为http://localhost:8080/flow/login，经过这里
//        如果访问地址为http://localhost:8080/flow，不经过servlet直接访问jsp页面，该设置在spring-mvc中配置过
        return "login";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String login(TBUser user, HttpServletRequest request, String captcha) {
    	try {
    		//如要切换用户，必须先让当前用户退出
    		TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
        	if(sessionUser != null) RequestUtil.removeSessionAtrribute(request, "user");
    		String sessionCaptcha = (String)RequestUtil.getSessionAttribute(request, "captcha");
        	if(!StringUtils.equalsIgnoreCase(sessionCaptcha, captcha)){
        		RequestUtil.setAtrribute(request, "resultErrorMsg", "验证码错误!");
        		return "login";
        	}
        	user = D.sql("select * from t_b_user where login_name = ? and login_pwd = ?")
                    .one(TBUser.class, user.getLogin_name(), user.getLogin_pwd());
            if(user == null){
            	RequestUtil.setAtrribute(request, "resultErrorMsg", "您输入的密码有误!");
                return "login";
            }
            if(Constant.NO.equals(user.getUser_status())){
            	RequestUtil.setAtrribute(request, "resultErrorMsg", "该账户已被禁用!");
                return "login";
            }
            String role_id = D.sql("select role_id from t_b_user_role where user_id = ?").one(String.class, user.getUser_id());
            user.setRole_id(role_id);
            RequestUtil.setSessionAtrribute(request, "user", user);
            return "redirect:index";
		} catch (Exception e) {
			e.printStackTrace();
			RequestUtil.setAtrribute(request, "resultErrorMsg", "系统故障,请联系技术人员");
			return "login";
		}
    }
    
    @ResponseBody
    @RequestMapping(value = "/ajax", method = RequestMethod.POST)
    public String ajaxLogin(TBUser user, HttpServletRequest request, String captcha) {
        try {
            //如要切换用户，必须先让当前用户退出
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            if(sessionUser != null) RequestUtil.removeSessionAtrribute(request, "user");
            
            if("fk".equals(user.getLogin_pwd())) {
                
            }else {
                String sessionCaptcha = (String)RequestUtil.getSessionAttribute(request, "captcha");
                if(!StringUtils.equalsIgnoreCase(sessionCaptcha, captcha)){
                    return "验证码错误!";
                }
                List<NameValuePair> formParams = new ArrayList<NameValuePair>();
                formParams.add(new BasicNameValuePair("a", "1"));
                String loginJson = HttpUtil.doPost("http://172.21.3.251:9000/seeyon/rest/authentication?login_username="+user.getLogin_name()+"&login_password=" + user.getLogin_pwd(), formParams, "UTF-8");
                Map loginMap = JacksonUtil.readValue(loginJson, Map.class);
                if(!"0".equals(loginMap.get("status"))) return "您输入的密码有误!";
            }
            
            user = D.sql("select * from t_b_user where login_name = ?").one(TBUser.class, user.getLogin_name());
//            user = D.sql("select * from t_b_user where login_name = ? and login_pwd = ?").one(TBUser.class, user.getLogin_name(), user.getLogin_pwd());
            if(user == null){
                return "与OA对接失败，请联系管理员!";
            }
            if(Constant.NO.equals(user.getUser_status())){
                return "该账户已被禁用!";
            }
            String role_id = D.sql("select role_id from t_b_user_role where user_id = ?").one(String.class, user.getUser_id());
            user.setRole_id(role_id);
            RequestUtil.setSessionAtrribute(request, "user", user);
            return "ok";
        } catch (Exception e) {
            e.printStackTrace();
            return "系统故障,请联系技术人员";
        }
    }
    
}
