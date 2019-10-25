package com.zy.bean.bus;
 
import java.util.Date;

import com.rps.util.dao.annotation.GenerateByDb;
import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_b_borrow_type")
public class TBBorrowType {
    @Id
    @GenerateByDb
	private Integer borrow_type_id;
    
    private String borrow_type_name;
    
    private String refund_account;
    
    private String borrow_type_status;
    
    private Integer subject_id;
    
    private String subject_name;
    
    private Date create_time;
    
    private Date update_time;

    public Integer getBorrow_type_id() {
        return borrow_type_id;
    }

    public void setBorrow_type_id(Integer borrow_type_id) {
        this.borrow_type_id = borrow_type_id;
    }

    public String getBorrow_type_name() {
        return borrow_type_name;
    }

    public void setBorrow_type_name(String borrow_type_name) {
        this.borrow_type_name = borrow_type_name;
    }

    public String getRefund_account() {
        return refund_account;
    }

    public void setRefund_account(String refund_account) {
        this.refund_account = refund_account;
    }

    public String getBorrow_type_status() {
        return borrow_type_status;
    }

    public void setBorrow_type_status(String borrow_type_status) {
        this.borrow_type_status = borrow_type_status;
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
    
}
 