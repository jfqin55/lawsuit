package com.zy.web.sys;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.zy.bean.bus.TBUser;
import com.zy.bean.sys.ResponseBean;
import com.zy.util.ConfigUtil;
import com.zy.util.DateFormatUtil;
import com.zy.util.E;
import com.zy.util.RequestUtil;
import com.zy.util.SeqIdUtil;

import net.coobird.thumbnailator.Thumbnails;


@Controller
@RequestMapping("/fileUpload")
public class FileController {
    
    private static final Logger logger = LoggerFactory.getLogger(FileController.class);
    
    @ResponseBody
    @RequestMapping(value = "/uploadImg")
    public ResponseBean uploadChatPic(HttpServletRequest request){
        ResponseBean response = new ResponseBean();
        try {
            String now = DateFormatUtil.getDateFormat_file().format(new Date());
            String[] nowArr = now.split("-", -1);
            String year = nowArr[0];
            String month = nowArr[1];
            String day = nowArr[2];
            int seqId = SeqIdUtil.getSeqId();
            String time = nowArr[3] + seqId;
            
            StringBuilder linuxPath = new StringBuilder(ConfigUtil.getString("img.linuxPath")).append(year).append(File.separator).append(month).append(File.separator).append(day).append(File.separator);
            StringBuilder httpPath = new StringBuilder(ConfigUtil.getString("img.httpPath")).append(year).append("/").append(month).append("/").append(day).append("/"); 
            File linuxFolder = new File(linuxPath.toString());
            if (!linuxFolder.exists()) linuxFolder.mkdirs();
            
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            String userId = sessionUser.getUser_id();
            MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
            Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
            for (Map.Entry<String, MultipartFile> entity : fileMap.entrySet()) {
                MultipartFile uploadFile = entity.getValue();
                if(uploadFile.getSize() > ConfigUtil.getInt("compress.switch")) {
                    Thumbnails.of(uploadFile.getInputStream()).size(1024, 768).outputFormat("jpg").toFile(linuxPath.append(time).append(userId).toString());
                    httpPath.append(time).append(userId).append(".jpg");
                }else {
                    String uploadFileName = uploadFile.getOriginalFilename();
                    String uploadFileType = uploadFileName.substring(uploadFileName.lastIndexOf("."));
                    FileCopyUtils.copy(uploadFile.getBytes(), new File(linuxPath.append(time).append(userId).append(uploadFileType).toString()));
                    httpPath.append(time).append(userId).append(uploadFileType);
                }
            }
            
            response.setCode(E.SUCCESS.code);
            response.setMsg(httpPath.toString());
            return response;
        } catch (Exception e) {
            logger.error("uploadChatPic fail", e);
            response.setError(E.UPLOAD_FAIL);
            return response;
        }
    }
    
	@RequestMapping("downloadTemplate.json")
	public void downloadTemplate(HttpServletRequest request, HttpServletResponse response){
		try {
			String fileName = "签约名单模板";
			Workbook workbook = WorkbookFactory.create(FileController.class.getClassLoader().getResourceAsStream("签约名单模板.xls"));
		    ByteArrayOutputStream baos = new ByteArrayOutputStream();
		    workbook.write(baos);
			byte[] excelContent = baos.toByteArray();
			//设置文档编码、类型和格式，然后从网络中导出
			if (request.getHeader("User-Agent").toUpperCase().contains("MSIE")) {
				fileName = URLEncoder.encode(fileName, "UTF-8");
			} else {
				fileName = new String(fileName.getBytes("UTF-8"), "ISO8859-1");
			}
			response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ".xls");
			response.setContentType("application/vnd.ms-excel");
			response.getOutputStream().write(excelContent);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
    @ResponseBody
    @RequestMapping(value = "/uploadExcel")
    public Map<String, Object> uploadMsgTxt(HttpServletRequest request) {
    	Map<String, Object> reponseMap = new HashMap<String, Object>();
        try {
        	int lineNum = 0;
        	int succeeNum = 0;//成功行数
			int errNum = 0;//失败行数
			int blankNum = 0;//空行数
			List<Map<String, Object>> errList = new ArrayList<Map<String, Object>>();
        	
        	MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
        	Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
        	
        	
        	for (Map.Entry<String, MultipartFile> entity : fileMap.entrySet()) {
        		
				MultipartFile mf = entity.getValue();
				Workbook workbook = WorkbookFactory.create(mf.getInputStream());
				
//				StringBuilder fileBasePath = new StringBuilder("");
//		        fileBasePath.append(DIRECTORY_FORMAT.format(now)).append(File.separator);
//		        File file = new File(fileBasePath.toString());
//		        if (!file.exists()) file.mkdirs();
//		        
//		        String fileName = originalFilename.substring(0, originalFilename.length()-4);
//		        String filePath = fileBasePath.append(fileName).append(FILE_FORMAT.format(now)).append(".txt").toString();
//		        
//		        workbook.write(new FileOutputStream(filePath));
		        Date now = new Date();
		        Sheet sheet = workbook.getSheetAt(0);
		        for(int i = 1; i < sheet.getPhysicalNumberOfRows(); i++){
		        	++lineNum;
		        	try {
		        		Row row = sheet.getRow(i);
						buildFlow(row, now);
						succeeNum ++;
					} catch (Exception e) {
						e.printStackTrace();
						errNum ++;
						putErrIntoErrList("", lineNum, "该行格式有误", errList);
					}
				}
				
        	}
        	
        	reponseMap.put("succeeNum", succeeNum);
        	reponseMap.put("errNum", errNum);
        	reponseMap.put("blankNum", blankNum);
        	reponseMap.put("errList", errList);
        	reponseMap.put("errCode", "0");
			return reponseMap;
		}catch(Exception e) {
			e.printStackTrace();
			reponseMap.put("errCode", "1");
			return reponseMap;
		}
    }

    private void putErrIntoErrList(String lineStr, int lineNum, String info, List<Map<String, Object>> errList){
    	Map<String, Object> map = new HashMap<String, Object>();
		map.put("content", lineStr);
		map.put("lineNum", lineNum);
		map.put("info", info);
		errList.add(map);
    }
    
    private static final SimpleDateFormat MONTH_FORMAT = new SimpleDateFormat("yyyy-MM");
    
    private void buildFlow(Row row, Date now){
		
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		calendar.add(Calendar.MONTH, -2);//月份加减
		int month = calendar.get(Calendar.MONTH);
		
//		int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH)-1;
//		calendar.add(Calendar.YEAR,-1);//年份加减
//		calendar.add(Calendar.MONTH,-month);//月份加减
//		calendar.add(Calendar.DAY_OF_MONTH,-dayOfMonth);//天数加减

//		flow.setQuarter_num(month/3 + 1);
		
		
    }
    
    private Integer str2Int(Row row, int i){
    	try {
    		return Integer.parseInt(row.getCell(i).getStringCellValue().trim());
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
    }
    
    
//    @RequestMapping("exportExcel.do")
//	public void exportExcel(HttpServletRequest request, HttpServletResponse response){
//		try {
//			List<TWCheckFlow> flowList = D.defSql("sql.check/getFlowList", request).list(TWCheckFlow.class);
////			if(msgSendlist != null && 0 <= msgSendlist.size() && msgSendlist.size() <= Integer.parseInt(sysConfigMap.get("max_msg_num"))) {
//			if(true){
//				//将数据传到Excels类中并以ImmutableMap.of()中的格式进行处理
//				Map<String, String> map = new LinkedHashMap<String, String>();
//				map.put("phone","手机号");
//				map.put("send_time","发送时间");
//				map.put("msg_content","短信内容");
//				map.put("sms_msg_id","短消息ID");
//				map.put("resp_msg_id","发送状态");
//				
//				String fileName = "短信查询列表";
//				byte[] excelContent = Excels.exportExcel(fileName, map, flowList, "yyyy/mm/dd hh:mm:ss");
//				
//				//设置文档编码、类型和格式，然后从网络中导出
//				if (request.getHeader("User-Agent").toUpperCase().contains("MSIE")) {
//					fileName = URLEncoder.encode(fileName, "UTF-8");
//				} else {
//					fileName = new String(fileName.getBytes("UTF-8"), "ISO8859-1");
//				}
//				response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ".xls");
//				response.setContentType("application/vnd.ms-excel");
//				response.getOutputStream().write(excelContent);
//			}else{
//				response.setContentType("text/html;charset=utf-8");
//				PrintWriter out = response.getWriter();
//				out.println("<html>最多只能导出10000条记录，请重新选择查询条件</html>");
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
    
    public static void main(String[] args) {
    	Calendar calendar = Calendar.getInstance();
		System.out.println(calendar.get(Calendar.YEAR) + "-" + calendar.get(Calendar.MONTH) + "-" + calendar.get(Calendar.DATE) + " " 
		        + calendar.get(Calendar.HOUR_OF_DAY) + ":" + calendar.get(Calendar.MINUTE) + ":" + calendar.get(Calendar.SECOND));
		
		String now = DateFormatUtil.getDateFormat_file().format(new Date());
        String[] nowArr = now.split("-", -1);
        String year = nowArr[0];
        String month = nowArr[1];
        String day = nowArr[2];
        String time = nowArr[3];
        System.out.println(year + "-" + month + "-" + day + " " + time);
        
        System.out.println("4444.1234".substring("4444.1234".lastIndexOf(".")));
	}
}
