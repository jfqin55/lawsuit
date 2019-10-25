package com.zy.web.admin;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rps.util.D;
import com.zy.bean.bus.TBCheckFlow;
import com.zy.service.CommonService;
import com.zy.util.PageModel;
import com.zy.util.PageUtil;

@Controller
@RequestMapping("/admin/flow")
public class FlowController {
	
	@RequestMapping()
	public String init(HttpServletRequest request) {
	    return "admin/flow";
	}
	
	@RequestMapping("/showDetailWindow.json")
	public String showDetailWindow() {
		return "admin/flowDetail";
	}
	
	@RequestMapping("/showOrgs.json")
    public String showOrgs() {
        return "admin/flowOrg";
    }
	
	@ResponseBody
    @RequestMapping("getOrgTree.json")
    public List<Map> getOrgTree(Integer check_flow_id, HttpServletRequest request) {
        try {
            List<Map> orgList = CommonService.getOrgTree();
            String org_list = D.sql("select org_list from t_b_check_flow where check_flow_id = ?").one(String.class, check_flow_id);
            if(org_list == null) org_list = "";
            String[] orgIdList = org_list.split("\\|", -1);
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
    public Boolean bindOrgs(final Integer check_flow_id, final String[] orgs){
        try{
            final String orgList = StringUtils.join(orgs, "|");
            D.startTranSaction(new Callable<Boolean>() {
                @Override
                public Boolean call() {
                    TBCheckFlow checkFlow = new TBCheckFlow();
                    checkFlow.setCheck_flow_id(check_flow_id);
                    checkFlow.setOrg_list(orgList);
                    checkFlow.setUpdate_time(new Date());
                    D.updateWithoutNull(checkFlow);
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
			return PageUtil.getPageModel(TBCheckFlow.class, "sql.admin/pageCheckFlow", request);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
    
    @ResponseBody
	@RequestMapping("createOrUpdate.do")
	public Boolean createOrUpdate(String action, TBCheckFlow checkFlow, HttpServletRequest request){
		try{
		    Date now = new Date();
		    checkFlow.setUpdate_time(now);
			if(StringUtils.equals("create", action)){
			    checkFlow.setCreate_time(now);
				D.insertWithoutNull(checkFlow);
			}else if(StringUtils.equals("update", action)){
				D.updateWithoutNull(checkFlow);
			}
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
    @ResponseBody
	@RequestMapping("deleteById.do")
	public Boolean deleteById(Integer check_flow_id, HttpServletRequest request){
		try{
			D.deleteById(TBCheckFlow.class, check_flow_id);
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
}
