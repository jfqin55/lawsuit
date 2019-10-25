<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<title>科目管理</title>
	<jsp:include page="/easyui.jsp" />
	<style type="text/css">
		html, body{ margin:0; padding:0; border:0; width:100%; height:100%; overflow:hidden; }
    </style>
</head>
<body>
	<div style="padding-bottom:5px;">
        <span>&nbsp;&nbsp;科目名称：</span>
            <input class="mini-textbox" type="text" id="subject_name_search" style="width:100px;"/>
<!-- 		<span>&nbsp;&nbsp;机构名称：</span> -->
<!--         <input id="org_id_search" class="mini-combobox" textField="org_name" valueField="org_id" allowInput="true" style="width:150px;" -->
<%-- 			url="${ctx}/check/all/getOrgList.json" onenter="searchByParams()" showNullItem="true"/> --%>
		<span>&nbsp;&nbsp;科目状态：</span>
		<input id="subject_status_search" class="mini-combobox" textField="text" valueField="id" allowInput="false" value="" style="width:60px;"
			data="[{id:'', text:'全部'}, {id:'1', text:'有效'}, {id:'0', text:'无效'}]" />
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <a class="mini-button" iconCls="icon-search" onclick="searchByParams()">查找</a>&nbsp;&nbsp;
        <a class="mini-button" iconCls="icon-reload" onclick="resetALLParams()">重置</a>
    </div>
    
	<div class="mini-toolbar" style="border-bottom:0;padding:0px;">
	    <table style="width:100%;">
	        <tr>
	            <td style="width:100%;">
	                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('create')">新增科目</a>
	                <a class="mini-button" iconCls="icon-edit" onclick="openDetailWindow('update')">修改科目</a>
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
	        url="${ctx}/admin/subject/selectAll.json" idField="subject_id" multiSelect="true" pageSize=100>
	        <div property="columns">
	        	<div type="indexcolumn"></div>
	            <div field="subject_name" width="120" align="center" headerAlign="center" allowSort="true">科目名称</div>
	            <div field="subject_status" width="60" align="center" headerAlign="center" allowSort="true">科目状态</div>
	            <div field="requird_info" width="480" align="left" headerAlign="center" allowSort="true">费用申报所需资料</div>
	            <div field="retain_switch" width="120" align="center" headerAlign="center" allowSort="true">月度预算可结转</div>
	            <div field="force_switch" width="120" align="center" headerAlign="center" allowSort="true">强制执行月度预算</div>
	            <div field="create_time" width="160" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">创建时间</div>
	            <div field="update_time" width="160" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">更新时间</div>
	        </div>
	    </div>
    </div>
    
	
<script type="text/javascript">
	mini.parse();
	var grid = mini.get("grid");
	grid.load(null, null, gridLoadFail);
//  grid.set({
//      data:record.rows
//  });
	
	function onDrawCell(e){
	    var record = e.record;
	    var value = e.value;
	    if(value == null) value = "";
	    
	    if(e.field == 'subject_status'){
	    	for(i in statusArr){
				if(statusArr[i].id == value) e.cellHtml = "<span style='color:"+ statusArr[i].color +";'>" + statusArr[i].text +"</span>";
			}
	    }
	    
	    if(e.field == 'retain_switch'){
            for(i in switchArr){
                if(switchArr[i].id == value) e.cellHtml = "<span style='color:"+ switchArr[i].color +";'>" + switchArr[i].text +"</span>";
            }
        }
	    
	    if(e.field == 'force_switch'){
            for(i in switchArr){
                if(switchArr[i].id == value) e.cellHtml = "<span style='color:"+ switchArr[i].color +";'>" + switchArr[i].text +"</span>";
            }
        }
	}
	
	var subject_name_search = mini.get("subject_name_search");
	var subject_status_search = mini.get("subject_status_search");
	
	function searchByParams(){
		grid.load({
			subject_name: subject_name_search.getFormValue(),
			subject_status: subject_status_search.getFormValue() // 除分页排序参数外的额外参数
	    }, null, gridLoadFail);
	}
     
	function resetALLParams(){
		subject_name_search.setValue('');
		subject_status_search.setValue('');
	}
	
	function openDetailWindow(action){
		var row = grid.getSelected();
        if(row || action == 'create'){
            mini.open({
                url: '${ctx}/admin/subject/showDetailWindow.json',
                title: "详情", width: 600, height: 270,
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
	            	$.post("${ctx}/admin/subject/deleteById.do?", {user_id: row.user_id}, function(data){
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