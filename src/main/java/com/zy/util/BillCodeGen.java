package com.zy.util;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;

public class BillCodeGen {
	
    private static volatile int seq_suffix = 0;
    private static volatile int seq_suffix_max = 99999;
    
    private static final SimpleDateFormat DATE_TIME_FORMAT = new SimpleDateFormat("yyyyMMddHHmmss");

//  private static Lock lock = new ReentrantLock();

    private static String getSeqSuffix() {
        ++ seq_suffix;
        if (seq_suffix > seq_suffix_max) {
            seq_suffix = 0;
        }
//      return seq_suffix;
        return StringUtils.leftPad("" + seq_suffix, 5, '0');
    }
    
    public static synchronized String getSeqId(Date date){
        return DATE_TIME_FORMAT.format(date) + "_" + getSeqSuffix();
    }
}
