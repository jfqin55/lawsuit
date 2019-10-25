package com.zy.bean.sys;
 
import java.util.Date;
import java.util.List;

import com.rps.util.dao.annotation.ColumnIgnore;
import com.rps.util.dao.annotation.GenerateByDb;
import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_s_user")
public class TSUser {
	/**主键*/
	@Id
	@GenerateByDb
	private Integer user_id;

	/**用户名*/
	private String username;

	/**密码*/
	private String password;

	/**状态。0-无效、1-有效*/
	private String user_status;

	/**角色。1-普通用户、2-审批员、3-预算管理员、4-系统管理员*/
	private String user_role;

	/**致远OA用户ID*/
	private Long oa_user_id;

	/**创建时间*/
	private Date create_time;
	
	/**更新时间*/
	private Date update_time;

	/**备注*/
	private String remark;

	@ColumnIgnore
	private List<TSMenu> menuList;
	
	public Integer getUser_id() {
		return user_id;
	}

	public void setUser_id(Integer user_id) {
		this.user_id = user_id;
	}
	
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
	public String getUser_status() {
		return user_status;
	}

	public void setUser_status(String user_status) {
		this.user_status = user_status;
	}
	
	public String getUser_role() {
		return user_role;
	}

	public void setUser_role(String user_role) {
		this.user_role = user_role;
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

	public List<TSMenu> getMenuList() {
		return menuList;
	}

	public void setMenuList(List<TSMenu> menuList) {
		this.menuList = menuList;
	}

    public Long getOa_user_id() {
        return oa_user_id;
    }

    public void setOa_user_id(Long oa_user_id) {
        this.oa_user_id = oa_user_id;
    }

    public Date getCreate_time() {
        return create_time;
    }

    public void setCreate_time(Date create_time) {
        this.create_time = create_time;
    }
	
}
 