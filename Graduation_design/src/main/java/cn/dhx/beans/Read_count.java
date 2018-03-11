package cn.dhx.beans;

public class Read_count {
	private int id;
	private String tab;
	private int rid;
	private int count;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getTab() {
		return tab;
	}
	public void setTab(String tab) {
		this.tab = tab;
	}
	public int getRid() {
		return rid;
	}
	public void setRid(int rid) {
		this.rid = rid;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	@Override
	public String toString() {
		return "Read_count [id=" + id + ", tab=" + tab + ", rid=" + rid + ", count=" + count + "]";
	}
	
}
