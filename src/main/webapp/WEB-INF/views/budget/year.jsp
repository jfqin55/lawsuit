<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<title>年度预算管理</title>
	<jsp:include page="/easyui.jsp" />
	<style type="text/css">
		html, body{ margin:0; padding:0; border:0; width:100%; height:100%; overflow:hidden; }
    </style>
</head>
<body>
<%--	<div style="padding-bottom:5px;">
		<span>&nbsp;&nbsp;机构名称：</span>
		<input id="key" class="mini-textbox" style="width:150px;" onenter="onKeyEnter"/>
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <a class="mini-button" iconCls="icon-search" onclick="onKeyEnter">查找</a>&nbsp;&nbsp;
        <a class="mini-button" iconCls="icon-reload" onclick="resetALLParams()">重置</a>
    </div>
    
	<div class="mini-toolbar" style="border-bottom:0;padding:0px;">
	    <table style="width:100%;">
	        <tr>
	            <td style="width:100%;">
	                <a class="mini-button" iconCls="icon-add" onclick="openDetailWindow('create')">创建用户</a>
	                <a class="mini-button" iconCls="icon-edit" onclick="openDetailWindow('update')">修改年度预算</a>
	                <a class="mini-button" iconCls="icon-remove" onclick="deleteById()">删除商户</a>
	            </td>
	        </tr>
	    </table>           
	</div>
	
    <div class="mini-fit" >
        <div id="treegrid" class="mini-treegrid" style="width:50%;height:100%;"     
<%--             url="${ctx}/portal/budget/year/getOrgBudgetTree.json" idField="id" parentField="pid"  
            showTreeIcon="true" treeColumn="xxx"  resultAsTree="false" ondrawcell="onDrawCell" expandOnLoad="true"
<%--              onnodedblclick="onNodeDblClick" expandOnDblClick="false" ondrawnode="onDrawNode" 
<!--             > -->
            <div property="columns">
<!--                 <div type="indexcolumn"></div> -->
                <div name="xxx" field="text" width="120" headerAlign="center">机构部门科目名称</div>
                <div field="budget_amount" width="120" headerAlign="center">预算额度</div>
            </div>
        </div>
    </div>--%>
    
    <div class="mini-fit" >
    <div class="mini-splitter" style="width:100%;height:100%;">
    
        <div size="23%" showCollapseButton="true">
            <div class="mini-toolbar" style="text-align:center;border-left:0;border-top:0;border-right:0;padding:3px;">
		          <label>机构名称：</label>
		          <input id="key" class="mini-textbox" style="width:120px;" onenter="onKeyEnter"/>
		          <a class="mini-button" style="width:60px;" onclick="onKeyEnter">查询</a>
		    </div>
<!--             <div style="font-size:14px;font-family:'黑体';height:21px;text-align:center;border-bottom: 1px solid blue;">请选中下方节点,点击鼠标右键,然后按提示操作</div> -->
            <div class="mini-fit" >
            <div id="tree" class="mini-tree" style="width:100%;height:100%;"  url="${ctx}/portal/budget/year/getOrgTree.json" showTreeIcon="true" 
                textField="text" idField="id" parentField="pid" resultAsTree="false" allowResize="true" expandOnLoad="false" contextMenu="#treeMenu"
                onnodeclick="onNodeClick" onendedit="onEndEdit" allowDrag="true" allowDrop="true" ondrawnode="onDrawNode" ondrop="onDrop">
            </div>
            </div>
        </div>
        
        
        <div showCollapseButton="true">
    		    
		    <div class="mini-toolbar" style="border:0;padding:0px;">
		        <table style="width:100%;">
		            <tr>
		                <td style="width:100%;">
                            <a class="mini-button" iconCls="icon-save" id="saveBudgets" onclick="saveBudgets">保存</a>  
		                </td>
		                <td style="white-space:nowrap;">
                            <div style="font-size:14px;font-family:'黑体';height:21px;text-align:center;border-bottom: 0px solid blue;margin-right:3px;">选中某个机构,点击下方单元格可修改预算金额</div>
<!--                             <div id="cbl1" class="mini-checkboxlist" repeatItems="3" repeatLayout="table" -->
<!-- 						        textField="text" valueField="id" value="1,2"  -->
<!-- 						        data="[{id:'1', text:'强制执行月度预算'}, {id:'2', text:'月度预算可结转'}]" > -->
<!-- 						    </div> -->
	                    </td>
		            </tr>
		        </table>           
		    </div>
		    
		    <div class="mini-fit">
		        <div id="grid" class="mini-datagrid" style="width:100%;height:100%;" allowResize="true" ondrawcell="onDrawCell"
		            url="${ctx}/portal/budget/year/selectAll.json" idField="budget_id" multiSelect="true" sizeList=[100] pageSize=100
		            allowCellValid="true" oncellvalidation="onCellValidation" allowAlternating="true"
		            allowCellEdit="true" allowCellSelect="true" editNextOnEnterKey="true"  editNextRowCell="true"
		            >
		            <div property="columns">
		                <div type="indexcolumn"></div>
		                <div field="year_num" width="120" align="center" headerAlign="center" allowSort="true">预算年度</div>
		                <div field="subject_name" width="120" align="center" headerAlign="center" allowSort="true">科目名称</div>
		                <div field="budget_amount" width="120" align="center" headerAlign="center" allowSort="true" vtype="float">预算金额(万元)
		                    <input property="editor" class="mini-textbox" vtype="float" style="width:100%;"/>
		                </div>
		                <div field="expense_amount" width="120" align="center" headerAlign="center" allowSort="true">支出金额(万元)</div>
		                <div field="remain_amount" width="120" align="center" headerAlign="center" allowSort="true">剩余金额(万元)</div>
		                <div field="update_time" width="120" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">更新时间</div>
		            </div>
		        </div>
		    </div>
		    
<%--            <fieldset id="form" style="width:500px;margin:auto;margin-top:5%">
                <legend><span>机构详情</span></legend>
                <form id="detailForm" method="post">
                    <div class="form" >
                        <input class="mini-hidden" id="type_id" />
                        <input class="mini-hidden" name="pid" id="parent_id" />
                        <table style="width:100%;margin-top:7px;">
                            <tr>
                                <td align="right" width="170px"><label>机构名称：</label></td>
                                <td><input name="text"  class="mini-textbox" required="true" style="width: 150px;" />
                            </tr>
                            <tr height="7px;"></tr>
                            <tr>
                                <td align="right" width="170px"><label>机构编号：</label></td>
                                <td><input id="department_id" name="id" class="mini-textbox" required="true" style="width: 150px;" />
                            </tr>
                            <tr height="7px;"></tr>
                            <tr>
                                <td align="right" width="100px"><label>备注：</label></td>
                                <td><input name="remark" class="mini-textbox" style="width: 150px;" /></td>
                            </tr>
                            <tr>
                                <td colspan="2" style="padding-top: 17px;" align="center">
                                    <a class="mini-button" id="saveChangesButton" enabled="false" onclick="onOk" style="width:60px;">保存</a>       
<!--                                    <a class="mini-button" onclick="onCancel" style="width:60px;">取消</a>    -->
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
            </fieldset>--%>
        </div>        
    </div>
    </div>
    
    <ul id="treeMenu" class="mini-contextmenu"  onbeforeopen="onBeforeOpen">        
<!--        <li iconCls="icon-move" onclick="onMoveNode">移动节点</li> -->
        <li name="add" iconCls="icon-add" onclick="onAddAfter">新增机构</li>
        <li name="addChild" iconCls="icon-add" onclick="onAddNode">新增子机构</li>
        <li name="edit" iconCls="icon-edit" onclick="onEditNode">修改机构名称</li>
        <li name="remove" iconCls="icon-remove" onclick="onRemoveNode">删除机构</li>
    </ul>
    
	
<script type="text/javascript">
	mini.parse();
	
// 	var treegrid = mini.get("treegrid");
//     $.post("${ctx}/portal/budget/year/getOrgBudgetTree.json", {}, function(data) {
//     	treegrid.loadList(data, "id", "pid");
//     });
    
//     function onDrawNode(e) {
// //         var patternPhone = /^1\d{10,10}$/;
//         var tree = e.sender;
//         var node = e.node;

//         var isLeaf = tree.isLeaf(node);
//         //所有子节点加上超链接
// //         if (isLeaf == true) {
// //             e.nodeHtml = '<a href="http://www.miniui.com/docs/api/' + node.id + '.html" target="_blank">' + node.text + '</a>';
// //         }
//         //父节点高亮显示；子节点斜线、蓝色、下划线显示
// //         if (isLeaf == false) {
// //             e.nodeStyle = 'font-weight:bold;';
// //         } else {
// //             e.nodeStyle = "font-style:italic;"; //nodeStyle
// //             e.nodeCls = "blueColor";            //nodeCls
// //         }
//         //修改默认的父子节点图标
//         if(isLeaf) {
//             e.iconCls = "icon-department";
// //             if(node.text) e.nodeHtml =  (node.text/100).toFixed(2);
//         }
// //         if (isLeaf == false) e.showCheckBox = false; //父节点的CheckBox全部隐藏
//     }
    
//     function onNodeDblClick(e) {
//     	var node = treegrid.getSelectedNode();
//     	if (!node) {
//             mini.alert("请选择一个机构");
//             return;
//         }
//     }
    
// 	function onDrawCell(e){
// 	    var record = e.record;
// 	    var value = e.value;
// 	    if(value == null) value = "";
	    
// 	    if(e.field == 'user_status'){
// 	    	for(i in statusArr){
// 				if(statusArr[i].id == value) e.cellHtml = "<span style='color:"+ statusArr[i].color +";'>"+ statusArr[i].text +"</span>";
// 			}
// 	    }
	    
// 	    if(e.field == 'role_id'){
// 	    	for(i in roleArr){
// 				if(roleArr[i].id == value) e.cellHtml = roleArr[i].text;
// 			}
// 	    }
// 	}
	
// 	function resetALLParams(){
// 		mini.get("key").setValue('');
// 	}

    var tree = mini.get("tree");
//     var detailForm = new mini.Form("detailForm");
//     detailForm.setEnabled(false); 
//     var saveChangesButton = mini.get("saveChangesButton");
    
    function onDrawNode(e) {
//         var patternPhone = /^1\d{10,10}$/;
        var tree = e.sender;
        var node = e.node;

        var isLeaf = tree.isLeaf(node);
        //所有子节点加上超链接
//         if (isLeaf == true) {
//             e.nodeHtml = '<a href="http://www.miniui.com/docs/api/' + node.id + '.html" target="_blank">' + node.text + '</a>';
//         }
        //父节点高亮显示；子节点斜线、蓝色、下划线显示
//         if (isLeaf == false) {
//             e.nodeStyle = 'font-weight:bold;';
//         } else {
//             e.nodeStyle = "font-style:italic;"; //nodeStyle
//             e.nodeCls = "blueColor";            //nodeCls
//         }
        //修改默认的父子节点图标
        if(isLeaf) {
            e.iconCls = "icon-department";
        }
//         if (isLeaf == false) e.showCheckBox = false; //父节点的CheckBox全部隐藏
    }
    
    function onKeyEnter(){
        var key = mini.get("key").getValue();
        if(myTrim(key) == ""){
            tree.clearFilter();
            tree.collapseAll();
        }else{
            key = key.toLowerCase();
            tree.filter(function (node) {
                var text = node.text ? node.text.toLowerCase() : "";
                if (text.indexOf(key) != -1) return true;
            });
            tree.expandAll();
        }
    }
    
    function onAddAfter(e) {
        var node = tree.getSelectedNode();
        var pid = 0;
        if(node){
            var parentNode = tree.getParentNode(node);
            if(parentNode){
                pid = parentNode.id;
            }
        }
        mini.open({
            url: '${ctx}/base/department/showDetailWindow.json',
            title: "新增机构", width: 300, height: 200,
            onload: function () {
                var iframe = this.getIFrameEl();
                var data = { action: "new", pid: pid};
                // 调用子页面 SetData 方法
                iframe.contentWindow.SetData(data);
            },
            ondestroy: function (action) {
                tree.reload();
            }
        });
    }
    
    function onAddNode(e) {
        var node = tree.getSelectedNode();
        mini.open({
            url: '${ctx}/base/department/showDetailWindow.json',
            title: "新增子机构", width: 300, height: 200,
            onload: function () {
                var iframe = this.getIFrameEl();
                var data = { action: "new", pid: node.id };
                iframe.contentWindow.SetData(data);
            },
            ondestroy: function (action) {
                tree.reload();
            }
        });
    }
    
    function onEditNode(e) {
        var node = tree.getSelectedNode();
        tree.beginEdit(node);
//      var node = tree.getSelectedNode();
//      var parentNode = tree.getParentNode(node);
//      mini.open({
//             url: '${ctx}/base/department/showDetailWindow.json',
//             title: "修改机构", width: 300, height: 200,
//             onload: function () {
//                 var iframe = this.getIFrameEl();
//                 var data = { action: "edit", id:node.id, pid: parentNode.id};
//                 iframe.contentWindow.SetData(data);
//             },
//             ondestroy: function (action) {
//                 tree.reload();
//             }
//         });
    }
    
    function onEndEdit(e){
        $.post("${ctx}/base/department/update.do", e.node, function(data){
            if(data == true){
                tree.reload();
                notifyOnBottomRight("修改机构名称成功！");
            }else{
                notifyOnBottomRight("服务器繁忙，请稍后重试");
            }
        });
    }
    
//     function onOk(){
//         var o = detailForm.getData(true);            
//         detailForm.validate();
//         if (detailForm.isValid() == false) return;
//         saveChangesButton.disable();
//         $.post("${ctx}/base/department/update.do", o, function(data){
//             if(data == true){
//                 tree.reload();
//                 notifyOnBottomRight("修改机构详情成功！");
//             }else{
//                 notifyOnBottomRight("服务器繁忙，请稍后重试");
//             }
//             saveChangesButton.enable();
//         });
//     }
    
    function onRemoveNode(e) {
        var node = tree.getSelectedNode();
        
        mini.confirm("确定删除该机构及其子机构?", "确定?", function(action){
            if (action == "ok") {
                $.post("${ctx}/base/department/deleteById.do?id=" + node.id, {}, function(data){
                    if(data == true){
                        tree.reload();
                        notifyOnBottomRight("删除机构成功！");
                    }else{
                        notifyOnBottomRight("服务器繁忙，请稍后重试");
                    }
                });
            }
        });
    }
    
    function onDrop(e){
        var dragNode = e.dragNode;
        var dropNode = e.dropNode;
        var dragAction = e.dragAction;
        if(dragAction == 'add'){
            dragNode.pid = dropNode.id;
        }else{
            dragNode.pid = dropNode.pid;
        }
        $.post("${ctx}/base/department/updatePid.do", dragNode, function(data){
            if(data == true){
                tree.reload();
                notifyOnBottomRight("拖拽操作成功！");
            }else{
                notifyOnBottomRight("服务器繁忙，请稍后重试");
            }
        });
    }
    
    function onBeforeOpen(e) {
        e.htmlEvent.preventDefault(); // 阻止浏览器默认右键菜单
        var menu = e.sender;
        var addItem = mini.getbyName("add", menu);
        var addChildItem = mini.getbyName("addChild", menu);
        var editItem = mini.getbyName("edit", menu);
        var removeItem = mini.getbyName("remove", menu);
        var node = tree.getSelectedNode();
        if(node){
            addItem.hide();
            addChildItem.hide();
//             addChildItem.show();
            editItem.hide();
            removeItem.hide();
//             removeItem.show();
        }else{
            addItem.hide();
            addChildItem.hide();
            editItem.hide();
            removeItem.hide();
        }
    }
	
/**********************************************************************************************************************/
	
	var grid = mini.get("grid");
	
	function onNodeClick(e){
//      var node = e.node;
//      detailForm.setData(node);
//      detailForm.setEnabled(true);
//      mini.get('department_id').disable();
//      saveChangesButton.enable();
	     grid.load({
	    	 department_id: e.node.id, 
	    	 department_name: e.node.text, 
	    	 corp_id: e.node.corp_id, 
	         budget_status: 1 // 除分页排序参数外的额外参数
	     }, null, gridLoadFail);
	 }
	
// 	tree.on("nodeselect", function (e) {
//         if (e.isLeaf) {
//             grid.load({ dept_id: e.node.id });
//         } else {
//             grid.setData([]);
//             grid.setTotalCount(0);
//         }
//     });
    
    function onDrawCell(e){
        var record = e.record;
        var value = e.value;
        if(value == null) value = "";
        if(e.record._state == "modified") return;
        if(e.field == 'budget_amount' || e.field == 'expense_amount' || e.field == 'remain_amount') {
        	if(value != ""){
        		if(e.field == 'expense_amount') e.cellHtml = "<span style='color:red;font-weight:bold;'>-" + value/1000000 +"</span>";
                else e.cellHtml = value/1000000; 
//                 e.cellHtml = (value/1000000).toFixed(2);
        	}
        }
        
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
    
    function onCellValidation(e) {
//      if (e.field == "age") {
//          if (e.value < 20) {
//              e.isValid = false;
//              e.errorText = "年龄必须大于20岁";
//          }
//      }
    }
    
    function onCellbeginedit(e){
    	e.value = e.value/1000000; 
    }
    
    function saveBudgets() {
    	mini.confirm("本次保存为初始化录入,如需变更该部门预算,请使用【年度预算变更】功能,确定保存？", "确定?", function(action){
            if (action != "ok") return;
            grid.validate();
            if (grid.isValid() == false){
             //allowCellEdit="false"时，以下两句不起作用，为true时无法根据下拉框选项自动填充食品信息
             var error = grid.getCellErrors()[0];
                grid.beginEditCell(error.record, error.column);
                return;
            }
            
            grid.commitEdit();
            var gridChanges = grid.getChanges();
//             var data = grid.getEditData(true);
            var flag = false;
            $.each(gridChanges, function(i){
                if(!gridChanges[i].budget_id){
                    gridChanges[i].budget_amount = gridChanges[i].budget_amount * 1000000;
                }else{
                    flag = true;
                    return;
                }
            });
            if(flag){
                notifyOnBottomRight("操作失败!如需变更预算请使用【年度预算变更】功能");
                grid.reload();
                return;
            }
            var gridChangesJson = mini.encode(gridChanges);
            mini.get("saveBudgets").disable();
            $.post("${ctx}/portal/budget/year/saveBudgets.do", {budgetListJson: gridChangesJson}, function(data){
                mini.get("saveBudgets").enable();
                if(data == true){
                    notifyOnBottomRight("操作成功!");
                }else{
                    notifyOnBottomRight("服务器繁忙,请稍后重试");
                }
            });
            $.each(gridChanges, function(i){
                gridChanges[i].budget_amount = gridChanges[i].budget_amount / 1000000;
            });
        });
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
//                  console.info(this.getIFrameEl().contentWindow.GetData()); //调用子页面 GetData 方法
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