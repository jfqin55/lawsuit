<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="res" value="${ctx}/static" />
<c:set var="css" value="${res}/css" />
<c:set var="js" value="${res}/js" />
<!-- miniui 配置开始 -->
<script src="${res}/miniui/jquery-1.6.2.min.js" type="text/javascript"></script>
<script src="${res}/miniui/zysj.js" type="text/javascript" ></script>
<script src="${res}/miniui/locale/zh_CN.js" type="text/javascript" ></script>
<link href="${res}/miniui/themes/default/miniui.css" rel="stylesheet" type="text/css" />
<link href="${res}/miniui/themes/blue2003/skin.css" rel="stylesheet" type="text/css" />
<link href="${res}/miniui/themes/icons.css" rel="stylesheet" type="text/css" />
<!-- miniui 配置结束 -->
<link rel="stylesheet" href="${css}/style.css" type="text/css">
<link rel="shortcut icon" href="favicon.ico">
<script>
	var statusArr = [{id:1, text:'有效', color:'green'}, {id:0, text:'无效', color:'red'}];
	var switchArr = [{id:1, text:'启用', color:'green'}, {id:0, text:'停用', color:'gray'}];
	var roleArr = [{id:0, text:'系统管理员'}, {id:1, text:'预算管理员'}, {id:2, text:'一级支行分管财务行长'}, {id:3, text:'市行财务部审核岗'}
	   , {id:4, text:'市行财务部出纳岗'}, {id:5, text:'一级支行财务审核岗'}, {id:'6', text:'县行财务部审核岗'}, {id:'7', text:'县行财务部出纳岗'}];
	var billTypeArr = [{id:1, text:'报销单'}, {id:2, text:'借款单'}, {id:3, text:'还款单'}];
	var checkStatusArr = [{id:0, text:'未通过', color:'gray'}, {id:1, text:'审批中', color:'blue'}, {id:2, text:'已通过', color:'green'}, {id:3, text:'已退回', color:'red'}, {id:4, text:'待审批', color:'blue'}];
	
	// 右下角提示框
	function notifyOnBottomRight(msg) {
		mini.showMessageBox({
            showModal: false, // 是否显示遮罩
            width : 250,
			height : 100,
            title: "提示",
//             iconCls: "mini-messagebox-warning",
            message: msg,
            timeout: 4000, //提示框持续时间
            x: 'right',
            y: 'bottom'
        });
	}
	
	// 显示遮罩,主要是为了防止用户重复点击按钮
	function showMask(){
		mini.mask({
            el: document.body,
            cls: 'mini-mask-loading',
            html: '处理中,请耐心等待...'
        });
	}
	
	// 隐藏遮罩
	function hideMask(){
		mini.unmask(document.body);
	}
	
	
	
	/** 
	 * 设置全局的AJAX请求默认回调函数，用户处理Session过期的情况 
	 */  
	$.ajaxSetup({  
// 	    type: 'POST',  
	    complete: function(xmlHttpReq, status) {  
	        var sessionStatus = xmlHttpReq.getResponseHeader('sessionstatus');  
	        if(sessionStatus == 'timeout') {  
	            var top = getTopWinow();  
	            mini.confirm("由于您长时间没有操作,session已过期,请重新登录.", "确定?", function(action){
	                if (action == "ok") {
	                	top.location.href = '${ctx}/logout';
	                }
	            });
	        }  
	    }  
	}); 
	
	/** 
	 * 在页面中任何嵌套层次的窗口中获取顶层窗口 
	 * @return 当前页面的顶层窗口对象 
	 */  
	function getTopWinow(){  
	    var p = window;  
	    while(p != p.parent){  
	        p = p.parent;  
	    }  
	    return p;  
	}  
	
	// 专门用于处理miniui中datagrid控件的load函数发起的ajax请求session过时问题
	function gridLoadFail(paramObj){
		var sessionStatus = paramObj.xhr.getResponseHeader('sessionstatus');  
        if(sessionStatus == 'timeout') {  
            var top = getTopWinow();  
            mini.confirm("由于您长时间没有操作,session已过期,请重新登录.", "确定?", function(action){
                if (action == "ok") {
                	top.location.href = '${ctx}/logout';
                }
            });
        }  
	}
	
	function onComboValidation(e) {
        var items = this.findItems(e.value);
        if (!items || items.length == 0) {
            e.isValid = false;
            e.errorText = "输入值不在下拉数据中";
        }
    }
	
	var phonePattern = /^1\d{10,10}$/;
    function onPhoneValidation(e){
    	if (e.isValid) {
            if(!phonePattern.test(e.value)){
            	e.errorText = "请输入规范的手机号";
                e.isValid = false;
            };
        }
    }
    
    /** 数字金额大写转换(可以处理整数,小数,负数) */    
    function toDX(n)     
    {    
        var fraction = ['角', '分'];    
        var digit = ['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖'];    
        var unit = [ ['元', '万', '亿'], ['', '拾', '佰', '仟']  ];    
        var head = n < 0? '欠': '';    
        n = Math.abs(n);    
      
        var s = '';    
      
        for (var i = 0; i < fraction.length; i++)     
        {    
            s += (digit[Math.floor(n * 10 * Math.pow(10, i)) % 10] + fraction[i]).replace(/零./, '');    
        }    
        s = s || '整';    
        n = Math.floor(n);    
      
        for (var i = 0; i < unit[0].length && n > 0; i++)     
        {    
            var p = '';    
            for (var j = 0; j < unit[1].length && n > 0; j++)     
            {    
                p = digit[n % 10] + unit[1][j] + p;    
                n = Math.floor(n / 10);    
            }    
            s = p.replace(/(零.)*零$/, '').replace(/^$/, '零')  + unit[0][i] + s;    
        }    
        return head + s.replace(/(零.)*零元/, '元').replace(/(零.)+/g, '零').replace(/^整$/, '零元整');    
    }
    
	// 解决IE6下，无法显示透明的png图片
	function fixPNG(myImage) {
		var arVersion = navigator.appVersion.split("MSIE");
		var version = parseFloat(arVersion[1]);
		if (version >= 5.5 && version < 7 && document.body.filters){
    		var imgID = myImage.id ? "id='" + myImage.id + "' " : "";
			var imgClass = myImage.className ? "class='" + myImage.className + "' " : "";
			var imgTitle = myImage.title ? "title='" + myImage.title   + "' " : "title='" + myImage.alt + "' ";
			var imgStyle = "display:inline-block;" + myImage.style.cssText;
			var strNewHTML = "<span " + imgID + imgClass + imgTitle + " style=\"width:" + myImage.width + "px; height:" + myImage.height+ "px;" + imgStyle 
				+ ";filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'" + myImage.src + "\', sizingMethod='scale');\"></span>";
			myImage.outerHTML = strNewHTML;
		}
	}
	
	function myTrim(x) {
      return x.replace(/^\s+|\s+$/gm,'');
    }
	//打印
	function preview(){
// 		bdhtml=window.document.body.innerHTML;//获取当前页的html代码
//         sprnstr="<!--startprint-->";//设置打印开始区域
//         eprnstr="<!--endprint-->";//设置打印结束区域
//         prnhtml=bdhtml.substring(bdhtml.indexOf(sprnstr)+18); //从开始代码向后取html
//         prnhtml=prnhtml.substring(0,prnhtml.indexOf(eprnstr));//从结束代码向前取html
//         window.document.body.innerHTML=prnhtml;
        window.print();
//         window.document.body.innerHTML=bdhtml;
	}
	
// 	// 修改全局img标签，使png格式图片能够在IE6下正常显示
// 	function correctPNG() {
// 		  var arVersion = navigator.appVersion.split("MSIE")
// 		  var version = parseFloat(arVersion[1])
// 		  if ((version >= 5.5) && (document.body.filters)) {
// 		    var lee_i = 0;
// 		    var docimgs=document.images;
// 		    for (var j = 0; j < docimgs.length; j++) {
// 		      var img = docimgs[j]
// 		      var imgName = img.src.toUpperCase();
// 		      if (imgName.substring(imgName.length - 3, imgName.length) == "PNG" && !img.getAttribute("usemap")) {
// 		        lee_i++;
// 		        var SpanID = img.id || 'ra_png_' + lee_i.toString();
// 		        var imgData = new Image();
// 		        imgData.proData = SpanID;
// 		        imgData.onload = function () {
// 		          $("#" + this.proData).css("width", this.width + "px").css("height", this.height + "px");
// 		        }
// 		        imgData.src = img.src;
// 		        var imgID = "id='" + SpanID + "' ";
// 		        var imgClass = (img.className) ? "class='" + img.className + "' " : ""
// 		        var imgTitle = (img.title) ? "title='" + img.title + "' " : "title='" + img.alt + "' "
// 		        var imgStyle = "display:inline-block;" + img.style.cssText
// 		        if (img.align == "left") imgStyle = "float:left;" + imgStyle
// 		        if (img.align == "right") imgStyle = "float:right;" + imgStyle
// 		        if (img.parentElement.href) imgStyle = "cursor:hand;" + imgStyle
// 		        var strNewHTML = "<span " + imgID + imgClass + imgTitle
// 		       + " style=\"" + "width:" + img.width + "px; height:" + img.height + "px;" + imgStyle + ";"
// 		       + "filter:progid:DXImageTransform.Microsoft.AlphaImageLoader"
// 		       + "(src=\'" + img.src + "\', sizingMethod='scale');\"></span>"
// 		        img.outerHTML = strNewHTML;
// 		        j = j - 1;
// 		      }
// 		    }
// 		  }
// 		}
// 		//判断是否为IE8及以下浏览器，其实除了这三个浏览器不支持addEventListener，其它浏览器都没问题
// 		if (typeof window.addEventListener == "undefined" && typeof document.getElementsByClassName == "undefined") {
// 		  window.attachEvent("onload", correctPNG);
// 		}

	
</script>