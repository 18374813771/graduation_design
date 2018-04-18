package cn.dhx.webSocket;


import java.io.IOException;
import java.util.HashSet;
import java.util.Iterator;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;


public class MyWebSocketHandler extends TextWebSocketHandler implements WebSocketHandler {
	//map的key为博客的id，map的value为一个session的集合
	private static ConcurrentMap<Integer,HashSet<WebSocketSession>> webSocketMap = new ConcurrentHashMap<>();
	private static HashSet<WebSocketSession> sessionSet;
	
	/**
	 * 建立连接后,把session加入set集合
	 */
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {			
	}
	/**
	 * 连接关闭后，把session从set集合中移除
	 * */
	public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus closeStatus) throws Exception {
		//对map的key用迭代器遍历
		Iterator<Integer> mapKeys = webSocketMap.keySet().iterator();
		while(mapKeys.hasNext()){
			//遍历，找到，删除迭代器中多次调用。next();就会报NoSuchElementException错误
			webSocketMap.get(mapKeys.next()).remove(session);
			
		}
	};
	/**
	 * 消息处理
	 * */
	@Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) {
       try{    	       	   
    	   //收到客户端传来的博客id后转类型
    	   int blogId = Integer.parseInt(message.getPayload());  
    	   //把session和博客id加入到map中
    	   this.addSession(session, blogId);
    	   //群发消息
//    	   this.sendStatuesToUser(blogId);
    	   
       }catch(Exception e){
    	   e.printStackTrace();
       }

    }
	
	/**
	 * 一个博客下有评论更新，群发此博客下的连接
	 * @param 客户端发送来的博客id
	 * */
	public void sendStatuesToUser(Integer blogId) throws IOException{
		//用迭代器遍历集合
		Iterator<WebSocketSession> bSessionSets = webSocketMap.get(blogId).iterator();
		while(bSessionSets.hasNext()){
			//当有数据更新时，返回数据一
			bSessionSets.next().sendMessage(new TextMessage("1"));
		}
	}
	
	/**
	 * 把WebSocketSession加到map中
	 * @param WebSocketSession
	 * @param 博客id
	 * */
	public  synchronized void addSession(WebSocketSession session, Integer blogId){
		//如果map中没有此博客的记录，创建一个人set作为此id的value
		if(!webSocketMap.containsKey(blogId)){
			sessionSet = new HashSet<WebSocketSession>();
			sessionSet.add(session);
			webSocketMap.put(blogId, sessionSet);
			
		}else
		if(!webSocketMap.get(blogId).contains(session)){//如果map中不存在此链接，加进去
			webSocketMap.get(blogId).add(session);
		}else {//如果已存在此链接，什么都不做
			
		}
	}

	
}
