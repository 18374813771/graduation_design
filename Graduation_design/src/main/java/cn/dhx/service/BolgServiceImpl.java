package cn.dhx.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import cn.dhx.beans.Blog;
import cn.dhx.beans.Comment;
import cn.dhx.beans.User;
import cn.dhx.dao.IBlogDao;
import cn.dhx.dao.IUserDao;
import cn.dhx.jedis.JedisClient;
import cn.dhx.utils.BlogComparatorDate;
import cn.dhx.utils.commentComparatorDate;

@Service("blogService")
public class BolgServiceImpl implements IBlogService {
	@Resource(name="IBlogDao")
	IBlogDao dao;
	@Resource(name="IUserDao")
	IUserDao userDao;
	@Resource(name="JedisClientPool")
	private JedisClient jedisClient;
	//获取用户用到的图片
	public List<String> getRealImages(String content) {
		List<String> images = new ArrayList<String>();
		
		//设置正则规则 ,将正则封装成对象
		Pattern p = Pattern.compile("src=\"/blogImg/(.+?)\"");
		//通过正则对象获取匹配器对象
		Matcher m = p.matcher(content);
		//find方法匹配到值，返回true;
		while(m.find()){
           //m.group返回匹配到的子序列
           //img1[1]得到文件名称，但多个“
           String[] img1=m.group().split("blogImg/");
           //去掉”
           String[] img2=img1[1].split("\"");
           images.add(img2[0]);
       }
		return images;
	}

	//处理图片，把用户用到的图片从临时目录移到真实目录，并删除旧图片
	@Override
	public void disposeImages(List<String> images,String oldPath,String newPath) { 
		 	//新路径
		 	String path1=null;
		 	//旧路径
		 	String path2=null;
		 	int byteread = 0; 
		try {		 	
		 	//遍历复制文件
		 	for(String img:images){
	    	   path1=oldPath+img;
	    	   path2=newPath+img;
	    	   File oldFile=new File(path1);
	    	   
	    	   if(oldFile.exists()){//若文件存在
	    		   //读入原文件
	    		   InputStream inStream = new FileInputStream(path1); 
	    		   FileOutputStream fs = new FileOutputStream(path2); 
	    		   byte[] buffer = new byte[1024];  
	        	   while ( (byteread = inStream.read(buffer)) != -1) { 
	        		   fs.write(buffer, 0, byteread); 
	        	   } 
	        	   inStream.close();
	        	   fs.close();
	        	   //删除旧文件
	        	   oldFile.delete();
	    	   }
	    	   
	       }
		 } catch (Exception e) { 
	    	 
	    	   e.printStackTrace(); 

	       }  
	}
	
	//用新路径替换旧路径
	@Override
	public String replaceContent(String content) {
		//替换图片路径
		String newContent=content.replaceAll("src=\"/blogImg/", "src=\"/realBlogImg/");
		return newContent;
	}
	

	
	//新增博客
	@Override
	public int insertBlog(String blogName, String content, Integer uid) {		
		String date = this.getCurrentDate();		
		
		Blog blog = new Blog();
		
		blog.setBlog_name(blogName);
		blog.setBlog_content(content);
		blog.setUid(uid);
		blog.setDate(date);
		//增加一条博客记录
		dao.insertBlog(blog);
		int bId = blog.getId();
		ObjectMapper jackson = new ObjectMapper();
		//把博客信息加入redis做缓存
		try{
			String jsonBlog = jackson.writeValueAsString(blog);
			String bIdStr = bId+"";
			jedisClient.hset("blog",bIdStr,jsonBlog);
		}catch(Exception e){
			e.printStackTrace();
		}		
		//新增一条阅读量记录
		dao.insertRead_count("blog",bId,0);
		return bId;
	}

	//获取所有博客信息
	@Override
	public List<Blog> getBlog() {
		//创建一个ObjectMapper操作json
		ObjectMapper jackson = new ObjectMapper();
		List<Blog> blogs = new ArrayList<Blog>();
		//先查询缓存
		try{			
			Map<String,String> allBlogs = jedisClient.hgetAllValues("blog");
			//如果缓存中有数据
			if(!allBlogs.isEmpty()){
				for(String field:allBlogs.keySet()){
					String value = allBlogs.get(field);
					Blog blog = jackson.readValue(value, Blog.class);
					blogs.add(blog);
				}
				//用自定义比较器进行比较
				BlogComparatorDate c = new BlogComparatorDate();
				Collections.sort(blogs,c);
				return blogs;
			}		
		}catch(Exception e){
			e.printStackTrace();
		}
		//如果缓存中没有数据，查询数据库，并把数据加入到缓存
		blogs = dao.getBlog();
		try{
			for(Blog blog:blogs){
				String blogId = blog.getId()+"";
				String jsonBlog = jackson.writeValueAsString(blog);
				jedisClient.hset("blog", blogId, jsonBlog);
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		//用自定义比较器进行比较
		BlogComparatorDate c = new BlogComparatorDate();
		Collections.sort(blogs,c);
		return blogs;
	}

	//查询博客信息
	public Blog getBlogById(int id) {		
		//创建一个ObjectMapper操作json
		ObjectMapper jackson = new ObjectMapper();
		
		String blogId = id+"";
		try{
			//查询出一个json类型的字符串
			String jsonBlog=jedisClient.hget("blog", blogId);
			//字符串有信息
			if(StringUtils.isNotBlank(jsonBlog)){				
				//反射把json字符串转化成对象
				Blog blog = jackson.readValue(jsonBlog, Blog.class);
				return blog;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		Blog blog = dao.getBlogById(id);
		if(blog!=null){
			try{
				//把user对象转化为json字符串
				String blogJson = jackson.writeValueAsString(blog);
				//把数据加入缓存
				jedisClient.hset("blog", blogId, blogJson);
				
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return blog;
	}
	
	//每次点击阅读量加一
	public void updateBlogRead_count(int bid) {
		dao.updateRead_count(bid);
		
	}

	//获取博客阅读量
	public int getBlogRead_count(int bid) {
		
		return dao.getRead_count(bid);
	}
	
	//增加博客的一条点赞记录
	public void insertPraise(int blogId, Integer uid) {
		dao.insertPraise("blog",blogId,uid);
		
	}
	//删除该博客该用户的点赞记录
	public void deletePraise(int bid, Integer uid) {
		dao.deletePraise("blog",bid,uid);
		
	}
	//查询某博客的点赞数量
	public int getPraise_count(int blogId) {
		
		return dao.getPraise_count(blogId,"blog");
	}
	
	//判断一个博客是否已赞
	public Boolean isBlogPraise(int bid,int uid) {
		//如果有记录则表示该用户对博客已点赞
		if(dao.selectPraise("blog",bid,uid)==null){
			return false;
		}
		return true;
	}
	
	//新增一条评论
	@Override
	public void insertComment(String commentContent,int ownId,int uid, int id,String style,
									 int topId,String topStyle) {
		//封装一个评论对象
		Comment comment = new Comment();
		String date = this.getCurrentDate();
		comment.setComment_content(commentContent);
		comment.setOwnId(ownId);
		comment.setUid(uid);
		comment.setStyle(style);
		comment.setMaster_id(id);
		comment.setDate(date);
		comment.setTopId(topId);
		comment.setTopStyle(topStyle);
		
		dao.insertComment(comment);
		//新增后添加进缓存
		ObjectMapper jackson = new ObjectMapper();
		try{
			String commentId = comment.getId()+"";
			String commentJson = jackson.writeValueAsString(comment);
			jedisClient.hset("comment", commentId, commentJson);
		}catch(Exception e){
			e.printStackTrace();
			}
		
	}

	//获取一条博客所有的评论信息
	@Override
	public List<Comment> getComments(int id,int userId) {
		String topStyle = "blog";
		ObjectMapper jackson = new ObjectMapper();
		List<Comment> comments = new ArrayList<Comment>();
		try{
			Map<String,String> allComments = jedisClient.hgetAllValues("comment");
			if(!allComments.isEmpty()){
				for(String commentId : allComments.keySet()){
					String  jsonComment = allComments.get(commentId);
					Comment comment = jackson.readValue(jsonComment, Comment.class);
					//从缓存中查询一个博客下的所有的评论
					if(comment.getTopId().equals(id)&&comment.getTopStyle().equals(topStyle)){
						comments.add(comment);
					}
				}
			}			
		}catch (Exception e) {
			e.printStackTrace();
		}
		//如果缓存为空就去数据库中查
		if(comments.isEmpty()){
			comments = dao.getCommentByTop(id,topStyle);
			//如果数据库中有信息就加到缓存中
			if(!comments.isEmpty()){
				try {
					for(Comment comment:comments){
						String commentId = comment.getId()+"";
						String jsonComment = jackson.writeValueAsString(comment);
						jedisClient.hset("comment", commentId, jsonComment);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
		}
		
		int praiseCount = 0;
		User answerUser;
		User answeredUser;
		for(Comment comment:comments){
			//获取评论的点赞数
			praiseCount = dao.getPraise_count(comment.getId(), "comment");
			comment.setPraiseCount(praiseCount);
						
			//得到评论者的信息
			answerUser = userDao.getUserById(comment.getOwnId());
			comment.setAnswerUser(answerUser);
			
			//得到被评论者的信息
			answeredUser = userDao.getUserById(comment.getUid());
			comment.setAnsweredUser(answeredUser);
			
			//判断当前用户对此评论是否点过赞
			if(dao.selectPraise("comment",comment.getId(),userId)==null){
				comment.setPraiseStatus("点赞");
			}else{
				comment.setPraiseStatus("已赞");
			}
			
		}
		commentComparatorDate c = new commentComparatorDate();
		Collections.sort(comments, c);
		return comments;
	}
	
	
	//获取当前时间
	public String getCurrentDate(){
		//获取系统时间
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		return df.format(new Date());
	}
	//更加用户id和博主id判断用户之间有没有家关注
	@Override
	public String getFocusStatus(Integer id, Integer id2) {
		Integer focus_onId = dao.getFocus_onId(id,id2); 
		if(focus_onId!=null){
			return "已关注";
		}
		return "+关注";
	}
	/**
	 * 新增举报，如果该条信息已被举报则数量加1，
	 * */
	@Override
	public void addReport(int commentId) {
		Integer id = dao.getReportByCommentId(commentId);
		if(id==null){
			dao.insertReport(commentId);
		}else{
			dao.ReportAddCount(id);
		}
	}

	

}
