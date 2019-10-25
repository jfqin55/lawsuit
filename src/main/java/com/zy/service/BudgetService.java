package com.zy.service;

import java.util.Calendar;
import java.util.Date;

import com.rps.util.D;
import com.zy.bean.bus.TBBill;
import com.zy.bean.bus.TBBudget;
import com.zy.util.Constant;
import com.zy.util.DateFormatUtil;

public class BudgetService {
    
    public static int getYear() {
        return Calendar.getInstance().get(Calendar.YEAR);
    }
    
    public static int getMonth() {
        return Calendar.getInstance().get(Calendar.MONTH) + 1;
    }
    
    public static TBBudget getBudgetBySubject(String departmentId, Integer subjectId, Integer yearNum) {
        return D.sql("select * from t_b_budget where department_id = ? and subject_id = ? and year_num = ?")
                .one(TBBudget.class, departmentId, subjectId, yearNum);
    }
    
    public static TBBudget getCanUseBudgetBySubject(String departmentId, Integer subjectId, Integer yearNum) {
        TBBudget budget = getBudgetBySubject(departmentId, subjectId, yearNum);
        if(budget == null) {
            budget = new TBBudget();
            budget.setCanUseAmount(-1);
            budget.setForce_switch(Constant.NO);
            return budget;
        }
        if(Constant.YES.equals(budget.getRetain_switch())) {
            budget.setCanUseAmount(budget.getBudget_amount() * getMonth() / 12 - budget.getExpense_amount());
        }else {
            TBBill bill = D.sql("select sum(bill_amount-return_amount) as bill_amount from t_b_bill where bill_status = ? and subject_id = ? and update_time >= str_to_date(?,'%Y-%m') and bill_type != ?")
                .one(TBBill.class, Constant.BillStatus.AGREE, subjectId, DateFormatUtil.getDateFormat_yyyyMM().format(new Date()), Constant.BillType.REFUND);
            budget.setCanUseAmount(budget.getBudget_amount() / 12 - bill.getBill_amount());
        }
        return budget;
    }
    
    public static TBBudget getBudgetByDepartment(String departmentId, Integer yearNum) {
        return D.sql("select * from t_b_budget where department_id = ? and year_num = ?")
                .one(TBBudget.class, departmentId, yearNum);
    }

}
