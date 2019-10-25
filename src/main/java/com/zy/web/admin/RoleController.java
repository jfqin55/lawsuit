package com.zy.web.admin;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rps.util.D;
import com.zy.bean.bus.TBUserRole;
import com.zy.service.CommonService;
import com.zy.util.Constant;
import com.zy.util.PageModel;
import com.zy.util.PageUtil;

@Controller
@RequestMapping("/admin/role")
public class RoleController {
	
	@RequestMapping()
	public String init(HttpServletRequest request) {
	    return "admin/role";
	}
	
	@RequestMapping("/showDetailWindow.json")
	public String showDetailWindow() {
		return "admin/roleDetail";
	}
	
	@RequestMapping("/showUserTree.json")
    public String showUserTree() {
        return "admin/userTree";
    }
	
	@ResponseBody
    @RequestMapping("getUserTree.json")
    public List<Map> getUserTree(HttpServletRequest request) {
        return CommonService.getUserTree();
    }
	
	@ResponseBody
	@RequestMapping("/selectAll.json")
	public PageModel selectAll(HttpServletRequest request){
		try {
//		    D.startTranSaction(new Callable<Boolean>() {
//	          @Override
//	          public Boolean call() throws Exception {
//	              D.sql("update t_b_msg_check set check_status=?,remark=? where check_id = ?").update(checkStatus, remark, flow_id);
//	              D.sql("update t_b_msg_check_detail set check_status = ? where check_id = ? and check_status != '6'").update(checkStatus, flow_id);
//	              return true;
//	          }
//	      });
			return PageUtil.getPageModel(TBUserRole.class, "sql.admin/pageUserRole", request);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
    @ResponseBody
	@RequestMapping("createOrUpdate.do")
	public Boolean createOrUpdate(String action, TBUserRole userRole, HttpServletRequest request){
		try{
		    Date now = new Date();
		    userRole.setUpdate_time(now);
			if(StringUtils.equals("create", action)){
			    if(Constant.UserRole.SH_CWBCNG.equals(userRole) || Constant.UserRole.SH_CWBSHG.equals(userRole)) {
			        List<String> userIdList = D.sql("select user_id from t_b_user_role where role_id = ?").list(String.class, userRole);
			        if(userIdList != null && userIdList.size() > 0) return false;
			    }
			    userRole.setCreate_time(now);
				D.insertWithoutNull(userRole);
			}else if(StringUtils.equals("update", action)){
				D.updateWithoutNull(userRole);
			}
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
    @ResponseBody
	@RequestMapping("deleteById.do")
	public Boolean deleteById(Integer user_role_id, HttpServletRequest request){
		try{
			D.deleteById(TBUserRole.class, user_role_id);
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
}
