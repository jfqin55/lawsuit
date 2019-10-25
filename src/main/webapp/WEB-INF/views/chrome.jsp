<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp"%>
<!doctype html>
<html lang="zh-cn">
<head>
	<meta charset="UTF-8">
	<title>湖北三峡农商银行费用管理系统</title>
	<jsp:include page="/easyui.jsp" />
	<link type="text/css" rel="stylesheet" href="${css}/login.css"/>
</head> 

<body >
<div style="width:686px;margin:auto;margin-top:4.4%;border:0px solid #CCC;">
            <h1 style="font-size:48px;letter-spacing:0px;color:white;font-family:'黑体';">湖北三峡农商银行费用管理系统</h1>
     </div>
     <div class="wrap" style="margin-top:5.4%;"> 
     
      <form action="${ctx }/login" method="post" target="_self" id="submitForm"> 
        <section class="loginForm"> 
          <header> 
            <h1>欢迎登录</h1> 
          </header> 
          <div class="loginForm_content"> 
            <fieldset> 
              <div class="inputWrap"> 
                <input type="text" placeholder="请输入用户名" name="login_name" id="login_name" autofocus required> 
              </div> 
              <div class="inputWrap"> 
                <input type="password" placeholder="请输入登录密码" name="login_pwd" id="login_pwd" required> 
              </div>
              </fieldset>
              <div class="inputWrap2"> 
                <input type="text" placeholder="请输入验证码" name="captcha" id="captcha" required class="fild2"> 
                <span style="padding-left: 8px;">
                	<a href="javascript:void(0);">
                		<img id="capchaImg" src="${ctx}/captcha/image.json" width="118" height="43" alt="" onclick="changeCapchaImg()"/> 
                	</a>
               	</span>
              </div> 
             
            <fieldset> 
              <input type="checkbox" checked="checked"  style="width: 16px; height: 16px;"> 
              <span>记住密码</span> 
            </fieldset> 
            <div class="cwts" id="resultErrorMsg">${resultErrorMsg}</div>
            <fieldset> 
              <input type="button" value="登录" id="submitButton"> 
            </fieldset> 
          </div> 
        </section> 
      </form> 
    </div> 
</body>

<script>if(window.top !== window.self){ window.top.location = window.location;}</script>

<script type="text/javascript">

	var expiredHours = 24 * 14;

	function setCookie(key, value, hours, path) {
		var expireDate = new Date();
		expireDate.setTime(expireDate.getTime() + hours * 3600000);
		var expires = (typeof hours) == "string" ? "" : ";expires=" + expireDate.toUTCString();
		path = path == "" ? "" : ";path=" + path;
		document.cookie = escape(key) + "=" + escape(value) + expires + path;
	}
    
    function getCookieValue(key) {
        //读cookie属性，这将返回文档的所有cookie
        var allCookies = document.cookie;
        //查找名为key的cookie的开始位置
        var key = escape(key) + "=";
        var pos = allCookies.indexOf(key);
        //如果找到了具有该名字的cookie，那么提取并使用它的值
        if (pos != -1) {
            var start = pos + key.length; // 找到key在cookie串中的位置
            var end = allCookies.indexOf(";", start);
            if (end == -1) end = allCookies.length; //如果end值为-1说明cookie列表里只有一个cookie
            var value = allCookies.substring(start, end);  //提取cookie的值
            return unescape(value); //解码
        }
        else return "";
    }
    
    $(function(){
// 	    	if(navigator.userAgent.indexOf("compatible") != -1){
// 	    		alert("为避免影响使用,请将360浏览器从兼容模式切换到极速模式");
// 	    	}
// 	    	if(navigator.appName == "Microsoft Internet Explorer"){
// 	    		alert("IE浏览器可能会有兼容性问题,我们建议您使用谷歌浏览器");
// 	    	}
        //获取Cookie保存的用户名和商户编号
        var cookie_username = getCookieValue("cookie_username");
        if (null != cookie_username && "" != cookie_username ) {
            $("#login_name").val(cookie_username);
// 	            $("#rememberUsername").prop("checked", true);
        } else {
// 	            $("#rememberUsername").prop("checked", false);
        }

        $("#submitButton").click(function () {
            var username = $("#login_name").val();
            var password = $("#login_pwd").val();
            var captcha = $("#captcha").val();
            
            if (isEmpty("用户名", username) || isEmpty("密码", password) || isEmpty("验证码", captcha)) {
            	return;
            }
// 	            if ($("#rememberUsername").is(":checked")) {
// 	                expiredHours = 24 * 14;
// 	            } else {
// 	                expiredHours = 0;
// 	            }
            setCookie('cookie_username', username, expiredHours, '/');
            
            $("#submitForm").submit();
        });

        $("#captcha").keyup(function (event) {
            if (event.keyCode == 13) {
                $("#submitButton").click();
            }
        });
    });

	function changeCapchaImg(){
		$("#capchaImg").attr("src", "${ctx}/captcha/image.json?date=" + new Date().getTime());
	}

 	// 空值校验
	function isEmpty(name, value) {
		if (null == value || "" == value){
			$('#resultErrorMsg').text(name + "不能为空");
			return true;
		}
		return false;
	}
</script>
</html>
