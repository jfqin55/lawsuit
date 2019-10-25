package com.zy.bean.bus;
 
import java.util.Date;

import com.rps.util.dao.annotation.GenerateByDb;
import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_b_budget_special")
public class TBBudgetSpecial {
    @Id
    @GenerateByDb
	private Integer budget_special_id;
    
    private String budget_special_name;
    
    private Integer budget_special_amount;
    
    private Integer expense_amount;
    
    private Integer remain_amount;
    
    private Date start_time;
    
    private Date end_time;
    
    private String remark;
    
    private String contract_code;
    
    private String contract_url;
    
    private String file_url;
    
    private Integer contract_deposit;

    public Integer getBudget_special_id() {
        return budget_special_id;
    }

    public void setBudget_special_id(Integer budget_special_id) {
        this.budget_special_id = budget_special_id;
    }

    public String getBudget_special_name() {
        return budget_special_name;
    }

    public void setBudget_special_name(String budget_special_name) {
        this.budget_special_name = budget_special_name;
    }

    public Integer getBudget_special_amount() {
        return budget_special_amount;
    }

    public void setBudget_special_amount(Integer budget_special_amount) {
        this.budget_special_amount = budget_special_amount;
    }

    public Integer getExpense_amount() {
        return expense_amount;
    }

    public void setExpense_amount(Integer expense_amount) {
        this.expense_amount = expense_amount;
    }

    public Integer getRemain_amount() {
        return remain_amount;
    }

    public void setRemain_amount(Integer remain_amount) {
        this.remain_amount = remain_amount;
    }

    public Date getStart_time() {
        return start_time;
    }

    public void setStart_time(Date start_time) {
        this.start_time = start_time;
    }

    public Date getEnd_time() {
        return end_time;
    }

    public void setEnd_time(Date end_time) {
        this.end_time = end_time;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getFile_url() {
        return file_url;
    }

    public void setFile_url(String file_url) {
        this.file_url = file_url;
    }

    public String getContract_code() {
        return contract_code;
    }

    public void setContract_code(String contract_code) {
        this.contract_code = contract_code;
    }

    public String getContract_url() {
        return contract_url;
    }

    public void setContract_url(String contract_url) {
        this.contract_url = contract_url;
    }

    public Integer getContract_deposit() {
        return contract_deposit;
    }

    public void setContract_deposit(Integer contract_deposit) {
        this.contract_deposit = contract_deposit;
    }

}
 