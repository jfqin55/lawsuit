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
	        <input class="mini-hidden" name="budget_id"/>
	        <input class="mini-hidden" name="expense_amount"/>
	        <input class="mini-hidden" id="old_amount" name="old_amount"/>
	        <table style="width:100%;margin-top:11px;">
<!-- 				<tr> -->
<!-- 					<td align="right" width="90px"><label>所属机构:</label></td> -->
<!-- 					<td><input id="org_id" name="org_id" class="mini-combobox" textField="org_name" valueField="org_id" allowInput="true" style="width:150px;" -->
<%-- 							url="${ctx}/check/all/getOrgList.json" showNullItem="false" /></td> --%>
<!-- 				</tr> -->
<!-- 				<tr height="7px;"></tr> -->
				<tr>
                    <td align="right" width="110px">预算年度:</td>
                    <td><input id="year_num" name="year_num" class="mini-textbox" vtype="int" required="true" style="width: 150px;"/></td>
                </tr>
                <tr height="7px;"></tr>
				<tr>
					<td align="right" width="110px">部门名称:</td>
					<td><input id="department_id" name="department_id" class="mini-buttonedit" style="width:150px;" onbuttonclick="onButtonEdit" allowInput="false" required="true" emptyText="请选择部门"/></td>
				</tr>
				<tr height="7px;"></tr>
                <tr>
                    <td align="right" width="110px">科目名称:</td>
                    <td><input id="subject_id" name="subject_id" class="mini-combobox" textField="subject_name" valueField="subject_id" allowInput="true" style="width:150px;" emptyText="请选择科目"
                            url="${ctx}/portal/bill/getSubjectList.json" required="true" showNullItem="true"/></td>
                </tr>
				<tr height="7px;"></tr>
				<tr>
					<td align="right" width="110px">原预算金额:</td>
					<td><input id="budget_amount" name="budget_amount" class="mini-textbox" required="true" vtype="float" style="width: 130px;" enabled="false"/> 万</td>
				</tr>
				<tr height="7px;"></tr>
                <tr>
                    <td align="right" width="110px">变更后预算金额:</td>
                    <td><input id="budget_amount1" name="budget_amount1" class="mini-textbox" required="true" vtype="float" style="width: 130px;" /> 万</td>
                </tr>
				<tr height="7px;"></tr>
<!--                 <tr> -->
<!--                    <td align="right" width="110px">预算状态:</td> -->
<!--                    <td><input name="budget_status" class="mini-combobox" textField="text" valueField="id" allowInput="false" style="width:150px;" required="true" -->
<!--                                data="[{id:'1', text:'有效'}, {id:'0', text:'无效'}]" value="1" /></td> -->
<!--                 </tr> -->
<!--                 <tr height="7px;"></tr> -->
                <tr>
                    <td style="width:110px;" align="right">强制执行月度预算:</td>
                    <td><input class="mini-combobox" name="force_switch" textField="text" valueField="id" allowInput="false"
                        data="[{id: '1',text: '是'},{id: '0',text: '否'}]" style="width:150px;" required="true"/>
                    </td>
                </tr>
                <tr height="7px;"></tr>
                <tr>
                    <td style="width:110px;" align="right">月度预算可结转:</td>
                    <td><input class="mini-combobox" name="retain_switch" textField="text" valueField="id" allowInput="false"
                        data="[{id: '1',text: '是'},{id: '0',text: '否'}]" style="width:150px;" required="true"/>
                    </td>
                </tr>
                <tr height="7px;"></tr>
                <tr>
                    <td align="right" width="100px">变更理由:</td>
                    <td><input name="update_reason" class="mini-textarea" style="width:150px;height:40px;" /></td>
                </tr>
                <tr height="7px;"></tr>
                <tr>
                    <td align="right" width="100px">批文上传:</td>
                    <td><input class="mini-fileupload" id="fileupload1" name="fileupload1" limitType="*.jpg;*.jpeg;*.png;" style="width: 150px;"
                        flashUrl="${res}/swfupload/swfupload.swf" buttonText="点击导入" emptyText="" limitSize="10MB"
                        onuploadsuccess="onUploadSuccess"  onuploaderror="onUploadError" onfileselect="onFileSelect" ononuploadcomplete="onUploadcomplete"/>
                        <a id="preview_fileupload1" class="mini-button" onclick="previewImg('url_fileupload1')" style="width:44px;">预&nbsp;览</a>
                        <input class="mini-hidden" id="url_fileupload1" name="annex_url"/>
                    </td>
                </tr>
				<tr>
					<td colspan="2" style="padding-top: 17px;" align="center">
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
        if(!mini.get('url_fileupload1').getValue()){
            mini.alert("请上传批文！");
            return;
        }
        mini.confirm("确定保存?", "确定?", function(action){
            if (action == "ok") {
                showMask();
                var obj = detailForm.getData(true);
                obj.budget_amount = (obj.budget_amount1 * 1000000).toFixed(0);
//              var json = mini.encode(obj);
                $.post("${ctx}/portal/budget/year/createOrUpdate.do?action=" + record.action, obj, function(data){
                    if(data == true){
                        CloseWindow("ok");
                    }else{
                    	hideMask();
                        notifyOnBottomRight("已存在的预算只能修改!");
//                         notifyOnBottomRight("服务器繁忙,请稍后重试");
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
        	var old_amount = row.budget_amount;
        	row.budget_amount=row.budget_amount/1000000;
            detailForm.setData(row);
            mini.get('old_amount').setValue(old_amount);
            detailForm.setEnabled(true);
            mini.get('year_num').disable();
            mini.get('department_id').setValue(row.department_id);
            mini.get('department_id').setText(row.department_name);
            mini.get('department_id').disable();
            mini.get('subject_id').disable();
            mini.get('preview_fileupload1').hide();
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
        notifyOnBottomRight('操作失败,请确认文件内容是否符合要求!');
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
//                   fileupload.setPostParam({a:1, b: true});
                     fileupload.startUpload();
                 }
             }
         });
    }
    
    function previewImg(id){
    	var imageUrl = mini.get(id).getValue();
    	window.open(imageUrl);    
    }
    
    function onButtonEdit(e) {
        var btnEdit = this;
        mini.open({
            url: '${ctx}/portal/bill/showOrgs.json',
            title: "详情", width: 300, height: 600,
            onload: function(){
                var iframe = this.getIFrameEl();
                var data = { action: "edit", row: {} };
                iframe.contentWindow.SetData(data);
            },
            ondestroy: function(action){
                if(action == "ok"){
                    var data = this.getIFrameEl().contentWindow.GetData();//调用子页面 GetData 方法
                    data = mini.clone(data);
                    if (data) {
                        btnEdit.setValue(data.id);
                        btnEdit.setText(data.text);
                    }
                }
            }
        });
    } 
</script>
</body>
</html>
