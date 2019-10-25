package com.zy.web.admin;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rps.util.D;
import com.zy.bean.bus.TBBudgetSpecial;
import com.zy.bean.bus.TBSubject;
import com.zy.util.PageModel;
import com.zy.util.PageUtil;

@Controller
@RequestMapping("/admin/subject")
public class SubjectController {
	
	@RequestMapping()
	public String init(HttpServletRequest request) {
	    return "admin/subject";
	}
	
	@RequestMapping("/showDetailWindow.json")
	public String showDetailWindow() {
		return "admin/subjectDetail";
	}
	
	@ResponseBody
    @RequestMapping("/checkSubjectName.json")
    public Boolean checkSubjectName(String subject_name, HttpServletRequest request){
        try{
            List<String> list = D.sql("select subject_name from t_b_subject where subject_name = ? ")
                    .list(String.class, subject_name);
            if(list != null && list.size() > 0) return false;
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
			return PageUtil.getPageModel(TBSubject.class, "sql.admin/pageSubject", request);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
    @ResponseBody
	@RequestMapping("createOrUpdate.do")
	public Boolean createOrUpdate(String action, TBSubject subject, HttpServletRequest request){
		try{
		    Date now = new Date();
		    subject.setUpdate_time(now);
			if(StringUtils.equals("create", action)){
			    subject.setCreate_time(now);
				D.insertWithoutNull(subject);
			}else if(StringUtils.equals("update", action)){
				D.updateWithoutNull(subject);
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
