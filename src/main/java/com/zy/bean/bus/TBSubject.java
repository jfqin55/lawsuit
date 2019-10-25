package com.zy.bean.bus;
 
import java.util.Date;

import com.rps.util.dao.annotation.GenerateByDb;
import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_b_subject")
public class TBSubject {
    @Id
    @GenerateByDb
	private Integer subject_id;
    
    private String subject_name;
    
    private String subject_status;
    
    private String requird_info;
    
    private Date create_time;
    
    private Date update_time;
    
    private String force_switch;
    
    private String retain_switch;

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

    public String getSubject_status() {
        return subject_status;
    }

    public void setSubject_status(String subject_status) {
        this.subject_status = subject_status;
    }

    public String getRequird_info() {
        return requird_info;
    }

    public void setRequird_info(String requird_info) {
        this.requird_info = requird_info;
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
    
}
 