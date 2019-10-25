<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<title>用户管理</title>
	<jsp:include page="/easyui.jsp" />
	<style type="text/css">
		html, body{ margin:0; padding:0; border:0; width:100%; height:100%; overflow:hidden; }
    </style>
</head>
<body>
	<div style="padding-bottom:5px;">
		<span>&nbsp;&nbsp;机构名称：</span>
        <input id="org_id_search" class="mini-combobox" textField="org_name" valueField="org_id" allowInput="true" style="width:150px;"
			url="${ctx}/check/all/getOrgList.json" onenter="searchByParams()" showNullItem="true"/>
		<span>&nbsp;&nbsp;用户状态：</span>
		<input id="user_status_search" class="mini-combobox" textField="text" valueField="id" allowInput="false" value=""
			data="[{id:'', text:'全部'}, {id:'1', text:'有效'}, {id:'0', text:'无效'}]" />
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <a class="mini-button" iconCls="icon-search" onclick="searchByParams()">查找</a>&nbsp;&nbsp;
        <a class="mini-button" iconCls="icon-reload" onclick="resetALLParams()">重置</a>
    </div>
    
	<div class="mini-toolbar" style="border-bottom:0;padding:0px;">
	    <table style="width:100%;">
	        <tr>
	            <td style="width:100%;">
	                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('create')">创建用户</a>
	                <a class="mini-button" iconCls="icon-edit" onclick="openDetailWindow('update')">修改用户</a>
	                <a class="mini-button" iconCls="icon-remove" onclick="deleteById()">删除商户</a>
	            </td>
	        </tr>
	    </table>           
	</div>
	
    <div class="mini-fit" >
	    <div id="grid" class="mini-datagrid" style="width:100%;height:100%;" allowResize="true" ondrawcell="onDrawCell"
	        url="${ctx}/user/selectAll.json" idField="user_id" multiSelect="true" pageSize=50>
	        <div property="columns">
	        	<div type="indexcolumn"></div>
	            <div field="org_name" width="120" align="center" headerAlign="center" allowSort="true">机构名称</div>
	            <div field="username" width="120" align="center" headerAlign="center" allowSort="true">用户名</div>
	            <div field="password" width="120" align="center" headerAlign="center" allowSort="true">密码</div>
	            <div field="user_status" width="60" align="center" headerAlign="center" allowSort="true">用户状态</div>
	            <div field="role_id" width="120" align="center" headerAlign="center" allowSort="true">用户角色</div>
	            <div field="update_time" width="120" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">更新时间</div>
	        </div>
	    </div>
    </div>
    
	
<script type="text/javascript">
	mini.parse();
	var grid = mini.get("grid");
	grid.load(null, null, gridLoadFail);
	var org_id_search = mini.get("org_id_search");
	var user_status_search = mini.get("user_status_search");
	
	function onDrawCell(e){
	    var record = e.record;
	    var value = e.value;
	    if(value == null) value = "";
	    
	    if(e.field == 'user_status'){
	    	for(i in statusArr){
				if(statusArr[i].id == value) e.cellHtml = "<span style='color:"+ statusArr[i].color +";'>"+ statusArr[i].text +"</span>";
			}
	    }
	    
	    if(e.field == 'role_id'){
	    	for(i in roleArr){
				if(roleArr[i].id == value) e.cellHtml = roleArr[i].text;
			}
	    }
	}
	
	function searchByParams(){
		grid.load({
			org_id: org_id_search.getFormValue(),
			user_status: user_status_search.getFormValue() // 除分页排序参数外的额外参数
	    }, null, gridLoadFail);
	}
     
	function resetALLParams(){
		org_id_search.setValue('');
		user_status_search.setValue('');
	}
	
	function openDetailWindow(action){
		var row = grid.getSelected();
        if(row || action == 'create'){
            mini.open({
                url: '${ctx}/user/showDetailWindow.json',
                title: "用户详情", width: 300, height: 250,
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
	            	$.post("${ctx}/user/deleteById.do?", {user_id: row.user_id}, function(data){
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