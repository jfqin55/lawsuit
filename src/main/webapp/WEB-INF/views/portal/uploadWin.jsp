<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <jsp:include page="/easyui.jsp" />
    <script src="${res}/swfupload/swfupload.js" type="text/javascript"></script>
    <script src="${res}/swfupload/multiupload.js" type="text/javascript"></script>
    <link href="${res}/swfupload/multiupload.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    	html, body { height: 100%; width: 100%; padding: 0; margin: 0; overflow: hidden; }
    </style>
</head>

<body>    
    <div class="mini-panel" style="width: 100%; height: 100%" showfooter="true" bodystyle="padding:0" borderStyle="border:0"
        showheader="false">
        
        <div id="multiupload1" class="uc-multiupload" style="width: 100%; height: 100%" 
            flashurl="${res}/swfupload/swfupload.swf" limitType="*.jpg;*.jpeg;*.png;" limitSize="10MB"
            uploadurl="${ctx}/fileUpload/uploadImg" _autoupload="true" borderstyle="border:0" >
        </div>

        <div property="footer" style="padding:8px; text-align: center">
            <a class="mini-button" onclick="onOk" style="width: 80px" iconcls="icon-ok">确定</a>
            <a class="mini-button" onclick="onCancel" style="width: 80px; margin-left: 50px" iconcls="icon-cancel">取消</a>
        </div>

    </div>

    
<script type="text/javascript">
	mini.parse();
	var grid = mini.get("multiupload1");
	var record = null;
	
	function onOk(e) {
		var rows = grid.findRows(function(row){
            if(row.status == 1) return true;
        });
        if(rows.length < 1){
        	mini.alert("您尚未上传图片!");
        }else{
        	CloseWindow("ok");
        }
    }
	
	// 该方法为父页面生成子页面时调用
	function SetData(data) {
		//跨页面传递的数据对象，克隆后才可以安全使用
//         record = mini.clone(data);
//         grid.setPostParam(record);
    }
	
	// 该方法为子页面关闭时，被父页面调用
    function GetData() {
        var rows = grid.findRows(function(row){
            if(row.status == 1) return true;
        });
        return rows;
    }
    
    function CloseWindow(action) {
    	if(action == "close" && detailForm.isChanged()){
            if(confirm("数据被修改了，是否先保存？")) return false;
        }
    	if(window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
        else window.close(); 
    }
    
    function onCancel(e) {        
        CloseWindow("cancel");
    }
	
	function GetNoUploadedData() {
		var rows = grid.findRows(function(row){
		    if(row.status != 1) return true;
		});
		return rows;
	}

</script>
</body>
</html>
