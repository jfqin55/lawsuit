package com.zy.web.portal;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.zxing.WriterException;
import com.rps.util.D;
import com.zy.bean.bus.TBBill;
import com.zy.bean.bus.TBBillAnnex;
import com.zy.bean.bus.TBBillCheck;
import com.zy.bean.bus.TBBorrowType;
import com.zy.bean.bus.TBBudget;
import com.zy.bean.bus.TBBudgetSpecial;
import com.zy.bean.bus.TBContract;
import com.zy.bean.bus.TBSubject;
import com.zy.bean.bus.TBSupplier;
import com.zy.bean.bus.TBUser;
import com.zy.bean.bus.TBUserAccount;
import com.zy.bean.sys.ResponseBean;
import com.zy.service.BudgetService;
import com.zy.service.CheckService;
import com.zy.service.CommonService;
import com.zy.util.BillCodeGen;
import com.zy.util.ConfigUtil;
import com.zy.util.Constant;
import com.zy.util.DateFormatUtil;
import com.zy.util.ExportWordUtil;
import com.zy.util.JacksonUtil;
import com.zy.util.PageModel;
import com.zy.util.PageUtil;
import com.zy.util.QRcodeUtil;
import com.zy.util.RequestUtil;
import com.zy.util.Word2Html;

@Controller
@RequestMapping("/portal/bill")
public class BillController {
    
    private static final Logger logger = LoggerFactory.getLogger(BillController.class);
	
	@RequestMapping()
	public String init(HttpServletRequest request) {
	    RequestUtil.setAtrribute(request, "frowWhere", "bill");
	    return "portal/bill";
	}
	
	@RequestMapping("/check")
    public String check(HttpServletRequest request) {
	    RequestUtil.setAtrribute(request, "frowWhere", "check");
        return "portal/bill";
    }
	
	@RequestMapping("/borrow")
    public String borrow(HttpServletRequest request) { 
	    return "portal/billBorrow";
    }
	
	@RequestMapping("/refund")
    public String refund(HttpServletRequest request) { return "portal/billRefund"; }
	
	@RequestMapping("/expense")
    public String expense(HttpServletRequest request) { 
	    List<TBBill> borrowList = CommonService.getBorrowIdList(request);
        setRequestAttr(request, borrowList, "create");
	    return "portal/billExpense"; 
	}

    private void setRequestAttr(HttpServletRequest request, List<TBBill> borrowList, String action) {
        RequestUtil.setAtrribute(request, "action", action);
        RequestUtil.setAtrribute(request, "borrowList", borrowList);
        RequestUtil.setAtrribute(request, "borrowListJson", JacksonUtil.writeValueAsString(borrowList));
    }
	
	@RequestMapping("/showOrgs.json")
    public String showOrgs() {
        return "portal/billOrg";
    }
	
	@RequestMapping("/showPreviewPrint.json")
	public String showPreviewPrint() {
	    return "portal/print";
	}
	
	@RequestMapping("/showBillFromQRcode.json")
    public String showBillFromQRcode(String billType, String bill_id, HttpServletRequest request) {
	    RequestUtil.setAtrribute(request, "qrcodeBillId", bill_id);
        if(Constant.BillType.EXPENSE.equals(billType)) {
            List<TBBill> borrowList = CommonService.getBorrowIdList();
            setRequestAttr(request, borrowList, "detail");
            return "portal/billExpense";
        }
        if(Constant.BillType.BORROW.equals(billType)) return "portal/billBorrow";
        if(Constant.BillType.REFUND.equals(billType)) return "portal/billRefund";
        else return "";
    }
	
	@ResponseBody
    @RequestMapping("getBillById.json")
    public TBBill getBillById(HttpServletRequest request, String bill_id) {
        try {
            if(StringUtils.isBlank(bill_id)) return null;
            return D.selectById(TBBill.class, bill_id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
	
	@RequestMapping("/showDetailWindow.json")
    public String showDetailWindow(String billType, HttpServletRequest request) {
	    if(Constant.BillType.EXPENSE.equals(billType)) {
	        List<TBBill> borrowList = CommonService.getBorrowIdList();
	        setRequestAttr(request, borrowList, "detail");
	        return "portal/billExpense";
	    }
	    if(Constant.BillType.BORROW.equals(billType)) return "portal/billBorrow";
	    if(Constant.BillType.REFUND.equals(billType)) return "portal/billRefund";
	    else return "";
    }
	
	@RequestMapping("/openCheckDetailWindow.json")
    public String openCheckDetailWindow(HttpServletRequest request) {
        return "portal/billCheck";
    }
	
	@RequestMapping("/showUploadWindow.json")
    public String showUploadWindow(String billType) {
	    return "portal/uploadWin";
    }
	
	@RequestMapping("/showPreviewWindow.json")
	public String showPreviewWindow(String billType) {
	    return "portal/previewWin";
	}
	
	@ResponseBody
    @RequestMapping("getRequiredInfoArrBySubject.json")
    public TBSubject getRequiredInfoArrBySubject(HttpServletRequest request, Integer subjectId) {
        return D.sql("select * from t_b_subject where subject_id = ?").one(TBSubject.class, subjectId);
    }
	
	@ResponseBody
    @RequestMapping("getCanUseBudgetBySubject.json")
    public TBBudget getCanUseBudgetBySubject(HttpServletRequest request, Integer subjectId) {
	    TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
        return BudgetService.getCanUseBudgetBySubject(sessionUser.getDepartment_id(), subjectId, BudgetService.getYear());
    }
	
	@ResponseBody
    @RequestMapping("getCanUseBudgetByBudgetSpecial.json")
    public Integer getCanUseBudgetByBudgetSpecial(HttpServletRequest request, Integer budget_special_id) {
        return D.selectById(TBBudgetSpecial.class, budget_special_id).getRemain_amount();
    }
	
	@ResponseBody
    @RequestMapping("getOrgTree.json")
    public List<Map> getOrgTree(HttpServletRequest request) {
        return CommonService.getOrgTreeByUserCorp(request);
    }
	
	@ResponseBody
    @RequestMapping("/getBillAnnexes.json")
    public List<TBBillAnnex> getBillAnnexes(HttpServletRequest request, String bill_id){
        try {
            return D.sql("select * from t_b_bill_annex where bill_id = ? ").list(TBBillAnnex.class, bill_id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
	
	@ResponseBody
	@RequestMapping("/getSubjectList.json")
	public List<TBSubject> getSubjectList(HttpServletRequest request){
	    try {
	        return D.sql("select * from t_b_subject where subject_status = ? order by subject_id").list(TBSubject.class, Constant.YES);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    }
	}
	
	@ResponseBody
    @RequestMapping("/getBudgetSpecialList.json")
    public List<TBBudgetSpecial> getBudgetSpecialList(HttpServletRequest request, String action){
        try {
            String now = DateFormatUtil.standard().format(new Date());
            if("detail".equals(action)) {
                return D.sql("select * from t_b_budget_special where start_time <= str_to_date(?,'%Y-%m-%d %H:%i:%s') and end_time >= str_to_date(?,'%Y-%m-%d %H:%i:%s') order by budget_special_id")
                        .list(TBBudgetSpecial.class, now, now);
            }
            if("create".equals(action)) {
                TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
                return D.sql("select * from t_b_budget_special where start_time <= str_to_date(?,'%Y-%m-%d %H:%i:%s') and end_time >= str_to_date(?,'%Y-%m-%d %H:%i:%s') and budget_special_id in (select budget_special_id from t_b_budget_special_org where org_id like ?) order by budget_special_id")
                        .list(TBBudgetSpecial.class, now, now, "%"+sessionUser.getDepartment_id()+"%");
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
	
	@ResponseBody
    @RequestMapping("getBorrowIdList.json")
    public List<TBBill> getBorrowIdList(HttpServletRequest request) {
        return CommonService.getBorrowIdList(request);
    }
	
	@ResponseBody
	@RequestMapping("getContractListByAction.json")
	public List<TBContract> getContractListByAction(HttpServletRequest request, String action) {
	    if("detail".equals(action)) return CommonService.getContractList(request);
        if("create".equals(action)) return CommonService.getContractListByDept(request);
        return null;
	}
	
	@ResponseBody
	@RequestMapping("getSupplierList.json")
	public List<TBSupplier> getSupplierList(HttpServletRequest request) {
	    return CommonService.getSupplierList(request);
	}
	
	@ResponseBody
    @RequestMapping("getUserAccountList.json")
    public List<TBUserAccount> getUserAccountList(HttpServletRequest request) {
	    TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
        return CommonService.getUserAccountList(request, sessionUser.getUser_id());
    }
	
	@ResponseBody
    @RequestMapping("getUserAccountListByBill.json")
    public List<TBUserAccount> getUserAccountListByBill(HttpServletRequest request, String user_id) {
        return CommonService.getUserAccountList(request, user_id);
    }
	
	@ResponseBody
	@RequestMapping("/selectAll.json")
	public PageModel selectAll(HttpServletRequest request, String frowWhere){
		try {
		    TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
		    Map<String, Object> paramMap = new HashMap<String, Object>();
		    if("bill".equals(frowWhere) && (sessionUser.getDepartment_name().contains("领导班子") || Constant.UserRole.YS.equals(sessionUser.getRole_id()))) {
		        paramMap.put("org_id", sessionUser.getOrg_id());
		    }else {
		        paramMap.put("user_id", sessionUser.getUser_id());
		    }
		    PageModel pageModel = PageUtil.getPageModel(TBBill.class, "sql.bill/pageBill", request, paramMap);
		    List<TBBill> billList = (List<TBBill>)pageModel.getData();
		    RequestUtil.setSessionAtrribute(request, "billList", billList);
		    Long totalAmount = 0L;
		    for (TBBill tbBill : billList) {
		        totalAmount += tbBill.getBill_amount();
            }
		    pageModel.setTotalAmount(totalAmount.toString());
			return pageModel;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
    @RequestMapping("/export.do")
    @ResponseBody
    public void export(HttpServletRequest request, HttpServletResponse response) {
        try {
            String fileName = "费用清单" + DateFormatUtil.getDateFormat_yyyyMMddHHmmss().format(new Date()) + ".csv";
            fileName = new String(fileName.getBytes("GBK"), "ISO-8859-1");
            response.setContentType(request.getServletContext().getMimeType(fileName) + ";charset=gbk");
            String title = "单据编号,申请部门,申请人,单据金额,单据类型,报销科目,审核状态,申请时间,员工收款账号,供应商,收款银行,收款账号,税号";
            StringBuffer sb = new StringBuffer(title).append("\r\n");
            
            List<TBBill> billList = (List<TBBill>)RequestUtil.getSessionAttribute(request, "billList");
            if (billList != null && billList.size() > 0) {
                for (TBBill bill : billList) {
                    String billType = bill.getBill_type();
                    if(Constant.BillType.EXPENSE.equals(billType)) billType = "报销单";
                    else if(Constant.BillType.BORROW.equals(billType)) billType = "借款单";
                    else if(Constant.BillType.REFUND.equals(billType)) billType = "还款单";
                    
                    String bill_status = bill.getBill_status();
                    if(Constant.BillStatus.WAITING.equals(bill_status)) bill_status = "审批中";
                    else if(Constant.BillStatus.RETURN.equals(bill_status)) bill_status = "已退回";
                    else if(Constant.BillStatus.AGREE.equals(bill_status)) bill_status = "已通过";
                    else if(Constant.BillStatus.REFUSE.equals(bill_status)) bill_status = "未通过";
                    
                    String line = String.format("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s", bill.getBill_code(), bill.getDepartment_name(), bill.getUser_name(), bill.getBill_amount()/100.0, 
                            billType, bill.getSubject_name(), bill_status, bill.getCreate_time().substring(0, 10), bill.getUser_account()+"\t", bill.getSupplier_name(), bill.getBank_name(), bill.getAccount()+"\t", bill.getTax_num());
                    sb.append(line).append("\r\n");
                }
            }

            response.setHeader("Content-disposition", "attachment;filename=" + fileName);
            response.getWriter().write(sb.toString().replaceAll("null", ""));
        } catch (Exception e) {
            logger.error("export csv failed", e);
        }
    }
    
    @ResponseBody
    @RequestMapping("/check/selectAll.json")
    public PageModel checkSelectAll(HttpServletRequest request){
        try {
            Map<String, Object> paramMap = new HashMap<String, Object>();
            paramMap.put("sort_id_not_equal", 0);
            return PageUtil.getPageModel(TBBillCheck.class, "sql.bill/pageBillCheck", request, paramMap);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    @ResponseBody
    @RequestMapping("/check/getBillCheckList.json")
    public List<TBBillCheck> getBillCheckList(String bill_id, HttpServletRequest request){
        try {
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            return D.sql("select * from t_b_bill_check where bill_id = ? and sort_id < (select sort_id from t_b_bill_check where bill_id = ? and auditor_id = ? order by sort_id desc limit 1)")
                    .list(TBBillCheck.class, bill_id, bill_id, sessionUser.getUser_id());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
	
	@ResponseBody
    @RequestMapping("agree.do")
	public ResponseBean agree(final String bill_id, HttpServletRequest request){
	    ResponseBean responseBean = new ResponseBean();
        try{
            final TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            Date now = new Date();
            
            if(Constant.UserRole.SH_CWBCNG.equals(sessionUser.getRole_id())) {//全部流程走完，需要计算金额
                
                TBBill bill = D.selectById(TBBill.class, bill_id);
                bill.setBill_status(Constant.BillStatus.AGREE);
                bill.setUpdate_time(now);
                bill.setUpdate_month(DateFormatUtil.getDateFormat_yyyyMM().format(now));
                
                String bill_type = bill.getBill_type();
                Integer bill_amount = bill.getBill_amount();
                
                if(Constant.BillType.EXPENSE.equals(bill_type)) {//报销单
                    if(StringUtils.isNotBlank(bill.getBill_id_borrow())) {
                        //抵扣借款单
                        TBBill borrowBill = D.selectById(TBBill.class, bill.getBill_id_borrow());
                        borrowBill.setReturn_amount(borrowBill.getReturn_amount() + bill_amount - bill.getDiff_amount());
                        borrowBill.setUpdate_time(now);
                        D.update(borrowBill);
                        
                        responseBean = handleBudget(borrowBill, responseBean);
                        if(StringUtils.isNotBlank(responseBean.getMsg())) return responseBean;
                        
                        handleContractExpenseAmount(bill.getContract_code(), bill_amount);
                    }else {
                        //不抵扣借款单
                        if(Constant.YES.equals(bill.getSpecial_switch())) {
                            //报销单关联专项预算
                            TBBudgetSpecial budgetSpecial = D.selectById(TBBudgetSpecial.class, bill.getBudget_special_id());
                            if(now.after(budgetSpecial.getEnd_time())) { responseBean.setMsg("操作失败，专项预算已过期"); return responseBean; }
                            Integer expenseAmount = budgetSpecial.getExpense_amount() + bill_amount;
                            if(expenseAmount > budgetSpecial.getBudget_special_amount()) { responseBean.setMsg("操作失败，已超出专项预算金额"); return responseBean; }
                            budgetSpecial.setExpense_amount(expenseAmount);
                            budgetSpecial.setRemain_amount(budgetSpecial.getRemain_amount() - bill_amount);
                            D.update(budgetSpecial);
                            
                            handleContractExpenseAmount(budgetSpecial.getContract_code(), bill_amount);
                        }else {
                            //报销单关联科目预算
                            responseBean = handleBudget(bill, responseBean);
                            if(StringUtils.isNotBlank(responseBean.getMsg())) return responseBean;
                            
                            handleContractExpenseAmount(bill.getContract_code(), bill_amount);
                        }
                    }
                }else if(Constant.BillType.BORROW.equals(bill_type)) {//借款单
                    //借款单关联科目预算
                    responseBean = handleBudget(bill, responseBean);
                    if(StringUtils.isNotBlank(responseBean.getMsg())) return responseBean;
                    
                }else if(Constant.BillType.REFUND.equals(bill_type)) {//还款单
                    TBBill borrowBill = D.selectById(TBBill.class, bill.getBill_id_borrow());
                    borrowBill.setReturn_amount(borrowBill.getReturn_amount() + bill_amount);
                    borrowBill.setUpdate_time(now);
                    D.update(borrowBill);
                    
                    TBBudget budget = BudgetService.getBudgetBySubject(borrowBill.getDepartment_id(), borrowBill.getSubject_id(), BudgetService.getYear());
                    if(budget != null) {
                        budget.setExpense_amount(budget.getExpense_amount() - bill_amount);
                        budget.setRemain_amount(budget.getRemain_amount() + bill_amount);
                        D.update(budget);
                    }
                }
                
                updateBillCheck(Constant.BillStatus.AGREE, "", bill_id, sessionUser, now);
                D.updateWithoutNull(bill);
                
            }else {
                updateBillCheck(Constant.BillStatus.AGREE, "", bill_id, sessionUser, now);
                handleNext(bill_id);
            }
            responseBean.setMsg("操作成功!"); 
            return responseBean;
        }catch(Exception e){
            e.printStackTrace();
            responseBean.setMsg("操作失败!"); 
            return responseBean;
        }
    }

    private void handleContractExpenseAmount(String contract_code, Integer bill_amount) {
        if(StringUtils.isNotBlank(contract_code)) {
            TBContract contract = D.selectById(TBContract.class, contract_code);
            contract.setExpense_amount(contract.getExpense_amount() + bill_amount);
            D.update(contract);
        }
    }

    private ResponseBean handleBudget(TBBill bill, ResponseBean responseBean) {
        TBBudget budget = BudgetService.getCanUseBudgetBySubject(bill.getDepartment_id(), bill.getSubject_id(), BudgetService.getYear());
        if(!budget.getCanUseAmount().equals(-1)) {
            Integer expenseAmount = budget.getExpense_amount() + bill.getBill_amount();
            if(Constant.YES.equals(budget.getForce_switch())) {
                if(bill.getBill_amount() > budget.getCanUseAmount()) { responseBean.setMsg("操作失败，已超出预算金额"); return responseBean; }
            }
            budget.setExpense_amount(expenseAmount);
            budget.setRemain_amount(budget.getRemain_amount() - bill.getBill_amount());
            D.update(budget);
        }
        return responseBean;
    }

    private void updateBillCheck(String check_status, String remark, String bill_id, TBUser sessionUser, Date now) {
        D.sql("update t_b_bill_check set check_status = ?, remark = ?, update_time = str_to_date(?,'%Y-%m-%d %H:%i:%s') where bill_id = ? and auditor_id = ?")
            .update(check_status, remark, DateFormatUtil.standard().format(now), bill_id, sessionUser.getUser_id());
    }
    

	@ResponseBody
    @RequestMapping("returnBack.do")
    public Boolean returnBack(final String bill_id, final String auditor_id, final String remark, HttpServletRequest request){
        try{
            final TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            D.startTranSaction(new Callable<Boolean>() {
                @Override
                public Boolean call() throws Exception {
                    updateBillCheckAndBill(Constant.BillStatus.RETURN, remark, bill_id, sessionUser, auditor_id, new Date());
                    return true;
                }
            });
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }
	
	private void updateBillCheckAndBill(String check_status, String remark, String bill_id, TBUser sessionUser, String auditor_id, Date now) {
        updateBillCheck(check_status, remark, bill_id, sessionUser, now);
        D.sql("update t_b_bill_check set check_status = ? where bill_id = ? and auditor_id = ?")
            .update(Constant.BillStatus.WAITING, bill_id, auditor_id);//退回到非报销人，必须如此
        D.sql("update t_b_bill set bill_status = ?, auditor_id = ?, remark_check = ?, update_time = str_to_date(?,'%Y-%m-%d %H:%i:%s') where bill_id = ?")
            .update(check_status, auditor_id, remark, DateFormatUtil.standard().format(now), bill_id);
    }
	
    @ResponseBody
    @RequestMapping("reject.do")
    public Boolean reject(final String bill_id, final String remark, HttpServletRequest request){
        try{
            final TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            D.startTranSaction(new Callable<Boolean>() {
                @Override
                public Boolean call() throws Exception {
                    updateBillCheckAndBill(Constant.BillStatus.REFUSE, remark, bill_id, sessionUser, sessionUser.getUser_id(), new Date());
                    return true;
                }
            });
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }
	
	@ResponseBody
    @RequestMapping("/checkBudgetSpecialName.json")
    public Boolean checkBudgetSpecialName(String budget_special_name, HttpServletRequest request){
        try{
            List<String> list = D.sql("select budget_special_name from t_b_budget_special where budget_special_name = ? ")
                    .list(String.class, budget_special_name);
            if(list != null && list.size() > 0) return false;
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }
    
    
    @ResponseBody
	@RequestMapping("createOrUpdate.do")
	public Boolean createOrUpdate(String action, String submitData, String billAnnexesJson, HttpServletRequest request){
		try{
		    TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
		    Date now = new Date();
		    TBBill bill = JacksonUtil.readValue(submitData, TBBill.class);
		    if(StringUtils.equals("create", action)) {
		        String bill_id = BillCodeGen.getSeqId(now);
		        bill.setBill_id(bill_id);
		        bill.setBill_code(bill_id);
		    }
		    bill.setBill_status(Constant.BillStatus.WAITING);
		    bill.setCorp_id(sessionUser.getOrg_id());
		    String department_id = sessionUser.getDepartment_id();
		    bill.setDepartment_id(department_id);
		    bill.setDepartment_name(sessionUser.getDepartment_name());
		    bill.setOrg_name(sessionUser.getOrg_name());
		    bill.setReturn_amount(0);
		    bill.setCreate_time(DateFormatUtil.standard().format(now));
		    bill.setUpdate_time(now);
		    bill.setUser_id(sessionUser.getUser_id());
		    bill.setUser_name(sessionUser.getUser_name());
		    //生成二维码
		    if(StringUtils.equals("create", action)) genQRcode(sessionUser, now, bill);
		    
		    if(Constant.BillType.BORROW.equals(bill.getBill_type())) {
		        TBBorrowType borrowType = D.selectById(TBBorrowType.class, bill.getBorrow_type_id());
		        bill.setSubject_id(borrowType.getSubject_id());
		        bill.setSubject_name(borrowType.getSubject_name());
		    }
		    
		    //根据审批流程规则生成审批链,该步骤会改变bill中auditor_id的值
		    if(StringUtils.equals("update", action)) D.sql("delete from t_b_bill_check where bill_id = ?").update(bill.getBill_id());
            CheckService.genBillCheckList(bill);
		    
		    if(StringUtils.equals("create", action)){
                D.insertWithoutNull(bill);
            }else if(StringUtils.equals("update", action)){
                D.updateWithoutNull(bill);
            }
		    //维护附件信息
		    handleAnnex(action, billAnnexesJson, bill);
		    //维护合同信息
		    handleContract(bill, department_id);
		    //维护供应商信息
		    handleSupplier(bill);
		    //维护用户账户信息
            handleUserAccount(bill);
		    
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}

    

    private void handleAnnex(String action, String billAnnexesJson, TBBill bill) throws Exception {
        String bill_type = bill.getBill_type();
        if(Constant.BillType.EXPENSE.equals(bill_type) || Constant.BillType.BORROW.equals(bill_type)) {
            List<TBBillAnnex> billAnnexList = JacksonUtil.readValueAsList(billAnnexesJson, List.class, TBBillAnnex.class);
            if(StringUtils.equals("update", action)) {
                D.sql("delete from t_b_bill_annex where bill_id = ?").update(bill.getBill_id());
            }
            for (TBBillAnnex tbBillAnnex : billAnnexList) {
                tbBillAnnex.setBill_id(bill.getBill_id());
                D.insertWithoutNull(tbBillAnnex);
            }
        }
    }

    private void genQRcode(TBUser sessionUser, Date now, TBBill bill)
            throws WriterException, IOException {
        String nowString = DateFormatUtil.getDateFormat_file().format(now);
        String[] nowArr = nowString.split("-", -1);
        String year = nowArr[0];
        String month = nowArr[1];
        String day = nowArr[2];
        String time = nowArr[3];
        String userId = sessionUser.getUser_id();
        StringBuilder linuxPath = new StringBuilder(ConfigUtil.getString("img.linuxPath")).append("qrcode").append(File.separator).append(year)
                .append(File.separator).append(month).append(File.separator).append(day).append(File.separator);
        StringBuilder httpPath = new StringBuilder(ConfigUtil.getString("img.httpPath")).append("qrcode").append("/").append(year)
                .append("/").append(month).append("/").append(day).append("/");
        File linuxFolder = new File(linuxPath.toString());
        if (!linuxFolder.exists()) linuxFolder.mkdirs();
        String qrcodeContent = new StringBuilder(ConfigUtil.getString("qrcode.content.prefix")).append(bill.getBill_type()).append("&bill_id=").append(bill.getBill_id()).toString();
        QRcodeUtil.QREncode(qrcodeContent, linuxPath.append(time).append(userId).append(".gif").toString());
        
        bill.setBill_qrcode_url(httpPath.append(time).append(userId).append(".gif").toString());
    }
    
    @ResponseBody
    @RequestMapping("appendBillAnnexes.do")
    public Boolean appendBillAnnexes(String billAnnexesJson, HttpServletRequest request){
        try {
            List<TBBillAnnex> billAnnexList = JacksonUtil.readValueAsList(billAnnexesJson, List.class, TBBillAnnex.class);
            if(billAnnexList == null || billAnnexList.size() < 1) return false;
            for (TBBillAnnex tbBillAnnex : billAnnexList) {
                D.insertWithoutNull(tbBillAnnex);
            }
            TBUser sessionUser = (TBUser)RequestUtil.getSessionAttribute(request, "user");
            updateBillCheck(Constant.BillStatus.AGREE, "", billAnnexList.get(0).getBill_id(), sessionUser, new Date());
            handleNext(billAnnexList.get(0).getBill_id());
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private void handleNext(final String bill_id) {
        TBBillCheck nextBillCheck = D.sql("select * from t_b_bill_check where bill_id = ? and check_status != '2' order by sort_id limit 0,1").one(TBBillCheck.class, bill_id);
        nextBillCheck.setCheck_status(Constant.BillStatus.WAITING);
        D.updateWithoutNull(nextBillCheck);
        
        D.sql("update t_b_bill set bill_status = ?, auditor_id = ?, update_time = str_to_date(?,'%Y-%m-%d %H:%i:%s') where bill_id = ?")
            .update(Constant.BillStatus.WAITING, nextBillCheck.getAuditor_id(), DateFormatUtil.standard().format(new Date()), bill_id);
    }

    private void handleSupplier(TBBill bill) {
        String supplier_name = bill.getSupplier_name();
        if(StringUtils.isNotBlank(supplier_name)) {
            try {
                TBSupplier supplier = D.sql("select * from t_b_supplier where supplier_name = ?").one(TBSupplier.class, supplier_name);
                if(supplier == null) {
                    supplier = new TBSupplier();
                    supplier.setAccount(bill.getAccount());
                    supplier.setBank_name(bill.getBank_name());
                    supplier.setSupplier_name(bill.getSupplier_name());
                    supplier.setTax_num(bill.getTax_num());
                    D.insert(supplier);
                }
            } catch (Exception e) {
                logger.warn("供应商信息维护失败，supplier_name={}", supplier_name);
            }
        }
    }
    
    private void handleUserAccount(TBBill bill) {
        String user_account = bill.getUser_account();
        if(StringUtils.isNotBlank(user_account)) {
            try {
                TBUserAccount userAccount = D.sql("select * from t_b_user_account where user_account = ? and user_id = ?").one(TBUserAccount.class, user_account, bill.getUser_id());
                if(userAccount == null) {
                    userAccount = new TBUserAccount();
                    userAccount.setUser_account(user_account);
                    userAccount.setUser_id(bill.getUser_id());
                    D.insert(userAccount);
                }
            } catch (Exception e) {
                logger.warn("用户账户信息维护失败，user_account={}", user_account);
            }
        }
    }

    private void handleContract(TBBill bill, String department_id) {
        String contract_code = bill.getContract_code();
        if(StringUtils.isNotBlank(contract_code)) {
            try {
                TBContract contract = D.selectById(TBContract.class, contract_code);
                String append = department_id + "|";
                if(contract == null) {
                    contract = new TBContract();
                    contract.setContract_amount(bill.getContract_amount());
                    contract.setContract_code(contract_code);
                    contract.setContract_deposit(bill.getContract_deposit());
                    contract.setContract_url(bill.getContract_url());
                    contract.setDepartment_list(append);
                    contract.setExpense_amount(0);
                    D.insert(contract);
                }else {
                    String department_list = contract.getDepartment_list();
                    if(!department_list.contains(department_id)) contract.setDepartment_list(department_list + append);
                    D.update(contract);
                }
            } catch (Exception e) {
                logger.warn("合同信息维护失败，contract_code={}", contract_code);
            }
        }
    }
    
    @ResponseBody
	@RequestMapping("deleteById.do")
	public Boolean deleteById(Integer budget_special_id, HttpServletRequest request){
		try{
			D.deleteById(TBBudgetSpecial.class, budget_special_id);
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
    
    
    @ResponseBody
    @RequestMapping("printCopy.do")
    public String printWord(HttpServletRequest request){
        try{
            
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("city", "武汉");
            
            String path  = BillController.class.getClassLoader().getResource("copy.docx").getPath(); // "E://single.docx"
            XWPFDocument doc = ExportWordUtil.generateWord(params, path);
            return Word2Html.convertDOCXToHtml(doc);
            
//            String fileName = params.get("city") + "农村商业银行"+split[0]+"年"+split[1]+"季度基因监管情况报告";
//            //设置文档编码、类型和格式，然后从网络中导出
//            if (request.getHeader("User-Agent").toUpperCase().contains("MSIE")) {
//                fileName = URLEncoder.encode(fileName, "UTF-8");
//            } else {
//                fileName = new String(fileName.getBytes("UTF-8"), "ISO8859-1");
//            }
//            response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ".docx");
//            response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
//            doc.write(response.getOutputStream());
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    @ResponseBody
    @RequestMapping("printExpense.do")
    public String printExpense(String bill_id, HttpServletRequest request){
        try{
            TBBill bill = D.selectById(TBBill.class, bill_id);
            if(bill == null) return null;
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("user_name",bill.getUser_name());
            params.put("department_name", bill.getDepartment_name());
            params.put("bill_amount", String.format("%.2f", bill.getBill_amount()/100.0));
            params.put("create_time", bill.getCreate_time().substring(0, 10));
            params.put("subject_name", bill.getSubject_name());
            
            String path  = BillController.class.getClassLoader().getResource("expense.docx").getPath(); // "E://single.docx"
            XWPFDocument doc = ExportWordUtil.generateWord(params, path);
            return Word2Html.convertDOCXToHtml(doc);
            
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    @ResponseBody
    @RequestMapping("printBorrow.do")
    public String printBorrow(String bill_id, HttpServletRequest request){
        try{
            TBBill bill = D.selectById(TBBill.class, bill_id);
            if(bill == null) return null;
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("user_name",bill.getUser_name());
            params.put("department_name", bill.getDepartment_name());
            params.put("bill_amount", String.format("%.2f", bill.getBill_amount()/100.0));
            params.put("create_time", bill.getCreate_time().substring(0, 10));
            params.put("subject_name", bill.getSubject_name());
            
            String path  = BillController.class.getClassLoader().getResource("borrow.docx").getPath(); // "E://single.docx"
            XWPFDocument doc = ExportWordUtil.generateWord(params, path);
            return Word2Html.convertDOCXToHtml(doc);
            
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    @ResponseBody
    @RequestMapping("printRefund.do")
    public String printRefund(String bill_id, HttpServletRequest request){
        try{
            TBBill bill = D.selectById(TBBill.class, bill_id);
            if(bill == null) return null;
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("user_name",bill.getUser_name());
            params.put("department_name", bill.getDepartment_name());
            params.put("bill_amount", String.format("%.2f", bill.getBill_amount()/100.0));
            params.put("create_time", bill.getCreate_time().substring(0, 10));
            params.put("subject_name", bill.getSubject_name());
            
            String path  = BillController.class.getClassLoader().getResource("refund.docx").getPath(); // "E://single.docx"
            XWPFDocument doc = ExportWordUtil.generateWord(params, path);
            return Word2Html.convertDOCXToHtml(doc);
            
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
}
