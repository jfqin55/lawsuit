package com.zy.util;

import java.io.ByteArrayOutputStream;
import java.util.Collection;
import java.util.Date;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;

public class Excels {

	public static byte[] exportExcel(String title, Map<String, String> fieldMap, Collection<?> data, String pattem) {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			Workbook wb = new HSSFWorkbook();
			
			//设置日期格式
			CellStyle dateCellStyle = null;
			if(pattem!=null && pattem.length()>0) {
				CreationHelper createHelper = wb.getCreationHelper();
				dateCellStyle = wb.createCellStyle();
				dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat(pattem));
			}
			
		    //设置文档头部信息
		    Sheet sheet = wb.createSheet(title);
		    sheet.setDefaultColumnWidth(21);
		    Row row = sheet.createRow(0);
		    int cellIndex = 0;
		    for(String headName : fieldMap.values()) {
		    	row.createCell(cellIndex++).setCellValue(headName);
		    }
		    
		    //设置文档内容
		    int rowIndex = 1;
		    for(Object obj : data) {
		    	cellIndex = 0;
		    	row = sheet.createRow(rowIndex++);
		    	for(String fieldName : fieldMap.keySet()) {
		    		Cell cell = row.createCell(cellIndex++);
		    		Object fieldValue = Reflections.getFieldValue(obj, fieldName);
		    		if(fieldValue instanceof Date) {
		    			if(dateCellStyle != null) {
		    				cell.setCellStyle(dateCellStyle);
		    			}
		    			cell.setCellValue((Date)fieldValue);
		    		} else {
		    			if(fieldValue != null) {
		    				cell.setCellValue(fieldValue.toString());
		    			}
		    		}
		    	}
		    }
		    wb.write(baos);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return baos.toByteArray();
	}
	
	/** 
	 * 设置合并单元格的值 
	 * @param sheet 
	 * @param row 
	 * @param column 
	 * @return 
	 */  
	public static String setMergedRegionValue(Sheet sheet ,int row , int column, Object value){  
	    int sheetMergeCount = sheet.getNumMergedRegions();  
	      
	    for(int i = 0 ; i < sheetMergeCount ; i++){  
	        CellRangeAddress ca = sheet.getMergedRegion(i);  
	        int firstColumn = ca.getFirstColumn();  
	        int lastColumn = ca.getLastColumn();  
	        int firstRow = ca.getFirstRow();  
	        int lastRow = ca.getLastRow();  
	          
	        if(row >= firstRow && row <= lastRow){  
	              
	            if(column >= firstColumn && column <= lastColumn){  
	                Row fRow = sheet.getRow(firstRow);  
	                Cell fCell = fRow.getCell(firstColumn);  
	                  
	                setCellValue(fCell, value) ;  
	            }  
	        }  
	    }  
	      
	    return null ;  
	} 
	
	/** 
	 * 设置单元格的值 
	 * @param cell 
	 * @return 
	 */  
	public static void setCellValue(Cell cell, Object value){  
	      
	    if(cell == null) return;  
	      
	    if(cell.getCellType() == Cell.CELL_TYPE_STRING){  
	          
	        cell.setCellValue((String)value); 
	          
	    }else if(cell.getCellType() == Cell.CELL_TYPE_BOOLEAN){  
	    	cell.setCellValue((Boolean)value); 
	          
	    }else if(cell.getCellType() == Cell.CELL_TYPE_FORMULA){  
	    	cell.setCellFormula((String)value); 
	          
	    }else if(cell.getCellType() == Cell.CELL_TYPE_NUMERIC){  
	    	cell.setCellValue((Double)value); 
	          
	    }  
	}
	
	/** 
	 * 获取合并单元格的值 
	 * @param sheet 
	 * @param row 
	 * @param column 
	 * @return 
	 */  
	public static String getMergedRegionValue(Sheet sheet ,int row , int column){  
	    int sheetMergeCount = sheet.getNumMergedRegions();  
	      
	    for(int i = 0 ; i < sheetMergeCount ; i++){  
	        CellRangeAddress ca = sheet.getMergedRegion(i);  
	        int firstColumn = ca.getFirstColumn();  
	        int lastColumn = ca.getLastColumn();  
	        int firstRow = ca.getFirstRow();  
	        int lastRow = ca.getLastRow();  
	          
	        if(row >= firstRow && row <= lastRow){  
	              
	            if(column >= firstColumn && column <= lastColumn){  
	                Row fRow = sheet.getRow(firstRow);  
	                Cell fCell = fRow.getCell(firstColumn);  
	                  
	                return getCellValue(fCell) ;  
	            }  
	        }  
	    }  
	      
	    return null ;  
	} 
	
	/** 
	 * 获取单元格的值 
	 * @param cell 
	 * @return 
	 */  
	public static String getCellValue(Cell cell){  
	      
	    if(cell == null) return "";  
	      
	    if(cell.getCellType() == Cell.CELL_TYPE_STRING){  
	          
	        return cell.getStringCellValue();  
	          
	    }else if(cell.getCellType() == Cell.CELL_TYPE_BOOLEAN){  
	          
	        return String.valueOf(cell.getBooleanCellValue());  
	          
	    }else if(cell.getCellType() == Cell.CELL_TYPE_FORMULA){  
	          
	        return cell.getCellFormula() ;  
	          
	    }else if(cell.getCellType() == Cell.CELL_TYPE_NUMERIC){  
	          
	        return String.valueOf(cell.getNumericCellValue());  
	          
	    }  
	      
	    return "";  
	}  
	
	/** 
	 * 判断指定的单元格是否是合并单元格 
	 * @param sheet 
	 * @param row 
	 * @param column 
	 * @return 
	 */  
	public static boolean isMergedRegion(Sheet sheet , int row , int column){  
	    int sheetMergeCount = sheet.getNumMergedRegions();  
	      
	    for(int i = 0 ; i < sheetMergeCount ; i++ ){  
	        CellRangeAddress ca = sheet.getMergedRegion(i);  
	        int firstColumn = ca.getFirstColumn();  
	        int lastColumn = ca.getLastColumn();  
	        int firstRow = ca.getFirstRow();  
	        int lastRow = ca.getLastRow();  
	          
	        if(row >= firstRow && row <= lastRow){  
	            if(column >= firstColumn && column <= lastColumn){  
	                  
	                return true ;  
	            }  
	        }  
	    }  
	      
	    return false ;  
	}  
	
//	Workbook workbook = new HSSFWorkbook();
//	// 设置字体
//	Font songTi_14_bold = workbook.createFont();
//	songTi_14_bold.setFontName("宋体");
//	songTi_14_bold.setBoldweight(Font.BOLDWEIGHT_BOLD);
//	songTi_14_bold.setFontHeightInPoints((short)14);
//	
//	Font songTi_11_bold = workbook.createFont();
//	songTi_11_bold.setFontName("宋体");
//	songTi_11_bold.setBoldweight(Font.BOLDWEIGHT_BOLD);
//	songTi_11_bold.setFontHeightInPoints((short)11);
//	
//	Font songTi_11 = workbook.createFont();
//	songTi_11.setFontName("宋体");
//	songTi_11.setFontHeightInPoints((short)11);
//	
//	Font songTi_11_red = workbook.createFont();
//	songTi_11_red.setFontName("宋体");
//	songTi_11_red.setFontHeightInPoints((short)11);
//	songTi_11_red.setColor(Font.COLOR_RED);
//	
//	// 设置样式
//	CellStyle cellStyle_songTi_14_bold = workbook.createCellStyle();
//	cellStyle_songTi_14_bold.setFont(songTi_14_bold);
//	cellStyle_songTi_14_bold.setAlignment(HSSFCellStyle.ALIGN_CENTER);
//	
//	CellStyle cellStyle_songTi_11_bold = workbook.createCellStyle();
//	cellStyle_songTi_11_bold.setFont(songTi_14_bold);
//	cellStyle_songTi_11_bold.setAlignment(HSSFCellStyle.ALIGN_CENTER);
//	
//	CellStyle cellStyle_songTi_11 = workbook.createCellStyle();
//	cellStyle_songTi_11.setFont(songTi_14_bold);
//	cellStyle_songTi_11.setAlignment(HSSFCellStyle.ALIGN_CENTER);
//	
//	CellStyle cellStyle_songTi_11_red = workbook.createCellStyle();
//	cellStyle_songTi_11_red.setFont(songTi_14_bold);
//	cellStyle_songTi_11_red.setAlignment(HSSFCellStyle.ALIGN_CENTER);
//    //设置文档头部信息
//	String fileName = year_month + "汇总报表";
//    Sheet sheet = workbook.createSheet(fileName);
//    sheet.setDefaultColumnWidth(16);
//    
//    CellRangeAddress cellRangeAddress = new CellRangeAddress(0, 1, 0, 5);
//    sheet.addMergedRegion(cellRangeAddress);
//    Row row = sheet.createRow(0);
//    Cell cell = row.createCell(0);
//    cell.setCellStyle(cellStyle_songTi_14_bold);
//    cell.setCellType(Cell.CELL_TYPE_STRING);
//    cell.setCellValue("2015年6月汇总汇报表");
//    
//    cellRangeAddress = new CellRangeAddress(2, 3, 0, 1);
//    sheet.addMergedRegion(cellRangeAddress);
//    row = sheet.createRow(1);
//    cell = row.createCell(0);
//    cell.setCellStyle(cellStyle_songTi_11_bold);
//    cell.setCellType(Cell.CELL_TYPE_STRING);
//    cell.setCellValue("商户名称");
//    
//    cellRangeAddress = new CellRangeAddress(2, 3, 1, 3);
//    sheet.addMergedRegion(cellRangeAddress);
//    row = sheet.createRow(1);
//    cell = row.createCell(0);
//    cell.setCellStyle(cellStyle_songTi_11_bold);
//    cell.setCellType(Cell.CELL_TYPE_STRING);
//    cell.setCellValue("类型");

}
