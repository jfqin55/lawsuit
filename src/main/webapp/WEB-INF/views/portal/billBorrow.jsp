<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!--startprint-->
<!doctype html>
<html>
<head>
	<title>三峡农商银行借款单</title>
	<jsp:include page="/easyui.jsp" />
	
	<link  href="${res}/viewer/viewer.css" rel="stylesheet">
    <script src="${res}/viewer/viewer.js"></script>
    
	<style type="text/css">
		html, body{ margin:0;padding:0;border:0;width:100%;height:100%;overflow:hidden; }
		@page { size: 14in 7in; }
    </style>
</head>
<body>
	<div class="mini-layout" style="width:99%;height:100%;">
		<%--右侧面板--%>
		<div region="east" title="注意" width="200" height="100" showSplit="true" showCollapseButton="false">
			<div style="margin-left:7px;">
			    1、部分借款类别可能受预算控制，申请该类别借款会占用部门整体预算额度。<br/>
		   		2、图片上传支持<span style="color:rgb(197,52,65);">&nbsp;jpg&nbsp;或&nbsp;png&nbsp;</span>格式。<br/>
		   		3、图片大小最多支持<span style="color:rgb(197,52,65);">&nbsp;10M&nbsp;</span>，图片过大会导致上传失败。<br/>
		   		<img src="" id="showImg" width="180" height="180" style="margin-top:50px;"/><br/>
		   		<a class="mini-button" onclick="previewPrint('borrow')" style="width:100px;margin-top:5px;">打印借款单</a><br/>
                <a class="mini-button" onclick="previewPrint('copy')" style="width:100px;margin-top:5px;">打印粘贴单</a>
	   		</div>
		</div>
		<%--中间页面展示区--%>
		<div showHeader="false" region="center">
            <form id="detailForm" method="post">
		        <div class="form">
		        <input class="mini-hidden" name="bill_id"/>
		        
		        <fieldset id="fieldset0" style="width:94%;border:solid 1px #aaa;margin-left:1.2%;display:inline;margin-top:1%;">
		            <legend>单据表头</legend>
		            <div style="padding:5px;">
		            <table style="width:100%;">
		                <tr>
		                    <td style="width:100px;" align="right">借款人:</td>
                            <td><input name="user_name" class="mini-textbox" enabled="false" required="true" style="width:150px;" value="${user.user_name}"/></td>
                            <td style="width:100px;" align="right">借款单位:</td>
                            <td><input name="department_name" class="mini-textbox" enabled="false" required="true" style="width:150px;" value="${user.department_name}"/></td>
		                    <td style="width:100px;" align="right">日期:</td>
		                    <td><input id="create_time" name="create_time" class="mini-datepicker" enabled="false" required="true" emptyText='' style="width: 150px;"/></td>
		                </tr>
		                <tr height="7px;"></tr>
		            </table>
		            </div>
		        </fieldset>
		        
		        <fieldset style="width:94%;border:solid 1px #aaa;margin-left:1.2%;margin-top:1%;">
                    <legend>借款信息</legend>
                    <div style="padding:5px;">
                    <table style="width:100%;">
                        <tr>
                            <td style="width:100px;" align="right">借款类别:</td>
                            <td><input name="borrow_type_id" class="mini-combobox" textField="borrow_type_name" valueField="borrow_type_id" allowInput="false" style="width:150px;" emptyText=""
                                url="${ctx}/portal/borrowType/getBorrowTypeList.json" showNullItem="false" required="true" onvaluechanged="changeBorrowType"/>
                            </td>
                            <td style="width:100px;" align="right">借款金额(小写):</td>
                            <td><input name="bill_amount" class="mini-textbox" required="true" vtype="float" onvaluechanged="onBillAmountChanged" style="width:130px;"/> 元</td>
                            <td style="width:100px;" align="right">借款金额(大写):</td>
                            <td><input id='bill_amount_big' name="bill_amount_big" class="mini-textbox" required="true" style="width:150px;" enabled="false"/></td>
                        </tr>
                        <tr height="7px;"></tr>
                        <tr>
                            <td style="width:100px;color:red;" align="right">可用预算额度:</td>
                            <td><input id="canUseAmount" class="mini-textbox" enabled="false" style="width:150px;"/></td>
                            <td style="width:100px;" align="right">借款事由:</td>
                            <td><input name="borrow_reason" class="mini-textbox" required="true" style="width:150px;"/></td>
                            <td style="width:100px;" align="right">备注:</td>
                            <td><input name="remark" class="mini-textbox" style="width:150px;"/></td>
                        </tr>
                        <tr height="7px;"></tr>
                        <tr>
                            <td style="width:100px;" align="right">附件上传:</td>
                            <td colspan="3">
                                <a id="fileupload1" class="mini-button" onclick="openMultiUploadWin" style="width:70px;">点击上传</a>
<!--                                 <a id="preview_fileupload1" class="mini-button" onclick="previewImgs" style="width:44px;">预&nbsp;览</a> -->
                            </td>
                        </tr>
                        <tr id="beforeImg" height="7px;"></tr>
                        <tr id="images">
                        
                        </tr>
                    </table>
                    </div>
                </fieldset>
                
                <fieldset id="fieldset5" style="width:94%;border:solid 1px #aaa;margin-left:1.2%;margin-top:1%;">
                    <legend>账户信息</legend>
                    <div style="padding:5px;">
                    <table style="width:100%;">
                        <tr>
                            <td style="width:100px;" align="right">收款账号:</td>
                            <td><input id="user_account" name="user_account" class="mini-combobox" textField="user_account" valueField="user_account" allowInput="true" style="width:150px;"
                                url="${ctx}/portal/bill/getUserAccountList.json" showNullItem="false" emptyText='' required="true" /></td>
                        </tr>
                        <tr height="7px;"></tr>
                    </table>
                    </div>
                </fieldset>
		        
		        <table style="width:100%;">
		            <tr>
		                <td style="padding-top: 17px;" align="center" id="tableFooter">
		                    <a class="mini-button" onclick="onOk" style="width:60px;margin-right:20px;">确定</a>       
		                    <a class="mini-button" onclick="onCancel" style="width:60px;">取消</a>   
		                </td>
		            </tr>
		        </table>
		        </div>
		        
		    </form>
		</div>
	</div>
	
<script type="text/javascript">
	mini.parse();
	
	var create_time = mini.get('create_time');
	var today = new Date();
// 	today.setHours(0,0,0);
	// var todayTime = today.getTime()-24*3600000;
	create_time.setValue(today);
	
	var detailForm = new mini.Form("detailForm");
	
	var record = {action: 'create'};
// 	mini.get('preview_fileupload1').hide();
	
	function onOk(e){
        detailForm.validate();
        if(detailForm.isValid() == false) return;
        if(billAnnexes.length<1){
            mini.alert("请上传附件！");
            return;
        }
        var obj = detailForm.getData(true);
        if(force_switch==1 && canUseAmount < obj.bill_amount){
        	mini.alert("金额已超出预算！");
            return;
        }
        mini.confirm("请确认资料上传齐全！", "确定?", function(action){
            if (action == "ok") {
                showMask();
                
                obj.bill_amount = (obj.bill_amount * 100).toFixed(0);
                obj.bill_type = billTypeArr[1].id;
                
                var json = mini.encode(obj);
                var billAnnexesJson = mini.encode(billAnnexes);
                
                $.post("${ctx}/portal/bill/createOrUpdate.do?action=" + record.action, {submitData: json, billAnnexesJson: billAnnexesJson}, function(data){
                    hideMask();
                    if(data == true){
                    	if(record.action == "create"){
                    		mini.confirm("操作成功!", "确定?", function(action){
                                window.location.reload();
                            });
                    	}else{
                    		CloseWindow("ok");
                    	}
                    }else{
                        notifyOnBottomRight("服务器繁忙,请稍后重试");
                    }
                });
            }
        });
    }
	
	var qrcodeBillId = '${qrcodeBillId}';
    if(!qrcodeBillId){}else{
        $.post("${ctx}/portal/bill/getBillById.json", {bill_id: qrcodeBillId}, function(data){
            if(!data) return;
            var row = data;
            row.bill_amount = row.bill_amount/100;
            detailForm.setData(row);
            detailForm.setEnabled(false);
            document.getElementById("tableFooter").style.display = "none";
        });
    }
    
    var qrcodeBillId = '${qrcodeBillId}';
    if(!qrcodeBillId){}else{
        $.post("${ctx}/portal/bill/getBillById.json", {bill_id: qrcodeBillId}, function(data){
            if(!data) return;
            detailInit(data);
        });
    }
	
	// 该方法为父页面生成子页面时调用
	function SetData(data){
	    //跨页面传递的数据对象，克隆后才可以安全使用
	    record = mini.clone(data);
	    if(record.action == "update"){
	    	record.row.remark = "本次为重新提交，上次申请被拒绝原因：" + record.row.remark_check
	    	detailInit(record.row);
            detailForm.setEnabled(true);
            document.getElementById("tableFooter").style.display = "block";
            mini.get('fileupload1').show();
//             mini.get('preview_fileupload1').hide();
	    }else if(record.action == "detail"){
	        detailInit(record.row);
	    }
	}
	
	function detailInit(row){
		row.bill_amount = row.bill_amount/100;
        detailForm.setData(row);
        detailForm.setEnabled(false);
        
        var userAccountComb = mini.get("user_account");
        if(userAccountComb){
//             userAccountComb.load("${ctx}/portal/bill/getUserAccountListByBill.json?user_id=" + row.user_id);
            userAccountComb.set({
                data:[{"user_account": row.user_account}]
            });
            userAccountComb.setValue(row.user_account);
        }
        
        mini.get('fileupload1').hide();
        $.post("${ctx}/portal/bill/getBillAnnexes.json", {bill_id: row.bill_id}, function(data){
            billAnnexes = data;
//             mini.get('preview_fileupload1').show();
            // 缩略图
//             $.each(billAnnexes, function(i){
//                 var newRow = "<tr>";
//                 newRow += "<td colspan='4'><img src='"+billAnnexes[i].annex_url+"' style='padding-top:9px;width:200px;' onclick=previewImg1('"+billAnnexes[i].annex_url+"') /></a></td>";
//                 newRow += "</tr><tr><td height='7px;'></td></tr>";
                
//                 $("#beforeImg").after(newRow);
//                 mini.parse();
//             });
            var imgList = "";
            $.each(billAnnexes, function(i){
                imgList += "<img width='200px' src='"+billAnnexes[i].annex_url+"' alt='"+billAnnexes[i].annex_type+"'>";
            });
            
            $("#images").html(imgList);
            var viewer = new Viewer(document.getElementById('images'),{
                loop: false
            });
        });
        
        document.getElementById("tableFooter").style.display = "none";
        $("#showImg")[0].src = row.bill_qrcode_url;
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
	
	var billAnnexes = [];
	function openMultiUploadWin(e) {
	    mini.open({
	        url: '${ctx}/portal/bill/showUploadWindow.json',
	        title: "文件上传", width: 600, height: 350, allowResize: false,
	        onload: function(){
	            var iframe = this.getIFrameEl();
	            var data = {};
	            iframe.contentWindow.SetData(data);
	        },
	        ondestroy: function(action){
	            if(action != "ok") return;
	            mini.get(e.source.id).hide();
// 	            mini.get('preview_'+e.source.id).show();
	            var data = this.getIFrameEl().contentWindow.GetData();
	            var imgs = mini.clone(data);
	            
	            $.each(imgs, function(i){
                    var billAnnex = {annex_type: e.source.text, annex_url: imgs[i].img_url};
                    billAnnexes.push(billAnnex);
                });
	            
	            // 缩略图
// 	            $.each(billAnnexes, function(i){
// 	                var newRow = "<tr>";
// 	                newRow += "<td colspan='4'><img src='"+billAnnexes[i].annex_url+"' style='padding-top:9px;width:200px;' onclick=previewImg1('"+billAnnexes[i].annex_url+"') /></a></td>";
// 	                newRow += "</tr><tr><td height='7px;'></td></tr>";
	                
// 	                $("#beforeImg").after(newRow);
// 	                mini.parse();
// 	            });
	            
	            var imgList = "";
            $.each(billAnnexes, function(i){
                imgList += "<img width='200px' src='"+billAnnexes[i].annex_url+"' alt='"+billAnnexes[i].annex_type+"'>";
            });
            
            $("#images").html(imgList);
            var viewer = new Viewer(document.getElementById('images'));
	//             var json = mini.encode(data);
	        }
	    });
	}
	
	function onBillAmountChanged(e){
		mini.get('bill_amount_big').setValue(toDX(e.sender.value));
	}
	
	function previewImgs(e){
// 		$.each(billAnnexes, function(i){
// 			mini.open({
// 	            url: '${ctx}/portal/bill/showPreviewWindow.json',
// 	            title: billAnnexes[i].annex_type, width: 600, height: 600, showMaxButton: true,
// 	            onload: function(){
// 	                var iframe = this.getIFrameEl();
// 	                iframe.contentWindow.SetData(billAnnexes[i]);
// 	            }
// 	        });
// 		});
	}
	
	function previewImg1(annex_url){
        mini.open({
            url: '${ctx}/portal/bill/showPreviewWindow.json',
            title: "", width: 600, height: 600, showMaxButton: true,
            onload: function(){
                var iframe = this.getIFrameEl();
                var billAnnex = {};
                billAnnex.annex_url = annex_url;
                iframe.contentWindow.SetData(billAnnex);
            }
        });
    }
	
	var canUseAmount = -1;
	var force_switch = 0;
	function changeBorrowType(e){
        $.post("${ctx}/portal/bill/getCanUseBudgetBySubject.json", {subjectId: e.selected.subject_id}, function(data){
            canUseAmount = data.canUseAmount/100;
            force_switch = data.force_switch;
            mini.get('canUseAmount').setValue(canUseAmount < 0 && canUseAmount > -1 ? '未限制' : canUseAmount);
        });
    }
	
	function previewPrint(action){
        if(record.row && record.row.bill_id.length > 0){
            mini.open({
                url: '${ctx}/portal/bill/showPreviewPrint.json',
                title: "打印预览", width: 1200, height: 700, showMaxButton: true,
                onload: function(){
                    var iframe = this.getIFrameEl();
                    var data = { url: record.row.bill_qrcode_url, action: action, bill_id: record.row.bill_id};
                    iframe.contentWindow.SetData(data);
                },
                ondestroy: function(action){
                    
                }
            });
        }
    }
</script>
</body>
</html>
<!--endprint-->