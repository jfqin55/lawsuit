<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!--startprint-->
<!doctype html>
<html>
<head>
	<title>三峡农商银行报销单</title>
	<jsp:include page="/easyui.jsp" />
	
	<link  href="${res}/viewer/viewer.css" rel="stylesheet">
    <script src="${res}/viewer/viewer.js"></script>
	
	<script src="${res}/swfupload/swfupload.js" type="text/javascript"></script>
	<style type="text/css">
		html, body{ margin:0;padding:0;border:0;width:100%;height:100%;overflow:auto; }
		@page { size: 14in 7in; }
    </style>
</head>
<body>
	<div class="mini-layout" style="width:99%;height:100%;">
		<%--右侧面板--%>
		<div region="east" title="注意" width="200" height="100" showSplit="true" showCollapseButton="false">
			<div style="margin-left:7px;">
			    1、一次只能报销<span style="color:rgb(197,52,65);">&nbsp;某个科目&nbsp;或&nbsp;某个专项预算&nbsp;</span>的费用。<br/>
		   		2、图片上传支持<span style="color:rgb(197,52,65);">&nbsp;jpg&nbsp;或&nbsp;png&nbsp;</span>格式。<br/>
		   		3、图片大小最多支持<span style="color:rgb(197,52,65);">&nbsp;10M&nbsp;</span>，图片过大会导致上传失败。<br/>
		   		<img src="" id="showImg" width="180" height="180" style="margin-top:50px;"/><br/>
		   		<a class="mini-button" onclick="previewPrint('expense')" style="width:100px;margin-top:5px;">打印报销单</a><br/>
		   		<a class="mini-button" onclick="previewPrint('copy')" style="width:100px;margin-top:5px;">打印粘贴单</a>
	   		</div>
		</div>
		<%--中间页面展示区--%>
		<div showHeader="false" region="center">
            <form id="detailForm" method="post">
		        <div class="form">
		        <input class="mini-hidden" name="bill_id"/>
		        
		        <fieldset style="width:94%;border:solid 1px #aaa;margin-left:1.2%;display:inline;margin-top:1%;">
		            <legend>单据表头</legend>
		            <div style="padding:5px;">
		            <table style="width:100%;">
		                <tr>
		                    <td style="width:100px;" align="right">报销人:</td>
                            <td><input name="user_name" class="mini-textbox" enabled="false" required="true" style="width:150px;" value="${user.user_name}"/></td>
                            <td style="width:100px;" align="right">报销单位:</td>
                            <td><input name="department_name" class="mini-textbox" enabled="false" required="true" style="width:150px;" value="${user.department_name}"/></td>
		                    <td style="width:100px;" align="right">日期:</td>
		                    <td><input id="create_time" name="create_time" class="mini-datepicker" enabled="false" required="true" emptyText='' style="width: 150px;"/></td>
		                </tr>
		                <tr height="7px;"></tr>
		                <tr>
                            <td style="width:100px;" align="right">是否专项预算:</td>
                            <td><input class="mini-combobox" name="special_switch" textField="text" valueField="id" allowInput="false" onvaluechanged="changeSwitch1"
                                data="[{id: '1',text: '是'},{id: '0',text: '否'}]" style="width:150px;" required="true" value="0" />
                            </td>
                            <td style="width:100px;" align="right">是否关联合同:</td>
                            <td><input class="mini-combobox" id="contract_switch" textField="text" valueField="id" allowInput="false" onvaluechanged="changeSwitch2"
                                data="[{id: '1',text: '是'},{id: '0',text: '否'}]" style="width:150px;" required="true" value="0" />
                            </td>
                            <td style="width:100px;" align="right">是否关联供应商:</td>
                            <td><input class="mini-combobox" id="supplier_switch" textField="text" valueField="id" allowInput="false" onvaluechanged="changeSwitch3"
                                data="[{id: '1',text: '是'},{id: '0',text: '否'}]" style="width:150px;" required="true" value="0" />
                            </td>
                        </tr>
                        <tr height="7px;"></tr>
		            </table>
		            </div>
		        </fieldset>
		        
		        <fieldset id="fieldset6" style="width:94%;border:solid 1px #aaa;margin-left:1.2%;display:inline;margin-top:1%;">
                    <legend>费用归属</legend>
                    <div style="padding:5px;">
                    <table style="width:100%;">
                        <tr>
                            <td style="width:100px;" align="right">费用归属:</td>
                            <td><input class="mini-combobox" name="belong" textField="text" valueField="id" allowInput="false"
                                data="[{id: '1',text: '本部门'},{id: '0',text: '法人行机关'}]" style="width:150px;" required="true" value="1" />
                            </td>
                        </tr>
                        <tr height="7px;"></tr>
                    </table>
                    </div>
                </fieldset>
		        
                <fieldset id="fieldset0" style="width:94%;border:solid 1px #aaa;margin-left:1.2%;display:inline;margin-top:1%;">
                    <legend>报销类型</legend>
                    <div style="padding:5px;">
                    <table style="width:100%;">
                        <tr>
                            <td style="width:100px;" align="right">报销科目:</td>
                            <td><input id="subject_id" name="subject_id" class="mini-combobox" textField="subject_name" valueField="subject_id" allowInput="true" style="width:150px;" 
                                    url="${ctx}/portal/bill/getSubjectList.json" showNullItem="false" onvalidation="onComboValidation" onvaluechanged="changeSubject"/>
                                <input class="mini-hidden" id="subject_name" name="subject_name"/>
                            </td>
                        </tr>
                        <tr height="7px;"></tr>
                    </table>
                    </div>
                </fieldset>
                
                <fieldset id="fieldset1" style="width:94%;border:solid 1px #aaa;margin-left:1.2%;display:inline;margin-top:1%;">
                    <legend>报销类型</legend>
                    <div style="padding:5px;">
                    <table style="width:100%;">
                        <tr>
                            <td style="width:100px;" align="right">专项预算名称:</td>
                            <td><input id="budget_special_id" name="budget_special_id" class="mini-combobox" textField="budget_special_name" valueField="budget_special_id" allowInput="true" style="width:150px;" 
                                    url="${ctx}/portal/bill/getBudgetSpecialList.json?action=${action}" showNullItem="false" onvalidation="onComboValidation" onvaluechanged="changeBudgetSpecial"/>
                                <input class="mini-hidden" id="budget_special_name" name="budget_special_name"/>
                            </td>
                        </tr>
                        <tr height="7px;"></tr>
                    </table>
                    </div>
                </fieldset>
                
                <fieldset id="fieldset3" style="width:94%;border:solid 1px #aaa;margin-left:1.2%;display:inline;margin-top:1%;">
                    <legend>合同信息</legend>
                    <div style="padding:5px;">
                    <table style="width:100%;">
                        <tr>
		                    <td style="width:100px;" align="right">合同编号:</td>
		                    <td><input id="contract_code" name="contract_code" class="mini-combobox" textField="contract_code" valueField="contract_code" allowInput="true" style="width:150px;"
		                        url="${ctx}/portal/bill/getContractListByAction.json?action=${action}" showNullItem="false" onvaluechanged="onContractChanged"/></td>
		                    <td style="width:100px;" align="right">押金金额:</td>
		                    <td><input id="contract_deposit" name="contract_deposit" class="mini-textbox" vtype="float" style="width:130px;" required="true"/> 万</td>
		                </tr>
		                <tr height="7px;"></tr>
		                <tr>
		                    <td align="right" width="100px">合同上传:</td>
		                    <td><input class="mini-fileupload" id="fileupload2" name="fileupload2" limitType="*.jpg;*.jpeg;*.png;" style="width: 150px;"
		                        flashUrl="${res}/swfupload/swfupload.swf" buttonText="点击导入" emptyText="" limitSize="10MB"
		                        onuploadsuccess="onUploadSuccess"  onuploaderror="onUploadError" onfileselect="onFileSelect" ononuploadcomplete="onUploadcomplete"/>
		                        <a id="preview_fileupload2" class="mini-button" onclick="previewImg('url_fileupload2')" style="width:44px;">预&nbsp;览</a>
		                        <input class="mini-hidden" id="url_fileupload2" name="contract_url"/>
		                    </td>
		                    <td style="width:100px;" align="right">合同金额:</td>
                            <td><input id="contract_amount" name="contract_amount" class="mini-textbox" vtype="float" style="width:130px;" required="true"/> 万</td>
		                </tr>
		                <tr height="7px;"></tr>
                    </table>
                    </div>
                </fieldset>
		        
		        <fieldset style="width:94%;border:solid 1px #aaa;margin-left:1.2%;margin-top:1%;">
                    <legend>费用详情</legend>
                    <div style="padding:5px;">
                    <table style="width:100%;">
                        <tr>
                            <td style="width:100px;color:red;" align="right">可用预算额度:</td>
                            <td><input id="canUseAmount" class="mini-textbox" enabled="false" style="width:150px;"/></td>
                            <td style="width:100px;" align="right">报销金额(小写):</td>
                            <td><input id="bill_amount" name="bill_amount" class="mini-textbox" required="true" vtype="float" onvaluechanged="onBillAmountChanged" style="width:130px;"/> 元</td>
                            <td style="width:100px;" align="right">报销金额(大写):</td>
                            <td><input id='bill_amount_big' name="bill_amount_big" class="mini-textbox" required="true" style="width:150px;" enabled="false"/></td>
                        </tr>
                        <tr height="7px;"></tr>
                        
                        <c:choose>
                            <c:when test="${fn:length(borrowList) > 0}">
                                <tr>
					                <td style="width:100px;" align="right">借款单编号:</td>
		                            <td><div id="bill_id_borrow" name="bill_id_borrow" class="mini-combobox" style="width:150px;"  popupWidth="400" textField="bill_id" valueField="bill_id" 
		                                  allowInput="false" showNullItem="false" ondrawcell="onDrawCell" onvaluechanged="changeBorrow">     
										    <div property="columns">
										        <div header="借款单编号" width="160" field="bill_id"></div>
										        <div header="待还金额" width="80" field="bill_amount"></div>
										    </div>
										</div>
		                            </td>
		                            <td style="width:100px;" align="right">差额:</td>
                                    <td><input id="diff_amount" name="diff_amount" class="mini-textbox" vtype="float" style="width:130px;"/> 元</td>
		                        </tr>
		                        <tr height="7px;"></tr>
				            </c:when>
                        </c:choose>
                    </table>
                    </div>
                </fieldset>
                
                <fieldset id="fieldset2" style="width:94%;border:solid 1px #aaa;margin-left:1.2%;margin-top:1%;">
                    <legend>差旅信息</legend>
                    <div style="padding:5px;">
                    <table style="width:100%;">
                        <tr>
                            <td>
	                            &emsp;&emsp;出发日期：<input id="begin_date_1" name="begin_date_1" class="mini-datepicker" emptyText='' style="width: 120px;"/>
	                            &emsp;&emsp;&emsp;&emsp;起点：<input name="begin_place_1" class="mini-textbox" emptyText='' style="width:120px;" />
	                            &emsp;&emsp;到达日期：<input id="end_date_1" name="end_date_1" class="mini-datepicker" emptyText='' style="width: 120px;"/>
	                            &emsp;&emsp;&emsp;&emsp;终点：<input name="end_place_1" class="mini-textbox" emptyText='' style="width:120px;" />
                            </td>
                        </tr>
                        <tr height="7px;"></tr>
                        <tr>
                            <td>
                                &emsp;&emsp;出发日期：<input id="begin_date_2" name="begin_date_2" class="mini-datepicker" emptyText='' style="width: 120px;"/>
                                &emsp;&emsp;&emsp;&emsp;起点：<input name="begin_place_2" class="mini-textbox" emptyText='' style="width:120px;" />
                                &emsp;&emsp;到达日期：<input id="end_date_2" name="end_date_2" class="mini-datepicker" emptyText='' style="width: 120px;"/>
                                &emsp;&emsp;&emsp;&emsp;终点：<input name="end_place_2" class="mini-textbox" emptyText='' style="width:120px;" />
                            </td>
                        </tr>
                        <tr height="7px;"></tr>
                        <tr>
                            <td>
                                &emsp;火车票张数：<input name="ticket_num_railway" class="mini-textbox" vtype="int" emptyText='' style="width:120px;"/>
                                &emsp;火车票金额：<input name="ticket_amount_railway" class="mini-textbox" vtype="float" emptyText='' style="width:104px;"/> 元
                                &emsp;&emsp;机票张数：<input name="ticket_num_air" class="mini-textbox" vtype="int" emptyText='' style="width:120px;"/>
                                &emsp;&emsp;机票金额：<input name="ticket_amount_air" class="mini-textbox" vtype="float" emptyText='' style="width:104px;"/> 元
                            </td>
                        </tr>
                        <tr height="7px;"></tr>
                        <tr>
                            <td>
                                &emsp;的士票张数：<input name="ticket_num_taxi" class="mini-textbox" vtype="int" emptyText='' style="width:120px;"/>
                                &emsp;的士票金额：<input name="ticket_amount_taxi" class="mini-textbox" vtype="float" emptyText='' style="width:104px;"/> 元
                                &emsp;&emsp;船票张数：<input name="ticket_num_steamer" class="mini-textbox" vtype="int" emptyText='' style="width:120px;"/>
                                &emsp;&emsp;船票金额：<input name="ticket_amount_steamer" class="mini-textbox" vtype="float" emptyText='' style="width:104px;"/> 元
                            </td>
                        </tr>
                        <tr height="7px;"></tr>
                        <tr>
                            <td>
                                &emsp;&emsp;出差人数：<input name="people_num" class="mini-textbox" vtype="int" emptyText='' style="width:120px;"/>
                                &emsp;&emsp;出差天数：<input name="day_num" class="mini-textbox" vtype="int" emptyText='' style="width:120px;"/>
                                &emsp;&emsp;补贴标准：<input name="subsidy_standard" class="mini-textbox" vtype="float" emptyText='' style="width:104px;"/> 元
                                &emsp;&emsp;补贴金额：<input name="subsidy_amount" class="mini-textbox" vtype="float" emptyText='' style="width:104px;"/> 元
                            </td>
                        </tr>
                        <tr height="7px;"></tr>
                        <tr>
                            <td>
                                &emsp;&emsp;&emsp;住宿费：<input name="hotel_amount" class="mini-textbox" vtype="float" emptyText='' style="width:104px;"/> 元
                                &emsp;&emsp;&emsp;餐饮费：<input name="food_amount" class="mini-textbox" vtype="float" emptyText='' style="width:104px;"/> 元
                                &emsp;&emsp;其他费用：<input name="other_amount" class="mini-textbox" vtype="float" emptyText='' style="width:104px;"/> 元
                            </td>
                        </tr>
                        <tr height="7px;"></tr>
                    </table>
                    </div>
                </fieldset>
                
                <fieldset id="fieldset4" style="width:94%;border:solid 1px #aaa;margin-left:1.2%;margin-top:1%;">
		            <legend>供应商信息</legend>
		            <div style="padding:5px;">
		            <table style="width:100%;">
		                <tr>
		                    <td style="width:100px;" align="right">供应商:</td>
		                    <td><input id="supplier_name" name="supplier_name" class="mini-combobox" textField="supplier_name" valueField="supplier_name" allowInput="true" style="width:150px;"
		                        url="${ctx}/portal/bill/getSupplierList.json" showNullItem="false" emptyText='' onvaluechanged="onSupplierChanged"  required="true"/></td>
		                    <td style="width:100px;" align="right">税号:</td>
		                    <td><input id="tax_num" name="tax_num" class="mini-textbox" style="width:150px;" emptyText="非必填"/></td>
		                </tr>
		                <tr height="7px;"></tr>
		                <tr>
		                    <td style="width:100px;" align="right">收款银行:</td>
		                    <td><input id="bank_name" name="bank_name" class="mini-textbox" required="true" style="width:150px;"/></td>
		                    <td style="width:100px;" align="right">收款账号:</td>
		                    <td><input id="account" name="account" class="mini-textbox" required="true" style="width:150px;" /></td>
		                </tr>
		                <tr height="7px;"></tr>
		            </table>
		            </div>
		        </fieldset>
		        
		        <fieldset id="fieldset5" style="width:94%;border:solid 1px #aaa;margin-left:1.2%;margin-top:1%;">
                    <legend>账户信息</legend>
                    <div style="padding:5px;">
                    <table style="width:100%;">
                        <tr>
                            <td style="width:100px;" align="right">收款账号:</td>
                            <td><input id="user_account" name="user_account" class="mini-combobox" textField="user_account" valueField="user_account" allowInput="true" style="width:150px;"
                                url="${ctx}/portal/bill/getUserAccountList.json" showNullItem="false" emptyText='' /></td>
                        </tr>
                        <tr height="7px;"></tr>
                    </table>
                    </div>
                </fieldset>
                
                <fieldset style="width:94%;border:solid 1px #aaa;margin-left:1.2%;margin-top:1%;">
		            <legend>附件信息</legend>
		            <div style="padding:5px;">
		            <table style="width:100%;">
		                <tr>
                            <td style="width:100px;" align="right">备注:</td>
                            <td colspan="3"><input name="remark" class="mini-textbox" style="width:400px;"/></td>
                        </tr>
                        <tr height="7px;"></tr>
                        <tr>
                            <td style="width:100px;" align="right">附件上传:</td>
                            <td colspan="3">
                                <a id="fileupload1" class="mini-button" onclick="openMultiUploadWin" style="width:70px;">点击上传</a>
<!--                                 <a id="preview_fileupload1" class="mini-button" onclick="previewImgs" style="width:44px;">预&nbsp;览</a> -->
                            </td>
                        </tr>
                        <tr id="beforeImg" height="7px;"></tr>
                        <tr id="images">
                        
                        </tr>
		            </table>
		            </div>
		        </fieldset>
		        
		        
		        <table style="width:100%;">
		            <tr>
		                <td style="padding-top: 17px;padding-bottom: 17px;" align="center" id="tableFooter">
		                    <a class="mini-button" onclick="onOk" style="width:60px;margin-right:20px;">确定</a>       
		                    <a class="mini-button" onclick="onCancel" style="width:60px;">取消</a>   
		                </td>
		            </tr>
		        </table>
		        </div>
		        
		    </form>
		</div>
	</div>
	
<script type="text/javascript">
	mini.parse();
	
	var create_time = mini.get('create_time');
	var today = new Date();
// 	today.setHours(0,0,0);
	// var todayTime = today.getTime()-24*3600000;
	create_time.setValue(today);
	
	mini.get('begin_date_1').setValue(today);
	mini.get('end_date_1').setValue(today);
	mini.get('begin_date_2').setValue(today);
	mini.get('end_date_2').setValue(today);
	
	
	var detailForm = new mini.Form("detailForm");
	
	var record = {action: 'create'};
// 	mini.get('preview_fileupload1').hide();
	mini.get('preview_fileupload2').hide();
	
	
	if(${fn:length(borrowList) > 0}){
		mini.get('bill_id_borrow').set({
	        data:${borrowListJson}
	    });
	}
	
	$("#fieldset6").css('display', 'none');
	if(${fn:contains(user.post_name, '会计')}){
        $("#fieldset6").css('display', 'block');
	}
	
	function onOk(e){
        detailForm.validate();
        if(detailForm.isValid() == false) return;
        
        if(billAnnexes.length<1){
            mini.alert("请上传附件！");
            return;
        }
        
        var obj = detailForm.getData(true);
        
        var contract_code = mini.get("contract_code").getValue();
        if(!contract_code){}else{
        	if(contract_remain == -1){
        		if(obj.bill_amount < (obj.expense_amount * 10000).toFixed(0)){
        			obj.deposit_switch = 0;
        		}else if(obj.bill_amount == (obj.expense_amount * 10000).toFixed(0)){
        			obj.deposit_switch = 1;
        		}else{
        			mini.alert("累计报销金额已能超过合同金额！");
                    return;
        		}
            }else{
                if(obj.bill_amount < contract_remain){
                	obj.deposit_switch = 0;
                }else if(obj.bill_amount == contract_remain){
                	obj.deposit_switch = 1;
                }else {
                	mini.alert("累计报销金额已能超过合同金额！");
                    return;
                }
            }
        	obj.contract_deposit = (obj.contract_deposit * 1000000).toFixed(0);
        	obj.contract_amount = (obj.contract_amount * 1000000).toFixed(0);
        	if(!mini.get('url_fileupload2').getValue()){
                mini.alert("请上传合同！");
                return;
            }
        }
        
        if(force_switch==1 && canUseAmount < obj.bill_amount){ mini.alert("金额已超出预算！"); return; }
        if(detailForm.special_switch==1 && !obj.budget_special_name){ mini.alert("请选择专项预算名称！"); return; }
        if(detailForm.special_switch==0 && !obj.subject_name){ mini.alert("请选择报销科目！"); return; }
//         if(travel_switch==1){
        	if(!obj.ticket_amount_railway){}else{obj.ticket_amount_railway = (obj.ticket_amount_railway * 100).toFixed(0);}
        	if(!obj.ticket_amount_air){}else{obj.ticket_amount_air = (obj.ticket_amount_air * 100).toFixed(0);}
        	if(!obj.ticket_amount_taxi){}else{obj.ticket_amount_taxi = (obj.ticket_amount_taxi * 100).toFixed(0);}
        	if(!obj.ticket_amount_steamer){}else{obj.ticket_amount_steamer = (obj.ticket_amount_steamer * 100).toFixed(0);}
        	if(!obj.subsidy_standard){}else{obj.subsidy_standard = (obj.subsidy_standard * 100).toFixed(0);}
        	if(!obj.subsidy_amount){}else{obj.subsidy_amount = (obj.subsidy_amount * 100).toFixed(0);}
        	if(!obj.hotel_amount){}else{obj.hotel_amount = (obj.hotel_amount * 100).toFixed(0);}
        	if(!obj.food_amount){}else{obj.food_amount = (obj.food_amount * 100).toFixed(0);}
        	if(!obj.other_amount){}else{obj.other_amount = (obj.other_amount * 100).toFixed(0);}
//         }
        if(!obj.diff_amount){}else{obj.diff_amount = (obj.diff_amount * 100).toFixed(0);}
        
        mini.confirm("请确认资料上传齐全(" + requiredInfoArr + ")！", "确定?", function(action){
            if (action == "ok") {
                showMask();
                obj.bill_amount = (obj.bill_amount * 100).toFixed(0);
                obj.bill_type = billTypeArr[0].id;
                
                var json = mini.encode(obj);
                var billAnnexesJson = mini.encode(billAnnexes);
                
                $.post("${ctx}/portal/bill/createOrUpdate.do?action=" + record.action, {submitData: json, billAnnexesJson: billAnnexesJson}, function(data){
                    hideMask();
                    if(data == true){
                    	if(record.action == "create"){
                    		mini.confirm("操作成功!", "确定?", function(action){
                                window.location.reload();
                            });
                    	}else{
                    		CloseWindow("ok");
                    	}
                    }else{
                        notifyOnBottomRight("服务器繁忙,请稍后重试");
                    }
                });
            }
        });
    }
	
	var qrcodeBillId = '${qrcodeBillId}';
    if(!qrcodeBillId){}else{
        $.post("${ctx}/portal/bill/getBillById.json", {bill_id: qrcodeBillId}, function(data){
            if(!data) return;
            detailInit(data);
        });
    }
	
	// 该方法为父页面生成子页面时调用
	function SetData(data){
	    //跨页面传递的数据对象，克隆后才可以安全使用
	    record = mini.clone(data);
	    if(record.action == "update"){
	    	record.row.remark = "本次为重新提交，上次申请被拒绝原因：" + record.row.remark_check
            detailInit(record.row);
            detailForm.setEnabled(true);
            document.getElementById("tableFooter").style.display = "block";
            mini.get('fileupload1').show();
//             mini.get('preview_fileupload1').hide();
	    }else if(record.action == "detail"){
	    	$("#fieldset6").css('display', 'block');
	        detailInit(record.row);
	    }
	}
	
	function detailInit(row){
		row.bill_amount = row.bill_amount/100;
        
        if(!row.contract_deposit){}else{row.contract_deposit = row.contract_deposit/1000000;}
        if(!row.contract_amount){}else{row.contract_amount = row.contract_amount/1000000;}
        if(!row.ticket_amount_railway){}else{row.ticket_amount_railway = row.ticket_amount_railway/100;}
        if(!row.ticket_amount_air){}else{row.ticket_amount_air = row.ticket_amount_air/100;}
        if(!row.ticket_amount_taxi){}else{row.ticket_amount_taxi = row.ticket_amount_taxi/100;}
        if(!row.ticket_amount_steamer){}else{row.ticket_amount_steamer = row.ticket_amount_steamer/100;}
        if(!row.subsidy_standard){}else{row.subsidy_standard = row.subsidy_standard/100;}
        if(!row.subsidy_amount){}else{row.subsidy_amount = row.subsidy_amount/100;}
        if(!row.hotel_amount){}else{row.hotel_amount = row.hotel_amount/100;}
        if(!row.food_amount){}else{row.food_amount = row.food_amount/100;}
        if(!row.other_amount){}else{row.other_amount = row.other_amount/100;}
        if(!row.diff_amount){}else{row.diff_amount = row.diff_amount/100;}
        
        detailForm.setData(row);
        detailForm.setEnabled(false);
        
        var userAccountComb = mini.get("user_account");
        if(userAccountComb){
//         	userAccountComb.load("${ctx}/portal/bill/getUserAccountListByBill.json?user_id=" + row.user_id);
        	userAccountComb.set({
                data:[{"user_account": row.user_account}]
            });
        	userAccountComb.setValue(row.user_account);
        }
        
        mini.get('fileupload1').hide();
        $.post("${ctx}/portal/bill/getBillAnnexes.json", {bill_id: row.bill_id}, function(data){
            billAnnexes = data;
//             mini.get('preview_fileupload1').show();
            // 缩略图
//             $.each(billAnnexes, function(i){
//                 var newRow = "<tr>";
//                 newRow += "<td colspan='4'><img src='"+billAnnexes[i].annex_url+"' style='padding-top:9px;width:200px;' onclick=previewImg1('"+billAnnexes[i].annex_url+"') /></a></td>";
//                 newRow += "</tr><tr><td height='7px;'></td></tr>";
                
//                 $("#beforeImg").after(newRow);
//                 mini.parse();
//             });
            
            var imgList = "";
            $.each(billAnnexes, function(i){
                imgList += "<img width='200px' src='"+billAnnexes[i].annex_url+"' alt='"+billAnnexes[i].annex_type+"'>";
            });
            
            $("#images").html(imgList);
            var viewer = new Viewer(document.getElementById('images'),{
            	loop: false
            });
        });
        
        // 科目
        if(row.special_switch == 1){
            $("#fieldset0").css('display', 'none');
            $("#fieldset1").css('display', 'block');
        }else{
            $("#fieldset0").css('display', 'block');
            $("#fieldset1").css('display', 'none');
            // 差旅
            if(row.subject_name.indexOf("差旅") != -1){
                $("#fieldset2").css('display', 'block');
            }else{
                $("#fieldset2").css('display', 'none');
            }
        }
        // 合同
        if(!row.contract_code){
            $("#fieldset3").css('display', 'none');
        }else{
            mini.get('fileupload2').hide();
            var billAnnex = {annex_type: row.contract_code, annex_url: row.contract_url};
            billAnnexes.push(billAnnex);
            mini.get('preview_fileupload2').show();
            $("#fieldset3").css('display', 'block');
        }
        
        // 供应商
        if(!row.supplier_name){
            $("#fieldset4").css('display', 'none');
            $("#fieldset5").css('display', 'block');
        }else{
            $("#fieldset4").css('display', 'block');
            $("#fieldset5").css('display', 'none');
        }
        // 确定和取消按钮
        document.getElementById("tableFooter").style.display = "none";
        // 二维码
        $("#showImg")[0].src = row.bill_qrcode_url;
        
	}
	    
	// 该方法为子页面关闭时，被父页面调用
	function GetData(){
	    return detailForm.getData(true);
	}
	
	function CloseWindow(action){            
	    if(action == "close" && detailForm.isChanged()){
	        if(confirm("数据被修改了，是否先保存？")) return false;
	    }
	    if(window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
	    else window.close(); 
	}
	    
	function onCancel(e){
	    CloseWindow("cancel");
	}
	
	var billAnnexes = [];
	function openMultiUploadWin(e) {
	    mini.open({
	        url: '${ctx}/portal/bill/showUploadWindow.json',
	        title: "文件上传", width: 600, height: 350, allowResize: false,
	        onload: function(){
	            var iframe = this.getIFrameEl();
	            var data = {};
	            iframe.contentWindow.SetData(data);
	        },
	        ondestroy: function(action){
	            if(action != "ok") return;
	            mini.get(e.source.id).hide();
// 	            mini.get('preview_'+e.source.id).show();
	            var data = this.getIFrameEl().contentWindow.GetData();
	            var imgs = mini.clone(data);
	            
	            $.each(imgs, function(i){
                    var billAnnex = {annex_type: e.source.text, annex_url: imgs[i].img_url};
                    billAnnexes.push(billAnnex);
                });
	            
	            // 缩略图
// 	            $.each(billAnnexes, function(i){
// 	                var newRow = "<tr>";
// 	                newRow += "<td colspan='4'><img src='"+billAnnexes[i].annex_url+"' style='padding-top:9px;width:200px;' onclick=previewImg1('"+billAnnexes[i].annex_url+"') /></a></td>";
// 	                newRow += "</tr><tr><td height='7px;'></td></tr>";
	                
// 	                $("#beforeImg").after(newRow);
// 	                mini.parse();
// 	            });
	            
	            var imgList = "";
	            $.each(billAnnexes, function(i){
	                imgList += "<img width='200px' src='"+billAnnexes[i].annex_url+"' alt='"+billAnnexes[i].annex_type+"'>";
	            });
	            
	            $("#images").html(imgList);
	            var viewer = new Viewer(document.getElementById('images'));
	            
	//             var json = mini.encode(data);
	        }
	    });
	}
	
	function onBillAmountChanged(e){
		mini.get('bill_amount_big').setValue(toDX(e.sender.value));
		var billIdBorrow = mini.get("bill_id_borrow");
		if(!billIdBorrow) return;
		var borrowBill = billIdBorrow.getSelected();
		if(!borrowBill) return;
		mini.get('diff_amount').setValue(((mini.get("bill_amount").getValue()*100).toFixed(0) - borrowBill.bill_amount)/100);
        mini.get('diff_amount').disable();
	}
	
	function previewImgs(e){
// 		var imgList = "";
// 		$.each(billAnnexes, function(i){
// 			imgList += "<li><img src='"+billAnnexes[i].annex_url+"' alt='"+billAnnexes[i].annex_type+"'></li>";
//         });
		
//         $("#images").html(imgList);
//         var viewer = new Viewer(document.getElementById('images'));
		
// 		$.each(billAnnexes, function(i){
// 			mini.open({
// 	            url: '${ctx}/portal/bill/showPreviewWindow.json',
// 	            title: billAnnexes[i].annex_type, width: 600, height: 600, showMaxButton: true,
// 	            onload: function(){
// 	                var iframe = this.getIFrameEl();
// 	                iframe.contentWindow.SetData(billAnnexes[i]);
// 	            }
// 	        });
// 		});

	}
	
	function previewImg1(annex_url){
		mini.open({
            url: '${ctx}/portal/bill/showPreviewWindow.json',
            title: "", width: 600, height: 600, showMaxButton: true,
            onload: function(){
                var iframe = this.getIFrameEl();
                var billAnnex = {};
                billAnnex.annex_url = annex_url;
                iframe.contentWindow.SetData(billAnnex);
            }
        });
    }
	
	
    var canUseAmount = -1;
    var force_switch = 0;
    var travel_switch = 0;
    $("#fieldset2").css('display', 'none');
    var requiredInfoArr = "";
	function changeSubject(e){
		if(!e.selected) return;
        mini.get('subject_name').setValue(e.selected.subject_name);
        $.post("${ctx}/portal/bill/getCanUseBudgetBySubject.json?subjectId=" + e.value, {}, function(data){
            canUseAmount = data.canUseAmount/100;
            force_switch = data.force_switch;
            mini.get('canUseAmount').setValue(canUseAmount < 0 && canUseAmount > -1 ? '未限制' : canUseAmount);
        });
        $.post("${ctx}/portal/bill/getRequiredInfoArrBySubject.json", {subjectId: e.value}, function(data){
        	if(!data.requird_info){
        		data.requird_info = "点击上传";
        	}else{
        		requiredInfoArr = data.requird_info;
        	}
        	mini.get('fileupload1').set({
        		text: data.requird_info,
        		width: data.requird_info.length * 12 + 50
        	});
        });
        if(e.selected.subject_name.indexOf("差旅") != -1){
        	travel_switch = 1;
        	$("#fieldset2").css('display', 'block');
        }else{
        	travel_switch = 0;
            $("#fieldset2").css('display', 'none');
        }
    }
	
	function changeBudgetSpecial(e){
		mini.get('budget_special_name').setValue(e.selected.budget_special_name);
		$.post("${ctx}/portal/bill/getCanUseBudgetByBudgetSpecial.json", {budget_special_id: e.value}, function(data){
            force_switch = 1;
            mini.get('canUseAmount').setValue(data/100);
            canUseAmount = data/100;
        });
		
		contract = e.selected;
        if(!contract) return;
        mini.get("contract_code").setValue(contract.contract_code);
        mini.get("contract_amount").setValue(contract.budget_special_amount/1000000);
        mini.get("contract_deposit").setValue(contract.contract_deposit/1000000);
        mini.get("url_fileupload2").setValue(contract.contract_url);
        mini.get("fileupload2").hide();
        mini.get("preview_fileupload2").show();
        contract_remain = (contract.budget_special_amount - contract.expense_amount)/100;
	}
	
	$("#fieldset0").css('display', 'block');
	$("#fieldset1").css('display', 'none');
    function changeSwitch1(e){
        if(e.value == 1){
            $("#fieldset0").css('display', 'none');
            $("#fieldset1").css('display', 'block');
            mini.get("subject_id").setValue('');
        }else{
            $("#fieldset0").css('display', 'block');
            $("#fieldset1").css('display', 'none');
            mini.get("budget_special_id").setValue('');
        }
    }
    
    $("#fieldset3").css('display', 'none');
    function changeSwitch2(e){
        if(e.value == 1){
            $("#fieldset3").css('display', 'block');
        }else{
            $("#fieldset3").css('display', 'none');
            mini.get("contract_code").setValue('');
        }
    }
    
    $("#fieldset4").css('display', 'none');
    $("#fieldset5").css('display', 'block');
    function changeSwitch3(e){
    	if(e.value == 1){
            $("#fieldset4").css('display', 'block');
            $("#fieldset5").css('display', 'none');
        }else{
            $("#fieldset4").css('display', 'none');
            $("#fieldset5").css('display', 'block');
            mini.get("supplier_name").setValue('');
        }
    }
    
    function onDrawCell(e) {
        var item = e.record, field = e.field, value = e.value;
        if(field == "bill_amount")
        //组织HTML设置给cellHtml
        e.cellHtml = '<span style="color:black;font-weight:bold;">' + value/100 +' 元</span>';   
    }
    
    function changeBorrow(e){
    	var billAmount = mini.get("bill_amount").getValue();
    	if(!billAmount){
    		mini.confirm("请先填写报销金额!", "确定?", function(action){
                window.location.reload();
            });
    	} 
    	mini.get('diff_amount').setValue(((mini.get("bill_amount").getValue()*100).toFixed(0) - e.selected.bill_amount)/100);
    	mini.get('diff_amount').disable();
    }
    
    var contract;
    var contract_remain = -1;
    function onContractChanged(e){
        contract = e.selected;
        if(!contract) return;
        mini.get("contract_amount").setValue(contract.contract_amount/1000000);
        mini.get("contract_deposit").setValue(contract.contract_deposit/1000000);
        mini.get("url_fileupload2").setValue(contract.contract_url);
        mini.get("fileupload2").hide();
        mini.get("preview_fileupload2").show();
        contract_remain = (contract.contract_amount - contract.expense_amount)/100;
    }
    
    var supplier;
    function onSupplierChanged(e){
    	supplier = e.selected;
        if(!supplier) return;
        mini.get("bank_name").setValue(supplier.bank_name);
        mini.get("account").setValue(supplier.account);
        mini.get("tax_num").setValue(supplier.tax_num);
    }
    
    function onUploadSuccess(e) {
        hideMask();
        var data = mini.decode(e.serverData);
        if(data.code == '0000'){
            mini.get('url_'+e.source.id).setValue(data.msg);
            mini.get('preview_'+e.source.id).show();
            mini.get(e.source.id).hide();
        }else{
            mini.alert("文件上传失败,请联系技术人员解决!");
        }
    }
    
    function onUploadError(e) {
        hideMask();
        notifyOnBottomRight('操作失败,请确认文件是否符合要求!');
    }
    
    function onUploadcomplete(e) {
        hideMask();
    }

    function onFileSelect(e){
        mini.confirm("确定上传该文件?", "提醒", function(action){
            if (action == "ok") {
                var fileupload = mini.get(e.source.id);
                if(fileupload.text){
                    showMask();
                    fileupload.setUploadUrl("${ctx}/fileUpload/uploadImg");
//                  fileupload.setPostParam({a:1, b: true});
                    fileupload.startUpload();
                }
            }
        });
    }
    
    function previewImg(id){
        var imageUrl = mini.get(id).getValue();
        window.open(imageUrl);    
    }
    
    function previewPrint(action){
    	if(record.row && record.row.bill_id.length > 0){
    		mini.open({
                url: '${ctx}/portal/bill/showPreviewPrint.json',
                title: "打印预览", width: 1200, height: 700, showMaxButton: true,
                onload: function(){
                    var iframe = this.getIFrameEl();
                    var data = { url: record.row.bill_qrcode_url, action: action, bill_id: record.row.bill_id};
                    iframe.contentWindow.SetData(data);
                },
                ondestroy: function(action){
                    
                }
            });
    	}
    }
</script>
</body>
</html>
<!--endprint-->