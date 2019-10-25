package com.zy.service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.rps.util.D;
import com.zy.bean.bus.TBOrg;
import com.zy.bean.bus.TBPost;
import com.zy.bean.bus.TBTitle;
import com.zy.bean.bus.TBUser;
import com.zy.util.Constant;
import com.zy.util.HttpUtil;
import com.zy.util.JacksonUtil;

public class Job_OA implements Job {
	
	private static final Logger logger = LoggerFactory.getLogger(Job_OA.class);
	
	private static AtomicBoolean exists = new AtomicBoolean(false);
	
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
    	if(exists.compareAndSet(false, true)){
    		try {
    		    
    	        String token = getToken();
                syncUser(token);
                syncCorp(token);
                syncDepartment(token);
                syncPost(token);
                syncTitle(token);
                
			} catch (Exception e) {
				e.printStackTrace();
				MsgSendService.sendMsg("18186493301", "同步致远OA数据失败");
			}
            exists.set(false);
    	}
    }


    private static String getToken() throws Exception {
        String loginResponseJson = HttpUtil.doGet("http://172.21.3.251:9000/seeyon/rest/token/yc_fygl/sanxbnet207", null, "UTF-8");
        Map loginResponse = JacksonUtil.readValue(loginResponseJson, Map.class);
        String token = (String)loginResponse.get("id");
        return token;
    }
    
    
    private static void syncUser(String token) throws Exception {
        String userJson = HttpUtil.doGet("http://172.21.3.251:9000/seeyon/rest/orgMembers/-1730833917365171641", null, "UTF-8", token);
        List<Map> userList = JacksonUtil.readValueAsList(userJson, List.class, Map.class);
        if(userList == null || userList.size() < 1) throw new RuntimeException();
        D.sql("truncate table t_b_user").update();
        for (Map map : userList) {
            try {
                TBUser user = new TBUser();
                user.setCreate_time(new Date((Long)map.get("createTime")));
                user.setDepartment_id(map.get("orgDepartmentId").toString());
                user.setUser_id(map.get("id").toString());
                user.setLogin_name((String)map.get("loginName"));
                user.setUser_name((String)map.get("name"));
                user.setOrg_id(map.get("orgAccountId").toString());
                user.setPhone((String)map.get("telNumber"));
                user.setPost_id(map.get("orgPostId").toString());
                user.setSort_id((Integer)map.get("sortId"));
                user.setTitle_id(map.get("orgLevelId").toString());
                user.setUpdate_time(new Date((Long)map.get("updateTime")));
                user.setUser_status((Boolean)map.get("isValid") ? Constant.YES : Constant.NO);
                user.setDepartment_name((String)map.get("orgDepartmentName"));
                user.setOrg_name((String)map.get("orgAccountName"));
                user.setPinyin((String)map.get("pinyin"));
                user.setPinyin_head((String)map.get("pinyinhead"));
                user.setPost_name((String)map.get("orgPostName"));
                user.setTitle_name((String)map.get("orgLevelName"));
                D.insert(user);
            } catch (Exception e) {
                logger.error("该用户同步失败:{}", map.toString());
                e.printStackTrace();
            }
        }
    }
    
    private static void syncCorp(String token) throws Exception {
        String orgJson = HttpUtil.doGet("http://172.21.3.251:9000/seeyon/rest/orgAccounts", null, "UTF-8", token);
        List<Map> orgList = JacksonUtil.readValueAsList(orgJson, List.class, Map.class);
        if(orgList == null || orgList.size() < 1) throw new RuntimeException();
        D.sql("truncate table t_b_org").update();
        for (Map map : orgList) {
            try {
                TBOrg org = new TBOrg();
                org.setCode((String)map.get("code"));
                org.setCreate_time(new Date((Long)map.get("createTime")));
                org.setOrg_id(map.get("id").toString());
                org.setOrg_name((String)map.get("name"));
                org.setOrg_status((Boolean)map.get("enabled") ? Constant.YES : Constant.NO);
                org.setParent_org_id(map.get("superior").toString());
                org.setParent_path((String)map.get("parentPath"));
                org.setPath((String)map.get("path"));
                org.setShort_name((String)map.get("shortName"));
                org.setSort_id((Integer)map.get("sortId"));
                org.setUpdate_time(new Date((Long)map.get("updateTime")));
                org.setOrg_type(Constant.ORG_TYPE.CORP);
                org.setCorp_id(org.getOrg_id());
                D.insert(org);
            } catch (Exception e) {
                logger.error("该法人行同步失败:{}", map.toString());
                e.printStackTrace();
            }
        }
    }
    
    private static void syncDepartment(String token) throws Exception {
        List<TBOrg> corpList = D.sql("select * from t_b_org where org_status = ? and org_type = ?").list(TBOrg.class, Constant.YES, Constant.ORG_TYPE.CORP);
        for (TBOrg tbOrg : corpList) {
            String orgJson = HttpUtil.doGet("http://172.21.3.251:9000/seeyon/rest/orgDepartments/" + tbOrg.getOrg_id(), null, "UTF-8", token);
            List<Map> orgList = JacksonUtil.readValueAsList(orgJson, List.class, Map.class);
            for (Map map : orgList) {
                try {
                    TBOrg org = new TBOrg();
                    org.setCode((String)map.get("code"));
                    org.setCreate_time(new Date((Long)map.get("createTime")));
                    org.setOrg_id(map.get("id").toString());
                    org.setOrg_name((String)map.get("name"));
                    org.setOrg_status((Boolean)map.get("enabled") ? Constant.YES : Constant.NO);
                    org.setParent_org_id(map.get("superior").toString());
                    org.setParent_path((String)map.get("parentPath"));
                    org.setPath((String)map.get("path"));
                    org.setShort_name(tbOrg.getShort_name());
                    org.setSort_id((Integer)map.get("sortId"));
                    org.setUpdate_time(new Date((Long)map.get("updateTime")));
                    org.setOrg_type(Constant.ORG_TYPE.DEPARTMENT);
                    org.setCorp_id(tbOrg.getOrg_id());
                    
                    String deptInfoJson = HttpUtil.doGet("http://172.21.3.251:9000/seeyon/rest/orgDepartment/departmentmanagerinfo/" + org.getOrg_id() + "/" + org.getCorp_id(), null, "UTF-8", token);
                    Map deptInfoMap = JacksonUtil.readValue(deptInfoJson, Map.class);
                    Map managerMap = JacksonUtil.readValue((String)deptInfoMap.get("deptrole0"), Map.class);
                    if(managerMap.containsKey("value")) org.setManager_id((((String)managerMap.get("value")).split("\\|", -1)[1]));
                    Map leaderMap = JacksonUtil.readValue((String)deptInfoMap.get("deptrole1"), Map.class);
                    if(leaderMap.containsKey("value")) org.setLeader_id((((String)leaderMap.get("value")).split("\\|", -1)[1]));
                    
                    D.insert(org);
                } catch (Exception e) {
                    logger.error("该部门同步失败:{}", map.toString());
                    e.printStackTrace();
                }
            }
        }
    }
    
    private static void syncPost(String token) throws Exception {
        D.sql("truncate table t_b_post").update();
        List<TBOrg> corpList = D.sql("select * from t_b_org where org_status = ? and org_type = ?").list(TBOrg.class, Constant.YES, Constant.ORG_TYPE.CORP);
        for (TBOrg tbOrg : corpList) {
            String postJson = HttpUtil.doGet("http://172.21.3.251:9000/seeyon/rest/orgPosts/" + tbOrg.getOrg_id(), null, "UTF-8", token);
            List<Map> postList = JacksonUtil.readValueAsList(postJson, List.class, Map.class);
            for (Map map : postList) {
                try {
                    TBPost post = new TBPost();
                    post.setCreate_time(new Date((Long)map.get("createTime")));
                    post.setPost_id(map.get("id").toString());
                    post.setPost_name((String)map.get("name"));
                    post.setCorp_id(tbOrg.getOrg_id());
                    post.setSort_id((Integer)map.get("sortId"));
                    post.setPost_status((Boolean)map.get("enabled") ? Constant.YES : Constant.NO);
                    post.setUpdate_time(new Date((Long)map.get("updateTime")));
                    D.insert(post);
                } catch (Exception e) {
                    logger.error("该岗位同步失败:{}", map.toString());
                    e.printStackTrace();
                }
            }
        }
    }
    
    private static void syncTitle(String token) throws Exception {
        D.sql("truncate table t_b_title").update();
        List<TBOrg> corpList = D.sql("select * from t_b_org where org_status = ? and org_type = ?").list(TBOrg.class, Constant.YES, Constant.ORG_TYPE.CORP);
        for (TBOrg tbOrg : corpList) {
            String titleJson = HttpUtil.doGet("http://172.21.3.251:9000/seeyon/rest/orgLevels/" + tbOrg.getOrg_id(), null, "UTF-8", token);
            List<Map> titleList = JacksonUtil.readValueAsList(titleJson, List.class, Map.class);
            for (Map map : titleList) {
                try {
                    TBTitle title = new TBTitle();
                    title.setCreate_time(new Date((Long)map.get("createTime")));
                    title.setTitle_id(map.get("id").toString());
                    title.setTitle_name((String)map.get("name"));
                    title.setCorp_id(tbOrg.getOrg_id());
                    title.setSort_id((Integer)map.get("levelId"));
                    title.setTitle_status((Boolean)map.get("enabled") ? Constant.YES : Constant.NO);
                    title.setUpdate_time(new Date((Long)map.get("updateTime")));
                    D.insert(title);
                } catch (Exception e) {
                    logger.error("该职位级别同步失败:{}", map.toString());
                    e.printStackTrace();
                }
            }
        }
    }
}
