<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<title>系统角色管理</title>
	<jsp:include page="/easyui.jsp" />
	<style type="text/css">
		html, body{ margin:0; padding:0; border:0; width:100%; height:100%; overflow:hidden; }
    </style>
</head>
<body>
	<div style="padding-bottom:5px;">
<!--         <span>&nbsp;&nbsp;科目名称：</span> -->
<!--         <input class="mini-textbox" type="text" id="subject_name_search" /> -->
<!-- 		 <span>&nbsp;&nbsp;机构名称：</span> -->
<!--         <input id="org_id_search" class="mini-combobox" textField="org_name" valueField="org_id" allowInput="true" style="width:150px;" -->
<%-- 			url="${ctx}/check/all/getOrgList.json" onenter="searchByParams()" showNullItem="true"/> --%>
		<span>&nbsp;&nbsp;角色名称：</span>
		<input id="role_name_search" class="mini-combobox" textField="text" valueField="id" allowInput="false" style="width:150px;"
			data="[{id:'', text:'全部'}, {id:'0', text:'系统管理员'}, {id:'1', text:'预算管理员'}, {id:'2', text:'一级支行分管财务行长'}, {id:'3', text:'市行财务部审核岗'}
			     , {id:'4', text:'市行财务部出纳岗'}, {id:'5', text:'一级支行财务审核岗'}, {id:'6', text:'县行财务部审核岗'}, {id:'7', text:'县行财务部出纳岗'}]" />
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <a class="mini-button" iconCls="icon-search" onclick="searchByParams()">查找</a>&nbsp;&nbsp;
        <a class="mini-button" iconCls="icon-reload" onclick="resetALLParams()">重置</a>
    </div>
    
	<div class="mini-toolbar" style="border-bottom:0;padding:0px;">
	    <table style="width:100%;">
	        <tr>
	            <td style="width:100%;">
	                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('create')">新增系统角色</a>
	                <a class="mini-button" iconCls="icon-edit" onclick="openDetailWindow('update')">修改系统角色</a>
	                <a class="mini-button" iconCls="icon-remove" onclick="deleteById()">删除系统角色</a>
	            </td>
                <td style="white-space:nowrap;">
<!--                      <div id="cbl1" class="mini-checkboxlist" repeatItems="3" repeatLayout="table" -->
<!--                         textField="text" valueField="id" data="[{id:'1', text:'所有科目月度预算可结转'}, {id:'2', text:'所有科目强制执行月度预算'}]" > -->
<!--                     </div> -->
                </td>
	        </tr>
	    </table>           
	</div>
	
    <div class="mini-fit" >
	    <div id="grid" class="mini-datagrid" style="width:100%;height:100%;" allowResize="true" ondrawcell="onDrawCell"
	        url="${ctx}/admin/role/selectAll.json" idField="user_role_id" multiSelect="true" pageSize=100>
	        <div property="columns">
	        	<div type="indexcolumn"></div>
	            <div field="role_id" width="80" align="center" headerAlign="center" allowSort="true">角色名称</div>
	            <div field="user_name" width="80" align="center" headerAlign="center" allowSort="true">用户姓名</div>
	            <div field="org_name" width="160" align="center" headerAlign="center" allowSort="true">所属单位</div>
	            <div field="department_name" width="80" align="center" headerAlign="center" allowSort="true">所属部门</div>
	            <div field="create_time" width="120" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">创建时间</div>
	            <div field="update_time" width="120" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">更新时间</div>
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
	    
	    if(e.field == 'role_id'){
	    	for(i in roleArr){
				if(roleArr[i].id == value) e.cellHtml = roleArr[i].text;
			}
	    }
	    
	}
	
	var role_name_search = mini.get("role_name_search");
	
	function searchByParams(){
		grid.load({
			role_id: role_name_search.getFormValue() // 除分页排序参数外的额外参数
	    }, null, gridLoadFail);
	}
     
	function resetALLParams(){
		role_name_search.setValue('');
	}
	
	function openDetailWindow(action){
		var row = grid.getSelected();
        if(row || action == 'create'){
            mini.open({
                url: '${ctx}/admin/role/showDetailWindow.json',
                title: "详情", width: 300, height: 300,
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
			mini.confirm("确定删除该记录?", "确定?", function(action){
	            if(action == "ok"){
	            	showMask();
	            	$.post("${ctx}/admin/role/deleteById.do?", {user_role_id: row.user_role_id}, function(data){
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
	
</script>
</body>
</html>