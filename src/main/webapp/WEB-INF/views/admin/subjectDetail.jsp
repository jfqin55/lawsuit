<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
    <title>详情</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <jsp:include page="/easyui.jsp" />
    <style type="text/css">
    	html, body{ font-size:12px; padding:0; margin:0; border:0; height:100%; overflow:hidden; }
    </style>
</head>

<body>    
    <form id="detailForm" method="post">
	    <div class="form" >
	        <input class="mini-hidden" name="subject_id"/>
	        <table style="width:100%;margin-top:11px;">
<!-- 				<tr> -->
<!-- 					<td align="right" width="90px"><label>所属机构:</label></td> -->
<!-- 					<td><input id="org_id" name="org_id" class="mini-combobox" textField="org_name" valueField="org_id" allowInput="true" style="width:150px;" -->
<%-- 							url="${ctx}/check/all/getOrgList.json" showNullItem="false" /></td> --%>
<!-- 				</tr> -->
<!-- 				<tr height="7px;"></tr> -->
				<tr>
					<td align="right" width="110px">科目名称:</td>
					<td><input id="subject_name" name="subject_name" class="mini-textbox" required="true" style="width: 150px;" onvalidation="onSubjectNameValid" /></td>
					<td style="width:110px;" align="right">科目状态:</td>
                    <td><input class="mini-combobox" name="subject_status" textField="text" valueField="id" allowInput="false" onvaluechanged="changeSwitch1"
                        data="[{id: '1',text: '有效'},{id: '0',text: '无效'}]" style="width:150px;" required="true" />
                    </td>
				</tr>
                <tr height="7px;"></tr>
                <tr>
                    <td align="right" width="110px">费用申报所需资料:</td>
                    <td colspan="3"><input name="requird_info" class="mini-textarea" style="width:446px;height:50px;" emptyText='如需多项资料,请用"|"隔开'/></td>
                </tr>
                <tr height="7px;"></tr>
                <tr>
                    <td style="width:110px;" align="right">强制执行月度预算:</td>
                    <td><input class="mini-combobox" name="force_switch" textField="text" valueField="id" allowInput="false" onvaluechanged="changeSwitch1"
                        data="[{id: '1',text: '是'},{id: '0',text: '否'}]" style="width:150px;" required="true"/>
                    </td>
                    <td style="width:110px;" align="right">月度预算可结转:</td>
                    <td><input class="mini-combobox" name="retain_switch" textField="text" valueField="id" allowInput="false" onvaluechanged="changeSwitch1"
                        data="[{id: '1',text: '是'},{id: '0',text: '否'}]" style="width:150px;" required="true"/>
                    </td>
                </tr>
            </table>
<!--             <table id="table1" style="width:100%;margin-top:11px;"> -->
<!--                 <tr> -->
<!--                     <td style="width:100px;" align="right">合同编号:</td> -->
<!--                     <td><input name="bill_id_borrow" class="mini-combobox" textField="bill_id" valueField="bill_id" allowInput="true" style="width:150px;" -->
<%--                         url="${ctx}/portal/bill/getBorrowIdList.json" showNullItem="false" /></td> --%>
<!--                 </tr> -->
<!--                 <tr height="7px;"></tr> -->
<!--                 <tr> -->
<!--                     <td style="width:100px;" align="right">合同全称:</td> -->
<!--                     <td colspan="3"><input name="contract_code" class="mini-combobox" textField="contract_code" valueField="contract_code" allowInput="true" style="width:438px;" -->
<%--                         url="${ctx}/portal/bill/getContractListByAction.json?action=detail" showNullItem="false" emptyText='请填写该笔费用报销关联的合同，没有则不填写'  /></td> --%>
<!--                 </tr> -->
<!--                 <tr height="7px;"></tr> -->
<!--                 <tr> -->
<!--                     <td style="width:100px;" align="right">合同金额:</td> -->
<!--                     <td><input name="bill_amount" class="mini-textbox" required="true" vtype="float" style="width:150px;"/></td> -->
<!--                     <td style="width:100px;" align="right">押金金额:</td> -->
<!--                     <td><input name="bill_amount" class="mini-textbox" required="true" vtype="float" style="width:150px;"/></td> -->
<!--                 </tr> -->
<!--             </table> -->
            <table style="width:100%;margin-top:11px;">
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
	
	var detailForm = new mini.Form("detailForm");
	var record = null;
	
	function onOk(e){
        detailForm.validate();
        if(detailForm.isValid() == false) return;
        var obj = detailForm.getData(true);
        $.post("${ctx}/admin/subject/createOrUpdate.do?action=" + record.action, obj, function(data){
            if(data == true){
                CloseWindow("ok");
            }else{
                notifyOnBottomRight("服务器繁忙,请稍后重试");
            }
        });
    }

   	// 该方法为父页面生成子页面时调用
    function SetData(data){
  		//跨页面传递的数据对象，克隆后才可以安全使用
      	record = mini.clone(data);
        if(record.action == "update"){
        	var row = record.row;
            detailForm.setData(row);
            detailForm.setEnabled(true);
            mini.get('subject_name').disable();
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
	
	function onSubjectNameValid(e){
    	if(e.isValid && record.action == 'create'){
    		var paramMap = {subject_name: e.value};
    		$.ajax({
    		    url: "${ctx}/admin/subject/checkSubjectName.json",
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
	

//     $("#table1").css('display', 'none');
    function changeSwitch1(e){
//         if(e.value == 1){
//             $("#table1").css('display', 'block');
//         }else{
//             $("#table1").css('display', 'none');
//         }
    }
</script>
</body>
</html>
