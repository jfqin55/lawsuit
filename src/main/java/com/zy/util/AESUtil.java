package com.zy.util;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;


/**
 * <p>AES 高级加密标准(Advanced Encryption Standard)，是一种可逆加密算法，对用户的敏感信息加密处理，对原始数据进行AES加密后，在进行Base64编码转化；</p>
 * 
 * <p>CBC (Cipher Block Chaining，加密块链)。是一种循环模式，前一个分组的密文和当前分组的明文异或操作后再加密，这样做的目的是增强破解难度.</p>
 * 
 * <p>CBC是AES的算法模式之一</p>
 */
public class AESUtil {

    private static final String SECRET_KEY = "H5gOs1ZshKZ6WikN";//加密密钥，由字母或数字组成，此处使用AES-128-CBC加密模式，key需要为16位。可自行修改
    private static final String INITIAL_VECTOR = "8888159601152533";//初始向量，可自行修改

    /** 加密 */
    public static String encrypt(String sSrc) throws Exception{
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        byte[] raw = SECRET_KEY.getBytes();
        SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
        IvParameterSpec iv = new IvParameterSpec(INITIAL_VECTOR.getBytes());// 使用CBC模式，需要一个向量iv，可增加加密算法的强度
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, iv);
        byte[] encrypted = cipher.doFinal(sSrc.getBytes());
        
//        return Base64.encodeBase64String(encrypted);
//        return new Base64().encodeToString(encrypted);
//        return new BASE64Encoder().encode(encrypted);// 此处使用BASE64做转码。
        return CTUtil.encodeBytes( encrypted );
    }

    /** 解密 */
    public static String decrypt(String sSrc) throws Exception{
    	byte[] raw = SECRET_KEY.getBytes();
        SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        IvParameterSpec iv = new IvParameterSpec(INITIAL_VECTOR.getBytes("UTF-8"));
        cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);
        
//        byte[] encrypted1 = new BASE64Decoder().decodeBuffer(sSrc);// 先用base64解密
        byte[] encrypted1 = CTUtil.decodeBytes(sSrc);
        byte[] original = cipher.doFinal(encrypted1);
        String originalString = new String(original, "UTF-8");
        return originalString;
    }
    
    public static void main(String[] args) throws Exception {
        // 需要加密的字串
        String str = "[{\"request_no\":\"1001\",\"service_code\":\"FS0001\",\"contract_id\":\"100002\",\"order_id\":\"0\",\"phone_id\":\"13913996922\",\"plat_offer_id\":\"100094\",\"channel_id\":\"1\",\"activity_id\":\"100045\"}]";
        
        // 加密
        long start = System.currentTimeMillis();
        String enString = AESUtil.encrypt(str);
        long end = System.currentTimeMillis();
        System.out.println("加密后的字串是：" + enString);
        System.out.println("加密耗时{" + (end - start) + "}毫秒");
        // 解密
        start = System.currentTimeMillis();
        String DeString = AESUtil.decrypt(enString);
        end = System.currentTimeMillis();
        System.out.println("解密后的字串是：" + DeString);
        System.out.println("解密耗时{" + (end - start) + "}毫秒");
    }
    
}