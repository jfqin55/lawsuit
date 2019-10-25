package com.zy.bean.sys;
 
import java.util.Date;

import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_s_log")
public class TSLog {
	@Id
	/**用户表ID*/
	private String user_id;

	/**用户IP*/
	private String user_ip;

	/**访问URL*/
	private String access_url;

	/**访问时间*/
	private Date access_time;

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getUser_ip() {
		return user_ip;
	}

	public void setUser_ip(String user_ip) {
		this.user_ip = user_ip;
	}
	
	public String getAccess_url() {
		return access_url;
	}

	public void setAccess_url(String access_url) {
		this.access_url = access_url;
	}
	
	public Date getAccess_time() {
		return access_time;
	}

	public void setAccess_time(Date access_time) {
		this.access_time = access_time;
	}
}
 