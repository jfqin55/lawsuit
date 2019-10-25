package com.zy.web.sys;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rps.util.D;
import com.zy.bean.bus.TBUser;
import com.zy.bean.sys.TSUser;
import com.zy.util.Constant;
import com.zy.util.PageModel;
import com.zy.util.PageUtil;
import com.zy.util.RequestUtil;

@Controller
@RequestMapping("/user")
public class UserController {
	
	@RequestMapping()
	public String init(HttpServletRequest request) {
		TSUser sessionUser = (TSUser)RequestUtil.getSessionAttribute(request, "user");
		if(Constant.UserRole.ADMIN.equals(sessionUser.getUser_role())) return "admin/user";
		return "login";
	}
	
	@RequestMapping("/showDetailWindow.json")
	public String showDetailWindow() {
		return "admin/userDetail";
	}
	
	@ResponseBody
	@RequestMapping("/changePwd.do")
	public boolean changePwd(HttpServletRequest request, TSUser user){
		try {
			TSUser sessionUser = (TSUser)RequestUtil.getSessionAttribute(request, "user");
			String password = D.sql("select password from t_s_user where password = ? and user_id = ?")
					.one(String.class, user.getPassword(), sessionUser.getUser_id());
			if(StringUtils.isBlank(password)) return false;
			D.sql("update t_s_user set password = ? where user_id = ?").update(user.getRemark(), sessionUser.getUser_id());
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	@ResponseBody
	@RequestMapping("/selectAll.json")
	public PageModel selectAll(HttpServletRequest request){
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("user_role_not_equal", Constant.UserRole.ADMIN);
			return PageUtil.getPageModel(TSUser.class, "sql.sys/pageUser", request, map);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
    
    @ResponseBody
	@RequestMapping("/checkUsername.json")
	public Boolean checkUsername(String username, HttpServletRequest request){
		try{
			List<String> list = D.sql("select username from t_s_user where username = ? ").list(String.class, username);
			if(list != null && list.size() > 0) return false;
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
    @ResponseBody
	@RequestMapping("createOrUpdate.do")
	public Boolean createOrUpdate(String action, TSUser user, HttpServletRequest request){
		try{
			TSUser sessionUser = (TSUser)RequestUtil.getSessionAttribute(request, "user");
			user.setUpdate_time(new Date());
			if(StringUtils.equals("create", action)){
//			    user.setUser_role(Constant.UserRole.BX);
				D.insertWithoutNull(user);
			}else if(StringUtils.equals("update", action)){
				D.updateWithoutNull(user);
			}
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
    @ResponseBody
	@RequestMapping("deleteById.do")
	public Boolean deleteById(Integer user_id, HttpServletRequest request){
		try{
			D.deleteById(TSUser.class, user_id);
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
    @ResponseBody
    @RequestMapping("showUserInfo.json")
    public TBUser showUserInfo(HttpServletRequest request) {
        try {
            TBUser user = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            return user;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
	public static void main(String[] args) {
		Long a = -129L;
		Long b = -129L;
		System.out.println(a==b);
	}
	
}
