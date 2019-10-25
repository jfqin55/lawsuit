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
@RequestMapping(value = "/report/date")
public class ReportDateController {
    
    private static final Logger logger = LoggerFactory.getLogger(ReportDateController.class);

    @RequestMapping("")
    public String date(HttpServletRequest request) {
        List<Map<String, String>> monthList = DateUtil.getMonthList();
        RequestUtil.setAtrribute(request, "monthList", JacksonUtil.writeValueAsString(monthList));
        return "report/date";
    }
    
    private static String MONTH_SQL_LEADER = "select update_month as name, ifnull(sum(bill_amount - return_amount), 0) as data from t_b_bill where bill_status = ? and bill_type in (?, ?) and corp_id = ? ";
    private static String MONTH_SQL_OTHERS = "select update_month as name, ifnull(sum(bill_amount - return_amount), 0) as data from t_b_bill where bill_status = ? and bill_type in (?, ?) and bill_id in (select bill_id from t_b_bill_check where auditor_id = ? and check_status != '4') ";
    
    @ResponseBody
	@RequestMapping("showMonthChart.do")
	public List<Map> showMonthChart(HttpServletRequest request, String subject_id, String department_id) {
		try {
			TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
			List<Map> monthColumnList = null;
			
			if(sessionUser.getDepartment_name().contains("领导班子") || Constant.UserRole.YS.equals(sessionUser.getRole_id())) {
			    StringBuilder sql = new StringBuilder(MONTH_SQL_LEADER);
			    if(StringUtils.isNotBlank(subject_id)) sql.append(" and subject_id = ").append(subject_id);
			    if(StringUtils.isNotBlank(department_id)) sql.append(" and department_id = ").append(department_id);
			    sql.append(" group by update_month ");
                monthColumnList = D.sql(sql.toString()).list(Map.class, Constant.BillStatus.AGREE, Constant.BillType.EXPENSE, Constant.BillType.BORROW, sessionUser.getOrg_id());
            }else {
                StringBuilder sql = new StringBuilder(MONTH_SQL_OTHERS);
                if(StringUtils.isNotBlank(subject_id)) sql.append(" and subject_id = ").append(subject_id);
                if(StringUtils.isNotBlank(department_id)) sql.append(" and department_id = ").append(department_id);
                sql.append(" group by update_month ");
                monthColumnList = D.sql(sql.toString()).list(Map.class, Constant.BillStatus.AGREE, Constant.BillType.EXPENSE, Constant.BillType.BORROW, sessionUser.getUser_id());
            }
			RequestUtil.setSessionAtrribute(request, "columnList", monthColumnList);
//			RequestUtil.setSessionAtrribute(request, "time_title", month.substring(0, 7));
			return monthColumnList==null ? new ArrayList<Map>() : monthColumnList;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
    
    @RequestMapping("exportExcel.do")
    @ResponseBody
    public void exportExcel(HttpServletRequest request, HttpServletResponse response) {
        try {
//            String time_title = (String)RequestUtil.getSessionAttribute(request, "time_title");
//            String fileName = time_title + "费用走势.csv";
            String fileName = "费用走势.csv";
            fileName = new String(fileName.getBytes("GBK"), "ISO-8859-1");
            response.setContentType(request.getServletContext().getMimeType(fileName) + ";charset=gbk");
            String title = "日期,费用金额(单位:万)";
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
