package com.zy.bean.sys;

import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_s_menu")
public class TSMenu {
	/**主键*/
	@Id
	private Integer menu_id;

	/**菜单名称*/
	private String menu_name;

	/**菜单URL*/
	private String menu_url;

	/**父菜单ID*/
	private Integer parent_menu_id;

	/**状态。0-无效、1-有效*/
	private String menu_status;

	/**菜单组*/
	private String menu_group;

	/**备注*/
	private String remark;

	
	public Integer getMenu_id() {
		return menu_id;
	}

	public void setMenu_id(Integer menu_id) {
		this.menu_id = menu_id;
	}
	
	public String getMenu_name() {
		return menu_name;
	}

	public void setMenu_name(String menu_name) {
		this.menu_name = menu_name;
	}
	
	public String getMenu_url() {
		return menu_url;
	}

	public void setMenu_url(String menu_url) {
		this.menu_url = menu_url;
	}
	
	public Integer getParent_menu_id() {
		return parent_menu_id;
	}

	public void setParent_menu_id(Integer parent_menu_id) {
		this.parent_menu_id = parent_menu_id;
	}
	
	public String getMenu_status() {
		return menu_status;
	}

	public void setMenu_status(String menu_status) {
		this.menu_status = menu_status;
	}
	
	public String getMenu_group() {
        return menu_group;
    }

    public void setMenu_group(String menu_group) {
        this.menu_group = menu_group;
    }

    public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
}
 