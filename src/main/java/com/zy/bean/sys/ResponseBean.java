package com.zy.bean.sys;

import com.zy.util.E;

public class ResponseBean {

	private String code;
	
	private String msg;
	
	public void setError(E err){
		this.code = err.code;
		this.msg = err.msg;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

}
