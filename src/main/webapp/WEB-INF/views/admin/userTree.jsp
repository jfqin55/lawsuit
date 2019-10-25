<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
    <title>详情</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <jsp:include page="/easyui.jsp" />
    <style type="text/css">
    	html, body{ font-size:12px; padding:0; margin:0; border:0; height:100%; overflow:hidden; }
    </style>
</head>

<body>    
    <div class="mini-toolbar" style="text-align:center;border-left:0;border-top:0;border-right:0;padding:3px;">
          <label>用户姓名：</label>
          <input id="key" class="mini-textbox" style="width:150px;" onenter="onKeyEnter"/>
          <a class="mini-button" style="width:60px;" onclick="onKeyEnter">查询</a>
    </div>
    
    <div class="mini-fit">
        <ul id="tree" class="mini-tree" style="width:100%;height:100%;" 
            textField="text" resultAsTree="false"  
            expandOnLoad="1" onnodedblclick="onOk" expandOnDblClick="false" ondrawnode="onDrawNode">
        </ul>
    </div>                
    <div class="mini-toolbar" style="text-align:center;padding-top:8px;padding-bottom:8px;" borderStyle="border-left:0;border-bottom:0;border-right:0;">
        <a class="mini-button" style="width:60px;" onclick="onOk()">确定</a>
        <span style="display:inline-block;width:25px;"></span>
        <a class="mini-button" style="width:60px;" onclick="onCancel()">取消</a>
    </div>
    
<script type="text/javascript">
	mini.parse();
	
	var tree = mini.get("tree");

    function onDrawNode(e) {
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
        	e.iconCls = "icon-user";
        }else{
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
	
	var record = null;

   	// 该方法为父页面生成子页面时调用
    function SetData(data){
  		//跨页面传递的数据对象，克隆后才可以安全使用
      	record = mini.clone(data);
        if(record.action == "edit"){
        	var row = record.row;
        	$.post("${ctx}/admin/role/getUserTree.json", {}, function(data) {
                tree.loadList(data, "id", "pid");
                var node = tree.getNode(row.user_id);
                tree.selectNode(node);// 默认调用 tree.expandPath(node);
                tree.scrollIntoView(node);
            });
		}
	}
     	
	// 该方法为子页面关闭时，被父页面调用
	function GetData(){
		return tree.getSelectedNode();
	}

    function CloseWindow(action){            
//         if(action == "close" && detailForm.isChanged()){
//             if(confirm("数据被修改了，是否先保存？")) return false;
//         }
        if(window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
        else window.close(); 
    }
        
    function onOk(e){
    	var node = tree.getSelectedNode();
    	var isLeaf = tree.isLeaf(node);
    	if(!isLeaf) {
    		notifyOnBottomRight("只允许选择用户");
    		return;
    	}
    	CloseWindow("ok");
//         var orgs = tree.getValue(false);//false-不包含父节点、true-包含
//         var paramMap = {budget_special_id:record.row.budget_special_id, orgs:orgs};
//         $.post('${ctx}/portal/budget/special/bindOrgs.do', paramMap, function(data) {
//             if (data == true) {
//                 CloseWindow("ok");
//             } else {
//                 notifyOnBottomRight("服务器繁忙,请稍后重试");
//             }
//         });
    }
        
	function onCancel(e){
	    CloseWindow("cancel");
	}
	
</script>
</body>
</html>
