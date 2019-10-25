package com.zy.web.portal;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rps.util.D;
import com.zy.bean.bus.TBBudget;
import com.zy.bean.bus.TBBudgetLog;
import com.zy.bean.bus.TBSubject;
import com.zy.bean.bus.TBUser;
import com.zy.service.BudgetService;
import com.zy.service.CommonService;
import com.zy.util.Constant;
import com.zy.util.DateUtil;
import com.zy.util.JacksonUtil;
import com.zy.util.PageModel;
import com.zy.util.PageUtil;
import com.zy.util.RequestUtil;

@Controller
@RequestMapping(value = "/portal/budget/year")
public class BudgetYearController {

    @RequestMapping("")
    public String init() {
    	return "budget/year";
    }
    
    @RequestMapping("/update")
    public String update(HttpServletRequest request) {
        List<Map<String, String>> yearList = DateUtil.getYearList();
        RequestUtil.setAtrribute(request, "yearList", JacksonUtil.writeValueAsString(yearList));
        return "budget/yearUpdate";
    }
    
    @RequestMapping("/showDetailWindow.json")
    public String showDetailWindow() {
        return "budget/yearUpdateDetail";
    }
    
    @ResponseBody
    @RequestMapping("getOrgTree.json")
    public List<Map> getOrgTree(HttpServletRequest request) {
        return CommonService.getOrgTreeByUserCorp(request);
    }
    
    @ResponseBody
	@RequestMapping("/selectAll.json")
	public PageModel selectAll(HttpServletRequest request) {
		try {
//			TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
		    Map<String, Object> paramMap = new HashMap<String, Object>();
		    int year = BudgetService.getYear();
            paramMap.put("year_num", year);
//			paramMap.put("orgIdList", new ArrayList());
		    PageModel pageModel = PageUtil.getPageModel(TBBudget.class, "sql.budget/pageBudget", request, paramMap);
		    List<TBBudget> budgetList = (List<TBBudget>)pageModel.getData();
		    if(budgetList != null && budgetList.size() > 0) return pageModel;
			List<TBSubject> subjectList = D.sql("select * from t_b_subject where subject_status = ? order by subject_id").list(TBSubject.class, Constant.YES);
			budgetList = new ArrayList<TBBudget>(subjectList.size());
			for (TBSubject tbSubject : subjectList) {
			    TBBudget budget = new TBBudget();
			    budget.setCorp_id(request.getParameter("corp_id"));
			    budget.setDepartment_id(request.getParameter("department_id"));
			    budget.setDepartment_name(request.getParameter("department_name"));
			    budget.setSubject_id(tbSubject.getSubject_id());
			    budget.setSubject_name(tbSubject.getSubject_name());
			    budget.setYear_num(year);
			    budget.setForce_switch(tbSubject.getForce_switch());
			    budget.setRetain_switch(tbSubject.getRetain_switch());
			    budgetList.add(budget);
            }
			pageModel.setData(budgetList);
			return pageModel;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
    
    @ResponseBody
    @RequestMapping("/update/selectAll.json")
    public PageModel updateSelectAll(HttpServletRequest request) {
        try {
            PageModel pageModel = PageUtil.getPageModel(TBBudget.class, "sql.budget/pageBudget", request);
            return pageModel;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    @ResponseBody
    @RequestMapping("saveBudgets.do")
    public Boolean saveBudgets(String budgetListJson, HttpServletRequest request){
        try{
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            Date now = new Date();
            List<TBBudget> budgetList = JacksonUtil.readValueAsList(budgetListJson, List.class, TBBudget.class);
            for (TBBudget tbBudget : budgetList) {
                tbBudget.setBudget_status(Constant.YES);
                tbBudget.setExpense_amount(0);
                tbBudget.setRemain_amount(tbBudget.getBudget_amount());
                tbBudget.setCreate_time(now);
                tbBudget.setUpdate_time(tbBudget.getCreate_time());
                tbBudget.setUser_id(sessionUser.getUser_id());
                TBBudget budgetBySubject = BudgetService.getBudgetBySubject(tbBudget.getDepartment_id(), tbBudget.getSubject_id(), tbBudget.getYear_num());
                if(budgetBySubject != null) {
                    tbBudget.setBudget_id(budgetBySubject.getBudget_id());
                   D.update(tbBudget);
                }else {
                    D.insert(tbBudget);
                }
            }
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }
    
    @ResponseBody
    @RequestMapping("createOrUpdate.do")
    public Boolean createOrUpdate(String action, final TBBudget budget, HttpServletRequest request){
        try{
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            Date now = new Date();
            budget.setBudget_status(Constant.YES);//预算只能是有效的
            budget.setUpdate_time(now);
            if(StringUtils.equals("create", action)){
                budget.setCreate_time(now);
                budget.setExpense_amount(0);
                budget.setRemain_amount(budget.getBudget_amount());
                budget.setCreate_time(now);
                budget.setUser_id(sessionUser.getUser_id());
                budget.setDepartment_name(D.sql("select org_name from t_b_org where org_id = ?").one(String.class, budget.getDepartment_id()));
                budget.setSubject_name(D.sql("select subject_name from t_b_subject where subject_id = ?").one(String.class, budget.getSubject_id()));
                TBBudget budgetBySubject = BudgetService.getBudgetBySubject(budget.getDepartment_id(), budget.getSubject_id(), budget.getYear_num());
                if(budgetBySubject != null) {
//                    budget.setBudget_id(budgetBySubject.getBudget_id());
//                    D.update(budget);
                    return false;
                }else {
                    D.insert(budget);
                }
            }else if(StringUtils.equals("update", action)){
                budget.setRemain_amount(budget.getBudget_amount() - budget.getExpense_amount());
                budget.setUser_id(sessionUser.getUser_id());
                
                final TBBudgetLog budgetLog = new TBBudgetLog();
                budgetLog.setAnnex_url(budget.getAnnex_url());
                budgetLog.setBudget_id(budget.getBudget_id());
                budgetLog.setOld_amount(budget.getOld_amount());
                budgetLog.setNew_amount(budget.getBudget_amount());
                budgetLog.setUpdate_reason(budget.getUpdate_reason());
                budgetLog.setUpdate_time(now);
                budgetLog.setUser_id(sessionUser.getUser_id());
                
                D.startTranSaction(new Callable<Boolean>() {
                    @Override
                    public Boolean call() throws Exception {
                        D.updateWithoutNull(budget);
                        D.insert(budgetLog);
                        return true;
                    }
                });
            }
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }
    
//  @ResponseBody
//  @RequestMapping("getOrgBudgetTree_old.json")
//  public List<Map> getOrgBudgetTree_old(HttpServletRequest request) {
//      try {
//          TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
//          List<Map> orgList = null;
//          if(sessionUser.getOrg_name().contains("三峡")) {
//              orgList = D.sql("select org_id as id, parent_org_id as pid, org_name as text from t_b_org where parent_org_id = ? and org_status = ? order by org_name").list(Map.class, sessionUser.getOrg_id(), Constant.YES);
//          } else {
//              orgList = D.sql("select org_id as id, parent_org_id as pid, org_name as text from t_b_org where corp_id = ? and org_status = ? and length(path) = 24 order by org_name").list(Map.class, sessionUser.getOrg_id(), Constant.YES);
//          }
//          int year = Calendar.getInstance().get(Calendar.YEAR);
//          List<TBBudget> budgetList = D.sql("select * from t_b_budget where year_num = ? and budget_status = ? order by budget_id").list(TBBudget.class, year, Constant.YES);
//          if(budgetList == null || budgetList.size() < 1) {
//              List<TBSubject> subjectList = D.sql("select * from t_b_subject where subject_status = ? order by subject_id").list(TBSubject.class, Constant.YES);
//              List<Map> orgBudgetList = new ArrayList<Map>();
//              for (Map map : orgList) {
//                  for (int i = 0; i < subjectList.size(); i++) {
//                      TBSubject tbSubject = subjectList.get(i);
//                      Map budgetMap = new HashMap();
//                      budgetMap.put("id", year+""+i);
//                      budgetMap.put("pid", map.get("id"));
//                      budgetMap.put("text", tbSubject.getSubject_name());
//                      budgetMap.put("subject_id", tbSubject.getSubject_id());
//                      budgetMap.put("year_num", year);
//                      budgetMap.put("budget_amount", "");
//                      orgBudgetList.add(budgetMap);
//                  }
//              }
//              orgList.addAll(orgBudgetList);
//          } else {
//              for (TBBudget tbBudget : budgetList) {
//                  Map budgetMap = new HashMap();
//                  budgetMap.put("id", tbBudget.getBudget_id());
//                  budgetMap.put("pid", tbBudget.getDepartment_id());
//                  budgetMap.put("text", tbBudget.getSubject_name());
//                  budgetMap.put("subject_id", tbBudget.getSubject_id());
//                  budgetMap.put("year_num", tbBudget.getYear_num());
//                  budgetMap.put("budget_amount", tbBudget.getBudget_amount());
//                  orgList.add(budgetMap);
//              }
//          }
//          Map corpMap = new HashMap();
//          corpMap.put("id", sessionUser.getOrg_id());
//          corpMap.put("pid", -1);
//          corpMap.put("text", sessionUser.getOrg_name());
//          orgList.add(0, corpMap);
//          return orgList;
//      } catch (Exception e) {
//          e.printStackTrace();
//          return null;
//      }
//  }
}
