package cn.dhx.handlers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.dhx.beans.User;
import cn.dhx.service.IBlogService;
import cn.dhx.service.ICommentService;

@Controller
public class commentController {
	
	@Autowired
	@Qualifier("commentService")
	private ICommentService commentService;
	
	@Autowired
	@Qualifier("blogService")
	private IBlogService IBlogService;
	/**
	 * 处理用户点赞评论
	 * */
	@RequestMapping(value="blogCommentParise.do",produces="text/html;charset=UTF-8")
	@ResponseBody
	public String blogCommentPraise(HttpServletRequest request,HttpSession session){
		Integer id = Integer.parseInt(request.getParameter("id"));
		String status = request.getParameter("currentStatus");
		
		User user = (User) session.getAttribute("user");
		Integer uid = user.getId();
		String praiseData = commentService.praise(id,uid,status);
		return praiseData;
	} 
	
	/**
	 * 对评论进行评论
	 * */
	@RequestMapping(value="subOneComment.do",produces="text/html;charset=UTF-8")
	@ResponseBody
	public String submitOneComment(HttpServletRequest request,HttpSession session){
		Integer id = Integer.parseInt(request.getParameter("id"));
		Integer topId = Integer.parseInt(request.getParameter("topId"));
		//被评论者id
		int uid=Integer.parseInt(request.getParameter("uid"));
		String commentContent = request.getParameter("commentContent");
		User user = (User) session.getAttribute("user");
		//评论者id
		int ownId = user.getId();
		String style = "comment";
		String topStyle = "blog";
		IBlogService.insertComment(commentContent,ownId,uid, id, style, topId, topStyle);
		return null;
		
	}
}
