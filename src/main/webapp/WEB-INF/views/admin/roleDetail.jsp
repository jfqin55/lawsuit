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
    <form id="detailForm" method="post">
	    <div class="form" >
	        <input class="mini-hidden" name="user_role_id"/>
	        <table style="width:100%;margin-top:11px;">
				<tr>
					<td align="right" width="90px">角色名称:</td>
					<td><input name="role_id" class="mini-combobox" textField="text" valueField="id" allowInput="false" value="" style="width:150px;"
                        data="[{id:'0', text:'系统管理员'}, {id:'1', text:'预算管理员'}, {id:'2', text:'一级支行分管财务行长'}, {id:'3', text:'市行财务部审核岗'}
                             , {id:'4', text:'市行财务部出纳岗'}, {id:'5', text:'一级支行财务审核岗'}, {id:'6', text:'县行财务部审核岗'}, {id:'7', text:'县行财务部出纳岗'}]" /></td>
				</tr>
				<tr height="7px;"></tr>
				<tr>
					<td align="right" width="90px">用户姓名:</td>
					<td><input id="user_id" name="user_id" class="mini-buttonedit" style="width:150px;" onbuttonclick="onButtonEdit" allowInput="false" emptyText="请选择用户"/></td>
				</tr>
				<tr>
					<td colspan="2" style="padding-top: 17px;" align="center">
						<a class="mini-button" onclick="onOk" style="width:60px;margin-right:20px;">确定</a>       
            			<a class="mini-button" onclick="onCancel" style="width:60px;">取消</a>   
					</td>
				</tr>
	        </table>
	    </div>
    </form>
    
<script type="text/javascript">
	mini.parse();
	var detailForm = new mini.Form("detailForm");
	var record = null;
	
	function onOk(e){
        detailForm.validate();
        if(detailForm.isValid() == false) return;
        var obj = detailForm.getData(true);
        $.post("${ctx}/admin/role/createOrUpdate.do?action=" + record.action, obj, function(data){
            if(data == true){
                CloseWindow("ok");
            }else{
                notifyOnBottomRight("操作失败，系统已存在改角色");
            }
        });
    }

   	// 该方法为父页面生成子页面时调用
    function SetData(data){
  		//跨页面传递的数据对象，克隆后才可以安全使用
      	record = mini.clone(data);
        if(record.action == "update"){
            detailForm.setData(record.row);
            var btnEdit = mini.get('user_id');
            btnEdit.setValue(record.row.user_id);
            btnEdit.setText(record.row.user_name);
            detailForm.setEnabled(true);
//             mini.get('username').disable();
		}
	}
     	
	// 该方法为子页面关闭时，被父页面调用
	function GetData(){
		return detailForm.getData(true);
	}

    function CloseWindow(action){            
        if(action == "close" && detailForm.isChanged()){
            if(confirm("数据被修改了，是否先保存？")) return false;
        }
        if(window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
        else window.close(); 
    }
        
	function onCancel(e){
	    CloseWindow("cancel");
	}
	
	function onButtonEdit(e) {
        var btnEdit = this;
        mini.open({
            url: '${ctx}/admin/role/showUserTree.json',
            title: "详情", width: 330, height: 600,
            onload: function(){
                var iframe = this.getIFrameEl();
                var data = { action: "edit", row: {user_id: btnEdit.getValue()} };
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
