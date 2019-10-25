<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
    <title>用户详情</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <jsp:include page="/easyui.jsp" />
    <style type="text/css">
    	html, body{ font-size:12px; padding:0; margin:0; border:0; height:100%; overflow:hidden; }
    </style>
</head>

<body>    
    <form id="detailForm" method="post">
	    <div class="form" >
	        <input class="mini-hidden" name="user_id"/>
	        <table style="width:100%;margin-top:11px;">
				<tr>
					<td align="right" width="90px"><label>所属机构:</label></td>
					<td><input id="org_id" name="org_id" class="mini-combobox" textField="org_name" valueField="org_id" allowInput="true" style="width:150px;"
							url="${ctx}/check/all/getOrgList.json" showNullItem="false" /></td>
				</tr>
				<tr height="7px;"></tr>
				<tr>
					<td align="right" width="90px">用户名:</td>
					<td><input id="username" name="username" class="mini-textbox" required="true" style="width: 150px;" onvalidation="onUsernameValidation" /></td>
				</tr>
				<tr height="7px;"></tr>
				<tr>
					<td align="right" width="90px"><label>密码:</label></td>
					<td><input name="password" class="mini-textbox" required="true" style="width: 150px;" /></td>
				</tr>
				<tr height="7px;"></tr>
				<tr>
					<td align="right" width="90px"><label>用户状态:</label></td>
					<td><input name="user_status" class="mini-combobox" textField="text" valueField="id" allowInput="false" style="width:150px;" required="true"
								data="[{id:'1', text:'有效'}, {id:'0', text:'无效'}]" value="1" /></td>
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
        var o = detailForm.getData(true);            
        detailForm.validate();
        if(detailForm.isValid() == false) return;
        $.post("${ctx}/user/createOrUpdate.do?action=" + record.action, o, function(data){
            if(data == true){
                CloseWindow("ok");
            }else{
                notifyOnBottomRight("服务器繁忙,请稍后重试");
            }
        });
    }

   	// 该方法为父页面生成子页面时调用
    function SetData(data){
  		//跨页面传递的数据对象，克隆后才可以安全使用
      	record = mini.clone(data);
        if(record.action == "update"){
            detailForm.setData(record.row);
            detailForm.setEnabled(true);
            mini.get('username').disable();
            mini.get('org_id').disable();
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
	
	function onUsernameValidation(e){
    	if(e.isValid && record.action == 'create'){
    		var paramMap = {username: e.value};
    		$.ajax({
    		    url: "${ctx}/user/checkUsername.json",
    		    async: false,// 只有同步请求才会使验证生效
    		    type: 'POST',
				data: paramMap,
    		    success: function(data){
    		    	if(data == false){
	        			e.errorText = "该用户名已存在";
	                    e.isValid = false;
	        		}
    		    }
    		});
        }
    }
	
</script>
</body>
</html>
