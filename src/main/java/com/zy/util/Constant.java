package com.zy.util;

import java.text.SimpleDateFormat;


public class Constant {
    
    public static final String CHARSET_NAME = "UTF-8";
	
	public static final String YES = "1";
	public static final String NO = "0";
	
	public static final SimpleDateFormat DATETIME_FORMAT = new SimpleDateFormat("yyyyMMddHHmmss");
	public static final SimpleDateFormat MONTH_FORMAT = new SimpleDateFormat("yyyy-MM");
	
	// 机构类型。1-法人、2-部门
	public static final class ORG_TYPE{
        public static final String CORP = "1";
        public static final String DEPARTMENT = "2";
    }
	
	// 用户角色。0-系统管理员、1-预算管理员、2-一级支行分管财务行长、3-市行财务部审核岗、4-市行财务部出纳岗、5-一级支行财务审核岗、6-县行财务部审核岗、7-县行财务部出纳岗
	public static class UserRole{
		public static final String ADMIN = "0";
		public static final String YS = "1";
		public static final String YJZH_FGCWHZ = "2";
		public static final String SH_CWBSHG = "3";
		public static final String SH_CWBCNG = "4";
		public static final String YJZH_CWSHG = "5";
		public static final String XH_CWBSHG = "6";
		public static final String XH_CWBCNG = "7";
	}
	
	// 单据状态。0-未通过、1-审批中、2-已通过、3-已退回、4-待审批
	public static class BillStatus{
		public static final String REFUSE = "0";
		public static final String WAITING = "1";
		public static final String AGREE = "2";
		public static final String RETURN = "3";
		public static final String READY = "4";
	}
	
	// 单据类型。1-报销单、2-借款单、3-还款单
	public static class BillType{
		public static final String EXPENSE = "1";
		public static final String BORROW = "2";
		public static final String REFUND = "3";
	}
	
}
