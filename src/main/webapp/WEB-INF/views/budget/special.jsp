<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<title>专项预算管理</title>
	<jsp:include page="/easyui.jsp" />
	<style type="text/css">
		html, body{ margin:0; padding:0; border:0; width:100%; height:100%; overflow:hidden; }
    </style>
</head>
<body>
	<div style="padding-bottom:5px;">
        <span>&nbsp;&nbsp;专项预算名称：</span>
            <input class="mini-textbox" type="text" id="budget_special_name_search" />
<!-- 		<span>&nbsp;&nbsp;机构名称：</span> -->
<!--         <input id="org_id_search" class="mini-combobox" textField="org_name" valueField="org_id" allowInput="true" style="width:150px;" -->
<%-- 			url="${ctx}/check/all/getOrgList.json" onenter="searchByParams()" showNullItem="true"/> --%>
<!-- 		<span>&nbsp;&nbsp;用户状态：</span> -->
<!-- 		<input id="user_status_search" class="mini-combobox" textField="text" valueField="id" allowInput="false" value="" -->
<!-- 			data="[{id:'', text:'全部'}, {id:'1', text:'有效'}, {id:'0', text:'无效'}]" /> -->
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <a class="mini-button" iconCls="icon-search" onclick="searchByParams()">查找</a>&nbsp;&nbsp;
        <a class="mini-button" iconCls="icon-reload" onclick="resetALLParams()">重置</a>
    </div>
    
	<div class="mini-toolbar" style="border-bottom:0;padding:0px;">
	    <table style="width:100%;">
	        <tr>
	            <td style="width:100%;">
	                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('create')">新增专项预算</a>
<!-- 	                <a class="mini-button" iconCls="icon-edit" onclick="openDetailWindow('update')">修改专项预算</a> -->
<!-- 	                <a class="mini-button" iconCls="icon-remove" onclick="deleteById()">删除专项预算</a> -->
                    <a class="mini-button" iconCls="icon-expand" onclick="bindOrgs()">预算适用部门</a>
	            </td>
	        </tr>
	    </table>           
	</div>
	
    <div class="mini-fit" >
	    <div id="grid" class="mini-datagrid" style="width:100%;height:100%;" allowResize="true" ondrawcell="onDrawCell"
	        url="${ctx}/portal/budget/special/selectAll.json" idField="budget_special_id" multiSelect="true" pageSize=50>
	        <div property="columns">
	        	<div type="indexcolumn"></div>
	            <div field="budget_special_name" width="120" align="center" headerAlign="center" allowSort="true">专项预算名称</div>
	            <div field="budget_special_amount" width="120" align="center" headerAlign="center" allowSort="true">专项预算金额(万)</div>
	            <div field="expense_amount" width="120" align="center" headerAlign="center" allowSort="true">支出金额(万元)</div>
                <div field="remain_amount" width="120" align="center" headerAlign="center" allowSort="true">剩余金额(万元)</div>
	            <div field="start_time" width="120" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd">启用时间</div>
	            <div field="end_time" width="120" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd">停用时间</div>
	            <div field="remark" width="120" align="center" headerAlign="center" allowSort="true">备注</div>
	            <div field="operate" width="60" align="center" headerAlign="center" allowSort="true">操作</div>
	        </div>
	    </div>
    </div>
    
	
<script type="text/javascript">
	mini.parse();
	var grid = mini.get("grid");
	grid.load(null, null, gridLoadFail);
	
	function onDrawCell(e){
	    var record = e.record;
	    var value = e.value;
	    if(value == null) value = "";
	    
// 	    if(e.field == 'user_status'){
// 	    	for(i in statusArr){
// 				if(statusArr[i].id == value) e.cellHtml = "<span style='color:"+ statusArr[i].color +";'>" + statusArr[i].text +"</span>";
// 			}
// 	    }

// 	    if(e.field == 'role_id'){
// 	    	for(i in roleArr){
// 				if(roleArr[i].id == value) e.cellHtml = roleArr[i].text;
// 			}
// 	    }

	    if(e.field == 'budget_special_amount' || e.field == 'expense_amount' || e.field == 'remain_amount') {
	        if(e.field == 'expense_amount') e.cellHtml = "<span style='color:red;font-weight:bold;'>-" + value/1000000 +"</span>";
	        else e.cellHtml = value/1000000; 
// 	        e.cellHtml = (value/1000000).toFixed(2);
	    }
	    if(e.field == 'operate') e.cellHtml = '<a class="mini-button" style="width:40px;" onclick=openDetailWindow("detail")>详情</a>';
	}
	
	var budget_special_name_search = mini.get("budget_special_name_search");
	
	function searchByParams(){
		grid.load({
			budget_special_name: budget_special_name_search.getFormValue()
// 			user_status: user_status_search.getFormValue() // 除分页排序参数外的额外参数
	    }, null, gridLoadFail);
	}
     
	function resetALLParams(){
		budget_special_name_search.setValue('');
	}
	
	function openDetailWindow(action){
		var row = grid.getSelected();
        if(row || action == 'create'){
            mini.open({
                url: '${ctx}/portal/budget/special/showDetailWindow.json',
                title: "详情", width: 630, height: 420,
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
	
	function bindOrgs(){
        var row = grid.getSelected();
        if(row){
        	mini.open({
                url: '${ctx}/portal/budget/special/showOrgs.json',
                title: "详情", width: 300, height: 600,
                onload: function(){
                    var iframe = this.getIFrameEl();
                    var data = { action: "edit", row: row };
                    iframe.contentWindow.SetData(data);
                },
                ondestroy: function(action){
                    if(action == "ok"){
//                     	var data = this.getIFrameEl().contentWindow.GetData();//调用子页面 GetData 方法
//                         data = mini.clone(data);
                        notifyOnBottomRight("操作成功!");
                    }
                }
            });
        }else{
            mini.alert("请选中一条记录");
        }
    }
	
</script>
</body>
</html>