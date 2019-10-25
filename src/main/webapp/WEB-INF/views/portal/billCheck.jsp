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
    <div class="mini-fit" >
        <div id="grid" class="mini-datagrid" style="width:100%;height:100%;" allowResize="true" ondrawcell="onDrawCell"
            url="${ctx}/portal/bill/check/selectAll.json" idField="check_id" multiSelect="true" pageSize=100>
            <div property="columns">
                <div type="indexcolumn"></div>
                <div field="auditor_name" width="80" align="center" headerAlign="center" allowSort="true">审批人</div>
                <div field="check_status" width="80" align="center" headerAlign="center" allowSort="true">审批结果</div>
                <div field="remark" width="240" align="center" headerAlign="center" allowSort="true">备注</div>
                <div field="update_time" width="120" align="center" headerAlign="center" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">审批时间</div>
            </div>
        </div>
    </div>
<script type="text/javascript">
	mini.parse();
	var grid = mini.get("grid");
	
	function onDrawCell(e){
        var record = e.record;
        var value = e.value;
        if(value == null) value = "";
        
        if(e.field == 'check_status'){
            for(i in checkStatusArr){
                if(checkStatusArr[i].id == value) e.cellHtml = "<span style='color:"+ checkStatusArr[i].color +";font-weight:bold;'>"+ checkStatusArr[i].text +"</span>";
            }
        }
        
    }
	
	// 该方法为父页面生成子页面时调用
	function SetData(data) {
		//跨页面传递的数据对象，克隆后才可以安全使用
        record = mini.clone(data);
        grid.load({
        	bill_id: record.row.bill_id // 除分页排序参数外的额外参数
        }, null, gridLoadFail);
    }
</script>
</body>
</html>
