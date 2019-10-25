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
	        <input class="mini-hidden" name="check_flow_id"/>
	        <table style="width:100%;margin-top:11px;">
	            <tr>
                    <td align="right" width="100px">流程描述:</td>
                    <td><input name="flow_desc" class="mini-textarea" required="true" style="width:400px;height:50px;" emptyText='各节点请用"|"隔开'/></td>
                </tr>
				<tr height="7px;"></tr>
				<tr>
				    <td align="right" width="100px">最低适用金额:</td>
                    <td><input name="min_amount" class="mini-textbox" required="true" vtype="float" style="width: 150px;" /> 元</td>
				</tr>
				<tr height="7px;"></tr>
				<tr>
                    <td align="right" width="100px">所需批文:</td>
                    <td><input name="requied_file" class="mini-textbox" style="width:400px;" emptyText='批文名称请用"|"隔开'/></td>
                </tr>
                <tr height="7px;"></tr>
                <tr>
                    <td align="right" style="width:100px;" align="right">流程状态:</td>
                    <td><input class="mini-combobox" name="flow_status" textField="text" valueField="id" allowInput="false" 
                        data="[{id: '1',text: '启用'},{id: '0',text: '停用'}]" style="width:150px;" required="true" />
                    </td>
                </tr>
				<tr height="7px;"></tr>
                <tr>
                    <td align="right" width="100px">备注:</td>
                    <td><input name="remark" class="mini-textarea" style="width:400px;height:50px;" /></td>
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
        obj.min_amount = obj.min_amount * 100;
        $.post("${ctx}/admin/flow/createOrUpdate.do?action=" + record.action, obj, function(data){
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
        	record.row.min_amount = record.row.min_amount/100;
            detailForm.setData(record.row);
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
	
</script>
</body>
</html>
