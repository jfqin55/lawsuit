package com.zy.filter;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import com.google.common.base.Strings;
import com.rps.util.D;
import com.zy.bean.bus.TBUser;
import com.zy.bean.sys.TSLog;
import com.zy.util.Constant;
import com.zy.util.RequestUtil;

public class PermissionFilter extends OncePerRequestFilter {

//	private static final Logger log = LoggerFactory.getLogger(PermissionFilter.class);

	private static String[] PASS_URLS = new String[] { "/login", "/index", "/static", "/captcha", "/favicon.ico", "/portal/bill/showBillFromQRcode", "/portal/bill/get", "/portal/borrowType/get" };

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
		Boolean isPassable = checkPassable(request);
		if(isPassable){
			filterChain.doFilter(request, response);
		}else{
			String requestType = request.getHeader("X-Requested-With");  
			if(!Strings.isNullOrEmpty(requestType) && requestType.equalsIgnoreCase("XMLHttpRequest")){
				// 1、处理session超时后的ajax请求
				response.setHeader("sessionstatus", "timeout");  
				response.sendError(518, "session timeout.");  
			    return;
			}else{
				// 2、处理session超时后的页面跳转
//				response.sendRedirect(request.getContextPath() + "/login");
				String url = request.getContextPath() + "/login";
				PrintWriter out = response.getWriter();
				out.println("<html><body>");
				out.println("<script>");
//				out.println("var a = document.createElement('a');");
//				out.println("a.setAttribute('href', '" + url + "');");
//				out.println("a.setAttribute('target', '_top');");
//				out.println("a.setAttribute('id', 'openwin');");
//				out.println("document.body.appendChild(a);");
//				out.println("a.click();");
				out.println("window.open('" + url + "','_top')");
				out.println("</script>");  
				out.println("</body></html>");
			}
		}
		return;
	}

	private static Boolean checkPassable(HttpServletRequest request) {
		String servletPath = request.getServletPath();
		if(StringUtils.isEmpty(servletPath)) return false;
		// 如果是登陆或访问静态内容，则直接放行
		for (String passUrl : PASS_URLS) {
			if (servletPath.startsWith(passUrl)) return true;
		}
		// 如果是退出登陆，则清空缓存
		if(servletPath.startsWith("/logout")){
			RequestUtil.removeSessionAtrribute(request, "user");
			return false;
		}
		// 到这里说明是业务请求
		TBUser user = (TBUser)RequestUtil.getSessionAttribute(request, "user");
		if(user == null) return false;
		// 如果要访问后台页面，则必须是管理员
		if(!Constant.UserRole.ADMIN.equals(user.getRole_id()) && servletPath.startsWith("/admin")) return false;
		if(!Constant.UserRole.YS.equals(user.getRole_id()) && servletPath.startsWith("/portal/budget")) return false;
		// 如果是ajax查询操作(.json)，则直接放行
		if(servletPath.endsWith(".json")) return true;
		// 记录系统日志
		insertTBLog(request, servletPath, user);
//		// 如果是ajax更改操作(.do)
//		if(servletPath.endsWith(".do")){
//			return true;
//		}
//		// 如果访问动态页面，则验证其权限
//		List<String> resources = user.getResources();
//		for (String resource : resources) {
//			if (StringUtils.equals(servletPath, resource)) {
//				return true;
//			}
//		}
		return true;
	}

	private static void insertTBLog(HttpServletRequest request, String servletPath, TBUser user) {
		try {
			TSLog log = new TSLog();
			log.setAccess_time(new Date());
			log.setAccess_url(servletPath);
			log.setUser_id(user.getUser_id());
			// 如果使用了代理(如nginx),X-Forwarded-For会附加在http header上
			String user_ip="0.0.0.0"; 
			if (request.getHeader("X-Forwarded-For") == null) { 
				user_ip = request.getRemoteAddr(); 
			}else{ 
				user_ip = request.getHeader("X-Forwarded-For");
			}
			log.setUser_ip(user_ip); //(String)request.getAttribute("X-real-ip")
			D.insert(log);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
