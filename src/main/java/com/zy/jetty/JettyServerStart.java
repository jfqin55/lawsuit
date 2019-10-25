package com.zy.jetty;

import org.eclipse.jetty.server.Server;

/**
 * 使用项目内置 Jetty 运行程序, 输入回车键可快速重新加载程序
 */
public class JettyServerStart {
	// 项目的访问路径为 http://localhost:PORT/CONTECT
    public static final int PORT = 8888;
    public static final String CONTEXT = "/cost";
    public static final String[] TLD_JAR_NAMES = new String[]{"spring-webmvc"};

    public static void main(String[] args) throws Exception {
    	
        try {
        	// 设定 Spring的profile
            System.setProperty("spring.profiles.active", "development");
        	// 启动 Jetty
            long startTime = System.currentTimeMillis();
            Server server = JettyFactory.createServerInSource(PORT, CONTEXT);
            JettyFactory.setTldJarNames(server, TLD_JAR_NAMES);
        	
            server.start();

            long usedTime = System.currentTimeMillis() - startTime;
            System.out.println("Server startup in " + usedTime + " ms, running at http://localhost:" + PORT + CONTEXT);
            System.out.println("Hit Enter to reload the application quickly");

            // 等待用户输入回车重载程序
            while (true) {
                char c = (char) System.in.read();
                if (c == '\n') {
                    JettyFactory.reloadContext(server);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(-1);
        }
    }
    
}
