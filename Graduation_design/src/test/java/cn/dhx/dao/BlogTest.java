package cn.dhx.dao;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;


import cn.dhx.beans.Comment;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:Spring-db.xml","classpath:Spring-mvc.xml","classpath:Spring-mybits.xml","classpath:Spring-service.xml","classpath:Spring-tx.xml"}) 
//@Transactional 
public class BlogTest {
	@Autowired 
	private IBlogDao IBlogDao;
	@Test
	public void insertCommentTest(){
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		String date = df.format(new Date());
		Comment comment = new Comment();
		
		comment.setComment_content("啊啊啊");
		comment.setUid(2);
		comment.setStyle("blog");
		comment.setMaster_id(5);
		comment.setDate(date);
		comment.setTopId(5);
		comment.setTopStyle("blog");
		IBlogDao.insertComment(comment);
	}
	
	@Test
	public void getCommetTest(){
		List<Comment> comments = IBlogDao.getCommentByTop(20, "blog");
		System.out.println(comments);
	}
}
