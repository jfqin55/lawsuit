package com.zy.bean.bus;
 
import java.util.Date;

import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_b_bill")
public class TBBill {
    @Id
	private String bill_id;
    
    private String bill_code;
    
    private String bill_qrcode_url;
    
    private String bill_status;
    
    private String auditor_id;
    
    private String bill_type;
    
    private Integer bill_amount;
    
    private String bill_amount_big;
    
    private String user_id;
    
    private String user_name;
    
    private String department_id;
    
    private String department_name;
    
    private String corp_id;
    
    private String org_name;
    
    private String create_time;
    
    private Date update_time;
    
    private String update_month;
    
    private String borrow_reason;
    
    private Integer return_amount;
    
    private Integer borrow_type_id;
    
    private String bill_id_borrow;
    
    private Integer diff_amount;
    
    private String remark;
    
    private String remark_check;
    
    private String special_switch;
    
    private Integer subject_id;
    
    private String subject_name;
    
    private Integer budget_special_id;
    
    private String budget_special_name;
    
    private String contract_code;
    
    private String contract_url;
    
    private Integer contract_deposit;
    
    private Integer contract_amount;
    
    private String deposit_switch;
    
    private String supplier_name;
    
    private String bank_name;
    
    private String account;
    
    private String tax_num;
    
    private String user_account;
    
    private String belong;
    
    
    private String begin_date_1;
    
    private String begin_place_1;
    
    private String end_date_1;
    
    private String end_place_1;
    
    private String begin_date_2;
    
    private String begin_place_2;
    
    private String end_date_2;
    
    private String end_place_2;
    
    private Integer ticket_num_railway;
    
    private Integer ticket_amount_railway;
    
    private Integer ticket_num_air;
    
    private Integer ticket_amount_air;
    
    private Integer ticket_num_taxi;
    
    private Integer ticket_amount_taxi;
    
    private Integer ticket_num_steamer;
    
    private Integer ticket_amount_steamer;
    
    private Integer people_num;
    
    private Integer day_num;
    
    private Integer subsidy_standard;
    
    private Integer subsidy_amount;
    
    private Integer hotel_amount;
    
    private Integer food_amount;
    
    private Integer other_amount;

    public String getBill_id() {
        return bill_id;
    }

    public void setBill_id(String bill_id) {
        this.bill_id = bill_id;
    }

    public String getBill_code() {
        return bill_code;
    }

    public void setBill_code(String bill_code) {
        this.bill_code = bill_code;
    }

    public String getBill_qrcode_url() {
        return bill_qrcode_url;
    }

    public void setBill_qrcode_url(String bill_qrcode_url) {
        this.bill_qrcode_url = bill_qrcode_url;
    }

    public String getBill_status() {
        return bill_status;
    }

    public void setBill_status(String bill_status) {
        this.bill_status = bill_status;
    }

    public String getAuditor_id() {
        return auditor_id;
    }

    public void setAuditor_id(String auditor_id) {
        this.auditor_id = auditor_id;
    }

    public String getBill_type() {
        return bill_type;
    }

    public void setBill_type(String bill_type) {
        this.bill_type = bill_type;
    }

    public Integer getBill_amount() {
        return bill_amount;
    }

    public void setBill_amount(Integer bill_amount) {
        this.bill_amount = bill_amount;
    }

    public String getBill_amount_big() {
        return bill_amount_big;
    }

    public void setBill_amount_big(String bill_amount_big) {
        this.bill_amount_big = bill_amount_big;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
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

    public String getCorp_id() {
        return corp_id;
    }

    public void setCorp_id(String corp_id) {
        this.corp_id = corp_id;
    }

    public String getOrg_name() {
        return org_name;
    }

    public void setOrg_name(String org_name) {
        this.org_name = org_name;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public Date getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(Date update_time) {
        this.update_time = update_time;
    }

    public String getUpdate_month() {
        return update_month;
    }

    public void setUpdate_month(String update_month) {
        this.update_month = update_month;
    }

    public String getBorrow_reason() {
        return borrow_reason;
    }

    public void setBorrow_reason(String borrow_reason) {
        this.borrow_reason = borrow_reason;
    }

    public Integer getReturn_amount() {
        return return_amount;
    }

    public void setReturn_amount(Integer return_amount) {
        this.return_amount = return_amount;
    }

    public Integer getBorrow_type_id() {
        return borrow_type_id;
    }

    public void setBorrow_type_id(Integer borrow_type_id) {
        this.borrow_type_id = borrow_type_id;
    }

    public String getBill_id_borrow() {
        return bill_id_borrow;
    }

    public void setBill_id_borrow(String bill_id_borrow) {
        this.bill_id_borrow = bill_id_borrow;
    }

    public Integer getDiff_amount() {
        return diff_amount;
    }

    public void setDiff_amount(Integer diff_amount) {
        this.diff_amount = diff_amount;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getRemark_check() {
        return remark_check;
    }

    public void setRemark_check(String remark_check) {
        this.remark_check = remark_check;
    }

    public String getSpecial_switch() {
        return special_switch;
    }

    public void setSpecial_switch(String special_switch) {
        this.special_switch = special_switch;
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

    public Integer getContract_amount() {
        return contract_amount;
    }

    public void setContract_amount(Integer contract_amount) {
        this.contract_amount = contract_amount;
    }

    public String getDeposit_switch() {
        return deposit_switch;
    }

    public void setDeposit_switch(String deposit_switch) {
        this.deposit_switch = deposit_switch;
    }

    public String getSupplier_name() {
        return supplier_name;
    }

    public void setSupplier_name(String supplier_name) {
        this.supplier_name = supplier_name;
    }

    public String getBank_name() {
        return bank_name;
    }

    public void setBank_name(String bank_name) {
        this.bank_name = bank_name;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getTax_num() {
        return tax_num;
    }

    public void setTax_num(String tax_num) {
        this.tax_num = tax_num;
    }

    public String getUser_account() {
        return user_account;
    }

    public void setUser_account(String user_account) {
        this.user_account = user_account;
    }

    public String getBelong() {
        return belong;
    }

    public void setBelong(String belong) {
        this.belong = belong;
    }

    public String getBegin_date_1() {
        return begin_date_1;
    }

    public void setBegin_date_1(String begin_date_1) {
        this.begin_date_1 = begin_date_1;
    }

    public String getBegin_place_1() {
        return begin_place_1;
    }

    public void setBegin_place_1(String begin_place_1) {
        this.begin_place_1 = begin_place_1;
    }

    public String getEnd_date_1() {
        return end_date_1;
    }

    public void setEnd_date_1(String end_date_1) {
        this.end_date_1 = end_date_1;
    }

    public String getEnd_place_1() {
        return end_place_1;
    }

    public void setEnd_place_1(String end_place_1) {
        this.end_place_1 = end_place_1;
    }

    public String getBegin_date_2() {
        return begin_date_2;
    }

    public void setBegin_date_2(String begin_date_2) {
        this.begin_date_2 = begin_date_2;
    }

    public String getBegin_place_2() {
        return begin_place_2;
    }

    public void setBegin_place_2(String begin_place_2) {
        this.begin_place_2 = begin_place_2;
    }

    public String getEnd_date_2() {
        return end_date_2;
    }

    public void setEnd_date_2(String end_date_2) {
        this.end_date_2 = end_date_2;
    }

    public String getEnd_place_2() {
        return end_place_2;
    }

    public void setEnd_place_2(String end_place_2) {
        this.end_place_2 = end_place_2;
    }

    public Integer getTicket_num_railway() {
        return ticket_num_railway;
    }

    public void setTicket_num_railway(Integer ticket_num_railway) {
        this.ticket_num_railway = ticket_num_railway;
    }

    public Integer getTicket_amount_railway() {
        return ticket_amount_railway;
    }

    public void setTicket_amount_railway(Integer ticket_amount_railway) {
        this.ticket_amount_railway = ticket_amount_railway;
    }

    public Integer getTicket_num_air() {
        return ticket_num_air;
    }

    public void setTicket_num_air(Integer ticket_num_air) {
        this.ticket_num_air = ticket_num_air;
    }

    public Integer getTicket_amount_air() {
        return ticket_amount_air;
    }

    public void setTicket_amount_air(Integer ticket_amount_air) {
        this.ticket_amount_air = ticket_amount_air;
    }

    public Integer getTicket_num_taxi() {
        return ticket_num_taxi;
    }

    public void setTicket_num_taxi(Integer ticket_num_taxi) {
        this.ticket_num_taxi = ticket_num_taxi;
    }

    public Integer getTicket_amount_taxi() {
        return ticket_amount_taxi;
    }

    public void setTicket_amount_taxi(Integer ticket_amount_taxi) {
        this.ticket_amount_taxi = ticket_amount_taxi;
    }

    public Integer getTicket_num_steamer() {
        return ticket_num_steamer;
    }

    public void setTicket_num_steamer(Integer ticket_num_steamer) {
        this.ticket_num_steamer = ticket_num_steamer;
    }

    public Integer getTicket_amount_steamer() {
        return ticket_amount_steamer;
    }

    public void setTicket_amount_steamer(Integer ticket_amount_steamer) {
        this.ticket_amount_steamer = ticket_amount_steamer;
    }

    public Integer getPeople_num() {
        return people_num;
    }

    public void setPeople_num(Integer people_num) {
        this.people_num = people_num;
    }

    public Integer getDay_num() {
        return day_num;
    }

    public void setDay_num(Integer day_num) {
        this.day_num = day_num;
    }

    public Integer getSubsidy_standard() {
        return subsidy_standard;
    }

    public void setSubsidy_standard(Integer subsidy_standard) {
        this.subsidy_standard = subsidy_standard;
    }

    public Integer getSubsidy_amount() {
        return subsidy_amount;
    }

    public void setSubsidy_amount(Integer subsidy_amount) {
        this.subsidy_amount = subsidy_amount;
    }

    public Integer getHotel_amount() {
        return hotel_amount;
    }

    public void setHotel_amount(Integer hotel_amount) {
        this.hotel_amount = hotel_amount;
    }

    public Integer getFood_amount() {
        return food_amount;
    }

    public void setFood_amount(Integer food_amount) {
        this.food_amount = food_amount;
    }

    public Integer getOther_amount() {
        return other_amount;
    }

    public void setOther_amount(Integer other_amount) {
        this.other_amount = other_amount;
    }
    
}
 