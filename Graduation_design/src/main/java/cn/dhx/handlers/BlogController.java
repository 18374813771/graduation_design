package cn.dhx.handlers;


import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.solr.client.solrj.SolrServerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import cn.dhx.beans.Blog;
import cn.dhx.beans.Comment;
import cn.dhx.beans.PageBean;
import cn.dhx.beans.User;
import cn.dhx.service.IBlogService;
import cn.dhx.service.IInteractionService;
import cn.dhx.service.IUserService;
import cn.dhx.solrJ.ISolrDao;
import cn.dhx.webSocket.MyWebSocketHandler;

@Controller
public class BlogController {
	@Autowired
	@Qualifier("blogService")
	private IBlogService service;
	@Autowired
	@Qualifier("UserService")
	private IUserService userService;
	@Autowired
	@Qualifier("interactionService")
	private IInteractionService interactionService;
	@Autowired
	private MyWebSocketHandler webSocketHandler;
	@Autowired
	private ISolrDao SolrDaoImpl;
	
	//写博客页面
	@RequestMapping("/toBlog.do")
	public String toBlog(HttpServletRequest request){
		User user = (User)request.getSession().getAttribute("user");
		Integer id = user.getId();
		//获取好友列表
		List<User> allFriends = interactionService.getAllFriends(id, 1);
		request.setAttribute("allFriends", allFriends);
		return "/WEB-INF/blog.jsp";
	}
	
	//博客编辑文件上传
	@RequestMapping(value="/blogImgUpload.do")
	@ResponseBody
	public String blogImgUpload(@RequestParam("file") MultipartFile file,HttpServletRequest request){
		
		String filename = file.getOriginalFilename();

		//拼接上传后的文件名
		String newFile=new Date().getTime()+filename;
		//拼接服务器路径
		String path="http://localhost:8080/blogImg/"+newFile;
		
		//上传文件的用的路径
		String uploadPath=request.getServletContext().getRealPath("/blogImg/")+"/"+newFile;

		//复制文件
		File imgFile=new File(uploadPath);
		try {
			file.transferTo(imgFile);
		}  catch (IOException e) {			
			e.printStackTrace();
		}
		
		Map<String, Object> result = new HashMap<>();
        result.put("error",0);

        result.put("url",path);
        ObjectMapper mapper = new ObjectMapper();  
        String string = null;
		try {
			//map转json
			string = mapper.writeValueAsString(result);
		} catch (JsonProcessingException e) {
			
			e.printStackTrace();
		}
        return string;
	}
	
	/**
	 * 处理博客
	 * */
	@RequestMapping("/blogging.do")
	public String blogging(HttpServletRequest request){
		//用户是否提交flag==1为提交，flag==2为取消
		String strFlag=request.getParameter("flag");
		int flag=Integer.parseInt(strFlag);		
		//用户取消后返回主页
		if(flag==2){
			return "/toIndex.do";
		}
		//文章名称
		String blogName=(String) request.getParameter("blogName");
		//原文章内容
		String content=(String) request.getParameter("content");
		//从session中获取用户id
		HttpSession session=request.getSession();
		User user=(User) session.getAttribute("user");
		Integer uid=user.getId();
		//获取邀请的好友id列表
		String invitedFriends[] = request.getParameterValues("invitedFriend");		
		
		//获取用户用到的图片列表
		List<String> images = service.getRealImages(content);
		
		//如果上传了图片
		if(!images.isEmpty()){
			//动态获取临时文件夹绝对路径
	        String oldPath=request.getServletContext().getRealPath("/blogImg/")+"/";
	        //动态获取真实文件夹绝对路径
	        String newPath=request.getServletContext().getRealPath("/realBlogImg/")+"/";
			//处理图片，把用户用到的图片从临时目录移到真实目录
			service.disposeImages(images,oldPath,newPath);
			//替换内容
			content = service.replaceContent(content);
			
		}
	
		//执行新增博客操作
		int blogId = service.insertBlog(blogName,content,uid);
		//把邀请回答的信息加入邀请表
		if(invitedFriends!=null){
			for(int i=0;i<invitedFriends.length;i++){
				int iid = Integer.parseInt(invitedFriends[i]);
				interactionService.addOneInvitation(uid,blogName,iid,blogId);
			}
		}
		//加入 索引库
		Blog blog = service.getBlogById(blogId);
		SolrDaoImpl.addBlogIndex(blog);
		return "/toIndex.do";
	}
	
	/**
	 * 去主页
	 * @throws SolrServerException 
	 * */
	@RequestMapping("/toIndex.do")
	public String toIndex(HttpServletRequest request) throws SolrServerException{
		//获取当前页码
		int currentPage = 0;
		//如果没有传入页码，默认为1
		try{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}catch(Exception e){
			currentPage = 1;
		}
		List<Blog> blogs = null;
		String blogInfo = null;
		try{
			//如果存在blogInfo参数，则表明为搜索博客
			
			blogInfo = request.getParameter("blogInfo");
			if(blogInfo!=null&&blogInfo!=""){
				//判断输入数据是否编码正确，如果不是utf-8则转码
				if(blogInfo.equals(new String(blogInfo.getBytes("iso8859-1"), "iso8859-1")))
				{
					blogInfo=new String(blogInfo.getBytes("iso8859-1"),"utf-8");
				}
			}
			
		}catch(Exception e){
					
		}
		if(blogInfo==null||blogInfo==""){
			
			//如果前面没有blogInfo数据，则执行查询所有博客
			blogs=SolrDaoImpl.getAllBlog(currentPage);
		}else{
			//从索引库根据条件查询博客数据
			blogs = SolrDaoImpl.getBlogByInfo(blogInfo, (currentPage-1)*6);
			
		}		
		
		int totalCount = 0;
		for(Blog blog:blogs){
			int bid = blog.getId();
			//查询阅读量
			int count = service.getBlogRead_count(bid);
			blog.setRead_count(count);
			int praiseCount=service.getPraise_count(bid);
			totalCount = blog.getTotalCount();
			blog.setPraise_count(praiseCount);
		}
		//分页数据
		PageBean pageBean = new PageBean();		
		pageBean.setCurrentCount(6);
		pageBean.setCurrentPage(currentPage);
		int totalPage = totalCount/6+1;
		pageBean.setTotalPage(totalPage);
		pageBean.setTotalCount(totalCount);
		
		//把搜索信息传递到页面
		request.setAttribute("blogInfo", blogInfo);
		request.setAttribute("pageBean", pageBean);
		request.setAttribute("blogs", blogs);
		return "/WEB-INF/index.jsp";
	}
	
	/**
	 * 具体博客页
	 * */
	@RequestMapping("/toShowBlog.do")
	public String showBlog(HttpServletRequest request){
		//接收博客id
		int id=Integer.parseInt(request.getParameter("id"));		
		//查询博客信息
		Blog blog = service.getBlogById(id);		
		//该博客阅读量+1
		service.updateBlogRead_count(id);
		//查询阅读量
		int count = service.getBlogRead_count(id);
		blog.setRead_count(count);
		
		Integer uId=blog.getUid();		
		//获取所看博客作者信息
		User bUser = userService.getUserById(uId);
		
		HttpSession session=request.getSession();
		User user = (User) session.getAttribute("user");
		//获取当前登录用户id
		Integer userId = user.getId(); 
		//判断当前用户是否点赞
		Boolean isPraise = service.isBlogPraise(id,userId);
		String praiseStatus = null;
		if(isPraise){
			praiseStatus="已赞";
		}else{
			praiseStatus="点赞";
		}
		//获取点赞的条数
		int praiseCount = service.getPraise_count(id); 
		blog.setPraise_count(praiseCount);
		//得到用户的关注状态
		String focusStatus = service.getFocusStatus(user.getId(),bUser.getId());
		
		request.setAttribute("focusStatus", focusStatus);
		request.setAttribute("praiseStatus", praiseStatus);
		request.setAttribute("blog", blog);
		request.setAttribute("bUser",bUser);
		return "/WEB-INF/showBlog.jsp";
	}
	
	/**
	 * 对于用户点赞的处理
	 **/
	@RequestMapping(value="ajaxPraise.do")
	@ResponseBody
	public String praiseBlog(HttpServletRequest request) throws IOException{
		//从request中获取博客id
		int blogId=Integer.parseInt(request.getParameter("blogId"));
		HttpSession session=request.getSession();
		User user = (User) session.getAttribute("user");
		//新增一条点赞记录
		service.insertPraise(blogId,user.getId());
		//获取此博客赞的数量
		int praise_count=service.getPraise_count(blogId);
		//定义点赞数量的json字符串
		String praiseCount="{\"count\":"+praise_count+"}";
		return praiseCount;
	}
	
	/**
	 * 对于用户取消赞的处理
	 * */
	@RequestMapping("ajaxNotPraise.do")
	@ResponseBody
	public String notPraiseBlog(HttpServletRequest request) throws IOException{
		//从request中获取博客id
		int blogId=Integer.parseInt(request.getParameter("blogId"));
		HttpSession session=request.getSession();
		User user = (User) session.getAttribute("user");
		//删除该用户点赞记录
		service.deletePraise(blogId,user.getId());
		//获取此博客赞的数量
		int praise_count=service.getPraise_count(blogId);
		//定义点赞数量的json字符串
		String praiseCount="{\"count\":"+praise_count+"}";
		
		return praiseCount;
	}
	
	/**
	 * 处理用户的评论
	 * */
	@RequestMapping("commentSubmit.do")
	@ResponseBody
	public String commentSubmit(HttpServletRequest request){
		String commentContent = request.getParameter("commentCotent");
		//从request中获取博客id
		int blogId=Integer.parseInt(request.getParameter("blogId"));
		//被评论者的id
		int uid=Integer.parseInt(request.getParameter("uid"));
		
		HttpSession session=request.getSession();
		User user = (User) session.getAttribute("user");
	
		
		//评论者
		int ownId = user.getId();
		String style = "blog";
		int topId = blogId;
		String topStyle = "blog";
		service.insertComment(commentContent,ownId,uid,blogId,style,topId,topStyle);
		//websocket通知前台有评论提交
		try {
			webSocketHandler.sendStatuesToUser(blogId);
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		
		return commentContent;
	}
	
	/**
	 * 通过ajax请求所有评论
	 * @throws JsonProcessingException 
	 * */
	//produces="text/html;charset=UTF-8"响应数据到jsp中文会变成？？问题
	@RequestMapping(value="/getComments.do",produces="text/html;charset=UTF-8")
	@ResponseBody
	public String getComments(HttpServletRequest request) throws JsonProcessingException{
		int blogId=Integer.parseInt(request.getParameter("blogId"));
		
		HttpSession session=request.getSession();
		User user = (User) session.getAttribute("user");
		int uid = user.getId();
		List<Comment> comments = service.getComments(blogId, uid);
		ObjectMapper jackson = new ObjectMapper();
		String jComment = jackson.writeValueAsString(comments);
		
		return jComment;
	}
	/**
	 * 举报评论
	 * */
	@RequestMapping("report.do")
	@ResponseBody
	public void report(HttpServletRequest request){
		int commentId = Integer.parseInt(request.getParameter("commentId"));
		service.addReport(commentId);
	}

}
