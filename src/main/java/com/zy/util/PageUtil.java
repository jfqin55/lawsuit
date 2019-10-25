package com.zy.util;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.rps.util.D;
import com.rps.util.dao.Page;

public class PageUtil {

	/**
	 * 获取分页数据
	 */
	public static PageModel getPageModel(Class<?> clazz, String clojureId, HttpServletRequest request) {
		Page<?> page = D.defSql(clojureId, request).pageSqlAndParams(clazz);
		PageModel PageModel = new PageModel(page.getTotalCount(), page.getData());
		return PageModel;
	}

	public static PageModel getPageModel(Class<?> clazz, String clojureId, HttpServletRequest request,Map map) {
		Page<?> page = D.defSql(clojureId, request,map).pageSqlAndParams(clazz);
		PageModel PageModel = new PageModel(page.getTotalCount(), page.getData());
		return PageModel;
	}
}
