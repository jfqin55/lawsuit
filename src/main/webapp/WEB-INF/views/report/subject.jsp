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
        <input id="search_type" class="mini-combobox" textField="text" valueField="id" allowInput="false" onvaluechanged="onSearchTypeChanged"
			data="[{id:'1', text:'按月份查询'}, {id:'2', text:'自定义查询'}]" style="width:90px;" value="1" />
        <input id="month_search" class="mini-combobox" textField="text" valueField="id" allowInput="false" data='${monthList }' style="width:100px;"/>
        <span id="time_period" style="display:none;">
        	<input id="start_time_search" class="mini-datepicker" emptyText="请选择开始时间"/> 至 <input id="end_time_search" class="mini-datepicker" emptyText="请选择结束时间"/>
        </span>
        <input id="department_id_search" class="mini-buttonedit" style="width:150px;" onbuttonclick="onButtonEdit" allowInput="false" emptyText="请选择部门"/>
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <a id="subButton" class="mini-button" iconCls="icon-search" onclick="searchByParams">查询</a>&nbsp;
        <a id="excelButton" class="mini-button" iconCls="icon-print" enabled="false" onclick="exportExcel()">导出excel</a>
    </div>
    
    <div id="subjectColumn" style="width:100%;height:100%;"></div>
    
    <div style="margin-top:7px;">
	    <div id="chart" style="width:500px;height:380px;margin:auto;"></div>
    </div>
    
    <form id="excelForm" action="" method="post" target="_self"></form>
</div>
	
<script type="text/javascript">

	mini.parse();
	var search_type = mini.get("search_type");
	var time_period = $("#time_period");
	var start_time_search = mini.get("start_time_search");
	var end_time_search = mini.get("end_time_search");
	
	var month_search = mini.get("month_search");
	//默认选中第一个选择项
	month_search.select(0);
	
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
	
	function showChart(title, columnList){
		var chart = new Highcharts.Chart({
	        chart: { renderTo: 'subjectColumn', type: 'column' },
	        credits: { enabled: false },
	        title: { text: title + ' 费用支出排行(按科目)' },
	        xAxis: { type: 'category' },
	        yAxis: { min: 0, title: { text: '' } },
	        legend: { enabled: false },
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
	            data: columnList }]
// 	            data: [['差旅费',399.9], ['业务宣传费',291.5], ['研究开发费',186.4], ['会议费',159.2], ['咨询费',134.0], ['保险费',116.0], ['监管费',95.6], ['水电费',78.5], ['公杂费',66.4], ['业务招待费',54.1]] } ]
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
	
	function onSearchTypeChanged(e){
		var choice = search_type.getFormValue();
		if(choice == '1'){
			month_search.show();
			time_period.hide();
		}
		if(choice == '2'){
			month_search.hide();
			time_period.show();
		}
	}
	
	function searchByParams(e){
		var department_id = department_id_search.getFormValue();
		var choice = search_type.getFormValue();
		if(choice == '1'){
			var month = month_search.getFormValue();
			mini.get("subButton").disable();
			showMask();
			$.ajax({
				url: "${ctx}/report/subject/showMonthChart.do?month=" + month + "-01&department_id=" + department_id,
				success: function (data) {
					hideMask();
					mini.get("subButton").enable();
					var columnList = [];
                    for(var i=0; i<data.length; i++){
                        var column = [];
                        column.push(data[i].name);
                        column.push(data[i].data/1000000);
                        columnList[i] = column;
                    }
					showChart(month, columnList);
					mini.get("excelButton").enable();
				},
				error: function () {
					hideMask();
					notifyOnBottomRight('操作失败!');
				}
			});
		}
		// 自定义时间段
		if(choice == '2'){
			var start_time = start_time_search.getFormValue();
			var end_time = end_time_search.getFormValue();
			if(start_time.length == 0){
				notifyOnBottomRight('请选择开始时间!');
				return;
			}
			if(end_time.length == 0){
				notifyOnBottomRight('请选择结束时间!');
				return;
			}
			
			var startDateStr = start_time + " 00:00:00";
			var endDateStr = end_time + " 23:59:59";
			
			mini.get("subButton").disable();
			showMask();
			$.ajax({
				url: "${ctx}/report/subject/showCustomChart.do?startDateStr=" + startDateStr + "&endDateStr=" + endDateStr + "&department_id=" + department_id,
				success: function (data) {
					hideMask();
					mini.get("subButton").enable();
					var columnList = [];
                    for(var i=0; i<data.length; i++){
                        var column = [];
                        column.push(data[i].name);
                        column.push(data[i].data/1000000);
                        columnList[i] = column;
                    }
	 				showChart(start_time + "至" + end_time, columnList);
					mini.get("excelButton").enable();
				},
				error: function () {
					hideMask();
					notifyOnBottomRight('操作失败!');
				}
			});
		}
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