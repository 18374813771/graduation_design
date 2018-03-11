package cn.dhx.dao;

import java.util.List;

import cn.dhx.beans.Blog;

public interface IBlogDao {

	public void insertBlog(Blog blog);

	public void insertRead_count(String table, int bId, int count);
	
	public List<Blog> getBlog();

	public Blog getBlogById(int id);

	public void updateRead_count(int bid);

	public int getRead_count(int bid);

	public void insertPraise(String string, int blogId, Integer uid);

	public int getPraise_count(int blogId);

	

}
