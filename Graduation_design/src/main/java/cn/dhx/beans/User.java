package cn.dhx.beans;

public class User {
	private Integer id;
	private String name;
	private String password;
	private int age;
	private String sex;
	private String telephone;
	private String email;
	private String src;
	private int isavailable;
	private int permissions;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getTelephone() {
		return telephone;
	}
	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getSrc() {
		return src;
	}
	public void setSrc(String src) {
		this.src = src;
	}
	public int getIsavailable() {
		return isavailable;
	}
	public void setIsavailable(int isavailable) {
		this.isavailable = isavailable;
	}
	public int getPermissions() {
		return permissions;
	}
	public void setPermissions(int permissions) {
		this.permissions = permissions;
	}
	@Override
	public String toString() {
		return "User [id=" + id + ", name=" + name + ", password=" + password + ", age=" + age + ", sex=" + sex
				+ ", telephone=" + telephone + ", email=" + email + ", src=" + src + ", isavailable=" + isavailable
				+ ", permissions=" + permissions + "]";
	}
	
	
}
