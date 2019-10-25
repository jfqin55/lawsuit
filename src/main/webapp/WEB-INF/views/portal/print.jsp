<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <jsp:include page="/easyui.jsp" />
    <style type="text/css">
    	html, body { height: 100%; width: 100%; padding: 0; margin: 0; overflow: hidden; }
    	@page { size: 14in 7in; }
    </style>
</head>

<body>    
<img src="" id="showImg" style="width:100%;height:100%;"/>
    
<script type="text/javascript">
	mini.parse();
	
	var serverHtml = '';
	
	// 该方法为父页面生成子页面时调用
	function SetData(data) {
		//跨页面传递的数据对象，克隆后才可以安全使用
        record = mini.clone(data);
        if(record.action=='expense'){
        	$.post("${ctx}/portal/bill/printExpense.do?bill_id=" + record.bill_id, {}, function(data){
                serverHtml = "<img src='http://cost.sanxb.net:8888/sx.jpg' width='316px' height='51px' style='margin-top:20px;margin-left:100px;' /><div style='margin-top:-50px;border-left:1px dotted black;'><div style='z-index:101;position:absolute;'><br/><br/>装<br/><br/><br/>订<br/><br/><br/>线</div><img src='"+record.url+"' width='200px' height='200px' style='z-index:102;position:absolute;top:220px;left:800px;' />" + data + "</div>"
                window.document.body.innerHTML = serverHtml + '<div property="footer" style="padding:8px; text-align: center"><a class="mini-button" onclick="onOk()" style="width: 80px" iconcls="icon-ok">打印</a><a class="mini-button" onclick="onCancel()" style="width: 80px; margin-left: 50px" iconcls="icon-cancel">取消</a></div>';
            });
        }else if(record.action=='borrow'){
            $.post("${ctx}/portal/bill/printBorrow.do?bill_id=" + record.bill_id, {}, function(data){
                serverHtml = "<img src='http://cost.sanxb.net:8888/sx.jpg' width='316px' height='51px' style='margin-top:20px;margin-left:100px;' /><div style='margin-top:-50px;border-left:1px dotted black;'><div style='z-index:101;position:absolute;'><br/><br/>装<br/><br/><br/>订<br/><br/><br/>线</div><img src='"+record.url+"' width='200px' height='200px' style='z-index:102;position:absolute;top:220px;left:800px;' />" + data + "</div>"
                window.document.body.innerHTML = serverHtml + '<div property="footer" style="padding:8px; text-align: center"><a class="mini-button" onclick="onOk()" style="width: 80px" iconcls="icon-ok">打印</a><a class="mini-button" onclick="onCancel()" style="width: 80px; margin-left: 50px" iconcls="icon-cancel">取消</a></div>';
            });
        }else if(record.action=='copy'){
        	$.post("${ctx}/portal/bill/printCopy.do", {}, function(data){
                serverHtml = "<img src='http://cost.sanxb.net:8888/sx.jpg' width='316px' height='51px' style='margin-top:20px;margin-left:100px;' /><div style='margin-top:-120px;border-left:1px dotted black;'><div style='z-index:101;position:absolute;'><br/><br/><br/>装<br/><br/><br/><br/><br/><br/>订<br/><br/><br/><br/><br/><br/>线</div>" + data + "</div>"
                window.document.body.innerHTML = serverHtml + '<div property="footer" style="margin-top:-50px; text-align: center"><a class="mini-button" onclick="onOk()" style="width: 80px" iconcls="icon-ok">打印</a><a class="mini-button" onclick="onCancel()" style="width: 80px; margin-left: 50px" iconcls="icon-cancel">取消</a></div>';
            });
        }
    }
	
	function CloseWindow(action) {
        if(action == "close" && detailForm.isChanged()){
            if(confirm("数据被修改了，是否先保存？")) return false;
        }
        if(window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
        else window.close(); 
    }
    
    function onCancel() {        
        CloseWindow("cancel");
    }
	
	function onOk() {
		window.document.body.innerHTML = serverHtml;
		window.print();
		CloseWindow("ok");
    }
</script>
</body>
</html>
