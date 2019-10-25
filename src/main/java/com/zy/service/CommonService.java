package com.zy.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.rps.util.D;
import com.zy.bean.bus.TBBill;
import com.zy.bean.bus.TBContract;
import com.zy.bean.bus.TBSupplier;
import com.zy.bean.bus.TBUser;
import com.zy.bean.bus.TBUserAccount;
import com.zy.util.Constant;
import com.zy.util.RequestUtil;

public class CommonService {
    
    public static List<Map> getOrgTree() {
        try {
            List<Map> orgList = D.sql("select org_id as id, parent_org_id as pid, org_name as text from t_b_org where org_status = ? order by code,sort_id")
                    .list(Map.class, Constant.YES);
            return orgList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static List<Map> getOrgTreeByUserCorp(HttpServletRequest request) {
        try {
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            List<Map> orgList = D.sql("select org_id as id, parent_org_id as pid, org_name as text, corp_id from t_b_org where corp_id = ? and org_status = ? order by code,sort_id")
                    .list(Map.class, sessionUser.getOrg_id(), Constant.YES);
            return orgList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static List<Map> getUserTree() {
        try {
            List<Map> userList = D.sql("select user_id as id, department_id as pid, concat(user_name, ' (' , post_name, ')') as text from t_b_user where user_status = ?")
                    .list(Map.class, Constant.YES);
            List<Map> orgTree = getOrgTree();
            orgTree.addAll(userList);
            return orgTree;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static List<Map> getUserTreeByUserCorp(HttpServletRequest request) {
        try {
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            List<Map> userList = D.sql("select user_id as id, department_id as pid, concat(user_name, ' (' , post_name, ')') as text from t_b_user where org_id = ? and user_status = ?")
                    .list(Map.class, sessionUser.getOrg_id(), Constant.YES);
            List<Map> orgTree = getOrgTreeByUserCorp(request);
            orgTree.addAll(userList);
            return orgTree;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static List<TBBill> getBorrowIdList() {
        try {
            List<TBBill> borrowIdList = D.sql("select bill_id, (bill_amount-return_amount) as bill_amount from t_b_bill where bill_type = ? and bill_status = ? order by create_time desc")
                    .list(TBBill.class, Constant.BillType.BORROW, Constant.BillStatus.AGREE);
            return borrowIdList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static List<TBBill> getBorrowIdList(HttpServletRequest request) {
        try {
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            List<TBBill> borrowIdList = D.sql("select bill_id, (bill_amount-return_amount) as bill_amount from t_b_bill where department_id = ? and bill_type = ? and bill_status = ? and bill_amount > return_amount order by create_time desc")
                    .list(TBBill.class, sessionUser.getDepartment_id(), Constant.BillType.BORROW, Constant.BillStatus.AGREE);
            return borrowIdList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static List<TBContract> getContractList(HttpServletRequest request) {
        try {
            List<TBContract> contractList = D.sql("select * from t_b_contract order by contract_code")
                    .list(TBContract.class);
            return contractList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static List<TBContract> getContractListByDept(HttpServletRequest request) {
        try {
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            List<TBContract> contractList = D.sql("select * from t_b_contract where department_list like ? order by contract_code")
                    .list(TBContract.class, "%" + sessionUser.getDepartment_id() + "%");
            return contractList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static List<TBSupplier> getSupplierList(HttpServletRequest request) {
        try {
            List<TBSupplier> supplierList = D.sql("select * from t_b_supplier order by supplier_name").list(TBSupplier.class);
            return supplierList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static List<TBUserAccount> getUserAccountList(HttpServletRequest request, String user_id) {
        try {
            List<TBUserAccount> userAccountList = D.sql("select * from t_b_user_account where user_id = ?").list(TBUserAccount.class, user_id);
            return userAccountList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
}
