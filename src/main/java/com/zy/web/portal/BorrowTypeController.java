package com.zy.web.portal;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rps.util.D;
import com.zy.bean.bus.TBBorrowType;
import com.zy.util.Constant;
import com.zy.util.PageModel;
import com.zy.util.PageUtil;

@Controller
@RequestMapping("/portal/borrowType")
public class BorrowTypeController {
	
	@RequestMapping()
	public String init(HttpServletRequest request) {
	    return "portal/borrowType";
	}
	
	@RequestMapping("/showDetailWindow.json")
	public String showDetailWindow() {
		return "portal/borrowTypeDetail";
	}
	
	@ResponseBody
    @RequestMapping("/getBorrowTypeList.json")
    public List<TBBorrowType> getBorrowTypeList(HttpServletRequest request){
        try {
            return D.sql("select * from t_b_borrow_type where borrow_type_status = ? order by borrow_type_name").list(TBBorrowType.class, Constant.YES);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
	
	@ResponseBody
    @RequestMapping("/checkName.json")
    public Boolean checkName(String borrow_type_name, HttpServletRequest request){
        try{
            List<String> list = D.sql("select borrow_type_name from t_b_borrow_type where borrow_type_name = ? ")
                    .list(String.class, borrow_type_name);
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
			return PageUtil.getPageModel(TBBorrowType.class, "sql.bill/pageBorrowType", request);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
    @ResponseBody
	@RequestMapping("createOrUpdate.do")
	public Boolean createOrUpdate(String action, TBBorrowType borrowType, HttpServletRequest request){
		try{
		    Date now = new Date();
		    borrowType.setUpdate_time(now);
			if(StringUtils.equals("create", action)){
			    borrowType.setCreate_time(now);
				D.insertWithoutNull(borrowType);
			}else if(StringUtils.equals("update", action)){
				D.updateWithoutNull(borrowType);
			}
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
    @ResponseBody
	@RequestMapping("deleteById.do")
	public Boolean deleteById(Integer borrow_type_id, HttpServletRequest request){
		try{
			D.deleteById(TBBorrowType.class, borrow_type_id);
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
}
