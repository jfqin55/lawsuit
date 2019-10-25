package com.zy.bean.bus;
 
import java.util.Date;

import com.rps.util.dao.annotation.GenerateByDb;
import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_b_check_flow")
public class TBCheckFlow {
    @Id
    @GenerateByDb
	private Integer check_flow_id;
    
    private String flow_desc;
    
    private Integer min_amount;
    
    private String org_list;
    
    private Date create_time;
    
    private Date update_time;
    
    private String remark;
    
    private String flow_status;
    
    private String requied_file;

    public Integer getCheck_flow_id() {
        return check_flow_id;
    }

    public void setCheck_flow_id(Integer check_flow_id) {
        this.check_flow_id = check_flow_id;
    }

    public String getFlow_desc() {
        return flow_desc;
    }

    public void setFlow_desc(String flow_desc) {
        this.flow_desc = flow_desc;
    }

    public Integer getMin_amount() {
        return min_amount;
    }

    public void setMin_amount(Integer min_amount) {
        this.min_amount = min_amount;
    }

    public String getOrg_list() {
        return org_list;
    }

    public void setOrg_list(String org_list) {
        this.org_list = org_list;
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

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getFlow_status() {
        return flow_status;
    }

    public void setFlow_status(String flow_status) {
        this.flow_status = flow_status;
    }

    public String getRequied_file() {
        return requied_file;
    }

    public void setRequied_file(String requied_file) {
        this.requied_file = requied_file;
    }

}
 