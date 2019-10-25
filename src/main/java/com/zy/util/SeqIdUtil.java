package com.zy.util;

public class SeqIdUtil {
	
	private static volatile int seq_suffix = 0;
	private static volatile int seq_suffix_max = 999999;
	
//	private static final SimpleDateFormat DATE_TIME_FORMAT = new SimpleDateFormat("yyyyMMddHHmmss");

//	private static Lock lock = new ReentrantLock();

	private static int getSeqSuffix() {
		++ seq_suffix;
		if (seq_suffix > seq_suffix_max) {
			seq_suffix = 0;
		}
		return seq_suffix;
//		return StringUtils.leftPad("" + seq_suffix, 12, '0');
	}
	
//	public static synchronized String getSeqId(Date date){
//		return DATE_TIME_FORMAT.format(date) + "_" + getSeqSuffix();
//	}
	
	public static synchronized int getSeqId(){
		return getSeqSuffix();
	}
}
