<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>湖北三峡农商银行费用管理系统</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <jsp:include page="/easyui.jsp" />
<!--     <link href="../demo.css" rel="stylesheet" type="text/css" /> -->
    <style type="text/css">
        body { width:100%;height:100%;margin:0;overflow:hidden; }
    </style>
</head>
<body style="background:#81a9e2;">   
<div style="width:680px;height:50px;line-height:50px;margin:auto;margin-top:5%;border:0px solid #CCC;font-size:48px;letter-spacing:0px;color:white;font-family:'黑体';">
     湖北三峡农商银行费用管理系统
</div>
<div id="loginWindow" class="mini-window" title="用户登录" style="width:310px;height:250px;" showModal="false" showCloseButton="false" allowResize="false" allowDrag="true">

    <div id="loginForm" style="padding:15px;padding-top:10px;">
        <table >
            <tr>
                <td align="center" style="width:60px;height:40px;font-size:14px;"><label for="login_name$text">帐&nbsp;&nbsp;&nbsp;&nbsp;号:</label></td>
                <td>
                    <input id="login_name" name="login_name" class="mini-textbox" required="true" style="width:150px;" emptyText='请输入账号'/>
                </td>    
            </tr>
            <tr>
                <td align="center" style="width:60px;height:40px;font-size:14px;"><label for="login_pwd$text">密&nbsp;&nbsp;&nbsp;&nbsp;码:</label></td>
                <td>
                    <input id="login_pwd" name="login_pwd" onvalidation="onPwdValidation" class="mini-password" requiredErrorText="密码不能为空" required="true" style="width:150px;"/>
<!--                     &nbsp;&nbsp;<a href="#" >忘记密码?</a> -->
                </td>
            </tr>
            <tr>
                <td>
                    <img id="capchaImg" src="${ctx}/captcha/image.json" height="40" alt="" onclick="changeCapchaImg()"/> 
                </td>
                <td>
                    <input id="captcha" name="captcha" class="mini-textbox" required="true" style="width:150px;" emptyText='请输入验证码' onenter="onLoginClick"/>
                </td>    
            </tr>          
        </table>
        
        <table style="width:100%;margin-top:0px;">
            <tr>
                <td style="padding-top: 17px;" align="center">
                    <a onclick="onLoginClick" class="mini-button" style="width:60px;margin-right:20px;">登录</a>
                    <a onclick="onResetClick" class="mini-button" style="width:60px;">重置</a> 
                </td>
            </tr>
        </table>
    </div>

</div>
<div id="htmlContent" style="padding-left:10px;display:none;">系统登录中...<div style="background:url('${img}/wait.gif') no-repeat 0px 50%;width:230px;height:30px;"></div></div>


<script>if(window.top !== window.self){ window.top.location = window.location;}</script>
<script type="text/javascript">
    mini.parse();
    
    var loginWindow = mini.get("loginWindow");
    loginWindow.show();
    
    var form = new mini.Form("#loginWindow");
    
    var htmlContent = document.getElementById("htmlContent");

    function onLoginClick(e) {
        form.validate();
        if (form.isValid() == false) return;

        loginWindow.hide();
        htmlContent.style.display = "";
        var messageId = mini.showMessageBox({
            width: 250,
            title: "用户登录",
//             buttons: [],
//             message: "sss",
            html: htmlContent,
            showModal: true,
            callback: function (action) { }
        });
//         setTimeout(function () {
//             window.location = "${ctx }/login";
//         }, 1500);
        var obj = form.getData(true);
        $.post("${ctx }/login/ajax", obj, function(data){
            if(data == 'ok'){
            	window.location = "${ctx }/index";
            }else{
            	mini.hideMessageBox(messageId);
            	loginWindow.show();
            	changeCapchaImg();
            	mini.get("captcha").setValue('');
                notifyOnBottomRight(data);
            }
        });
    }
    
    function onResetClick(e) {
        form.clear();
    }
    /////////////////////////////////////
    function isEmail(s) {
        if (s.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1)
            return true;
        else
            return false;
    }
    function onUserNameValidation(e) {
        if (e.isValid) {
            if (isEmail(e.value) == false) {
                e.errorText = "必须输入邮件地址";
                e.isValid = false;
            }
        }
    }
    function onPwdValidation(e) {
        if (e.isValid) {
            if (e.value.length < 1) {
                e.errorText = "密码不能少于1个字符";
                e.isValid = false;
            }
        }
    }
    
    function changeCapchaImg(){
        $("#capchaImg").attr("src", "${ctx}/captcha/image.json?date=" + new Date().getTime());
    }
    
    function flashChecker() {  
        var hasFlash = 0;         //是否安装了flash  
        var flashVersion = 0; //flash版本  
        var isIE = /*@cc_on!@*/0;      //是否IE浏览器  
     
        if (isIE) {  
            var swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');  
            if (swf) {  
                hasFlash = 1;  
                VSwf = swf.GetVariable("$version");  
                flashVersion = parseInt(VSwf.split(" ")[1].split(",")[0]);  
            }  
        } else {  
            if (navigator.plugins && navigator.plugins.length > 0) {  
                var swf = navigator.plugins["Shockwave Flash"];  
                if (swf) {  
                    hasFlash = 1;  
                    var words = swf.description.split(" ");  
                    for (var i = 0; i < words.length; ++i) {  
                        if (isNaN(parseInt(words[i]))) continue;  
                        flashVersion = parseInt(words[i]);  
                    }  
                }  
            }  
        }  
        return { f: hasFlash, v: flashVersion };  
    }  
     
    var fls = flashChecker();  
    if (fls.f){
    	if(fls.v < 9) alert("该浏览器的flash插件版本为: " + fls.v + "，可能影响图片上传功能");  
    }else{
    	alert("该浏览器尚未安装flash插件，可能影响图片上传功能"); 
    }
    
</script>

</body>
</html>