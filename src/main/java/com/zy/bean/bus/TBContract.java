package com.zy.bean.bus;
 
import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_b_contract")
public class TBContract {
    @Id
	private String contract_code;
    
    private String contract_url;
    
    private Integer contract_amount;
    
    private Integer contract_deposit;
    
    private Integer expense_amount;
    
    private String department_list;

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

    public Integer getContract_amount() {
        return contract_amount;
    }

    public void setContract_amount(Integer contract_amount) {
        this.contract_amount = contract_amount;
    }

    public Integer getContract_deposit() {
        return contract_deposit;
    }

    public void setContract_deposit(Integer contract_deposit) {
        this.contract_deposit = contract_deposit;
    }

    public Integer getExpense_amount() {
        return expense_amount;
    }

    public void setExpense_amount(Integer expense_amount) {
        this.expense_amount = expense_amount;
    }

    public String getDepartment_list() {
        return department_list;
    }

    public void setDepartment_list(String department_list) {
        this.department_list = department_list;
    }
    
}
 