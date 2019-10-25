<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>湖北三峡农商银行费用管理系统</title>
	<jsp:include page="/easyui.jsp" />
	<link type="text/css" rel="stylesheet" href="${css }/public.css"/>
	<style type="text/css">
		.top {
/*             background: url(${img}/beijingtu.jpg) no-repeat center top; */
            background: #81a9e2;
            height: 90px;
            width: 100%;
            background-size: 100% 100%;
/*             filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='${img}/beijingtu.jpg', sizingMethod='scale'); */
        }

        html {overflow: hidden;}
	</style>
</head>
<body>

<div class="mini-layout" style="width:100%;height:100%;">
	<%--导航栏--%>
	<div class="top" region="north" bodyStyle="overflow:hidden;" height="87px;" showHeader="false" showSplit="false">
<!-- 		<div style="width:70px; height:70px;border:0px solid black;float:left;margin-left:33px;margin-top:10px;"> -->
<%-- 			<img style="width:70px; height:70px;" src='${sysConfigMap.index_logo }' onerror="javascript:this.style.display='none';"> --%>
<!-- 		</div> -->
<%-- 		<div class="logo" style="margin-left:24px;margin-top:25px;"><a href="#" class="qi"><img src="${img}/nxs.jpg"/></a></div> --%>
		<c:choose>
			<c:when test="${user.role_id == '0'}">
				<div class="logo" style="margin-left:17px;"><a href="#" class="qi">湖北三峡农商银行费用管理系统</a></div>
			</c:when>
			<c:otherwise>  
				<div class="logo" style="margin-left:17px;"><a href="#" class="qi">湖北三峡农商银行费用管理系统</a></div>
			</c:otherwise>
		</c:choose>
<!-- 		<div id="welcomeFont" style="margin-left:38%;line-height:86px;;width:400px;height:80px;border:0px solid black;overflow:hidden;"> -->
<%-- 			<div style="margin-left:450px;width:1000px;height:30px;font-size:30px;color:white;border:0px solid black;">欢迎您！${user.user_name}</div> --%>
<!-- 		</div> -->
		<div class="daohangtiao">
            <a href="javascript:void(0)" onclick="showUserInfo()" classname="account">
               <img src="${img}/zhanghu.png" width="29" height="46"/>
               <p>账户详情</p>
            </a>
<!-- 			<a href="javascript:void(0)" onclick="changePwd()" classname="loginManager"> -->
<%--                 <img src="${img}/suo.png" width="36" height="46" onload="fixPNG(this)"/> --%>
<!--                 <p>修改密码</p> -->
<!-- 	        </a> -->
	        <a href="javascript:void(0);" onclick="logout();return false;">
	            <img src="${img}/guanji.png" width="45" height="46" onload="fixPNG(this)"/>
	            <p>退出</p>
	        </a>
        </div>
	</div>
	
	<%--底部--%>
	<div showHeader="false" region="south" style="border: 0; text-align: center;" height="25" showSplit="false">
				技术支持：武汉卓鹰世纪科技有限公司
<!-- 				Copyright © 湖北三峡农村商业银行股份有限公司 -->
	</div>
	
	<%--左边树形菜单--%>
	<div region="west" title="功能菜单" showHeader="true" bodyStyle="padding-left:1px;" showSplitIcon="true" width="200" minWidth="100" maxWidth="350">
<!-- 		<ul id="leftMenuTree" class="mini-tree" textField="menu_name" idField="menu_id" showTreeIcon="true" style="width: 100%; height: 100%;" -->
<!-- 			expandOnLoad="true" enableHotTrack="true" expandOnNodeClick="true" onnodeclick="onNodeSelect" ondrawnode="onDrawNode"> -->
<!-- 		</ul> -->
		<ul id="leftMenuTree" class="mini-tree" textField="menu_name" idField="menu_id" showTreeIcon="true" style="width: 100%; height: 100%;" 
			 parentField="parent_menu_id" resultAsTree="false"
			expandOnLoad="true" enableHotTrack="true" expandOnNodeClick="true" onnodeclick="onNodeSelect" ondrawnode="onDrawNode">
		</ul>
	</div>
		
	<%--中间页面展示区--%>
	<div title="center" region="center" style="border:0;">
		<div id="mainTabs" class="mini-tabs" activeIndex="0" style="width: 100%; height: 100%;" contextMenu="#tabsMenu">
			<c:choose>
				<c:when test="${welcome}">
				    <div title="首页" name="index" url="${ctx}/index/portal"></div>
				</c:when>
				<c:otherwise>
					<div title="首页" name="index" url=""></div>
				</c:otherwise>
			</c:choose>
		</div>
		<!-- 右键小菜单 start-->
		<ul id="tabsMenu" class="mini-contextmenu" onbeforeopen="onBeforeOpen">
			<li onclick="closeOther" iconCls="icon-expand">关闭其他</li>
			<li onclick="closeAll" iconCls="icon-collapse">关闭所有</li>
			<li onclick="reload" iconCls="icon-reload">刷新</li>
		</ul>
		<!-- 右键小菜单 end-->
	</div>
</div>

<!-- 修改密码 start -->
<div id="changePwdWin" class="mini-window" title="修改密码" style="width: 300px; height: 210px;" showModal="true" showCloseButton="true"  allowResize="true" allowDrag="true">
	<div id="changePwdForm" style="padding: 15px;">
	<!--         <input class="mini-hidden" name="id"/> -->
		<table>
			<tr>
				<td align="right" width="80px"><label>原始密码：</label></td>
				<td><input name="login_pwd"  class="mini-password" requiredErrorText="密码不能为空" required="true" style="width: 150px;" />
			</tr>
			<tr height="7px;"></tr>
			<tr>
				<td align="right" width="80px"><label>新密码：</label></td>
				<td><input id="remark" name="remark" onvalidation="onPwdValidation" class="mini-password" requiredErrorText="密码不能为空" required="true" style="width: 150px;" /></td>
			</tr>
			<tr height="7px;"></tr>
			<tr>
				<td align="right" width="80px"><label>确认新密码：</label></td>
				<td><input onvalidation="onPwdValidation" class="mini-password" requiredErrorText="密码不能为空" required="true" style="width: 150px;" /></td>
			</tr>
			<tr>
				<td colspan="2" style="padding-top: 17px;" align="center" height="30px;">
					<a onclick="onSubmitClick" class="mini-button" style="width: 60px;">确认</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a onclick="onCancleClick" class="mini-button" style="width: 60px;">取消</a>
				</td>
			</tr>
		</table>
	</div>
</div>
<!-- 修改密码 end -->

<div id="detailWindow" class="mini-window" title="账户详情" style="width:580px;height:200px;" showModal="true" showCloseButton="true" allowResize="true" allowDrag="true">
    <div id="detailForm" style="padding: 15px;">
<!--         <input class="mini-hidden" name="id"/> -->
        <table style="width:100%;">
            <tr>
                <td style="width:80px;" align="right">账号名称：</td>
                <td>
                    <input name="login_name" class="mini-textbox" allowInput="false" style="width:150px;" />
                </td>
                <td style="width:80px;" align="right">更新时间：</td>
                <td>
                    <input name="update_time" class="mini-datepicker" emptyText='' style="width: 150px;"/>
                </td>
            </tr>
            <tr height="7px;"></tr>
            <tr>
                <td style="width:80px;" align="right">单位名称：</td>
                <td>
                    <input name="org_name" class="mini-textbox" allowInput="false" style="width:150px;"/>
                </td>
                <td style="width:80px;" align="right">部门名称：</td>
                <td>
                    <input name="department_name" class="mini-textbox" allowInput="false" style="width:150px;" />
                </td>
            </tr>
            <tr height="7px;"></tr>
            <tr>
                <td style="width:80px;" align="right">岗位名称：</td>
                <td>
                    <input name="post_name" class="mini-textbox" allowInput="false" style="width:150px;"/>
                </td>
                <td style="width:80px;" align="right">职务名称：</td>
                <td>
                    <input name="title_name" class="mini-textbox" allowInput="false" style="width:150px;" />
                </td>
            </tr>
            <tr height="7px;"></tr>
            <tr>
                <td style="width:80px;" align="right">真实姓名：</td>
                <td>
                    <input name="user_name" class="mini-textbox" allowInput="false" style="width:150px;"/>
                </td>
                <td style="width:80px;" align="right">手机号码：</td>
                <td>
                    <input name="phone" class="mini-textbox" allowInput="false" style="width:150px;" />
                </td>
            </tr>
        </table>
    </div>
</div>


<script type="text/javascript">
	
// 	var data = [
// 	            {"id":1,"text":"短信管理","children":[
// 					{"id":2,"text":"手动短信发送","url":"/msg/send"},
// 					{"id":3,"text":"文件批量发送","url":"/msg/sendTemplate"},
// 					{"id":4,"text":"短信查询","url":"/msg/down"},
// 					{"id":5,"text":"用户回复","url":"/msg/up"}
// 				]},
// 	            {"id":6,"text":"基本配置","children":[
// 					{"id":7,"text":"组织机构管理","url":"/base/department"},
// 					{"id":8,"text":"通讯录管理","url":"/base/phoneList"},
// 					{"id":9,"text":"短信类型管理","url":"/base/msgType"}
// 				]}
// 	];
	
// 	$(function(){
// 		var serviceCodeListSize = ${fn:length(serviceCodeList)};
// 		if(serviceCodeListSize != 0){
// 			leftMenuTree.loadData(data);
// 		}
		
// 		var fields = detailForm.getFields();                
// 	    for (var i = 0, l = fields.length; i < l; i++) {
// 	        var c = fields[i];
// 	        if (c.setReadOnly) c.setReadOnly(true);     //只读
// 	        if (c.setIsValid) c.setIsValid(true);      //去除错误提示
// 	        if (c.addCls) c.addCls("asLabel");          //增加asLabel外观
// 	    }
// 	});

	mini.parse();
	var leftMenuTree = mini.get("leftMenuTree");
	var data = ${menuList };
	leftMenuTree.loadList(data, "menu_id", "parent_menu_id");
	
	var changePwdWin = mini.get("changePwdWin");
	var mainTabs = mini.get("mainTabs");
	
	$(function(){
// 		var pwd = '${user.login_pwd}';
// 		if('1' == pwd){
// 			mini.alert("您的密码过于简单,请及时修改!");
// 		}
	});
	
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
        if (isLeaf){
//             e.iconCls = node.remark;//自定义图标
//             e.iconCls = "icon-phone";
            e.iconCls = "icon-node";
        }
        //父节点的CheckBox全部隐藏
//         if (isLeaf == false) {
//             e.showCheckBox = false;
//         }
    }
	
	// 点击左侧菜单，在主面板的一个tab中显示页面
	function showTab(node) {
		var id = "tab$" + node.menu_id;
		var tab = mainTabs.getTab(id);
		if (!tab) {
			tab = {};
			tab._nodeid = node.menu_id;
			tab.name = id;
			tab.title = node.menu_name;
			tab.showCloseButton = true;
			//这里拼接了url，实际项目，应该从后台直接获得完整的url地址
			tab.url = "${ctx}/" + node.menu_url;
			mainTabs.addTab(tab);
		}
		mainTabs.activeTab(tab);
	}

	function onNodeSelect(e) {
		var node = e.node;
		var isLeaf = e.isLeaf;
		if (isLeaf) {
			showTab(node);
		}
	}
	
	function logout() {
// 		var a = document.createElement("a");
// 		a.setAttribute("href", '${ctx}/logout');
// 		a.setAttribute("target", "_top");
// 		a.setAttribute("id", "openwin");
// 		document.body.appendChild(a);
// 		a.click();
		window.parent.location = '${ctx}/logout';
	}
	
	var changePwdForm = new mini.Form("#changePwdForm");
	
	function changePwd() {
		changePwdWin.show();
	}
	
	function onCancleClick(e) {
		changePwdWin.hide();
	}
	
	function onSubmitClick(e) {
		changePwdForm.validate();
		if (changePwdForm.isValid() == false) return;
		var data = changePwdForm.getData(true);
		$.post("${ctx}/user/changePwd.do", data, function(res) {
			changePwdWin.hide();
			if(res == true){
				changePwdForm.reset();
				mini.confirm("修改密码成功,是否重新登录?", "确定?", function(action){
	                if (action == "ok") logout();
	            });
			}else{
				notifyOnBottomRight("请输入正确的原始密码!");
			}
		});
	}
	
	function onPwdValidation(e) {
		var preValue = mini.get("remark").value;
		if (e.isValid) {
			if (e.value != preValue) {
				e.errorText = "新密码必须相同";
				e.isValid = false;
			}
		}
	}
	
	var currentTab = null;
	//面板右键功能
	function onBeforeOpen(e) {
		currentTab = mainTabs.getTabByEvent(e.htmlEvent);
		if (!currentTab) {
			e.cancel = true;
		}
	}

	//面板右键关闭其他
	function closeOther(e){
		var cutTab = [currentTab];
		cutTab.push(mainTabs.getTab("index"));
		mainTabs.removeAll(cutTab);
	}

	//面板右键关闭所有
	function closeAll(e){
		var cutTab = [mainTabs.getTab("index")];
		mainTabs.removeAll(cutTab);
	}

	//面板右键刷新当前tab
	function reload(e){
		var cutTab = mainTabs.getActiveTab();
		mainTabs.loadTab(cutTab.url, cutTab);
	}

	
	var z=0; var j=0;
	function scrollLeft(){
		setTimeout("scrollLeft()",50);
		if(j<=700){
				document.getElementById("welcomeFont").scrollLeft=z;
				z+=2;j+=2;
			}
		if(j>=700){
				z=0;j=0;
		}
	}
// 	scrollLeft();
	
	
	var detailWindow = mini.get("detailWindow");
    var detailForm = new mini.Form("#detailForm");
    
	function showUserInfo(){
        detailWindow.show();
        detailForm.clear();
        detailForm.loading();
        $.post("${ctx}/user/showUserInfo.json", {}, function(data){
        	detailForm.unmask();
        	var obj = mini.decode(data);
            detailForm.setData(obj);
            detailForm.setEnabled(false);
        });
    }
</script>
</body>
</html>