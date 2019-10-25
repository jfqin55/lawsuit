package com.zy.bean.bus;
 
import com.rps.util.dao.annotation.GenerateByDb;
import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_b_budget_special_org")
public class TBBudgetSpecialOrg {
    @Id
    @GenerateByDb
	private Integer budget_special_org_id;
    
    private Integer budget_special_id;
    
    private String org_id;

    public Integer getBudget_special_org_id() {
        return budget_special_org_id;
    }

    public void setBudget_special_org_id(Integer budget_special_org_id) {
        this.budget_special_org_id = budget_special_org_id;
    }

    public Integer getBudget_special_id() {
        return budget_special_id;
    }

    public void setBudget_special_id(Integer budget_special_id) {
        this.budget_special_id = budget_special_id;
    }

    public String getOrg_id() {
        return org_id;
    }

    public void setOrg_id(String org_id) {
        this.org_id = org_id;
    }

}
 