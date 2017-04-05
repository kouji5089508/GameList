package db;

public class WithConnection {
	private java.sql.Connection con=null;
	public WithConnection(){
		this.con=DBUtil.getNewConnection();
	}
	public java.sql.Connection getConnection(){
		return this.con;
	}
}
