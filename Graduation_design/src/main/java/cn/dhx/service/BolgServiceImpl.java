package cn.dhx.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.dhx.beans.Blog;
import cn.dhx.beans.Comment;
import cn.dhx.beans.User;
import cn.dhx.dao.IBlogDao;
import cn.dhx.dao.IUserDao;

@Service("blogService")
public class BolgServiceImpl implements IBlogService {
	@Resource(name="IBlogDao")
	IBlogDao dao;
	@Resource(name="IUserDao")
	IUserDao userDao;
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

	//处理图片，把用户用到的图片从临时目录移到真实目录，并删除就图片
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
	public void insertBlog(String blogName, String content, Integer uid) {		
		String date = this.getCurrentDate();		
		
		Blog blog = new Blog();
		
		blog.setBlog_name(blogName);
		blog.setBlog_content(content);
		blog.setUid(uid);
		blog.setDate(date);
		//增加一条博客记录
		dao.insertBlog(blog);
		int bId = blog.getId();
		//新增一条阅读量记录
		dao.insertRead_count("blog",bId,0);
	}

	//获取所有博客信息
	@Override
	public List<Blog> getBlog() {
		
		return dao.getBlog();
	}

	//查询博客信息
	public Blog getBlogById(int id) {

		return dao.getBlogById(id);
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
	}

	//获取一条博客所有的评论信息
	@Override
	public List<Comment> getComments(int id,int userId) {
		String topStyle = "blog";
		List<Comment> comments = dao.getCommentByTop(id,topStyle);
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
		return comments;
	}
	
	
	//获取当前时间
	public String getCurrentDate(){
		//获取系统时间
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		return df.format(new Date());
	}

	

}
