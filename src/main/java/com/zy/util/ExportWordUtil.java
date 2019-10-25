package com.zy.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.poi.POIXMLDocument;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;

import com.zy.util.Reflections;

/**
 * 适用于word 2007 poi 版本 3.7
 */
public class ExportWordUtil {

    /**
     * 根据指定的参数值、模板，生成 word 文档
     *
     * @param param    需要替换的变量
     * @param template 模板
     */
    public static XWPFDocument generateWord(Map<String, Object> param,
                                            String template) {
        XWPFDocument doc = null;
        OPCPackage pack = null;
        try {
            pack = POIXMLDocument.openPackage(template);
            doc = new XWPFDocument(pack);
            if (param != null && param.size() > 0) {

                // 处理段落 - 文字或照片
                List<XWPFParagraph> paragraphList = doc.getParagraphs();
                processParagraphs(paragraphList, param, doc, null, 0);

                // 处理表格 - 文字或照片
                List<XWPFTable> tablelist = doc.getTables();
                for (int i = 0; i < tablelist.size(); i++) {
                    XWPFTable xwpfTable = tablelist.get(i);
                    List<XWPFTableRow> rows = xwpfTable.getRows();
                    for (int j = 0; j < rows.size(); j++) {
                        XWPFTableRow row = rows.get(j);
                        List<XWPFTableCell> cells = row.getTableCells();
                        for (int k = 0; k < cells.size(); k++) {
                            XWPFTableCell cell = cells.get(k);
                            List<XWPFParagraph> paragraphListTable = cell
                                    .getParagraphs();
                            processParagraphs(paragraphListTable, param, doc,
                                    xwpfTable, j);
                        }
                    }
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doc;
    }


    private static String replaceParams(List<String> mapbeParams, XWPFRun run, List<XWPFRun> runList, Map<String, Object> params) {
        String text = "";
        for (String s : mapbeParams) {
            text += s.trim();
        }
//        System.out.println("合成的key=" + text);
        Object paramValue = getParamValue(text.substring(2, text.length() - 1), params);
        if(paramValue == null){
            return "";
        }
        return paramValue.toString();
//        String value = (String) param.get(text);
//        if (value != null) {
//            return value;
//        }
////        for (int i = 0; i < runList.size(); i++) {
////            runList.get(i).setText(mapbeParams.get(i), 0);
////        }
//        return "";


    }


    private static Pattern FULL_PARAM = Pattern.compile("\\$\\{([^}]+)\\}");

    public static Object getParamValue(String key, Map<String, Object> params) {
        String[] split = key.split("\\.");
        Object scope = params;
        Object value = null;
        for (int i = 0; i < split.length; i++) {
            value = getScopeValue(split[i], scope);
            scope = value;
        }
        return value;

    }

    private static Object getScopeValue(String key, Object scope) {
        if (scope == null) {
            return null;
        }
        if (scope instanceof Map) {
            return ((Map) scope).get(key);
        }
        return Reflections.getFieldValue(scope, key);
    }

    public static String getReplaceMent(String text, Map<String, Object> params) {
        StringBuffer sb = new StringBuffer();
        Matcher matcher = FULL_PARAM.matcher(text);

        while (matcher.find()) {
            String key = matcher.group(1).trim();
//            System.out.println("key=" + key);
            Object paramValue = getParamValue(key, params);
            if (paramValue == null) {
                matcher.appendReplacement(sb, "");
            } else {
                matcher.appendReplacement(sb, paramValue.toString());
            }

        }
        matcher.appendTail(sb);
        return sb.toString();

    }


    /**
     * 处理段落
     *
     * @param paragraphList
     * @throws Exception
     */
    public static void processParagraphs(List<XWPFParagraph> paragraphList,
                                         Map<String, Object> params, XWPFDocument doc, XWPFTable xwpfTable,
                                         int rownum) throws Exception {
        if (paragraphList != null && paragraphList.size() > 0) {
            for (XWPFParagraph paragraph : paragraphList) {
                List<XWPFRun> runs = paragraph.getRuns();
                List<String> mapbeParams = new ArrayList<String>();
                List<XWPFRun> runList = new ArrayList<XWPFRun>();
                boolean paramsIsSplit = false;
                for (XWPFRun run : runs) {
                    String text = run.getText(0);
                    if (text == null || "".equals(text.trim())) {
                        continue;
                    }
//                    System.out.println("text=" + text);
                    text = text.trim();
                    //替换完整的${user.name}这种格式
                    text = getReplaceMent(text, params);

                    //如果剩下的字符串还包含${或者$
                    int dollorIndex = text.indexOf("$");
                    int rightBraceIndex = text.indexOf("}");
                    //不包含 $，也不包含}
                    if (dollorIndex == -1 && rightBraceIndex == -1) {
                        //不在被变量被分割的上下文中
                        if (paramsIsSplit) {
                            mapbeParams.add(text);
                            run.setText("", 0);
                        } else {
                            //可以结束改run了
                            run.setText(text, 0);
                        }
                        continue;

                    }
                    if (dollorIndex != -1) {
                        paramsIsSplit = true;
                        String left = text.substring(0, dollorIndex);
                        //保留左边部分
                        run.setText(left, 0);
                        //右边部分进入list，用来拼接完整的${a.b}这种格式
                        mapbeParams.add(text.substring(dollorIndex));
                    }
                    if (rightBraceIndex != -1) {
                        //凑齐了完整的变量格式
                        paramsIsSplit = false;
                        String left = text.substring(0, rightBraceIndex + 1);
                        mapbeParams.add(left);

                        String s = replaceParams(mapbeParams, run, runList, params);
                        run.setText(s + text.substring(rightBraceIndex + 1), 0);

                    }

                }
            }
        }
    }

    /**
     * 将输入流中的数据写入字节数组
     *
     * @param in
     * @return
     */
    public static byte[] inputStream2ByteArray(InputStream in, boolean isClose) {
        byte[] byteArray = null;
        try {
            int total = in.available();
            byteArray = new byte[total];
            in.read(byteArray);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (isClose) {
                try {
                    in.close();
                } catch (Exception e2) {
                }
            }
        }
        return byteArray;
    }


}
