package com.zy.util;

import java.io.ByteArrayOutputStream;
import java.util.List;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFPictureData;

import fr.opensagres.poi.xwpf.converter.xhtml.XHTMLConverter;
import fr.opensagres.poi.xwpf.converter.xhtml.XHTMLOptions;


public class Word2Html {
    /** 
     * word2007和word2003的构建方式不同， 
     * 前者的构建方式是xml，后者的构建方式是dom树
     * 文件的后缀也不同，前者后缀为.docx，后者后缀为.doc 
     */
    public static String convertDOCXToHtml(XWPFDocument document) throws Exception {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        
        //word07文档
      //获取文档中的图片
//        List<XWPFPictureData> allPictures = document.getAllPictures();
//        for (XWPFPictureData xwpfPictureData : allPictures) {
//            String name = xwpfPictureData.getFileName();
//            System.out.println(name);
////            byte[] data = xwpfPictureData.getData();
////            InputStream input = new ByteArrayInputStream(data);
//            // TODO 图片处理
//        }
 
        final String imageUrl = "";
        XHTMLOptions options = XHTMLOptions.create();
        //不把图片生成出来
        options.setExtractor(null);
        options.setIgnoreStylesIfUnused(false);
        options.setFragment(true);
       
        //转换
        XHTMLConverter.getInstance().convert(document, out, options);
        out.close();
        //转化数据流，替换特殊字符
//        return StringEscapeUtils.escapeHtml(out.toString());
        return out.toString();
    }
    
}
