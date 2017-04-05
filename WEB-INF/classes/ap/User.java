package ap;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import db.DBUtil;
import db.WithConnection;
import etc.Log;

public class User implements Cloneable{
	String id;
	String name;
	String age;
	String sex;
	int count;
	int rating;
	int play_count;//総ゲームプレイ回数
	int int_status=1;//json用
	java.sql.Date startdate;
	java.sql.Date lastdate;
	String vote_flg=null;
	WithConnection wc;
	static Master master;
	static boolean first_call_flg=true;
	public User(String id){
		this.id=id;
		master.setUserData(this);//マスタに登録
		Object[] data=DBUtil.getOneLineData("select u.*,count(*) play_count from user u left join game_log gl on u.id=gl.player where u.id=\'"+id+"\' group by u.id");
		java.sql.ResultSet rs=null;
		java.sql.ResultSetMetaData rsmd=null;
		rs=(java.sql.ResultSet)data[0];
		rsmd=(java.sql.ResultSetMetaData)data[1];
		try {
			rs.next();
			this.age=rs.getString("age");
			this.sex=rs.getString("sex");
			this.count=rs.getInt("count");
			this.name=rs.getString("name");
			this.startdate=rs.getDate("startdate");
			this.rating=rs.getInt("rating");
			this.play_count=rs.getInt("play_count");
			this.vote_flg=rs.getString("vote_flg");
			count++;
			if(first_call_flg==true){
				DBUtil.executeQuery("update user set count="+count+","+"lastdate=now() where id="+"'"+id+"'");
				first_call_flg=false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			Log.systemLog(e);
		}
		//Log.setUser(name);//ログにユーザーネームセット
		this.wc=new WithConnection();
	}
	public java.sql.Connection getConnection(){
		return this.wc.getConnection();
	}
	public synchronized static void setMaster(Master m){
		master=m;
	}
	public String getId(){
		return id;
	}
	public String  getName(){
		return name;
	}
	public String getVoteFlg(){
		return this.vote_flg;
	}
	public void setVoteFlg(String v){
		this.vote_flg=v;
	}
	public void setName(String name){
		this.name=name;
	}

	public void setStatus(int s){//json用
		this.int_status=s;
	}
	public String getCount(){
		return count+"";
	}

	public String getStartDate(){
		if(startdate!=null){
			return new SimpleDateFormat("yyyy年MM月dd日").format(startdate);
		}
		else{
			return null;
		}
	}
	public PlayUser makePlayUser(Game game){
		return new PlayUser(this,game);
	}
	public  static  Master getMaster(){
		return master;
	}
	public int getRaiting(){
		return this.rating;
	}

	public int getPlayCount(){
		return this.play_count;
	}

	public String getSex(){
		if(this.sex!=null &&this.sex.equals("1")){
			return "男";
		}
		else if(this.sex!=null && this.sex.equals("2")){
			return "女";
		}
		else{
			return "未登録";
		}
	}

	public Integer getIntSex(){
		if(this.sex==null){
			return 0;
		}
		try{
			int s=Integer.parseInt(this.sex);
			return s;
		}
		catch(Exception e){
			return 0;
		}

	}
	public String getAge(){
		return this.age;
	}
	public void setRaiting(int rai){
		this.rating=rai;
	}

	public void addPlayCount(){
		this.play_count++;
	}
	public ArrayList<String[]> getUserInfo(){
		ArrayList<String[]> info = new ArrayList<String[]>();
		info.add(new String[]{"名前",this.getName()});
		info.add(new String[]{"年齢",this.getAge()});
		info.add(new String[]{"性別",this.getSex()});
		info.add(new String[]{"開始日",this.getStartDate()});
		info.add(new String[]{"来場回数",this.getCount()});
		info.add(new String[]{"レーティング",this.getRaiting()+""});
		info.add(new String[]{"プレイ回数",this.play_count+""});
		return info;
	}

	public static void registDefaultUser(Integer id){
		String insert_new_user="insert into user (id,name,startdate,age,sex) values("+"'"+id+"'"+","+"'"+"名無し"+"'"+","+"now(),'"+"未登録"+"','"+0+"' );";//ユーザー登録
		DBUtil.executeQuery(insert_new_user);
	}

	public void update(String n,String s,String a){
		this.name=n;
		this.sex=s;
		this.age=a;
		String update_sql="update  user set name='"+n+"'"+","+"age='"+a+"', sex = '"+s+"' where id='"+this.id+"' ;";
		DBUtil.executeQuery(update_sql);
	}


}
