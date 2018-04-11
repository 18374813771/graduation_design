//package cn.dhx.service;
//
//
//import java.util.List;
//
//import org.junit.Test;
//import org.junit.runner.RunWith;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Qualifier;
//import org.springframework.context.ApplicationContext;
//import org.springframework.test.context.ContextConfiguration;
//import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
//
//
//import cn.dhx.beans.Comment;
//import cn.dhx.webSocket.MyWebSocket;
////import cn.dhx.webSocket.ApplicationContextRegister;
//
//@RunWith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration(locations = {"classpath:Spring-db.xml","classpath:Spring-mvc.xml","classpath:Spring-mybits.xml","classpath:Spring-service.xml","classpath:Spring-tx.xml"}) 
//
//public class BlogServiceTest {
//	@Autowired
//	@Qualifier("blogService")
//	private IBlogService service;
//	
//	@Test
//	public void getCommentTest(){
//		List<Comment> comments = service.getComments(20,4);
//		System.out.println(comments);
//	}
//	@Test
//	public void test66(){
//		
////    	BolgServiceImpl bsi = new BolgServiceImpl();
////    	List<Comment> comments = bsi.getComments(18,4);
////    	System.out.println(comments);
////    	System.out.println(bsi.getCurrentDate());
////		通过工具类使用spring的Service层的方法
////		MyWebSocket mws = new MyWebSocket();
////        
//        List<Comment> comments = service.getComments(20,4);
//        System.out.println(comments);
//	}
//
//}
