<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<title>审批流程管理</title>
	<jsp:include page="/easyui.jsp" />
	<style type="text/css">
		html, body{ margin:0; padding:0; border:0; width:100%; height:100%; overflow:hidden; }
    </style>
</head>
<body>
	<div style="padding-bottom:5px;">
<!--         <span>&nbsp;&nbsp;审批流程名称：</span> -->
<!--             <input class="mini-textbox" type="text" id="budget_special_name_search" /> -->
<!-- 		<span>&nbsp;&nbsp;机构名称：</span> -->
<!--         <input id="org_id_search" class="mini-combobox" textField="org_name" valueField="org_id" allowInput="true" style="width:150px;" -->
<%-- 			url="${ctx}/check/all/getOrgList.json" onenter="searchByParams()" showNullItem="true"/> --%>
		<span>&nbsp;&nbsp;流程状态：</span>
		<input id="flow_status_search" class="mini-combobox" textField="text" valueField="id" allowInput="false" value=""
			data="[{id:'', text:'全部'}, {id:'1', text:'启用'}, {id:'0', text:'停用'}]" />
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <a class="mini-button" iconCls="icon-search" onclick="searchByParams()">查找</a>&nbsp;&nbsp;
        <a class="mini-button" iconCls="icon-reload" onclick="resetALLParams()">重置</a>
    </div>
    
	<div class="mini-toolbar" style="border-bottom:0;padding:0px;">
	    <table style="width:100%;">
	        <tr>
	            <td style="width:100%;">
	                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('create')">新增流程</a>
	                <a class="mini-button" iconCls="icon-edit" onclick="openDetailWindow('update')">修改流程</a>
<!-- 	                <a class="mini-button" iconCls="icon-remove" onclick="deleteById()">删除专项预算</a> -->
                    <a class="mini-button" iconCls="icon-expand" onclick="bindOrgs()">流程适用部门</a>
	            </td>
	        </tr>
	    </table>           
	</div>
	
    <div class="mini-fit" >
	    <div id="grid" class="mini-datagrid" style="width:100%;height:100%;" allowResize="true" ondrawcell="onDrawCell"
	        url="${ctx}/admin/flow/selectAll.json" idField="check_flow_id" multiSelect="true" pageSize=50>
	        <div property="columns">
	        	<div type="indexcolumn"></div>
	            <div field="min_amount" width="120" align="center" headerAlign="center" allowSort="true">最低适用金额(元)</div>
	            <div field="flow_desc" width="480" align="left" headerAlign="center" allowSort="true">流程描述</div>
	            <div field="requied_file" width="240" align="left" headerAlign="center" allowSort="true">所需批文</div>
                <div field="flow_status" width="60" align="center" headerAlign="center" allowSort="true">流程状态</div>
	            <div field="remark" width="120" align="right" headerAlign="center" allowSort="true">备注</div>
	            <div field="create_time" width="160" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">创建时间</div>
	            <div field="update_time" width="160" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">更新时间</div>
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
	    
	    if(e.field == 'flow_status'){
	    	for(i in switchArr){
				if(switchArr[i].id == value) e.cellHtml = "<span style='color:"+ switchArr[i].color +";'>" + switchArr[i].text +"</span>";
			}
	    }

// 	    if(e.field == 'role_id'){
// 	    	for(i in roleArr){
// 				if(roleArr[i].id == value) e.cellHtml = roleArr[i].text;
// 			}
// 	    }

	    if(e.field == 'min_amount') {
	        e.cellHtml = value/100; 
// 	        e.cellHtml = (value/1000000).toFixed(2);
	    }
// 	    if(e.field == 'file_url') e.cellHtml = '<a href="' + value + '" target="_blank">' + value + '</a>';
	}
	
	var flow_status_search = mini.get("flow_status_search");
	
	function searchByParams(){
		grid.load({
			flow_status: flow_status_search.getFormValue() // 除分页排序参数外的额外参数
	    }, null, gridLoadFail);
	}
     
	function resetALLParams(){
		flow_status_search.setValue('');
	}
	
	function openDetailWindow(action){
		var row = grid.getSelected();
        if(row || action == 'create'){
            mini.open({
                url: '${ctx}/admin/flow/showDetailWindow.json',
                title: "详情", width: 600, height: 330,
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
	            	$.post("${ctx}/admin/flow/deleteById.do?", {user_id: row.user_id}, function(data){
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
                url: '${ctx}/admin/flow/showOrgs.json',
                title: "详情", width: 330, height: 600,
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