package com.zy.bean.bus;
 
import java.util.Date;

import com.rps.util.dao.annotation.GenerateByDb;
import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_b_budget_log")
public class TBBudgetLog {
    @Id
    @GenerateByDb
    private Integer budget_log_id;
    
	private Integer budget_id;
	
	private Integer old_amount;
	
	private Integer new_amount;
    
    private String update_reason;
    
    private String annex_url;
    
    private String user_id;
    
    private Date update_time;

    public Integer getBudget_log_id() {
        return budget_log_id;
    }

    public void setBudget_log_id(Integer budget_log_id) {
        this.budget_log_id = budget_log_id;
    }

    public Integer getBudget_id() {
        return budget_id;
    }

    public void setBudget_id(Integer budget_id) {
        this.budget_id = budget_id;
    }

    public Integer getOld_amount() {
        return old_amount;
    }

    public void setOld_amount(Integer old_amount) {
        this.old_amount = old_amount;
    }

    public Integer getNew_amount() {
        return new_amount;
    }

    public void setNew_amount(Integer new_amount) {
        this.new_amount = new_amount;
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

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public Date getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(Date update_time) {
        this.update_time = update_time;
    }
    
}
 