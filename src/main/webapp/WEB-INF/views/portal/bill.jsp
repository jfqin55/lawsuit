<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<title></title>
	<jsp:include page="/easyui.jsp" />
	<style type="text/css">
		html, body{ margin:0; padding:0; border:0; width:100%; height:100%; overflow:hidden; }
    </style>
</head>
<body>
	<div style="padding-bottom:5px;">
	    <span>&nbsp;&nbsp;申请时间:</span>
        <input id="start_time_search" class="mini-datepicker" style="width:100px;"/> 至 <input id="end_time_search" class="mini-datepicker" style="width:100px;"/>
	    <span>&nbsp;&nbsp;员工姓名：</span>
	    <input id="user_name_search" class="mini-textbox" type="text" style="width:100px;" />
	    <span>&nbsp;&nbsp;部门名称：</span>
	    <input id="department_id_search" class="mini-buttonedit" style="width:120px;" onbuttonclick="onButtonEdit" allowInput="false"/>
        <span>&nbsp;&nbsp;科目名称：</span>
        <input id="subject_id_search" class="mini-combobox" textField="subject_name" valueField="subject_id" allowInput="true" style="width:120px;"
			url="${ctx}/portal/bill/getSubjectList.json" showNullItem="true"/>
		<span>&nbsp;&nbsp;审批状态：</span>
		<input id="bill_status_search" class="mini-combobox" textField="text" valueField="id" allowInput="false" value="" style="width:60px;"
			data="[{id:'', text:'全部'}, {id:'0', text:'未通过'}, {id:'1', text:'审批中'}, {id:'2', text:'已通过'}]" />
		<span>&nbsp;&nbsp;单据类型：</span>
        <input id="bill_type_search" class="mini-combobox" textField="text" valueField="id" allowInput="false" value="" style="width:60px;"
            data="[{id:'', text:'全部'}, {id:'1', text:'报销单'}, {id:'2', text:'借款单'}, {id:'2', text:'还款单'}]" />
        <span>&nbsp;&nbsp;单据金额:</span>
        <input id="bill_amount_start_search" class="mini-textbox" vtype="float" style="width:50px;"/> 万 - <input id="bill_amount_end_search" class="mini-textbox" vtype="float" style="width:50px;"/> 万
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <a class="mini-button" iconCls="icon-search" onclick="searchByParams()">查找</a>&nbsp;&nbsp;
        <a class="mini-button" iconCls="icon-reload" onclick="resetALLParams()">重置</a>&nbsp;&nbsp;
        <a id="excelButton" class="mini-button" iconCls="icon-print" enabled="false" onclick="exportExcel()">导出查询结果</a>
    </div>
    
    <c:choose>
		<c:when test="${false}">
			<div class="mini-toolbar" style="border-bottom:0;padding:1px;">
			    <table style="width:100%;">
			        <tr>
			            <td style="width:100%;">
<!-- 			                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('createExpense')">新增报销单</a> -->
<!-- 			                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('createBorrow')">新增借款单</a> -->
<!-- 			                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('createRefund')">新增还款单</a> -->
<!-- 			                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('createRefund')">回退押金</a> -->
		<!-- 	                <a class="mini-button" iconCls="icon-edit" onclick="openDetailWindow('update')">修改报告</a> -->
		<!-- 	                <a class="mini-button" iconCls="icon-remove" onclick="deleteById()">删除商户</a> -->
			            </td>
			        </tr>
			    </table>           
			</div>
		</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
	
    <div class="mini-fit" >
	    <div id="grid" class="mini-datagrid" style="width:100%;height:100%;" allowResize="true" ondrawcell="onDrawCell"
	        url="${ctx}/portal/bill/selectAll.json?frowWhere=${frowWhere}" idField="bill_id" multiSelect="true" pageSize=50 
	        ondrawsummarycell="onDrawSummaryCell" showSummaryRow="true">
	        <div property="columns">
	        	<div type="indexcolumn"></div>
	            <div field="bill_code" width="120" align="center" headerAlign="center" allowSort="true">单据编号</div>
	            <div field="department_name" width="80" align="center" headerAlign="center" allowSort="true">申请部门</div>
	            <div field="user_name" width="60" align="center" headerAlign="center" allowSort="true">申请人</div>
	            <div field="subject_name" width="60" align="center" headerAlign="center" allowSort="true">报销科目</div>
	            <div field="bill_amount" width="60" align="right" headerAlign="center" allowSort="true">单据金额(元)</div>
	            <div field="bill_type" width="60" align="center" headerAlign="center" allowSort="true">单据类型</div>
	            <div field="bill_status" width="60" align="center" headerAlign="center" allowSort="true">审核状态</div>
	            <div field="create_time" width="120" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">申请时间</div>
<!-- 	            <div field="update_time" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">审核时间</div>     -->
	            <div field="operate" width="200" align="center" headerAlign="center" allowSort="false">操作</div>
	        </div>
	    </div>
    </div>
    
    <!-- 回退窗口 start -->
	<div id="returnBackWin" class="mini-window" title="回退" style="width: 350px; height: 240px;" showModal="true" showCloseButton="true">
		<div id="returnBackForm" style="padding: 15px;">
			<table>
				<tr>
				    <td><input id="auditor_id" name="auditor_id" class="mini-combobox" textField="auditor_name" valueField="auditor_id" allowInput="false" style="width:150px;" 
				        showNullItem="false" required="true" emptyText="请选择回退对象"/></td>
				</tr>
				<tr height="7px;"></tr>
				<tr>
                    <td><input name="remark" class="mini-textarea" style="width:300px;height:70px;" requiredErrorText="请填写回退原因"  required="true" emptyText="请填写回退原因"/></td>
                </tr>
				<tr>
					<td colspan="2" style="padding-top: 17px;" align="center" height="30px;">
						<a onclick="onSubmitClick" class="mini-button" style="width: 60px;">确认</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a onclick="onCancleClick" class="mini-button" style="width: 60px;">取消</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<!-- 回退窗口 end -->
    
	<form id="excelForm" action="" method="post" target="_self"></form>
	
<script type="text/javascript">
	mini.parse();
	var grid = mini.get("grid");
	grid.load(null, null, gridLoadFail);
	var start_time_search = mini.get('start_time_search');
    var end_time_search = mini.get('end_time_search');
//     var today = new Date();
//  start_time_search.setValue(new Date());
//  end_time_search.setValue(new Date());
	var user_name_search = mini.get("user_name_search");
	var department_id_search = mini.get("department_id_search");
	var subject_id_search = mini.get("subject_id_search");
	var bill_status_search = mini.get("bill_status_search");
	var bill_type_search = mini.get("bill_type_search");
	
	var bill_amount_start_search = mini.get("bill_amount_start_search");
    var bill_amount_end_search = mini.get("bill_amount_end_search");
	
	var returnBackWin = mini.get("returnBackWin");
	
	var role_id = '${user.role_id}';
	
	function onDrawCell(e){
	    var record = e.record;
	    var value = e.value;
	    if(value == null) value = "";
	    
	    if(e.field == 'bill_status'){
	    	for(i in checkStatusArr){
				if(checkStatusArr[i].id == value) e.cellHtml = "<span style='color:"+ checkStatusArr[i].color +";font-weight:bold;'>"+ checkStatusArr[i].text +"</span>";
			}
	    }
	    
	    if(e.field == 'bill_type'){
	    	for(i in billTypeArr){
				if(billTypeArr[i].id == value) e.cellHtml = billTypeArr[i].text;
			}
	    }
	    
	    if(e.field == 'bill_amount') e.cellHtml = value/100; 
	    if(e.field == 'operate'){
	    	if(${frowWhere == 'check'}){
	    		if(record.auditor_id == '${user.user_id}' && record.bill_status != 0 && record.bill_status != 2){
	    			e.cellHtml = ['<a class="mini-button" style="width:40px;" onclick=openDetailWindow("detail")>详情</a>&nbsp;&nbsp;',
	                    '<a class="mini-button" style="width:40px;" onclick="agree()">同意</a>&nbsp;&nbsp;',
	                    '<a class="mini-button" style="width:40px;" onclick="returnBack()">回退</a>&nbsp;&nbsp;',
	                    '<a class="mini-button" style="width:40px;" onclick="reject()">拒绝</a>&nbsp;&nbsp;',
	                    '<a class="mini-button" style="width:60px;" onclick="openCheckDetailWindow()">审批详情</a>'].join('');
	    		}else{
	    			e.cellHtml = ['<a class="mini-button" style="width:40px;" onclick=openDetailWindow("detail")>详情</a>&nbsp;&nbsp;',
	                    '<a class="mini-button" style="width:60px;" onclick="openCheckDetailWindow()">审批详情</a>'].join('');
	    		}
	    	}else if(${frowWhere == 'bill'} && '${user.user_id}' == record.user_id && record.bill_status != 0 && record.bill_status != 2){
	    		e.cellHtml = ['<a class="mini-button" style="width:40px;" onclick=openDetailWindow("detail")>详情</a>&nbsp;&nbsp;',
                    '<a class="mini-button" style="width:60px;" onclick="openMultiUploadWin()">补充附件</a>&nbsp;&nbsp;',
                    '<a class="mini-button" style="width:60px;" onclick="openCheckDetailWindow()">审批详情</a>'].join('');
	    	}else if(record.bill_status == 0){
	    		e.cellHtml = ['<a class="mini-button" style="width:40px;" onclick=openDetailWindow("detail")>详情</a>&nbsp;&nbsp;',
	    			'<a class="mini-button" style="width:60px;" onclick=openDetailWindow("update")>重新申请</a>&nbsp;&nbsp;',
                    '<a class="mini-button" style="width:60px;" onclick="openCheckDetailWindow()">审批详情</a>'].join('');
	    	}else{
                e.cellHtml = ['<a class="mini-button" style="width:40px;" onclick=openDetailWindow("detail")>详情</a>&nbsp;&nbsp;',
                    '<a class="mini-button" style="width:60px;" onclick="openCheckDetailWindow()">审批详情</a>'].join('');
            }
	    }
	}
	
	function onDrawSummaryCell(e) {
        var totalAmount = e.result.totalAmount;
        if (e.field == "bill_amount") { 
        	e.cellHtml = "<span style='color:Brown;font-weight:bold;margin-left:7px;'>合计：￥" + totalAmount/100 + "</span>";
        }
    }
	
	function searchByParams(){
		var start_time = start_time_search.getFormValue();
        var end_time = end_time_search.getFormValue();
        if(start_time.length > 0) start_time = start_time + " 00:00:00";
        if(end_time.length > 0) end_time = end_time + " 23:59:59";
        var bill_amount_start = bill_amount_start_search.getFormValue();
        var bill_amount_end = bill_amount_end_search.getFormValue();
        
        if(bill_amount_start.length > 0) bill_amount_start = (bill_amount_start * 1000000).toFixed(0);
        if(bill_amount_end.length > 0) bill_amount_end = (bill_amount_end * 1000000).toFixed(0);
        
		grid.load({
			start_time: start_time,
            end_time: end_time,
            bill_amount_start: bill_amount_start,
            bill_amount_end: bill_amount_end,
			user_name: user_name_search.getFormValue(),
			department_id: department_id_search.getFormValue(),
			subject_id: subject_id_search.getFormValue(),
            bill_type: bill_type_search.getFormValue(),
			bill_status: bill_status_search.getFormValue() // 除分页排序参数外的额外参数
	    }, null, gridLoadFail);
		mini.get("excelButton").enable();
	}
     
	function resetALLParams(){
		start_time_search.setValue('');
        end_time_search.setValue('');
		user_name_search.setValue('');
		department_id_search.setValue('');
		department_id_search.setText('');
		subject_id_search.setValue('');
		bill_status_search.setValue('');
		bill_type_search.setValue('');
		bill_amount_start_search.setValue('');
		bill_amount_end_search.setValue('');
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
	
	function openDetailWindow(action){
		var row = {};
		if(action == "detail" || action == "update") row = grid.getSelected();
		else if(action == "createExpense") row = {bill_type: '1'};
		else if(action == "createBorrow") row = {bill_type: '2'};
		else if(action == "createRefund") row = {bill_type: '3'};
		
        var title = '';
        for(i in billTypeArr){
            if(billTypeArr[i].id == row.bill_type) title = billTypeArr[i].text;
        }
        mini.open({
            url: '${ctx}/portal/bill/showDetailWindow.json?billType=' + row.bill_type,
            title: title, width: 1200, height: 600, showMaxButton: true,
            onload: function(){
                var iframe = this.getIFrameEl();
                var data = { action: action, row: row };
                iframe.contentWindow.SetData(data);
            },
            ondestroy: function(action){
//              console.info(this.getIFrameEl().contentWindow.GetData()); //调用子页面 GetData 方法
                if(action == "ok"){
                    grid.reload();
                    notifyOnBottomRight("操作成功!");
                }
            }
        });
	}
	
	function openCheckDetailWindow(){
		var row = grid.getSelected();
        mini.open({
            url: '${ctx}/portal/bill/openCheckDetailWindow.json',
            title: "审批详情", width: 800, height: 300,
            onload: function(){
                var iframe = this.getIFrameEl();
                var data = { row: row };
                iframe.contentWindow.SetData(data);
            },
            ondestroy: function(action){
//              console.info(this.getIFrameEl().contentWindow.GetData()); //调用子页面 GetData 方法
//                 if(action == "ok"){
//                     grid.reload();
//                     notifyOnBottomRight("操作成功!");
//                 }
            }
        });
	}
	
	function agree(){
		mini.confirm("确认同意?", "确定?", function(action){
            if (action == "ok") {
            	var row = grid.getSelected();
            	showMask();
            	$.post("${ctx}/portal/bill/agree.do?",{bill_id: row.bill_id},function(data){
            		hideMask();
            		grid.reload();
                    notifyOnBottomRight(data.msg);
    			});
            }
        });
	}
	
	function returnBack(){
		var row = grid.getSelected();
		$.post("${ctx}/portal/bill/check/getBillCheckList.json", {bill_id: row.bill_id}, function(data){
			mini.get('auditor_id').set({
                data: data
            });
			returnBackWin.show();
        });
	}
	
	function reject(){
	    mini.prompt("请输入拒绝原因：", "确认拒绝?", function (action, value) {
	        if (action == "ok") {
	        	var row = grid.getSelected();
	            showMask();
	            if(!value) value = '';
                $.post("${ctx}/portal/bill/reject.do", {bill_id: row.bill_id, remark: value}, function(data){
                    hideMask();
                    if(data){
                        grid.reload();
                        notifyOnBottomRight("操作成功!");
                    }else{
                        notifyOnBottomRight("操作失败!");
                    }
                });
            }
        }, true);
	}
	
	
	function onCancleClick(e) {
		returnBackWin.hide();
	}
	
	function onSubmitClick(e) {
		var returnBackForm = new mini.Form("#returnBackForm");
		returnBackForm.validate();
		if (returnBackForm.isValid() == true){
			var data = returnBackForm.getData(true);
			var row = grid.getSelected();
			data.bill_id = row.bill_id;
			showMask();
			$.post("${ctx}/portal/bill/returnBack.do", data, function(res) {
				hideMask();
				returnBackWin.hide();
				if(res == true){
					returnBackForm.reset();
					grid.reload();
					notifyOnBottomRight("操作成功!");
				}else{
					notifyOnBottomRight("操作失败!");
				}
			});
		}
	}
	
    function openMultiUploadWin() {
    	var row = grid.getSelected();
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
                var data = this.getIFrameEl().contentWindow.GetData();
                var imgs = mini.clone(data);
                var billAnnexes = [];
                $.each(imgs, function(i){
                    var billAnnex = {bill_id: row.bill_id, annex_type: '补充', annex_url: imgs[i].img_url};
                    billAnnexes.push(billAnnex);
                });
                
                var billAnnexesJson = mini.encode(billAnnexes);
                $.post("${ctx}/portal/bill/appendBillAnnexes.do", {billAnnexesJson: billAnnexesJson}, function(data){
                    hideMask();
                    grid.reload();
                    if(data == true){
                    	notifyOnBottomRight("操作成功!");
                    }else{
                        notifyOnBottomRight("操作失败!");
                    }
                });
    //             var json = mini.encode(data);
            }
        });
    }
	
    function exportExcel(){
        mini.confirm("确认导出查询结果?", "提示", function(action){
            if(action == "ok"){
                var url = "${ctx}/portal/bill/export.do";
                $("#excelForm").attr('action', url);
                $("#excelForm").submit();
            }
        });
    }
</script>
</body>
</html>