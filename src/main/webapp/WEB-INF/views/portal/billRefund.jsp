<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!--startprint-->
<!doctype html>
<html>
<head>
	<title>三峡农商银行还款单</title>
	<jsp:include page="/easyui.jsp" />
	<style type="text/css">
		html, body{ margin:0;padding:0;border:0;width:100%;height:100%;overflow:hidden; }
		@page { size: 14in 7in; }
    </style>
</head>
<body>
	<div class="mini-layout" style="width:99%;height:100%;">
		<%--右侧面板--%>
		<div region="east" title="注意" width="200" height="100" showSplit="true" showCollapseButton="false">
			<div style="margin-left:7px;">
		   		1、需要在线下还款到指定账户后，再走线上审批流程备案。<br/>
		   		<img src="" id="showImg" width="180" height="180" style="margin-top:50px;"/><br/>
		   		<a class="mini-button" onclick="previewPrint('refund')" style="width:100px;margin-top:5px;">打印还款单</a><br/>
                <a class="mini-button" onclick="previewPrint('copy')" style="width:100px;margin-top:5px;">打印粘贴单</a>
	   		</div>
		</div>
		<%--中间页面展示区--%>
		<div showHeader="false" region="center">
            <form id="detailForm" method="post">
		        <div class="form">
		        <input class="mini-hidden" name="bill_id"/>
		        
		        <fieldset id="fieldset0" style="width:94%;border:solid 1px #aaa;margin-left:1.2%;display:inline;margin-top:1%;">
		            <legend>单据表头</legend>
		            <div style="padding:5px;">
		            <table style="width:100%;">
		                <tr>
		                    <td style="width:100px;" align="right">还款人:</td>
                            <td><input name="user_name" class="mini-textbox" enabled="false" required="true" style="width:150px;" value="${user.user_name}"/></td>
                            <td style="width:100px;" align="right">还款单位:</td>
                            <td><input name="department_name" class="mini-textbox" enabled="false" required="true" style="width:150px;" value="${user.department_name}"/></td>
		                    <td style="width:100px;" align="right">日期:</td>
		                    <td><input id="create_time" name="create_time" class="mini-datepicker" enabled="false" required="true" emptyText='' style="width: 150px;"/></td>
		                </tr>
		                <tr height="7px;"></tr>
		            </table>
		            </div>
		        </fieldset>
		        
		        <fieldset style="width:94%;border:solid 1px #aaa;margin-left:1.2%;margin-top:1%;">
                    <legend>还款信息</legend>
                    <div style="padding:5px;">
                    <table style="width:100%;">
                        <tr>
                            <td style="width:100px;" align="right">借款单编号:</td>
                            <td><div name="bill_id_borrow" class="mini-combobox" textField="bill_id" valueField="bill_id" allowInput="false" style="width:150px;" popupWidth="400" emptyText=""
                                url="${ctx}/portal/bill/getBorrowIdList.json" showNullItem="false" required="true" ondrawcell="onDrawCell">
	                                <div property="columns">
	                                    <div header="借款单编号" width="160" field="bill_id"></div>
	                                    <div header="待还金额" width="80" field="bill_amount"></div>
	                                </div>
                                </div>
                            </td>
                            <td style="width:100px;" align="right">还款金额(小写):</td>
                            <td><input name="bill_amount" class="mini-textbox" required="true" vtype="float" onvaluechanged="onBillAmountChanged" style="width:130px;"/> 元</td>
                            <td style="width:100px;" align="right">还款金额(大写):</td>
                            <td><input id='bill_amount_big' name="bill_amount_big" class="mini-textbox" required="true" style="width:150px;" enabled="false"/></td>
                        </tr>
                        <tr height="7px;"></tr>
                        <tr>
                            <td style="width:100px;" align="right">备注:</td>
                            <td colspan="3"><input name="remark" class="mini-textbox" style="width:400px;"/></td>
                        </tr>
                        <tr height="7px;"></tr>
                    </table>
                    </div>
                </fieldset>
		        
		        <table style="width:100%;">
		            <tr>
		                <td style="padding-top: 17px;" align="center" id="tableFooter">
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
	
	var detailForm = new mini.Form("detailForm");
	
	var record = {action: 'create'};
	
	function onOk(e){
        detailForm.validate();
        if(detailForm.isValid() == false) return;
        mini.confirm("确定保存?", "确定?", function(action){
            if (action == "ok") {
                showMask();
                var obj = detailForm.getData(true);
                obj.bill_amount = (obj.bill_amount * 100).toFixed(0);
                obj.bill_type = billTypeArr[2].id;
                
                var json = mini.encode(obj);
                
                $.post("${ctx}/portal/bill/createOrUpdate.do?action=" + record.action, {submitData: json}, function(data){
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
	        var row = record.row;
	        row.budget_special_amount=row.budget_special_amount/100;
	        detailForm.setData(row);
	        detailForm.setEnabled(true);
	        mini.get('budget_special_name').disable();
	    }else if(record.action == "detail"){
	        detailInit(record.row);
	    }
	}
	
	function detailInit(row){
		row.bill_amount = row.bill_amount/100;
        detailForm.setData(row);
        detailForm.setEnabled(false);
        document.getElementById("tableFooter").style.display = "none";
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
	
	function onBillAmountChanged(e){
		mini.get('bill_amount_big').setValue(toDX(e.sender.value));
	}
	
	function onDrawCell(e) {
        var item = e.record, field = e.field, value = e.value;
        if(field == "bill_amount")
        //组织HTML设置给cellHtml
        e.cellHtml = '<span style="color:black;font-weight:bold;">' + value/100 +' 元</span>';   
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