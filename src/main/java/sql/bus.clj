(ns sql.bus
  (:use [com.rps.util.dao.cljutil.daoutil2] )
  (:import [javax.servlet.http HttpServletRequest]
           [com.rps.util.dao SqlAndParams]
           [java.util ArrayList]))

(defsql pageScoreRange {
    :sql "select * from t_w_score_range "
    :where (AND 
         ("quota_name"  "quota_name like ?" "%" "%")
     )
    :page true
    :orderby true
    :orderby-default " order by quota_name asc"
})


(defsql pageOrderDetail {
    :sql "select * from t_i_order_detail "
    :where (AND 
			   ("order_id"  "order_id = ?")
         ("phone"  "phone = ?")
         ("recharge_status"  "recharge_status = ?")
         {"mht_id"  "mht_id = ?"}
         ("mht_id"  "mht_id = ?")
         ("start_time"  "mht_recharge_time >= str_to_date(?,'%Y-%m-%d %H:%i:%s') ")
			   ("end_time"  "mht_recharge_time <= str_to_date(?,'%Y-%m-%d %H:%i:%s')")
;         {"pointIdList"  "a.point_id in @pointIdList"}
     )
    :page true
    :orderby true
    :orderby-default " order by order_detail_id asc"
})

(defsql getOrderDetails {
    :sql "select * from t_i_order_detail "
    :where (AND 
			   ("order_id"  "order_id = ?")
         ("phone"  "phone = ?")
         ("recharge_status"  "recharge_status = ?")
         {"mht_id"  "mht_id = ?"}
         ("mht_id"  "mht_id = ?")
         ("start_time"  "mht_recharge_time >= str_to_date(?,'%Y-%m-%d %H:%i:%s') ")
			   ("end_time"  "mht_recharge_time <= str_to_date(?,'%Y-%m-%d %H:%i:%s')")
     )
    :page false
    :orderby true
    :orderby-default " order by order_detail_id asc"
})


(defsql pageMhtTrade {
    :sql "select a.*,b.mht_name from t_b_mht_trade a left join t_i_mht b on a.mht_id = b.mht_id"
    :where (AND 
         ("mht_id"  "a.mht_id = ?")
         ("start_time"  "a.trade_time >= str_to_date(?,'%Y-%m-%d %H:%i:%s') ")
			   ("end_time"  "a.trade_time <= str_to_date(?,'%Y-%m-%d %H:%i:%s')")
     )
    :page true
    :orderby true
    :orderby-default " order by a.trade_id desc"
})

(defsql pageMsgSend
  {
    :sql "select * from ( select * from all_sndmsg "
    :where (AND
               "fs_send='2'" ; 3 表示营销，2表示96568省外，1表示96568省内
;               {"fs_send"  "fs_send = ?"}
	             {"point_code"  "fs_regorg = ?"}
			         ("start_time"  "fs_waitdate >= ? ")
						   ("end_time"  "fs_waitdate <= ?")
			         ("phone"  "fs_phone = ?")
			         ("fs_stat"  "fs_stat = ?")
     )

    :sql2 " union all select * from all_sndmsglsb "
    :where2 (AND
              "fs_send='2'"  ; 3 表示营销，2表示96568省外，1表示96568省内
;               {"fs_send"  "fs_send = ?"}
               {"point_code"  "fs_regorg = ?"}
			         ("start_time"  "fs_waitdate >= ? ")
						   ("end_time"  "fs_waitdate <= ?")
			         ("phone"  "fs_phone = ?")
               ("fs_stat"  "fs_stat = ?")
     )
    :page true          
    :orderby true
    :orderby-default " ) A order by A.fs_msg_id desc "
})
