package cn.dhx.beans;

public class Blog {
	private Integer id;
	private String blog_name;
	private String blog_content;
	private Integer uid;
	private int read_count;
	private int praise_count;
	private String date;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getBlog_name() {
		return blog_name;
	}
	public void setBlog_name(String blog_name) {
		this.blog_name = blog_name;
	}
	public String getBlog_content() {
		return blog_content;
	}
	public void setBlog_content(String blog_content) {
		this.blog_content = blog_content;
	}
	public Integer getUid() {
		return uid;
	}
	public void setUid(Integer uid) {
		this.uid = uid;
	}
	public int getRead_count() {
		return read_count;
	}
	public void setRead_count(int read_count) {
		this.read_count = read_count;
	}
	public int getPraise_count() {
		return praise_count;
	}
	public void setPraise_count(int praise_count) {
		this.praise_count = praise_count;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	@Override
	public String toString() {
		return "Blog [id=" + id + ", blog_name=" + blog_name + ", blog_content=" + blog_content + ", uid=" + uid
				+ ", read_count=" + read_count + ", praise_count=" + praise_count + ", date=" + date + "]";
	}
	
}
