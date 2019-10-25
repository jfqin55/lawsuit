package com.zy.bean.bus;
 
import java.util.Date;

import com.rps.util.dao.annotation.ColumnIgnore;
import com.rps.util.dao.annotation.GenerateByDb;
import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_b_budget")
public class TBBudget {
    @Id
    @GenerateByDb
	private Integer budget_id;
    
    private String corp_id;
    
    private String department_id;
    
    private String department_name;
    
    private Integer subject_id;
    
    private String subject_name;
    
    private Integer year_num;
    
    private Integer budget_amount;
    
    private Integer expense_amount;
    
    private Integer remain_amount;
    
    private Date create_time;
    
    private Date update_time;
    
    private String budget_status;
    
    private String force_switch;
    
    private String retain_switch;
    
    private String user_id;
    @ColumnIgnore
    private String update_reason;
    @ColumnIgnore
    private String annex_url;
    @ColumnIgnore
    private Integer old_amount;
    @ColumnIgnore
    private Integer canUseAmount;

    public Integer getBudget_id() {
        return budget_id;
    }

    public void setBudget_id(Integer budget_id) {
        this.budget_id = budget_id;
    }

    public String getCorp_id() {
        return corp_id;
    }

    public void setCorp_id(String corp_id) {
        this.corp_id = corp_id;
    }

    public String getDepartment_id() {
        return department_id;
    }

    public void setDepartment_id(String department_id) {
        this.department_id = department_id;
    }

    public String getDepartment_name() {
        return department_name;
    }

    public void setDepartment_name(String department_name) {
        this.department_name = department_name;
    }

    public Integer getSubject_id() {
        return subject_id;
    }

    public void setSubject_id(Integer subject_id) {
        this.subject_id = subject_id;
    }

    public String getSubject_name() {
        return subject_name;
    }

    public void setSubject_name(String subject_name) {
        this.subject_name = subject_name;
    }

    public Integer getYear_num() {
        return year_num;
    }

    public void setYear_num(Integer year_num) {
        this.year_num = year_num;
    }

    public Integer getBudget_amount() {
        return budget_amount;
    }

    public void setBudget_amount(Integer budget_amount) {
        this.budget_amount = budget_amount;
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

    public Date getCreate_time() {
        return create_time;
    }

    public void setCreate_time(Date create_time) {
        this.create_time = create_time;
    }

    public Date getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(Date update_time) {
        this.update_time = update_time;
    }

    public String getBudget_status() {
        return budget_status;
    }

    public void setBudget_status(String budget_status) {
        this.budget_status = budget_status;
    }

    public String getForce_switch() {
        return force_switch;
    }

    public void setForce_switch(String force_switch) {
        this.force_switch = force_switch;
    }

    public String getRetain_switch() {
        return retain_switch;
    }

    public void setRetain_switch(String retain_switch) {
        this.retain_switch = retain_switch;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getUpdate_reason() {
        return update_reason;
    }

    public void setUpdate_reason(String update_reason) {
        this.update_reason = update_reason;
    }

    public String getAnnex_url() {
        return annex_url;
    }

    public void setAnnex_url(String annex_url) {
        this.annex_url = annex_url;
    }

    public Integer getOld_amount() {
        return old_amount;
    }

    public void setOld_amount(Integer old_amount) {
        this.old_amount = old_amount;
    }

    public Integer getCanUseAmount() {
        return canUseAmount;
    }

    public void setCanUseAmount(Integer canUseAmount) {
        this.canUseAmount = canUseAmount;
    }
    
}
 