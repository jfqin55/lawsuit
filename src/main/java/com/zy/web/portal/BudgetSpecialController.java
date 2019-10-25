package com.zy.web.portal;

import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rps.util.D;
import com.zy.bean.bus.TBBudgetSpecial;
import com.zy.bean.bus.TBBudgetSpecialOrg;
import com.zy.bean.bus.TBContract;
import com.zy.bean.bus.TBUser;
import com.zy.service.CommonService;
import com.zy.util.JacksonUtil;
import com.zy.util.PageModel;
import com.zy.util.PageUtil;
import com.zy.util.RequestUtil;

@Controller
@RequestMapping("/portal/budget/special")
public class BudgetSpecialController {
	
	@RequestMapping()
	public String init(HttpServletRequest request) {
	    return "budget/special";
	}
	
	@RequestMapping("/showDetailWindow.json")
	public String showDetailWindow() {
		return "budget/specialDetail";
	}
	
	@RequestMapping("/showOrgs.json")
    public String showOrgs() {
        return "budget/specialOrg";
    }
	
	@ResponseBody
    @RequestMapping("getOrgTree.json")
    public List<Map> getOrgTree(Integer budget_special_id, HttpServletRequest request) {
        try {
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            List<Map> orgList = CommonService.getOrgTreeByUserCorp(request);
            List<String> orgIdList = D.sql("select org_id from t_b_budget_special_org where budget_special_id = ?").list(String.class, budget_special_id);
            for (Map map : orgList) {
//                map.setChecked(null); // session中还保存有上次操作留下的checked数据，必须清掉
                for (String orgId : orgIdList) {
                    String id = (String)map.get("id");
                    if(id.equals(orgId)) {// 注意Long类型比较，Long.valueOf()源码
                        map.put("checked", true);
                        break;
                    }
                }
            }
            return orgList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
	
	@ResponseBody
    @RequestMapping("bindOrgs.do")
    public Boolean bindOrgs(final Integer budget_special_id, final String[] orgs){
        try{
            TBBudgetSpecial budgetSpecial = D.selectById(TBBudgetSpecial.class, budget_special_id);
            if(StringUtils.isNotBlank(budgetSpecial.getContract_code())) {
                TBContract contract = D.selectById(TBContract.class, budgetSpecial.getContract_code());
                StringBuilder departmentList = new StringBuilder();
                for (String org_id : orgs) {
                    departmentList.append(org_id).append("|");
                }
                contract.setDepartment_list(departmentList.toString());
                D.update(contract);
            } 
            D.startTranSaction(new Callable<Boolean>() {
                @Override
                public Boolean call() {
                    D.sql("delete from t_b_budget_special_org where budget_special_id = ?").update(budget_special_id);
                    for (String org_id : orgs) {
                        TBBudgetSpecialOrg bsOrg = new TBBudgetSpecialOrg();
                        bsOrg.setBudget_special_id(budget_special_id);
                        bsOrg.setOrg_id(org_id);
                        D.insert(bsOrg);
                    }
                    return true;
                }
            });
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
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
			return PageUtil.getPageModel(TBBudgetSpecial.class, "sql.budget/pageBudgetSpecial", request);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	@ResponseBody
    @RequestMapping("/checkBudgetSpecialName.json")
    public Boolean checkBudgetSpecialName(String budget_special_name, HttpServletRequest request){
        try{
            List<String> list = D.sql("select budget_special_name from t_b_budget_special where budget_special_name = ? ")
                    .list(String.class, budget_special_name);
            if(list != null && list.size() > 0) return false;
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }
    
    
    @ResponseBody
	@RequestMapping("createOrUpdate.do")
	public Boolean createOrUpdate(String action, String submitData, HttpServletRequest request){
		try{
		    final TBBudgetSpecial budgetSpecial = JacksonUtil.readValue(submitData, TBBudgetSpecial.class);
			if(StringUtils.equals("create", action)){
			    budgetSpecial.setRemain_amount(budgetSpecial.getBudget_special_amount());
			    budgetSpecial.setExpense_amount(0);
			    D.insertWithoutNull(budgetSpecial);
			    if(StringUtils.isBlank(budgetSpecial.getContract_code())) return true;
			    final TBContract contract= new TBContract();
			    contract.setContract_amount(budgetSpecial.getBudget_special_amount());
			    contract.setContract_code(budgetSpecial.getContract_code());
			    contract.setContract_deposit(budgetSpecial.getContract_deposit());
			    contract.setContract_url(budgetSpecial.getContract_url());
			    TBContract existContract = D.sql("select * from t_b_contract where contract_code = ?").one(TBContract.class, budgetSpecial.getContract_code());
			    if(existContract == null) {
			        contract.setExpense_amount(0);
			        D.insert(contract);
			    }else {
			        if(!contract.getContract_amount().equals(existContract.getContract_amount())) return false;
			        contract.setExpense_amount(existContract.getExpense_amount());
			        D.update(contract);
			    }
			}else if(StringUtils.equals("update", action)){
				D.updateWithoutNull(budgetSpecial);
			}
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
    @ResponseBody
	@RequestMapping("deleteById.do")
	public Boolean deleteById(Integer budget_special_id, HttpServletRequest request){
		try{
			D.deleteById(TBBudgetSpecial.class, budget_special_id);
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
}
