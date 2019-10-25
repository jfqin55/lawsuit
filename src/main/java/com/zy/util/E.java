package com.zy.util;


public enum E {
	
    SUCCESS("0000", "成功"),
    ERROR("9999", "服务器未知错误"),
    UPLOAD_FAIL("1007", "上传失败"),
    USERNAME_ERROR("1001", "用户名错误"),
    STATUS_ERROR("1002", "无效的商户"),
    PASSWORD_ERROR("1003", "密码错误"),
    DATAGRAM_ERROR("1004", "报文长度错误"),
    REQUESTBODY_ERROR("1005", "requestBody格式错误"),
    OVERFLOW_ERROR("1006", "报文包含100条以上信息"),
    PHONE_ERROR("1007", "无效的手机号"),
    GRADE_ERROR("1008", "无效的流量档位"),
    ACCOUNT_ERROR("1009", "账户余额不足"),
    INTERVAL_ERROR("1010", "查询间隔小于5秒"),
    PATH_ERROR("1011", "请求地址错误"),
    AUTH_NULL_ERROR("1012", "鉴权信息不完整"),
    
    ;
    
    public String code;

    public String msg;

    private E(String code, String msg) {
        this.code = code;
        this.msg = msg;
    }

}
