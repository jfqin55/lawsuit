package com.zy.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.rps.util.D;
import com.zy.bean.bus.TBBill;
import com.zy.bean.bus.TBBillCheck;
import com.zy.bean.bus.TBCheckFlow;
import com.zy.bean.bus.TBOrg;
import com.zy.bean.bus.TBUser;
import com.zy.util.Constant;

public class CheckService {
    
    public static void genBillCheckList(TBBill bill) {
        String bill_department_id = bill.getDepartment_id();
        List<TBCheckFlow> checkFlowList = D.sql("select * from t_b_check_flow where flow_status = ? and org_list like ? order by min_amount desc")
                .list(TBCheckFlow.class, Constant.YES, "%"+bill_department_id+"%");
        TBCheckFlow checkFlow = null;
        for (TBCheckFlow tbCheckFlow : checkFlowList) {
            Integer min_amount = tbCheckFlow.getMin_amount();
            if(bill.getBill_amount() < min_amount) continue;
            checkFlow = tbCheckFlow;
            break;
        }
        if(checkFlow == null) throw new RuntimeException("未找到匹配的审批规则");
        String[] auditors = checkFlow.getFlow_desc().split("\\|", -1);
        List<TBBillCheck> billCheckList = new ArrayList<TBBillCheck>();
        // 自己也算一环
        handleSelf(bill, billCheckList);
        
        for(int i = 0; i<auditors.length; i++){
            TBBillCheck billCheck = new TBBillCheck();
            billCheck.setBill_id(bill.getBill_id());
            billCheck.setCheck_status(Constant.BillStatus.READY);
            
            if("部门负责人".equals(auditors[i])) {
                handleDeptManager(bill_department_id, billCheckList, billCheck);
            }else if("部门分管领导".equals(auditors[i])) {
                handleDeptLeader(bill, bill_department_id, billCheckList);
            }else if("市行财务部审核岗".equals(auditors[i])) {
                handleSHCWBSHG(billCheckList, billCheck);
            }else if("市行财务部负责人".equals(auditors[i])) {
                hendleSHCWBFZR(billCheckList, billCheck);
            }else if("市行财务分管领导".equals(auditors[i])) {
                handleSHCWFGLD(billCheckList, billCheck);
            }else if("一级支行财务审核岗".equals(auditors[i])) {//只有夷陵支行需要设置，其他支行直接取会计主管
                handleYJZHCWSHG(bill_department_id, billCheckList, billCheck);
            }else if("一级支行分管财务行长".equals(auditors[i])) {//夷陵支行查找该角色需要做特殊处理
                handleYJZHFGCWHZ(bill_department_id, billCheckList, billCheck);
            }else if("网点委派会计".equals(auditors[i])) {
                handleWDWPKJ(bill_department_id, billCheckList, billCheck);
            }else if("一级支行行长".equals(auditors[i])) {
                handleYJZHHZ(bill_department_id, billCheckList, billCheck);
            }else if("市行财务部出纳岗".equals(auditors[i])) {
                handleSHCWBCNG(bill, billCheckList);
            }else if("县行财务部负责人".equals(auditors[i])) {
                hendleXHCWBFZR(bill.getCorp_id(), billCheckList, billCheck);
            }else if("县行财务部审核岗".equals(auditors[i])) {
                handleXHCWBSHG(bill.getCorp_id(), billCheckList, billCheck);
            }else if("县行财务部出纳岗".equals(auditors[i])) {
                handleXHCWBCNG(bill.getCorp_id(), billCheckList, billCheck);
            }else if("县行财务分管领导".equals(auditors[i])) {
                handleXHCWFGLD(bill.getCorp_id(), billCheckList, billCheck);
            }else {
                throw new RuntimeException("非法的审批规则");
            }
        }
        
        for(int i = 0; i<billCheckList.size(); i++){
            TBBillCheck tbBillCheck = billCheckList.get(i);
            tbBillCheck.setSort_id(i);
            if(i == 1) {
                tbBillCheck.setCheck_status(Constant.BillStatus.WAITING);  
                bill.setAuditor_id(tbBillCheck.getAuditor_id());
            }
            D.insert(tbBillCheck);
        }
    }

    private static void handleSHCWBCNG(TBBill bill, List<TBBillCheck> billCheckList) {
        String userId = D.sql("select user_id from t_b_user_role where role_id = ?").one(String.class, Constant.UserRole.SH_CWBCNG);
        TBUser user = D.selectById(TBUser.class, userId);        
        TBBillCheck selfBillCheck = new TBBillCheck();
        selfBillCheck.setBill_id(bill.getBill_id());
        selfBillCheck.setCheck_status(Constant.BillStatus.READY);
        selfBillCheck.setAuditor_id(user.getUser_id());
        selfBillCheck.setAuditor_name(user.getUser_name());
        billCheckList.add(selfBillCheck);
    }

    private static void handleSelf(TBBill bill, List<TBBillCheck> billCheckList) {
        TBBillCheck selfBillCheck = new TBBillCheck();
        selfBillCheck.setBill_id(bill.getBill_id());
        selfBillCheck.setCheck_status(Constant.BillStatus.AGREE);
        selfBillCheck.setAuditor_id(bill.getUser_id());
        selfBillCheck.setAuditor_name(bill.getUser_name());
        selfBillCheck.setUpdate_time(bill.getUpdate_time());
        billCheckList.add(selfBillCheck);
    }

    private static void handleWDWPKJ(String department_id, List<TBBillCheck> billCheckList, TBBillCheck billCheck) {
        TBUser user = null;
        if("1277220550212078520".equals(department_id)) {//只有夷陵支行需要设置，其他支行直接取会计主管
            user = D.sql("select * from t_b_user where user_id in (select user_id from t_b_user_role where role_id = ?) limit 0,1").one(TBUser.class, Constant.UserRole.YJZH_CWSHG);
        }else {
            user = D.sql("select * from t_b_user where department_id = ? and post_name like ? limit 0,1").one(TBUser.class, department_id, "%会计%");
        }
        billCheck.setAuditor_id(user.getUser_id());
        billCheck.setAuditor_name(user.getUser_name());
        billCheckList.add(billCheck);
    }

    private static void handleYJZHFGCWHZ(String department_id, List<TBBillCheck> billCheckList, TBBillCheck billCheck) {
        List<String> yjzhList = D.sql("select org_id from t_b_org where parent_org_id = ? and org_name like ?").list(String.class, "670869647114347", "%支行");//所有一级支行
        if(yjzhList.contains(department_id)) {
            TBUser user = D.sql("select * from t_b_user where department_id = ? and user_id in (select user_id from t_b_user_role where role_id = ?) limit 0,1")
                    .one(TBUser.class, department_id, Constant.UserRole.YJZH_FGCWHZ);
            billCheck.setAuditor_id(user.getUser_id());
            billCheck.setAuditor_name(user.getUser_name());
            billCheckList.add(billCheck);
        }else {
            String deptId = department_id;
            while(true) {
                String parent_org_id = D.sql("select parent_org_id from t_b_org where org_id = ?").one(String.class, deptId);
                if(yjzhList.contains(parent_org_id)) {
                    TBUser user = null;
                    if("1277220550212078520".equals(parent_org_id)) {//夷陵支行查找该角色需要做特殊处理
                        user = D.sql("select * from t_b_user where department_name like '%夷陵支行%' and user_id in (select user_id from t_b_user_role where role_id = ?) limit 0,1").one(TBUser.class, Constant.UserRole.YJZH_FGCWHZ);
                    }else {
                        user = D.sql("select * from t_b_user where department_id = ? and user_id in (select user_id from t_b_user_role where role_id = ?) limit 0,1")
                                .one(TBUser.class, parent_org_id, Constant.UserRole.YJZH_FGCWHZ);
                    }
                    billCheck.setAuditor_id(user.getUser_id());
                    billCheck.setAuditor_name(user.getUser_name());
                    billCheckList.add(billCheck);
                    break;
                }else {
                    deptId = parent_org_id;
                }
            }
        }
    }

    private static void handleYJZHCWSHG(String department_id, List<TBBillCheck> billCheckList, TBBillCheck billCheck) {
        List<String> yjzhList = D.sql("select org_id from t_b_org where parent_org_id = ? and org_name like ?").list(String.class, "670869647114347", "%支行");//所有一级支行
        if(yjzhList.contains(department_id)) {
            handleWDWPKJ(department_id, billCheckList, billCheck);
        }else {
            String deptId = department_id;
            while(true) {
                String parent_org_id = D.sql("select parent_org_id from t_b_org where org_id = ?").one(String.class, deptId);
                if(yjzhList.contains(parent_org_id)) {
                    handleWDWPKJ(parent_org_id, billCheckList, billCheck);
                    break;
                }else {
                    deptId = parent_org_id;
                }
            }
        }
    }
    
    private static void handleXHCWBSHG(String bill_corp_id, List<TBBillCheck> billCheckList, TBBillCheck billCheck) {
        String userId = D.sql("select a.user_id from t_b_user_role a left join t_b_user b on a.user_id = b.user_id where a.role_id = ? and b.org_id = ?")
                .one(String.class, Constant.UserRole.XH_CWBSHG, bill_corp_id);
        TBUser user = D.selectById(TBUser.class, userId);
        billCheck.setAuditor_id(user.getUser_id());
        billCheck.setAuditor_name(user.getUser_name());
        billCheckList.add(billCheck);
    }
    
    private static void handleXHCWBCNG(String bill_corp_id, List<TBBillCheck> billCheckList, TBBillCheck billCheck) {
        String userId = D.sql("select a.user_id from t_b_user_role a left join t_b_user b on a.user_id = b.user_id where a.role_id = ? and b.org_id = ?")
                .one(String.class, Constant.UserRole.XH_CWBCNG, bill_corp_id);
        TBUser user = D.selectById(TBUser.class, userId);
        billCheck.setAuditor_id(user.getUser_id());
        billCheck.setAuditor_name(user.getUser_name());
        billCheckList.add(billCheck);
    }

    private static void handleSHCWFGLD(List<TBBillCheck> billCheckList, TBBillCheck billCheck) {
        String userId = D.sql("select leader_id from t_b_org where org_id = ?").one(String.class, "8344454492843625139");
        TBUser user = D.selectById(TBUser.class, userId);
        billCheck.setAuditor_id(user.getUser_id());
        billCheck.setAuditor_name(user.getUser_name());
        billCheckList.add(billCheck);
    }
    
    private static void handleXHCWFGLD(String bill_corp_id, List<TBBillCheck> billCheckList, TBBillCheck billCheck) {
        String userId = D.sql("select leader_id from t_b_org t where corp_id = ? and org_name like '%财务%';").one(String.class, bill_corp_id);
        TBUser user = D.selectById(TBUser.class, userId);
        billCheck.setAuditor_id(user.getUser_id());
        billCheck.setAuditor_name(user.getUser_name());
        billCheckList.add(billCheck);
    }

    private static void hendleSHCWBFZR(List<TBBillCheck> billCheckList, TBBillCheck billCheck) {
        String userId = D.sql("select manager_id from t_b_org where org_id = ?").one(String.class, "8344454492843625139");
        TBUser user = D.selectById(TBUser.class, userId);
        billCheck.setAuditor_id(user.getUser_id());
        billCheck.setAuditor_name(user.getUser_name());
        billCheckList.add(billCheck);
    }
    
    private static void hendleXHCWBFZR(String bill_corp_id, List<TBBillCheck> billCheckList, TBBillCheck billCheck) {
        String userId = D.sql("select manager_id from t_b_org t where corp_id = ? and org_name like '%财务%';").one(String.class, bill_corp_id);
        TBUser user = D.selectById(TBUser.class, userId);
        billCheck.setAuditor_id(user.getUser_id());
        billCheck.setAuditor_name(user.getUser_name());
        billCheckList.add(billCheck);
    }

    private static void handleSHCWBSHG(List<TBBillCheck> billCheckList, TBBillCheck billCheck) {
        String userId = D.sql("select user_id from t_b_user_role where role_id = ?").one(String.class, Constant.UserRole.SH_CWBSHG);
        TBUser user = D.selectById(TBUser.class, userId);
        billCheck.setAuditor_id(user.getUser_id());
        billCheck.setAuditor_name(user.getUser_name());
        billCheckList.add(billCheck);
    }

    private static void handleDeptLeader(TBBill bill, String department_id, List<TBBillCheck> billCheckList) {
        String deptId = department_id;
        while(true) {
            TBOrg org = D.sql("select * from t_b_org where org_id = ?").one(TBOrg.class, deptId);
            String leaderId = org.getLeader_id();
            if(StringUtils.isBlank(leaderId) || org.getOrg_name().contains("领导")) break;
            TBUser user = D.selectById(TBUser.class, leaderId);
            TBBillCheck check = new TBBillCheck();
            check.setBill_id(bill.getBill_id());
            check.setCheck_status(Constant.BillStatus.READY);
            check.setAuditor_id(user.getUser_id());
            check.setAuditor_name(user.getUser_name());
            billCheckList.add(check);
            deptId = user.getDepartment_id();
        }
    }

    private static void handleDeptManager(String department_id, List<TBBillCheck> billCheckList,
            TBBillCheck billCheck) {
        String managerId = D.sql("select manager_id from t_b_org where org_id = ?").one(String.class, department_id);
        while(StringUtils.isBlank(managerId)) {
            String parentOrgId = D.sql("select parent_org_id from t_b_org where org_id = ?").one(String.class, department_id);
            if(StringUtils.isBlank(parentOrgId)) break;
            managerId = D.sql("select manager_id from t_b_org where org_id = ?").one(String.class, parentOrgId);
        }
        if(StringUtils.isBlank(managerId)) return;
        TBUser user = D.selectById(TBUser.class, managerId);
        billCheck.setAuditor_id(user.getUser_id());
        billCheck.setAuditor_name(user.getUser_name());
        billCheckList.add(billCheck);
    }
    
    private static void handleYJZHHZ(String department_id, List<TBBillCheck> billCheckList,
            TBBillCheck billCheck) {
        List<String> yjzhList = D.sql("select org_id from t_b_org where parent_org_id = ? and org_name like ?").list(String.class, "670869647114347", "%支行");//所有一级支行
        if(yjzhList.contains(department_id)) {
            insertYJZHHZ(department_id, billCheckList, billCheck);
        }else {
            String deptId = department_id;
            while(true) {
                String parent_org_id = D.sql("select parent_org_id from t_b_org where org_id = ?").one(String.class, deptId);
                if(yjzhList.contains(parent_org_id)) {
                    insertYJZHHZ(parent_org_id, billCheckList, billCheck);
                    break;
                }else {
                    deptId = parent_org_id;
                }
            }
        }
        
    }

    private static void insertYJZHHZ(String department_id, List<TBBillCheck> billCheckList, TBBillCheck billCheck) {
        String managerId = D.sql("select manager_id from t_b_org where org_id = ?").one(String.class, department_id);
        TBUser user = D.selectById(TBUser.class, managerId);
        billCheck.setAuditor_id(user.getUser_id());
        billCheck.setAuditor_name(user.getUser_name());
        billCheckList.add(billCheck);
    }

}
