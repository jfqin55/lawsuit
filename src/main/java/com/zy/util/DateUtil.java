package com.zy.util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DateUtil {
	
	private static final SimpleDateFormat MONTH_FORMAT = new SimpleDateFormat("yyyy-MM");

	public static List<Map<String, String>> getMonthList(){
		Calendar now = Calendar.getInstance();
		List<Map<String, String>> monthList = new ArrayList<Map<String, String>>();
		for (int i = 0; i < 12; i++) {
			Map<String, String> map = new HashMap<String, String>();
			String yearMonth = MONTH_FORMAT.format(now.getTime());
			map.put("id", yearMonth);
			map.put("text", yearMonth.replace("-", "年") + "月");
			monthList.add(map);
			now.add(Calendar.MONTH,-1);
		}
		return monthList;
	}
	
	private static final SimpleDateFormat YEAR_FORMAT = new SimpleDateFormat("yyyy");

    public static List<Map<String, String>> getYearList(){
        Calendar now = Calendar.getInstance();
        List<Map<String, String>> yearList = new ArrayList<Map<String, String>>();
        for (int i = 0; i < 5; i++) {
            Map<String, String> map = new HashMap<String, String>();
            String year = YEAR_FORMAT.format(now.getTime());
            map.put("id", year);
            map.put("text", year + "年");
            yearList.add(map);
            now.add(Calendar.YEAR,-1);
        }
        return yearList;
    }
	
}
