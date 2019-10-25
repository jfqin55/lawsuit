package com.zy.web.portal;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rps.util.D;
import com.zy.bean.bus.TBUser;
import com.zy.util.Constant;
import com.zy.util.DateUtil;
import com.zy.util.JacksonUtil;
import com.zy.util.RequestUtil;

@Controller
@RequestMapping(value = "/report/dept")
public class ReportDeptController {
    
    private static final Logger logger = LoggerFactory.getLogger(ReportDeptController.class);

    @RequestMapping("")
    public String dept(HttpServletRequest request) {
    	List<Map<String, String>> monthList = DateUtil.getMonthList();
    	RequestUtil.setAtrribute(request, "monthList", JacksonUtil.writeValueAsString(monthList));
    	return "report/dept";
    }
    
    private static String MONTH_SQL_LEADER = "select department_name as name, ifnull(sum(bill_amount - return_amount), 0) as data from t_b_bill where bill_status = ? and bill_type in (?, ?) and corp_id = ? and update_time >= str_to_date(?,'%Y-%m-%d') and update_time < date_add(str_to_date(?,'%Y-%m-%d'), interval 1 month) ";
    private static String MONTH_SQL_OTHERS = "select department_name as name, ifnull(sum(bill_amount - return_amount), 0) as data from t_b_bill where bill_status = ? and bill_type in (?, ?) and bill_id in (select bill_id from t_b_bill_check where auditor_id = ? and check_status != '4') and update_time >= str_to_date(?,'%Y-%m-%d') and update_time < date_add(str_to_date(?,'%Y-%m-%d'), interval 1 month) ";
    
    @ResponseBody
	@RequestMapping("showMonthChart.do")
	public List<Map> showMonthChart(HttpServletRequest request, String month, String subject_id) {
		try {
			if(month == null) return null;
			TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
			List<Map> monthColumnList = null;
			
			if(sessionUser.getDepartment_name().contains("领导班子") || Constant.UserRole.YS.equals(sessionUser.getRole_id())) {
			    StringBuilder sql = new StringBuilder(MONTH_SQL_LEADER);
			    if(StringUtils.isBlank(subject_id)) {
	                sql.append(" group by department_name ").toString();
	            }else {
	                sql.append(" and subject_id = ").append(subject_id).append(" group by department_name ").toString();
	            }
                monthColumnList = D.sql(sql.toString()).list(Map.class, Constant.BillStatus.AGREE, Constant.BillType.EXPENSE, Constant.BillType.BORROW, sessionUser.getOrg_id(), month, month);
            }else {
                StringBuilder sql = new StringBuilder(MONTH_SQL_OTHERS);
                if(StringUtils.isBlank(subject_id)) {
                    sql.append(" group by department_name ").toString();
                }else {
                    sql.append(" and subject_id = ").append(subject_id).append(" group by department_name ").toString();
                }
                monthColumnList = D.sql(sql.toString()).list(Map.class, Constant.BillStatus.AGREE, Constant.BillType.EXPENSE, Constant.BillType.BORROW, sessionUser.getUser_id(), month, month);
            }
			RequestUtil.setSessionAtrribute(request, "columnList", monthColumnList);
			RequestUtil.setSessionAtrribute(request, "time_title", month.substring(0, 7));
			return monthColumnList==null ? new ArrayList<Map>() : monthColumnList;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
    
    
    private static String CUSTOM_SQL_LEADER = "select department_name as name, ifnull(sum(bill_amount - return_amount), 0) as data from t_b_bill where bill_status = ? and bill_type in (?, ?) and corp_id = ? and update_time >= str_to_date(?,'%Y-%m-%d %H:%i:%s') and update_time <= str_to_date(?,'%Y-%m-%d %H:%i:%s') ";
    private static String CUSTOM_SQL_OTHERS = "select department_name as name, ifnull(sum(bill_amount - return_amount), 0) as data from t_b_bill where bill_status = ? and bill_type in (?, ?) and bill_id in (select bill_id from t_b_bill_check where auditor_id = ? and check_status != '4') and update_time >= str_to_date(?,'%Y-%m-%d %H:%i:%s') and update_time <= str_to_date(?,'%Y-%m-%d %H:%i:%s') ";
    
    
    @ResponseBody
	@SuppressWarnings("all")
	@RequestMapping("showCustomChart.do")
	public List<Map> showCustomChart(HttpServletRequest request, String startDateStr, String endDateStr, String subject_id) {
		try {
			if(startDateStr == null || endDateStr == null) return null;
			
			TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            List<Map> customColumnList = null;
            if(sessionUser.getDepartment_name().contains("领导班子") || Constant.UserRole.YS.equals(sessionUser.getRole_id())) {
                StringBuilder sql = new StringBuilder(CUSTOM_SQL_LEADER);
                if(StringUtils.isBlank(subject_id)) {
                    sql.append(" group by department_name ").toString();
                }else {
                    sql.append(" and subject_id = ").append(subject_id).append(" group by department_name ").toString();
                }
                customColumnList = D.sql(sql.toString()).list(Map.class, Constant.BillStatus.AGREE, Constant.BillType.EXPENSE, Constant.BillType.BORROW, sessionUser.getOrg_id(), startDateStr, endDateStr);
            }else {
                StringBuilder sql = new StringBuilder(CUSTOM_SQL_OTHERS);
                if(StringUtils.isBlank(subject_id)) {
                    sql.append(" group by department_name ").toString();
                }else {
                    sql.append(" and subject_id = ").append(subject_id).append(" group by department_name ").toString();
                }
                customColumnList = D.sql(sql.toString()).list(Map.class, Constant.BillStatus.AGREE, Constant.BillType.EXPENSE, Constant.BillType.BORROW, sessionUser.getUser_id(), startDateStr, endDateStr);
            }
			RequestUtil.setSessionAtrribute(request, "columnList", customColumnList);
			RequestUtil.setSessionAtrribute(request, "time_title", startDateStr.substring(0,10) + "至" + endDateStr.substring(0,10));
			return customColumnList;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
    
    @RequestMapping("exportExcel.do")
    @ResponseBody
    public void exportExcel(HttpServletRequest request, HttpServletResponse response) {
        try {
            String time_title = (String)RequestUtil.getSessionAttribute(request, "time_title");
            String fileName = time_title + " 年费用支出排行(按部门).csv";
            fileName = new String(fileName.getBytes("GBK"), "ISO-8859-1");
            response.setContentType(request.getServletContext().getMimeType(fileName) + ";charset=gbk");
            String title = "部门,费用金额(单位:万)";
            StringBuffer sb = new StringBuffer(title).append("\r\n");
            
            List<Map> columnList = (List<Map>)RequestUtil.getSessionAttribute(request, "columnList");
            if (columnList != null && columnList.size() > 0) {
                for (Map column : columnList) {
                    String line = String.format("%s,%s", column.get("NAME").toString(), ((BigDecimal)column.get("DATA")).doubleValue()/1000000.0);
                    sb.append(line).append("\r\n");
                }
            }

            response.setHeader("Content-disposition", "attachment;filename=" + fileName);
            response.getWriter().write(sb.toString());
        } catch (Exception e) {
            logger.error("export csv failed", e);
        }
    }
    
}
