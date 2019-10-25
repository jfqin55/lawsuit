<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<title>首页</title>
	<jsp:include page="/easyui.jsp" />
	<style type="text/css">
		html, body {
			margin:0;padding:0;border:0;width:100%;height:100%;overflow:hidden;
		}
		.shortcut {font-size:15px; font-weight:bold; color:rgb(197,52,65);}
		.icon {width:56px; height:56px;}
		a {text-decoration:none}
    </style>
</head>
<body>
	<fieldset style="width:500px;border:solid 1px #aaa;margin:auto;margin-top:17px;">
		<legend><span class="shortcut">快捷菜单</span></legend>
		<div style="padding:17px;">
		<table style="width:100%;">
			<tr align="center">
				<td>
					<a href="${ctx}/phone/group" target="_self" onclick="createTab('1001','群组管理','phone/group');return false;">
    		      		<img alt="群组管理" src="${img}/b01.png" class="icon" onload="fixPNG(this)" border="0">
    		      		<div class="shortcut">群组管理</div>
   		      		</a>
				</td>
				<td>
					<a href="${ctx}/phone/linkman" target="_self" onclick="createTab('1002','组员管理','phone/linkman');return false;">
	   		      		<img alt="组员管理" src="${img}/b02.png" class="icon" onload="fixPNG(this)" border="0">
	   		      		<div class="shortcut">组员管理</div>
  		      		</a>
				</td>
				<td>
   		      		<a href="${ctx}/phone/blacklist" target="_self" onclick="createTab('1003','黑名单管理','phone/blacklist');return false;">
    		      		<img alt="黑名单管理" src="${img}/b13.png" class="icon" onload="fixPNG(this)" border="0">
    		      		<div class="shortcut">黑名单管理</div>
   		      		</a>
				</td>
			</tr>
			<tr height="30px;"></tr>
			
			<tr align="center">
				<td>
					<a href="${ctx}/msg/down" target="_self" onclick="createTab('1004','已发短信','msg/down');return false;">
    		      		<img alt="已发短信" src="${img}/b07.png" class="icon" onload="fixPNG(this)" border="0">
    		      		<div class="shortcut">已发短信</div>
   		      		</a>
				</td>
				<td>
					<a href="${ctx}/msg/up" target="_self" onclick="createTab('1005','上行短信','msg/up');return false;">
    		      		<img alt="上行短信" src="${img}/b09.png" class="icon" onload="fixPNG(this)" border="0">
    		      		<div class="shortcut">上行短信</div>
   		      		</a>
				</td>
				<td>
					<a href="${ctx}/msg/wait" target="_self" onclick="createTab('1006','待发短信','msg/wait');return false;">
    		      		<img alt="待发短信" src="${img}/b10.png" class="icon" onload="fixPNG(this)" border="0">
    		      		<div class="shortcut">待发短信</div>
   		      		</a>
				</td>
			</tr>
			<tr height="30px;"></tr>
			
			<tr align="center">
				<td>
					<a href="${ctx}/report/costNum" target="_self" onclick="createTab('1007','短信发送汇总','report/costNum');return false;">
    		      		<img alt="短信发送汇总" src="${img}/b12.png" class="icon" onload="fixPNG(this)" border="0">
    		      		<div class="shortcut">短信发送汇总</div>
   		      		</a>
				</td>
				<td>
					<a href="${ctx}/report/arriveNum" target="_self" onclick="createTab('1008','短信到达汇总','report/arriveNum');return false;">
    		      		<img alt="短信到达汇总" src="${img}/b11.png" class="icon" onload="fixPNG(this)" border="0">
    		      		<div class="shortcut">短信到达汇总</div>
   		      		</a>
				</td>
			</tr>
		</table>
		</div>
	</fieldset>
	
<script type="text/javascript">
	mini.parse();
	
	function createTab(menu_id, menu_name, menu_url){
		var node = {};
		node.menu_id = menu_id;
		node.menu_name = menu_name;
		node.menu_url = menu_url;
		window.parent.showTab(node);
	}
</script>
</body>
</html>