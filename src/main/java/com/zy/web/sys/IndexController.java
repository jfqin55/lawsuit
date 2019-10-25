package com.zy.web.sys;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rps.util.D;
import com.zy.bean.bus.TBBudget;
import com.zy.bean.bus.TBUser;
import com.zy.bean.sys.TSMenu;
import com.zy.service.BudgetService;
import com.zy.util.Constant;
import com.zy.util.JacksonUtil;
import com.zy.util.RequestUtil;

@Controller
@RequestMapping("/index")
public class IndexController {

    @RequestMapping()
    public String index(HttpServletRequest request) {
    	// 若用户直接访问 http://IP:8080/flow/index， 则让其去登陆页面
    	TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
    	if(sessionUser == null || sessionUser.getLogin_name() == null) return "login";
    	
    	// 动态判断用户可访问的菜单
    	RequestUtil.setAtrribute(request, "welcome", false);
    	List<TSMenu> menuList = null;
    	String role_id = sessionUser.getRole_id();
    	if(Constant.UserRole.ADMIN.equals(role_id)) {
    	    menuList = D.sql("select * from t_s_menu where menu_group in ('3','5') and menu_status = ? order by menu_id").list(TSMenu.class, Constant.YES);
    	}else if(Constant.UserRole.YS.equals(role_id)) {
    	    menuList = D.sql("select * from t_s_menu where menu_group in ('1','2','3','4') and menu_status = ? order by menu_id").list(TSMenu.class, Constant.YES);
    	    RequestUtil.setAtrribute(request, "welcome", true);
    	}else {
    	    // 如果有审批权限默认也有统计权限，如果没有审批权限，判断是否为领导或财务
            List<String> billIdList = D.sql("select bill_id from t_b_bill_check where auditor_id = ? and sort_id != 0").list(String.class, sessionUser.getUser_id());
            if(billIdList.size() > 0) {
                menuList = D.sql("select * from t_s_menu where menu_group in ('1','3','4') and menu_status = ? order by menu_id").list(TSMenu.class, Constant.YES);
                RequestUtil.setAtrribute(request, "welcome", true);
            }else {
                List<String> userIdList = D.sql("select user_id from t_b_user where department_name like '%财务%' or department_name like '%领导班子%' or post_name like '%会计%' or user_id in (select manager_id from t_b_org)").list(String.class);
                if(userIdList.contains(sessionUser.getUser_id())) {
                    menuList = D.sql("select * from t_s_menu where menu_group in ('3','4') and menu_status = ? order by menu_id").list(TSMenu.class, Constant.YES);
                    RequestUtil.setAtrribute(request, "welcome", true);
                }else {
                    menuList = D.sql("select * from t_s_menu where menu_group in ('3') and menu_status = ? order by menu_id").list(TSMenu.class, Constant.YES);
                }
            }
        }
    	RequestUtil.setAtrribute(request, "menuList", JacksonUtil.writeValueAsString(menuList));
    	
        return "index";
    }
    
    @RequestMapping("/portal")
    public String portal(HttpServletRequest request) {
        return "portal";
    }
    
    @ResponseBody
    @RequestMapping("showChart.do")
    public Map<String, Object> showChart(HttpServletRequest request) {
        try {
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            
            Map<String, Object> map = new HashMap<String, Object>();
            int year = BudgetService.getYear();
            map.put("year", year);
            TBBudget budget = null;
            if(sessionUser.getDepartment_name().contains("领导班子") || Constant.UserRole.YS.equals(sessionUser.getRole_id())) {
                budget = D.sql("select ifnull(sum(budget_amount), 0) as budget_amount, ifnull(sum(expense_amount), 0) as expense_amount from t_b_budget where corp_id = ? and year_num = ?").one(TBBudget.class, sessionUser.getOrg_id(), year);
            }else {
                budget = D.sql("select ifnull(sum(budget_amount), 0) as budget_amount, ifnull(sum(expense_amount), 0) as expense_amount from t_b_budget where department_id = ? and year_num = ?").one(TBBudget.class, sessionUser.getDepartment_id(), year);
            }
            map.put("yearBudget", budget.getBudget_amount());
            map.put("usedYearBudget", budget.getExpense_amount());
            return map;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
}
