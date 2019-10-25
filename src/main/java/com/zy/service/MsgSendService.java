package com.zy.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.zy.util.ConfigUtil;
import com.zy.util.DateFormatUtil;
import com.zy.util.HttpUtil;
import com.zy.util.Md5Util;

public class MsgSendService {
    
    private static final Logger logger = LoggerFactory.getLogger(MsgSendService.class);
    
    public static void sendMsg(String phone, String msgContent) {
        try {
            String proxyServiceCode = "";
            String sendTime = "" ;
            String timestamp = DateFormatUtil.getDateFormat_yyyyMMddHHmmss().format(new Date());
            String mhtMsgIds = RandomStringUtils.randomAlphabetic(1);
            
            List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
            nameValuePairs.add(new BasicNameValuePair("timestamp", timestamp));
            nameValuePairs.add(new BasicNameValuePair("userName", ConfigUtil.getString("msg.userName")));
            nameValuePairs.add(new BasicNameValuePair("sign", Md5Util.getMd5(ConfigUtil.getString("msg.pwd") + timestamp)));
            nameValuePairs.add(new BasicNameValuePair("serviceCode", ConfigUtil.getString("msg.serviceCode")));
            if (StringUtils.isNotBlank(proxyServiceCode)) nameValuePairs.add(new BasicNameValuePair("proxyServiceCode", proxyServiceCode));
            nameValuePairs.add(new BasicNameValuePair("phones", phone));
            nameValuePairs.add(new BasicNameValuePair("mhtMsgIds", mhtMsgIds));
            nameValuePairs.add(new BasicNameValuePair("sendTime", sendTime));
            nameValuePairs.add(new BasicNameValuePair("priority", "5"));
            nameValuePairs.add(new BasicNameValuePair("orgCode", "test"));
            nameValuePairs.add(new BasicNameValuePair("msgType", ConfigUtil.getString("msg.msgType")));
            nameValuePairs.add(new BasicNameValuePair("msgContent", msgContent));
//          nameValuePairs.add(new BasicNameValuePair("reportFlag", "1"));

            String result = HttpUtil.doPost(ConfigUtil.getString("msg.url"), nameValuePairs, "GBK");
            logger.info("msgSend response: {}", result);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("短信发送失败,phone:{},msgContent:{}", phone, msgContent);
        }
        
        
    }

}
