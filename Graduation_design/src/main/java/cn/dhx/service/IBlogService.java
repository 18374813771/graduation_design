package cn.dhx.service;

import java.util.List;

public interface IBlogService {
	public List<String> getRealImages(String conetnt);

	public void disposeImages(List<String> images,String oldPath,String newPath);

	public String replaceContent(String content);

	public void insertBlog(String blogName, String content, Integer uid);
}
