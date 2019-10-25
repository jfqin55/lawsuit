<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/taglibs.jsp" %>
<!doctype html>
<html>
<head>
<title>首页</title>
<jsp:include page="/easyui.jsp" />
<link href="${res}/miniui/portal/portal.css" rel="stylesheet" type="text/css" />
<script src="${res}/miniui/portal/portal.js" type="text/javascript"></script>
<!--highcharts-->
<script type="text/javascript" src="${res}/highcharts/highcharts.js"></script>
<script type="text/javascript" src="${res}/highcharts/modules/exporting.src.js"></script>
<%-- <script type="text/javascript" src="${res}/highcharts/themes/dark-unica.js"></script> --%>

<style>
    .mini-panel.max {position:fixed !important; width:100% !important; height:100% !important; left:0 !important; top:0 !important; z-index:10000;}    
</style>
</head>
<body>
<!-- 	<div id="totalBar" style="width:100%;height:100%;background:#1abc9c;font-size:40px;font-family:'黑体';color:white;text-align:left;line-height:100px;"> -->
<!-- 		<div style="margin-left:20px;">预算总额：300万，实际支出：230.88万</div> -->
<!-- 		<div style="margin-left:20px;">专项预算：100万，实际支出：60万</div> -->
<!-- 	</div> -->
	
<!-- 	<div id="account" style="width:100%;height:100%;background:#e84c3d;font-size:44px;font-family:'黑体';color:white;text-align:center;line-height:120px;"> -->
<%-- 		<c:choose> --%>
<%-- 			<c:when test="${mht.pay_type == '1'}">0 元</c:when> --%>
<%-- 			<c:otherwise>${mht.account/100 } 元</c:otherwise> --%>
<%-- 		</c:choose> --%>
<!-- 	</div> -->
<!-- 	<div id="monthNum" style="width:100%;height:100%;background:#3598db;font-size:44px;font-family:'黑体';color:white;text-align:center;line-height:120px;"></div> -->
	
	<div id="btns" style="width:100%;height:100%;">
	   <a class="mini-button" width="100" height="30" style="font-size:20px;font-weight:bold;padding:6px 6px 0px 6px;margin-left:60px;" onclick="createTab('301','报销申请','portal/bill/expense')">报销申请</a>
	   <a class="mini-button" width="100" height="30" style="font-size:20px;font-weight:bold;padding:6px 6px 0px 6px;margin-left:60px;" onclick="createTab('302','借款申请','portal/bill/borrow')">借款申请</a>
	   <a class="mini-button" width="100" height="30" style="font-size:20px;font-weight:bold;padding:6px 6px 0px 6px;margin-left:60px;" onclick="createTab('303','还款申请','portal/bill/refund')">还款申请</a>
	</div>
	<div id="totalBar" style="width:100%;height:100%;"></div>
<!-- 	<div id="subjectColumn" style="width:100%;height:100%;"></div> -->
<!-- 	<div id="deptColumn" style="width:100%;height:100%;"></div> -->
<!-- 	<div id="line" style="width:100%;height:100%;"></div> -->
</body>

<script type="text/javascript">

var chartArr = [];

function initPortal(){
	var portal = new mini.ux.Portal();
    portal.set({
        style: "width:100%; height:400px",
        columns: ["100%"]
//         columns: ["50%", "50%"]
    });
    portal.render(document.body);
    
    portal.setPanels([
// 		{ column: 0, id: "p1", buttons: "collapse max close", headerStyle: 'background:white;border:0px;', bodyStyle: "padding:0px;border:0px;", onbuttonclick: onbuttonclick, height: 250, title: "", body: "#totalBar" },
		{ column: 0, id: "p0", buttons: "max close", headerStyle: 'background:white;border:0px;', bodyStyle: "padding:0px;border:0px;", onbuttonclick: onbuttonclick, height: 80, title: "", body: "#btns" },
		{ column: 0, id: "p1", buttons: "max close", headerStyle: 'background:white;border:0px;', bodyStyle: "padding:0px;border:0px;", onbuttonclick: onbuttonclick, height: 400, title: "", body: "#totalBar" }
// 		{ column: 1, id: "p5", buttons: "max close", headerStyle: 'background:white;border:0px;', bodyStyle: "padding:0px;border:0px;", onbuttonclick: onbuttonclick, height: 250, title: "", body: "#subjectColumn" },
// 		{ column: 0, id: "p4", buttons: "max close", headerStyle: 'background:white;border:0px;', bodyStyle: "padding:0px;border:0px;", onbuttonclick: onbuttonclick, height: 250, title: "", body: "#deptColumn" },
// 		{ column: 1, id: "p2", buttons: "max close", headerStyle: 'background:white;border:0px;', bodyStyle: "padding:0px;border:0px;", onbuttonclick: onbuttonclick, height: 250, title: "", body: "#line" }
    ]);
    // 给id为p2的panel添加id为Button2的组件
//     var bodyEl = portal.getPanelBodyEl("p2");
//     bodyEl.appendChild(document.getElementById("Button2"));

    //获取配置的panels信息
//     var panels = portal.getPanels();
}

function maxPanel(id) {
    var panel = mini.get(id);
    panel.maxed = true;
    $(panel.el).addClass("max");
    $(panel.el).find(".mini-tools-max").addClass("mini-tools-restore");
    mini.layout();
    $.each(chartArr, function(i){
        chartArr[i].reflow();
    });
}

function restorePanel(id) {
    var panel = mini.get(id);
    panel.maxed = false;
    $(panel.el).find(".mini-tools-max").removeClass("mini-tools-restore");
    $(panel.el).removeClass("max");
    mini.layout();
    $.each(chartArr, function(i){
        chartArr[i].reflow();
    });
}

function onbuttonclick(e) {
    var panel = this;
    if (e.name == "max") {
        if (panel.maxed) {
            restorePanel(panel);
        } else {
            maxPanel(panel);
        }
    }
}

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

function createTab(menu_id, menu_name, menu_url){
    var node = {};
    node.menu_id = menu_id;
    node.menu_name = menu_name;
    node.menu_url = menu_url;
    window.parent.showTab(node);
}

$(function(){
	initPortal();
	showBarChart();
// 	showColumnChart();
// 	showColumnChartDept();
// 	showLineChart();

	$.ajax({
        url: "${ctx}/index/showChart.do",
        success: function (data) {
            showChart(data.year, data.usedYearBudget, data.usedSpecialBudget, data.yearBudget, data.specialBudget);
        },
        error: function () {
//             notifyOnBottomRight('操作失败!');
        }
    });

});

function showChart(year, usedYearBudget, usedSpecialBudget, yearBudget, specialBudget){
	var chart = new Highcharts.Chart({
        chart: { renderTo: 'totalBar', type: 'bar' },
        credits: { enabled: false },
        title: { text: year + ' 年预算使用情况' },
        xAxis: { type: 'category' },
        yAxis: { 
            min: 0, 
            title: { text: '', align: 'high' }, 
            labels: { overflow: 'justify' } },
        tooltip: { valueSuffix: ' 万' },
        plotOptions: { 
            bar: { 
                dataLabels: { 
                    enabled: true, 
                    allowOverlap: true, 
                    format: '{point.y:.2f}万' }}}, // allowOverlap允许数据标签重叠
        legend: { 
            layout: 'vertical', 
            align: 'right', 
            verticalAlign: 'top', 
            x: -40, y: 100, 
            floating: true, 
            borderWidth: 1,
            backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'), 
            shadow: true},
        series: [
            { name: '实际支出', data: [['年度预算',usedYearBudget/1000000]] }, 
            { name: '预算总额', data: [['年度预算',yearBudget/1000000]] }]
//             { name: '实际支出', data: [['年度预算',usedYearBudget], ['专项预算',usedSpecialBudget]] }, 
//             { name: '预算总额', data: [['年度预算',yearBudget], ['专项预算',specialBudget]] }]
    });
    chartArr.push(chart);
}


function showBarChart(){
	var chart = new Highcharts.Chart({
	    chart: { renderTo: 'totalBar', type: 'bar' },
	    credits: { enabled: false },
	    title: { text: '2019 年预算使用情况' },
	    xAxis: { type: 'category' },
	    yAxis: { 
	    	min: 0, 
	    	title: { text: '', align: 'high' }, 
	    	labels: { overflow: 'justify' } },
	    tooltip: { valueSuffix: ' 万' },
	    plotOptions: { 
	    	bar: { 
	    		dataLabels: { 
	    			enabled: true, 
	    			allowOverlap: true, 
	    			format: '{point.y:.2f}万' }}}, // allowOverlap允许数据标签重叠
	    legend: { 
	    	layout: 'vertical', 
	    	align: 'right', 
	    	verticalAlign: 'top', 
	    	x: -40, y: 100, 
	    	floating: true, 
	    	borderWidth: 1,
	        backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'), 
	        shadow: true},
	    series: [
	    	{ name: '实际支出', data: [['年度预算',207], ['专项预算',332]] }, 
	        { name: '预算总额', data: [['年度预算',973], ['专项预算',731]] }]
	});
	chartArr.push(chart);
}

function showColumnChart(){
	var chart =  new Highcharts.Chart({
	    chart: { renderTo: 'subjectColumn', type: 'column' },
	    credits: { enabled: false },
	    title: { text: '2019 年费用支出排行(按科目)' },
	    xAxis: { type: 'category' },
	    yAxis: { 
	    	min: 0, 
	    	title: { text: '' } },
	    legend: {
	        enabled: false},
	    tooltip: {
	        // head + 每个 point + footer 拼接成完整的 table
	        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
	        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
	        '<td style="padding:0"><b>{point.y:.2f} 万</b></td></tr>',
	        footerFormat: '</table>',
	        shared: true,
	        useHTML: true},
	    plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: true,
                    format: '{point.y:.2f}万'}}},
	    series: [{ 
	    	name: '科目', 
	    	data: [['差旅费',399.9], ['业务宣传费',291.5], ['研究开发费',186.4], ['会议费',159.2], ['咨询费',134.0], ['保险费',116.0], ['监管费',95.6], ['水电费',78.5], ['公杂费',66.4], ['业务招待费',54.1]] } ]
	});
	chartArr.push(chart);
}

function showColumnChartDept(){
    var chart = new Highcharts.Chart({
        chart: { renderTo: 'deptColumn', type: 'column' },
        credits: { enabled: false },
        title: { text: '2019 年费用支出排行(按部门)' },
        xAxis: { type: 'category' },
        yAxis: { 
        	min: 0, 
        	title: { text: '' } },
        legend: {
            enabled: false},
        tooltip: {
            // head + 每个 point + footer 拼接成完整的 table
            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>{point.y:.2f} 万</b></td></tr>',
            footerFormat: '</table>',
            shared: true,
            useHTML: true},
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: true,
                    format: '{point.y:.2f}万'}}},
        series: [{ 
        	name: '部门', 
        	data: [['小微金融部',399.9], ['信贷管理部',291.5], ['办公室',186.4], ['电子银行部',159.2], ['信息科技部',134.0], ['计划财务部',116.0]] } ]
    });
    chartArr.push(chart);
}

function showLineChart(){
    var chart = new Highcharts.Chart({
    	chart: { renderTo: 'line', type: 'line' },
        credits: { enabled: false },
        title: { text: '2019 年费用支出走势' },
        xAxis: { categories: ["1月","2月","3月","4月","5月","6月","7月","8月"] },
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
        	data: [43.93, 52.50, 5.71, 69.65, 97.03, 119.9, 13.71, 15.4]}]
    });
    chartArr.push(chart);
}

function showPieChart(seriesData){
	$('#pie').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false},
        title: {
            text: '',
            floating: true},
        credits: {enabled: false},
        tooltip: {
    	    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'},
        plotOptions: {
            pie: {
            	allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    color: '#000000',
                    connectorColor: '#000000',
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %'}}},
        series: [{
            type: 'pie',
            name: '占比',
            data: seriesData}]
//             data: [{name:'移动',y:33},{name:'联通',y:33},{name:'电信',y:34}]
    });
}

</script>
</html>