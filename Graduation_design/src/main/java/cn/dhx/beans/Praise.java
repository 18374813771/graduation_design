package cn.dhx.beans;

public class Praise {
	private Integer id;
	private String tab;
	private Integer pid;
	private Integer uid;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getTab() {
		return tab;
	}
	public void setTab(String tab) {
		this.tab = tab;
	}
	public Integer getPid() {
		return pid;
	}
	public void setPid(Integer pid) {
		this.pid = pid;
	}
	public Integer getUid() {
		return uid;
	}
	public void setUid(Integer uid) {
		this.uid = uid;
	}
	@Override
	public String toString() {
		return "Praise [id=" + id + ", tab=" + tab + ", pid=" + pid + ", uid=" + uid + "]";
	}
	
}
