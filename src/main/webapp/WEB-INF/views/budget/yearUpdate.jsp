<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<title>年度预算变更</title>
	<jsp:include page="/easyui.jsp" />
	<style type="text/css">
		html, body{ margin:0; padding:0; border:0; width:100%; height:100%; overflow:hidden; }
    </style>
</head>
<body>
	<div style="padding-bottom:5px;">
	    <span>&nbsp;&nbsp;预算年度：</span>
	    <input id="year_search" class="mini-combobox" textField="text" valueField="id" allowInput="false" data='${yearList }' style="width:70px;"/>
        <span>&nbsp;&nbsp;部门名称：</span>
        <input id="department_id_search" class="mini-buttonedit" style="width:120px;" onbuttonclick="onButtonEdit" allowInput="false" emptyText="请选择部门"/>
        <span>&nbsp;&nbsp;科目名称：</span>
        <input id="subject_id_search" class="mini-combobox" textField="subject_name" valueField="subject_id" allowInput="true" style="width:120px;" emptyText="请选择科目"
            url="${ctx}/portal/bill/getSubjectList.json" onenter="searchByParams" showNullItem="true"/>
<!-- 		<span>&nbsp;&nbsp;预算状态：</span> -->
<!-- 		<input id="budget_status_search" class="mini-combobox" textField="text" valueField="id" allowInput="false" value="" style="width:50px;" -->
<!-- 			data="[{id:'', text:'全部'}, {id:'1', text:'有效'}, {id:'0', text:'无效'}]" /> -->
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <a class="mini-button" iconCls="icon-search" onclick="searchByParams()">查找</a>&nbsp;&nbsp;
        <a class="mini-button" iconCls="icon-reload" onclick="resetALLParams()">重置</a>
    </div>
    
	<div class="mini-toolbar" style="border-bottom:0;padding:0px;">
	    <table style="width:100%;">
	        <tr>
	            <td style="width:100%;">
	                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('create')">新增预算</a>
	                <a class="mini-button" iconCls="icon-edit" onclick="openDetailWindow('update')">修改预算</a>
<!-- 	                <a class="mini-button" iconCls="icon-remove" onclick="deleteById()">删除预算</a> -->
	            </td>
	        </tr>
	    </table>           
	</div>
	
	<div class="mini-fit">
        <div id="grid" class="mini-datagrid" style="width:100%;height:100%;" allowResize="true" ondrawcell="onDrawCell"
            url="${ctx}/portal/budget/year/update/selectAll.json" idField="budget_id" multiSelect="true" sizeList=[100] pageSize=100
            allowCellValid="true" oncellvalidation="onCellValidation" 
            allowCellEdit="true" allowCellSelect="true" editNextOnEnterKey="true"  editNextRowCell="true" 
            >
            <div property="columns">
                <div type="indexcolumn"></div>
                <div field="year_num" width="60" align="center" headerAlign="center" allowSort="true">预算年度</div>
                <div field="department_name" width="120" align="right" headerAlign="center" allowSort="true">部门名称</div>
                <div field="subject_name" width="120" align="right" headerAlign="center" allowSort="true">科目名称</div>
                <div field="budget_amount" width="90" align="right" headerAlign="center" allowSort="true">预算金额(万元)</div>
                <div field="expense_amount" width="90" align="right" headerAlign="center" allowSort="true">支出金额(万元)</div>
                <div field="remain_amount" width="90" align="right" headerAlign="center" allowSort="true">剩余金额(万元)</div>
                <div field="retain_switch" width="90" align="center" headerAlign="center" allowSort="true">月度预算可结转</div>
                <div field="force_switch" width="90" align="center" headerAlign="center" allowSort="true">强制执行月度预算</div>
<!--                 <div field="budget_status" width="60" align="center" headerAlign="center" allowSort="true">预算状态</div> -->
                <div field="update_time" width="120" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">更新时间</div>
            </div>
        </div>
    </div>
	
	
<script type="text/javascript">
	mini.parse();
	
	var year_search = mini.get("year_search");
    year_search.select(0); //默认选中第一个选择项
    var department_id_search = mini.get("department_id_search");
    var subject_id_search = mini.get("subject_id_search");
//     var budget_status_search = mini.get("budget_status_search");
	
	var grid = mini.get("grid");
	searchByParams();
// 	grid.load(null, null, gridLoadFail);
	
	function onDrawCell(e){
	    var record = e.record;
	    var value = e.value;
	    if(value == null) value = "";
        
        if(e.field == 'budget_status'){
            for(i in statusArr){
                if(statusArr[i].id == value) e.cellHtml = "<span style='color:"+ statusArr[i].color +";'>" + statusArr[i].text +"</span>";
            }
        }
        
        if(e.field == 'retain_switch'){
            for(i in statusArr){
                if(switchArr[i].id == value) e.cellHtml = "<span style='color:"+ switchArr[i].color +";'>" + switchArr[i].text +"</span>";
            }
        }
        
        if(e.field == 'force_switch'){
            for(i in switchArr){
                if(switchArr[i].id == value) e.cellHtml = "<span style='color:"+ switchArr[i].color +";'>" + switchArr[i].text +"</span>";
            }
        }

	    if(e.field == 'budget_amount' || e.field == 'expense_amount' || e.field == 'remain_amount') {
	        if(e.field == 'expense_amount') e.cellHtml = "<span style='color:red;font-weight:bold;'>-" + value/1000000 +"</span>";
	        else e.cellHtml = value/1000000; 
// 	        e.cellHtml = (value/1000000).toFixed(2);
	    }
	}
	
	function searchByParams(){
		grid.load({
			year_num: year_search.getFormValue(),
			department_id: department_id_search.getFormValue(),
			subject_id: subject_id_search.getFormValue()
// 			budget_status: budget_status_search.getFormValue() // 除分页排序参数外的额外参数
	    }, null, gridLoadFail);
	}
	
	function resetALLParams(){
		year_search.setValue('');
		department_id_search.setValue('');
		department_id_search.setText('');
		subject_id_search.setValue('');
// 		budget_status_search.setValue('');
	}
	
	function openDetailWindow(action){
		var row = grid.getSelected();
        if(row || action == 'create'){
            mini.open({
                url: '${ctx}/portal/budget/year/showDetailWindow.json',
                title: "详情", width: 330, height: 450,
                onload: function(){
                    var iframe = this.getIFrameEl();
                    var data = { action: action, row: row };
                    iframe.contentWindow.SetData(data);
                },
                ondestroy: function(action){
//                 	console.info(this.getIFrameEl().contentWindow.GetData()); //调用子页面 GetData 方法
                	if(action == "ok"){
                    	grid.reload();
    	            	notifyOnBottomRight("操作成功!");
    	            }
                }
            });
        }else{
        	mini.alert("请选中一条记录");
        }
	}
	
	function deleteById(){
		var row = grid.getSelected();
		if(row){
			mini.confirm("确定删除该用户?", "确定?", function(action){
	            if(action == "ok"){
	            	showMask();
	            	$.post("${ctx}/portal/budget/special/deleteById.do?", {user_id: row.user_id}, function(data){
	            		hideMask();
	            		if(data == true){
	            			grid.reload();
	            			notifyOnBottomRight("操作成功!");
	            		}else{
	            			notifyOnBottomRight("操作失败!");
	            		}
	            	});
	            }
	        });
        }else{
        	mini.alert("请选中一条记录");
        }
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