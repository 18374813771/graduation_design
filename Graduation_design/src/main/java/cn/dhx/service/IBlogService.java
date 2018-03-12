package cn.dhx.service;

import java.util.List;

import cn.dhx.beans.Blog;

public interface IBlogService {
	public List<String> getRealImages(String conetnt);

	public void disposeImages(List<String> images,String oldPath,String newPath);

	public String replaceContent(String content);

	public void insertBlog(String blogName, String content, Integer uid);

	public List<Blog> getBlog();

	public Blog getBlogById(int id);

	public void updateBlogRead_count(int id);

	public int getBlogRead_count(int bid);

	public void insertPraise(int blogId, Integer id);

	public int getPraise_count(int blogId);

	public Boolean isBlogPraise(int bid,int uid);

	public void deletePraise(int bid, Integer uid);
}
