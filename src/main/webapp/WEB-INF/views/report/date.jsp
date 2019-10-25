<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<title></title>
	<jsp:include page="/easyui.jsp" />
	<!--highcharts-->
	<script type="text/javascript" src="${res}/highcharts/highcharts.js"></script>
    <script type="text/javascript" src="${res}/highcharts/modules/exporting.src.js"></script>
	<style type="text/css">
		html, body{
			margin:0;padding:0;border:0;width:100%;height:100%;
		}
    </style>
</head>
<body>
<div style="margin-left:0.5%;margin-top:0.5%;border:0px solid black;width:99%;height:95%;">
	<div class="mini-toolbar" style="padding-bottom:5px; margin-top:5px; border:0;">
		&nbsp;&nbsp;
		<input id="department_id_search" class="mini-buttonedit" style="width:150px;" onbuttonclick="onButtonEdit" allowInput="false" emptyText="请选择部门"/>
        <input id="subject_id_search" class="mini-combobox" textField="subject_name" valueField="subject_id" allowInput="true" style="width:150px;" emptyText="请选择科目"
            url="${ctx}/portal/bill/getSubjectList.json" onenter="searchByParams" showNullItem="true"/>
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <a id="subButton" class="mini-button" iconCls="icon-search" onclick="searchByParams">查询</a>&nbsp;
        <a id="excelButton" class="mini-button" iconCls="icon-print" enabled="false" onclick="exportExcel()">导出excel</a>
    </div>
    
    <div id="line" style="width:100%;height:100%;"></div>
    
    <div style="margin-top:7px;">
	    <div id="chart" style="width:500px;height:380px;margin:auto;"></div>
    </div>
    
    <form id="excelForm" action="" method="post" target="_self"></form>
</div>
	
<script type="text/javascript">

	mini.parse();
	
	var subject_id_search = mini.get("subject_id_search");
	var department_id_search = mini.get("department_id_search");
	
	Highcharts.setOptions({
        lang:{
           contextButtonTitle:"图表导出菜单",
           decimalPoint:".",
           downloadJPEG:"下载JPEG图片",
           downloadPDF:"下载PDF文件",
           downloadPNG:"下载PNG文件",
           downloadSVG:"下载SVG文件",
           downloadCSV:"下载CSV文件",
           downloadXLS:"下载XLS文件",
           viewData:"下方显示数据表",
           drillUpText:"返回 {series.name}",
           loading:"加载中",
           months:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],
           noData:"没有数据",
           numericSymbols: [ "千" , "兆" , "G" , "T" , "P" , "E"],
           printChart:"打印图表",
           resetZoom:"恢复缩放",
           resetZoomTitle:"恢复图表",
           shortMonths: [ "Jan" , "Feb" , "Mar" , "Apr" , "May" , "Jun" , "Jul" , "Aug" , "Sep" , "Oct" , "Nov" , "Dec"],
           thousandsSep:",",
           weekdays: ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六","星期天"],
           viewFullscreen: "全屏显示"
        }
    });
	
	function showChart(nameList, dataList){
		var chart = new Highcharts.Chart({
            chart: { renderTo: 'line', type: 'line' },
            credits: { enabled: false },
            title: { text: '费用走势' },
            xAxis: { categories: nameList },
//             xAxis: { categories: ["1月","2月","3月","4月","5月","6月","7月","8月"] },
            yAxis: { title: {text: '费用支出'} },
            tooltip: { valueSuffix: '万' },
            legend: { 
                layout: 'vertical', 
                align: 'right', 
                verticalAlign: 'middle' },
            plotOptions: { 
                line: { 
                    dataLabels: {
                        enabled: true, 
                        format: '{point.y:.2f}万'}}},  // 开启数据标签       
            series: [{
                name: '三峡农商行', 
                data: dataList }]
//                 data: [43.93, 52.50, 5.71, 69.65, 97.03, 119.9, 13.71, 15.4]}]
        });
    }
	
	function onButtonEdit(e) {
        var btnEdit = this;
        mini.open({
            url: '${ctx}/portal/bill/showOrgs.json',
            title: "详情", width: 300, height: 600,
            onload: function(){
                var iframe = this.getIFrameEl();
                var data = { action: "edit", row: {} };
                iframe.contentWindow.SetData(data);
            },
            ondestroy: function(action){
                if(action == "ok"){
                    var data = this.getIFrameEl().contentWindow.GetData();//调用子页面 GetData 方法
                    data = mini.clone(data);
                    if (data) {
                        btnEdit.setValue(data.id);
                        btnEdit.setText(data.text);
                    }
                }
            }
        });
    } 
	
	function searchByParams(e){
		var subject_id = subject_id_search.getFormValue();
		var department_id = department_id_search.getFormValue();
		mini.get("subButton").disable();
        showMask();
        $.ajax({
            url: "${ctx}/report/date/showMonthChart.do?subject_id=" + subject_id + "&department_id=" + department_id,
            success: function (data) {
                hideMask();
                mini.get("subButton").enable();
                var nameList = [];
                var dataList = [];
                for(var i=0; i<data.length; i++){
                	nameList.push(data[i].name);
                	dataList.push(data[i].data/1000000);
                }
                showChart(nameList, dataList);
                mini.get("excelButton").enable();
            },
            error: function () {
                hideMask();
                notifyOnBottomRight('操作失败!');
            }
        });
	}
	
	function exportExcel(){
		mini.confirm("确认导出 excel 报表?", "提示", function(action){
            if (action == "ok") {
            	var url = '${ctx}/report/subject/exportExcel.do';
    	    	$("#excelForm").attr('action', url);
    	    	$("#excelForm").submit();
            }
        });
	}
	
</script>
</body>
</html>