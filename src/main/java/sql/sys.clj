(ns sql.sys
  (:use [com.rps.util.dao.cljutil.daoutil2] )
  (:import [javax.servlet.http HttpServletRequest]
           [com.rps.util.dao SqlAndParams]
           [java.util ArrayList]))

(defsql pageUser {
    :sql "select a.*,b.org_name from t_s_user a left join t_w_org b on a.org_id = b.org_id "
    :where (AND 
         ("org_id"  "a.org_id = ?")
         ("user_status"  "a.user_status = ?")
         {"user_role_not_equal"  "a.user_role != ?"}
     )
    :page true
    :orderby true
    :orderby-default " order by a.org_id asc"
})