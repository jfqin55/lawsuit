<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<title>借款类型管理</title>
	<jsp:include page="/easyui.jsp" />
	<style type="text/css">
		html, body{ margin:0; padding:0; border:0; width:100%; height:100%; overflow:hidden; }
    </style>
</head>
<body>
	<div style="padding-bottom:5px;">
        <span>&nbsp;&nbsp;借款类型名称：</span>
            <input class="mini-textbox" type="text" id="borrow_type_name_search" style="width:100px;"/>
<!-- 		<span>&nbsp;&nbsp;机构名称：</span> -->
<!--         <input id="org_id_search" class="mini-combobox" textField="org_name" valueField="org_id" allowInput="true" style="width:150px;" -->
<%-- 			url="${ctx}/check/all/getOrgList.json" onenter="searchByParams()" showNullItem="true"/> --%>
		<span>&nbsp;&nbsp;借款类型状态：</span>
		<input id="borrow_type_status_search" class="mini-combobox" textField="text" valueField="id" allowInput="false" value="" style="width:60px;"
			data="[{id:'', text:'全部'}, {id:'1', text:'有效'}, {id:'0', text:'无效'}]" />
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <a class="mini-button" iconCls="icon-search" onclick="searchByParams()">查找</a>&nbsp;&nbsp;
        <a class="mini-button" iconCls="icon-reload" onclick="resetALLParams()">重置</a>
    </div>
    
	<div class="mini-toolbar" style="border-bottom:0;padding:0px;">
	    <table style="width:100%;">
	        <tr>
	            <td style="width:100%;">
	                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('create')">新增借款类型</a>
	                <a class="mini-button" iconCls="icon-edit" onclick="openDetailWindow('update')">修改借款类型</a>
<!-- 	                <a class="mini-button" iconCls="icon-remove" onclick="deleteById()">删除专项预算</a> -->
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
	        url="${ctx}/portal/borrowType/selectAll.json" idField="borrow_type_id" multiSelect="true" pageSize=100>
	        <div property="columns">
	        	<div type="indexcolumn"></div>
	            <div field="borrow_type_name" width="120" align="center" headerAlign="center" allowSort="true">借款类型名称</div>
	            <div field="subject_name" width="60" align="center" headerAlign="center" allowSort="true">关联科目</div>
	            <div field="refund_account" width="120" align="center" headerAlign="center" allowSort="true">还款账号</div>
	            <div field="borrow_type_status" width="60" align="center" headerAlign="center" allowSort="true">借款类型状态</div>
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
	    
	    if(e.field == 'borrow_type_status'){
	    	for(i in statusArr){
				if(statusArr[i].id == value) e.cellHtml = "<span style='color:"+ statusArr[i].color +";'>" + statusArr[i].text +"</span>";
			}
	    }
	    
	    if(e.field == 'budget_switch'){
            for(i in switchArr){
                if(switchArr[i].id == value) e.cellHtml = "<span style='color:"+ switchArr[i].color +";'>" + switchArr[i].text +"</span>";
            }
        }
	    
	}
	
	var borrow_type_name_search = mini.get("borrow_type_name_search");
	var borrow_type_status_search = mini.get("borrow_type_status_search");
	
	function searchByParams(){
		grid.load({
			borrow_type_name: borrow_type_name_search.getFormValue(),
			borrow_type_status: borrow_type_status_search.getFormValue() // 除分页排序参数外的额外参数
	    }, null, gridLoadFail);
	}
     
	function resetALLParams(){
		borrow_type_name_search.setValue('');
		borrow_type_status_search.setValue('');
	}
	
	function openDetailWindow(action){
		var row = grid.getSelected();
        if(row || action == 'create'){
            mini.open({
                url: '${ctx}/portal/borrowType/showDetailWindow.json',
                title: "详情", width: 600, height: 200,
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
	            	$.post("${ctx}/portal/borrowType/deleteById.do?", {user_id: row.user_id}, function(data){
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