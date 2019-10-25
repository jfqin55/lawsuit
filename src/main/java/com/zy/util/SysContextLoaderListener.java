package com.zy.util;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletException;
import javax.sql.DataSource;

import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.impl.StdSchedulerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.ContextLoaderListener;

import com.alibaba.druid.pool.DruidDataSource;
import com.rps.util.D;
import com.rps.util.SpringContextUtil;
import com.rps.util.dao.dialet.MySqlDialet;
import com.zy.service.Job_OA;

public class SysContextLoaderListener extends ContextLoaderListener implements
		ServletContextListener {

	@Override
	public void contextDestroyed(ServletContextEvent event) {
		super.contextDestroyed(event);
	}

	public void contextInitialized(ServletContextEvent event) {
		super.contextInitialized(event);
		try {
			init();
			startQuartz();
			System.out.println("----------setDataSourceAndDialet success----------");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void init() throws ServletException, IOException {
		ApplicationContext ctx = getCurrentWebApplicationContext();
		SpringContextUtil.setApplicationContext(ctx);
		DataSource dataSource = SpringContextUtil.getBean("dataSource");
		D.setDataSourceAndDialet(dataSource, new MySqlDialet());
		D.setShowSqlLevel(3);//取代 daoutil.clj 中sql打印相关参数
		//加载缓存
		/*CacheCenter cacheCenter = SpringContextUtil.getBean("cacheCenter");
		cacheCenter.loadCache();*/
	}
	
	private static void startQuartz() throws Exception {
		
        Scheduler scheduler = StdSchedulerFactory.getDefaultScheduler();
        
        // todo 1-刷新基础信息、2-审批短信提醒、3-下载过的账单2天自动设置为已出账
	    JobDetail reloadOAJob = newJob(Job_OA.class)
	            .withIdentity("reloadOAJob", "group1")
	            .build();
	    CronTrigger reloadOATrigger = newTrigger()
	    	    .withIdentity("reloadOATrigger", "group1")
	    	    .withSchedule(cronSchedule("0 0 4 * * ?"))
	    	    .build();

       
        // 0 0 4,14,16 * * ? 每天的4、14、16点
        scheduler.scheduleJob(reloadOAJob, reloadOATrigger);
        
        scheduler.start();
//        scheduler.shutdown();
	}
	
	private static void setDatasource(){
		try {
			DruidDataSource dataSource = new DruidDataSource();
			dataSource.setDriverClassName("org.postgresql.Driver");
			dataSource.setUrl("jdbc:postgresql://182.92.107.223:5432/wdz_admin");
			dataSource.setUsername("postgres");
			dataSource.setPassword("postgres");
			dataSource.setFilters("stat");
			dataSource.setMaxActive(30);
			dataSource.setInitialSize(10);
			dataSource.setMaxWait(60000);
			dataSource.setMinIdle(5);
			dataSource.setTimeBetweenEvictionRunsMillis(3000);
			dataSource.setMinEvictableIdleTimeMillis(300000);
			dataSource.setPoolPreparedStatements(true);
			dataSource.setMaxPoolPreparedStatementPerConnectionSize(20);
			D.setDataSourceAndDialet(dataSource, new MySqlDialet());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		setDatasource();
		List<Map> list = D.sql("select * from t_s_user where user_status = '1'").list(Map.class);
	}
	
}
