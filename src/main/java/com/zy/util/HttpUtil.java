package com.zy.util;

import java.net.URI;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.apache.commons.codec.binary.Base64;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HttpUtil {

	private static Logger logger = LoggerFactory.getLogger(HttpUtil.class);

	private static int CONNECT_TIMEOUT = 60 * 1000;// 请求超时时间
	private static int SOCKET_TIMEOUT = 60 * 1000;// 传输超时时间

	private static String execute(HttpRequestBase httpRequest, final String encoding) throws Exception{
	    CloseableHttpResponse response = null;
		try {
		    CloseableHttpClient httpclient = HttpClients.createDefault();
			RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(SOCKET_TIMEOUT).setConnectTimeout(CONNECT_TIMEOUT)
//					.setProxy(new HttpHost("127.0.0.1", 8888))
					.build();
			httpRequest.setConfig(requestConfig);
			
			response = httpclient.execute(httpRequest);
			
			int statusCode = response.getStatusLine().getStatusCode();
            if(statusCode != 200){
                logger.error("HTTP状态码异常：{}", statusCode);
                throw new RuntimeException("HTTP状态码异常");
            }
            
            HttpEntity entity = response.getEntity();
            return EntityUtils.toString(entity, encoding);
		} finally {
		    StreamUtil.closeStream(response);
		}
	}

	public static String doPost(String url, String json, String encoding) throws Exception {
	    HttpPost httpPost = new HttpPost(url.trim());
        StringEntity stringEntity = new StringEntity(json, encoding);
        httpPost.setEntity(stringEntity);
        return execute(httpPost, encoding);
    }
    
    public static String doPost(String url, List<? extends NameValuePair> formParams, String encoding) throws Exception {
//        List<NameValuePair> formParams = new ArrayList<NameValuePair>();
//        formParams.add(new BasicNameValuePair("receivedOrders", receivedOrders));
        HttpPost httpPost = new HttpPost(url.trim());
        httpPost.setEntity(new UrlEncodedFormEntity(formParams, encoding));
        return execute(httpPost, encoding);
    }
	
	public static String doGet(String url, List<NameValuePair> formParams, String encoding) throws Exception {
	    HttpGet httpGet = new HttpGet(url.trim());
	    if(formParams != null) {
            UrlEncodedFormEntity entity = new UrlEncodedFormEntity(formParams, encoding);
            httpGet.setURI(new URI(httpGet.getURI() + "?" + EntityUtils.toString(entity)));
        }
        return execute(httpGet, encoding);
	}
	
	public static String doGet(String url, List<NameValuePair> formParams, String encoding, String token) throws Exception {
	    HttpGet httpGet = new HttpGet(url.trim());
        httpGet.setHeader("token", token);
        if(formParams != null) {
            UrlEncodedFormEntity entity = new UrlEncodedFormEntity(formParams, encoding);
            httpGet.setURI(new URI(httpGet.getURI() + "?" + EntityUtils.toString(entity)));
        }
        return execute(httpGet, encoding);
    }

	public static String cm(String xmlHead, String xmlBody, String encoding) throws Exception {
	    HttpPost httpPost = new HttpPost("");
        httpPost.setHeader("ACTCODE", "");
        httpPost.setHeader("X-WSSE", buildXWSSEHeader(new Date(), encoding));
        
//      MultipartEntity entity = new MultipartEntity();
//      entity.addPart("xmlhead", new StringBody(xmlHead, Charset.forName(Constant.CHARSET_NAME)));
//      entity.addPart("xmlbody", new StringBody(xmlBody, Charset.forName(Constant.CHARSET_NAME)));
//      entity.addPart("param3", new FileBody(new File("C:\\1.txt")));
        
        MultipartEntityBuilder entityBuilder = MultipartEntityBuilder.create().addTextBody("xmlhead", xmlHead).addTextBody("xmlbody", xmlBody);
        httpPost.setEntity(entityBuilder.build());
        return execute(httpPost, encoding);
	}

	private static String buildXWSSEHeader(Date now, String encoding) throws Exception {
		String nonce = UUID.randomUUID().toString();
		String base64Nonce = Base64.encodeBase64String(nonce.getBytes(encoding));
		String created = DateFormatUtil.getDateFormat_file().format(now);
		
		String str = nonce + created + "AppSecret";
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		byte[] digest = md.digest(str.getBytes(encoding));
		String passwordDigest = Base64.encodeBase64String(HexUtil.parseByte2HexStr(digest).getBytes(encoding));
		
		StringBuffer sb = new StringBuffer();
		sb.append("UsernameToken Username=\"").append("AppKey").append("\", PasswordDigest=\"").append(passwordDigest)
		  .append("\", Nonce=\"").append(base64Nonce).append("\",Created=\"").append(created).append("\"");
		return sb.toString();
	}

	public static String doPostAES(String url, String json, String encoding) throws Exception {
	    String code = AESUtil.encrypt(json);
        HttpPost httpPost = new HttpPost(url);
        StringEntity stringEntity = new StringEntity("{\"code\":\""+code+"\"}", encoding);
        httpPost.setEntity(stringEntity);
        return execute(httpPost, encoding);
    }
	
	public static void main(String[] args) throws Exception {
		List<NameValuePair> formParams = new ArrayList<NameValuePair>();
		formParams.add(new BasicNameValuePair("appid", "wx6e7c89d0fccb27c6"));
//		formParams.add(new BasicNameValuePair("secret", "593bb1b14bf364c689b931814367e6b6"));
//		formParams.add(new BasicNameValuePair("js_code", "081kUiQV0x14iU178kTV0bNgQV0kUiQr"));
//		formParams.add(new BasicNameValuePair("grant_type", "authorization_code"));
//		String doGet = doGet("https://api.weixin.qq.com/sns/jscode2session", formParams, "UTF-8");
		
		String doGet = doGet("https://tapi.ccxcredit.com", formParams, "UTF-8");
		System.out.println(doGet);
	}

}
