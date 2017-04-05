package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import ap.Conf;
import etc.Log;

public class DBUtil {
	public DBUtil(){

	}

	static java.sql.Connection db=null;

	public  static void setDB(java.sql.Connection dbc){
		db=dbc;
	}
	public  static java.sql.Connection getConnection(){
		return db;
	}
	public static Connection getNewConnection(){
		Connection t_db=null;
		try {
			t_db = DriverManager.getConnection(Conf.getConfAttr(Conf.DB_URL),Conf.getConfAttr(Conf.DB_USER_NAME),Conf.getConfAttr(Conf.DB_PASSWORD));
		} catch (SQLException e) {
			e.printStackTrace();
			Log.systemLog(e);
		}
		return t_db;
	}
	public static String  getOneColumn(String sql){
		java.sql.PreparedStatement ps;
		java.sql.ResultSet rs;
		java.sql.ResultSetMetaData rsmd=null;
		String result=null;
		try {
			ps = db.prepareStatement(sql);
			rs =  ps.executeQuery();
			rsmd=  rs.getMetaData();
			rs.next();
			result=rs.getString(1);
			Log.dbLog(sql);
		} catch (SQLException e1) {
			e1.printStackTrace();
			 Log.systemLog(e1);
		}

		return result;
	}

	public static Object  getOneObjectColumn(String sql){
		java.sql.PreparedStatement ps;
		java.sql.ResultSet rs;
		java.sql.ResultSetMetaData rsmd=null;
		Object result=null;
		try {
			ps = db.prepareStatement(sql);
			rs =  ps.executeQuery();
			rsmd=  rs.getMetaData();
			rs.next();
			result=rs.getObject(1);
			Log.dbLog(sql);
		} catch (SQLException e1) {
			e1.printStackTrace();
			 Log.systemLog(e1);
		}

		return result;
	}

	public static void executeQuery(String sql){
		java.sql.PreparedStatement ps;
		try {
			ps = db.prepareStatement(sql);
			ps.executeUpdate();
			ps.close();
			Log.dbLog(sql);
		} catch (SQLException e1) {
			e1.printStackTrace();
			 Log.systemLog(e1);
		}
	}

	public static void executeQuery(java.sql.PreparedStatement sql){
		java.sql.PreparedStatement ps;
		try {
			ps = sql;
			ps.executeUpdate();
			ps.close();
			Log.dbLog(sql.toString());
		} catch (SQLException e1) {
			e1.printStackTrace();
			 Log.systemLog(e1);
		}finally{
			if(sql!=null){
				try {
					sql.close();
				} catch (SQLException e) {
					// TODO 自動生成された catch ブロック
					e.printStackTrace();
					Log.systemLog(e);
				}
			}
		}
	}

	public static Object[] getOneLineData(String sql){
		java.sql.PreparedStatement ps;
		java.sql.ResultSet rs=null;
		java.sql.ResultSetMetaData rsmd=null;
		String result=null;
		try {
			ps = db.prepareStatement(sql);
			rs =  ps.executeQuery();
			rsmd=  rs.getMetaData();
			Log.dbLog(sql.toString());
		} catch (SQLException e1) {
			e1.printStackTrace();
			 Log.systemLog(e1);
		}
		Object[] data=new Object[2];
		data[0]=rs;
		data[1]=rsmd;
		return data;
	}

	public static int getGameSequence( ) throws SQLException {
		PreparedStatement statement = null;
		ResultSet rs = null;
		int autoIncKey = -1;
		try {
			StringBuilder sql = new StringBuilder();

			sql.append(" insert into seq_game_log");
			sql.append("   (");
			sql.append("     hoge");
			sql.append("  ) ");
			sql.append(" values (?) ");
			// 引数にjava.sql.Statement.RETURN_GENERATED_KEYSを指定
			// DBコネクションは既に取得ずみとする
			statement = db.prepareStatement(sql.toString(),
					java.sql.Statement.RETURN_GENERATED_KEYS);

			statement.setString(1, "hoge");

			// 追加
			statement.executeUpdate();
			Log.dbLog(sql.toString());
			// auto-incrementの値取得
			rs = statement.getGeneratedKeys();
			if(rs!=null){
				if (rs.next()) {
					autoIncKey = rs.getInt(1);
				}
			}
		} catch (SQLException e) {
			throw e;
		} finally {
			// ResultSetクローズ
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			// statementクローズ
			if (statement != null) {
				try {
					statement.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}

		return autoIncKey;
	}
}
