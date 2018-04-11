package cn.dhx.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import cn.dhx.dao.IBlogDao;

@Service("commentService")
public class CommentServiceImpl implements ICommentService {
	@Resource(name="IBlogDao")
	IBlogDao dao;
	@Override
	public String praise(Integer id,Integer uid, String status) {
		String praiseStatus ; 
		if(status.equals("点赞")){
			dao.insertPraise("comment",id,uid);
			praiseStatus = "已赞";
		}else{
			dao.deletePraise("comment", id, uid);
			praiseStatus = "点赞";
		}
		int praiseCount = dao.getPraise_count(id,"comment");
		
		Map<String,Object> praiseData = new HashMap<String,Object>();
		praiseData.put("praiseStatus", praiseStatus);
		praiseData.put("praiseCount", praiseCount);
		//Map转json
		ObjectMapper mapper = new ObjectMapper();
		String praiseDataJson = null;
		try {
			praiseDataJson = mapper.writeValueAsString(praiseData);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} 
		return praiseDataJson;
	}

}
