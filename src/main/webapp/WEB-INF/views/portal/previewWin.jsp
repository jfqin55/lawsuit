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
    </style>
</head>

<body>    
<img src="" id="showImg" style="width:100%;height:100%;"/>
    
<script type="text/javascript">
	mini.parse();
	
	// 该方法为父页面生成子页面时调用
	function SetData(data) {
		//跨页面传递的数据对象，克隆后才可以安全使用
        record = mini.clone(data);
        $("#showImg")[0].src = record.annex_url;
    }
</script>
</body>
</html>
