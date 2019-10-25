<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
    <title>详情</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <jsp:include page="/easyui.jsp" />
    <script src="${res}/swfupload/swfupload.js" type="text/javascript"></script>
    <style type="text/css">
    	html, body{ font-size:12px; padding:0; margin:0; border:0; height:100%; overflow:hidden; }
    </style>
</head>

<body>    
    <form id="detailForm" method="post">
	    <div class="form" >
	        <input class="mini-hidden" name="budget_special_id"/>
	        <table style="width:100%;margin-top:11px;">
<!-- 				<tr> -->
<!-- 					<td align="right" width="90px"><label>所属机构:</label></td> -->
<!-- 					<td><input id="org_id" name="org_id" class="mini-combobox" textField="org_name" valueField="org_id" allowInput="true" style="width:150px;" -->
<%-- 							url="${ctx}/check/all/getOrgList.json" showNullItem="false" /></td> --%>
<!-- 				</tr> -->
<!-- 				<tr height="7px;"></tr> -->
				<tr>
					<td align="right" width="100px">专项预算名称:</td>
					<td><input id="budget_special_name" name="budget_special_name" class="mini-textbox" required="true" style="width: 150px;" onvalidation="onBudgetSpecialNameValid" /></td>
					<td align="right" width="100px">专项预算金额:</td>
					<td><input id="budget_special_amount" name="budget_special_amount" class="mini-textbox" required="true" vtype="float" style="width: 130px;" /> 万</td>
				</tr>
				<tr height="7px;"></tr>
				<tr>
                    <td align="right" width="100px">启用时间:</td>
                    <td><input id="start_time" name="start_time" class="mini-datepicker" format="yyyy-MM-dd HH:mm:ss" timeFormat="HH:mm:ss" showTime="true" showOkButton="true" showClearButton="false" required="true" emptyText='' style="width: 150px;"/></td>
                    <td align="right" width="100px">停用时间:</td>
                    <td><input id="end_time" name="end_time" class="mini-datepicker" format="yyyy-MM-dd HH:mm:ss" timeFormat="HH:mm:ss" showTime="true" showOkButton="true" showClearButton="false" required="true" emptyText='' style="width: 150px;"/></td>
                </tr>
                <tr height="7px;"></tr>
                <tr>
                    <td align="right" width="100px">备注:</td>
                    <td colspan="3"><input name="remark" class="mini-textarea" style="width:438px;height:50px;" /></td>
                </tr>
                <tr height="7px;"></tr>
                <tr>
                    <td align="right" width="100px">批文上传:</td>
                    <td colspan="3"><input class="mini-fileupload" id="fileupload1" name="fileupload1" limitType="*.jpg;*.jpeg;*.png;" style="width: 150px;"
                        flashUrl="${res}/swfupload/swfupload.swf" buttonText="点击导入" emptyText="" limitSize="10MB"
                        onuploadsuccess="onUploadSuccess"  onuploaderror="onUploadError" onfileselect="onFileSelect" ononuploadcomplete="onUploadcomplete"/>
                        <a id="preview_fileupload1" class="mini-button" onclick="previewImg('url_fileupload1')" style="width:44px;">预&nbsp;览</a>
                        <input class="mini-hidden" id="url_fileupload1" name="file_url"/>
                    </td>
                </tr>
                <tr height="7px;"></tr>
                <tr>
                    <td style="width:100px;" align="right">是否关联合同:</td>
                    <td><input class="mini-combobox" id="contract_switch" textField="text" valueField="id" allowInput="false" onvaluechanged="changeSwitch1"
                        data="[{id: '1',text: '是'},{id: '0',text: '否'}]" style="width:150px;" required="true" value="0" />
                    </td>
                </tr>
            </table>
            <table id="table1" style="width:100%;margin-top:11px;">
                <tr>
                    <td style="width:100px;" align="right">合同编号:</td>
                    <td><input id="contract_code" name="contract_code" class="mini-combobox" textField="contract_code" valueField="contract_code" allowInput="true" style="width:150px;"
                        url="${ctx}/portal/bill/getContractListByAction.json?action=detail" showNullItem="false" onvaluechanged="onContractChanged"/></td>
                    <td style="width:100px;" align="right">押金金额:</td>
                    <td><input id="contract_deposit" name="contract_deposit" class="mini-textbox" vtype="float" style="width:130px;"/> 万</td>
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
                </tr>
            </table>
            <table style="width:100%;margin-top:11px;">
<!-- 				<tr> -->
<!-- 					<td align="right" width="90px"><label>用户状态:</label></td> -->
<!-- 					<td><input name="user_status" class="mini-combobox" textField="text" valueField="id" allowInput="false" style="width:150px;" required="true" -->
<!-- 								data="[{id:'1', text:'有效'}, {id:'0', text:'无效'}]" value="1" /></td> -->
<!-- 				</tr> -->
				<tr>
					<td colspan="4" style="padding-top: 17px;" align="center">
						<a class="mini-button" onclick="onOk" style="width:60px;margin-right:20px;">确定</a>       
            			<a class="mini-button" onclick="onCancel" style="width:60px;">取消</a>   
					</td>
				</tr>
	        </table>
	    </div>
    </form>
    
<script type="text/javascript">
	mini.parse();
	
	var start_time = mini.get('start_time');
    var end_time = mini.get('end_time');
    var today = new Date();
    today.setHours(0,0,0);
//     var todayTime = today.getTime()-24*3600000;
    start_time.setValue(today);
    end_time.setValue(today);
	
	var detailForm = new mini.Form("detailForm");
	var record = null;
	
	function onOk(e){
        detailForm.validate();
        if(detailForm.isValid() == false) return;
        
        if(!mini.get('url_fileupload1').getValue()){
            mini.alert("请上传批文！");
            return;
        }
        if(mini.get('contract_switch').getValue() == '1'){
            if(!contract){
                
            }else{
                if(contract.contract_amount != (mini.get('budget_special_amount').getValue()* 1000000).toFixed(0)){
                    mini.alert("专项预算金额与合同金额不一致！");
                    return;
                }
            }
            
            if(!mini.get('url_fileupload2').getValue()){
                mini.alert("请上传合同！");
                return;
            }
            if(!mini.get('contract_deposit').getValue()){
                mini.alert("请填写合同押金！");
                return;
            }
            if(!mini.get('contract_code').getValue()){
                mini.alert("请填写合同编号！");
                return;
            }
        }else{
            mini.get('url_fileupload2').setValue('');
            mini.get('contract_deposit').setValue('');
            mini.get('contract_code').setValue('');
        }
        mini.confirm("确定保存?", "确定?", function(action){
            if (action == "ok") {
                showMask();
                var obj = detailForm.getData(true);
                obj.budget_special_amount = (obj.budget_special_amount * 1000000).toFixed(0);
                obj.contract_deposit = (obj.contract_deposit * 1000000).toFixed(0);
                var json = mini.encode(obj);
                $.post("${ctx}/portal/budget/special/createOrUpdate.do?action=" + record.action, {submitData: json}, function(data){
                    if(data == true){
                        CloseWindow("ok");
                    }else{
                        hideMask();
                        notifyOnBottomRight("服务器繁忙,请稍后重试");
                    }
                });
            }
        });
    }

   	// 该方法为父页面生成子页面时调用
    function SetData(data){
  		//跨页面传递的数据对象，克隆后才可以安全使用
      	record = mini.clone(data);
        if(record.action == "update"){
        	var row = record.row;
        	row.budget_special_amount=row.budget_special_amount/1000000;
            detailForm.setData(row);
            detailForm.setEnabled(true);
            mini.get('budget_special_name').disable();
		}else if(record.action == "detail"){
			var row = record.row;
            row.budget_special_amount=row.budget_special_amount/1000000;
            row.contract_deposit=row.contract_deposit/1000000;
            detailForm.setData(row);
            detailForm.setEnabled(false);
            if(!mini.get('url_fileupload2').getValue()){
            	mini.get('contract_switch').setValue('0');
            }else{
            	mini.get('contract_switch').setValue('1');
            	$("#table1").css('display', 'block');
            }
            mini.get('fileupload1').hide();
            mini.get('fileupload2').hide();
		}else if(record.action == "create"){
			mini.get('preview_fileupload1').hide();
			mini.get('preview_fileupload2').hide();
		}
        
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
	
	function onBudgetSpecialNameValid(e){
    	if(e.isValid && record.action == 'create'){
    		var paramMap = {budget_special_name: e.value};
    		$.ajax({
    		    url: "${ctx}/portal/budget/special/checkBudgetSpecialName.json",
    		    async: false,// 只有同步请求才会使验证生效
    		    type: 'POST',
				data: paramMap,
    		    success: function(data){
    		    	if(data == false){
	        			e.errorText = "该名称已存在";
	                    e.isValid = false;
	        		}
    		    }
    		});
        }
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
    
    $("#table1").css('display', 'none');
    function changeSwitch1(e){
        if(e.value == 1){
            $("#table1").css('display', 'block');
        }else{
            $("#table1").css('display', 'none');
        }
    }
    
    function previewImg(id){
        var imageUrl = mini.get(id).getValue();
        window.open(imageUrl);    
    }
    
    var contract;
    function onContractChanged(e){
    	contract = e.selected;
    	if(!contract) return;
    	mini.get("contract_deposit").setValue(contract.contract_deposit/1000000);
    	mini.get("url_fileupload2").setValue(contract.contract_url);
    	mini.get("fileupload2").hide();
    	mini.get("preview_fileupload2").show();
    }
</script>
</body>
</html>
