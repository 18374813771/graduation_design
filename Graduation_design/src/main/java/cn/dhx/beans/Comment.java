package cn.dhx.beans;

public class Comment {
	private Integer id;
	private String comment_content;
	private Integer ownId;
	private Integer uid;
	private String style;
	private Integer master_id;
	private String date;
	private Integer	topId;
	private String topStyle;
	
	private int praiseCount; //获赞数量
	private String praiseStatus; //点赞的状态（已赞或点赞）
	private User answerUser; //回答者
	private User answeredUser;//被回答者
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getComment_content() {
		return comment_content;
	}
	public void setComment_content(String comment_content) {
		this.comment_content = comment_content;
	}
	
	public Integer getOwnId() {
		return ownId;
	}
	public void setOwnId(Integer ownId) {
		this.ownId = ownId;
	}
	public Integer getUid() {
		return uid;
	}
	public void setUid(Integer uid) {
		this.uid = uid;
	}
	public String getStyle() {
		return style;
	}
	public void setStyle(String style) {
		this.style = style;
	}
	public Integer getMaster_id() {
		return master_id;
	}
	public void setMaster_id(Integer master_id) {
		this.master_id = master_id;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	
	public Integer getTopId() {
		return topId;
	}
	public void setTopId(Integer topId) {
		this.topId = topId;
	}
	public String getTopStyle() {
		return topStyle;
	}
	public void setTopStyle(String topStyle) {
		this.topStyle = topStyle;
	}
	
	
	public int getPraiseCount() {
		return praiseCount;
	}
	public void setPraiseCount(int praiseCount) {
		this.praiseCount = praiseCount;
	}
	public String getPraiseStatus() {
		return praiseStatus;
	}
	public void setPraiseStatus(String praiseStatus) {
		this.praiseStatus = praiseStatus;
	}
	public User getAnswerUser() {
		return answerUser;
	}
	public void setAnswerUser(User answerUser) {
		this.answerUser = answerUser;
	}
	public User getAnsweredUser() {
		return answeredUser;
	}
	public void setAnsweredUser(User answeredUser) {
		this.answeredUser = answeredUser;
	}
	@Override
	public String toString() {
		return "Comment [id=" + id + ", comment_content=" + comment_content + ", ownId=" + ownId + ", uid=" + uid
				+ ", style=" + style + ", master_id=" + master_id + ", date=" + date + ", topId=" + topId
				+ ", topStyle=" + topStyle + ", praiseCount=" + praiseCount + ", praiseStatus=" + praiseStatus
				+ ", answerUser=" + answerUser + ", answeredUser=" + answeredUser + "]";
	}
	
	
	
	
	
	
}
