package ap;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map.Entry;

import db.DBUtil;
import etc.Log;

public class GameLog {
	private HashMap<Integer,ArrayList<String>> g_u_log=new HashMap<Integer,ArrayList<String>>();
	private ArrayList<Integer> winner_list;
	private Integer game_id=0;
	private String theme;
	private HashMap <Integer,PlayUser> users_data;
	public GameLog(String tid,HashMap <Integer,PlayUser> u_data){
		theme=tid;
		this.users_data=u_data;
		try {
			game_id=DBUtil.getGameSequence();
		} catch (SQLException e) {
			e.printStackTrace();
			Log.systemLog(e);
		}
	}
	public void  addLog(Integer user_id,String vote_number,String comment){
		ArrayList u_log=new ArrayList();
		if(vote_number==null){
			vote_number=""+0;
		}
		u_log.add(vote_number);
		u_log.add(comment);
		g_u_log.put(user_id,u_log);

	}

	public Integer getId(){
		return game_id;
	}
	public void recordLog(){
		for(Entry<Integer, ArrayList<String>> entry : g_u_log.entrySet()){
			String u_id=entry.getKey()+"";
			ArrayList u_log=g_u_log.get(entry.getKey());
			Object t_vote=u_log.get(0);
			Integer vote_number=0;
			if(t_vote!=null){
				String tv=(String)t_vote;
				if(!tv.equals("null")){
					try{
						vote_number=Integer.parseInt(tv);
					}
					catch(NumberFormatException e){
						e.printStackTrace();
						Log.systemLog(e);
					}
				}
			}
			StringBuilder sql = new StringBuilder();
			PreparedStatement statement = null;
			sql.append(" insert into game_log (id,player,date,vote_num,comment,theme)");
			sql.append(" values (?,?,now(),?,?,?) ");
			// 引数にjava.sql.Statement.RETURN_GENERATED_KEYSを指定
			// DBコネクションは既に取得ずみとする
			java.sql.Connection  db=DBUtil.getConnection();
			try {
				statement = db.prepareStatement(sql.toString(),
						java.sql.Statement.RETURN_GENERATED_KEYS);
				statement.setInt(1, game_id);
				statement.setString(2, u_id);
				statement.setInt(3, vote_number);
				statement.setString(4, (String)u_log.get(1));
				statement.setString(5, theme);
				DBUtil.executeQuery(statement);
			} catch (SQLException e) {
				// TODO 自動生成された catch ブロック
				e.printStackTrace();
				Log.systemLog(e);
			}

		}
	}
	public ArrayList<Integer> getWinner(){
		int max=0;
		for(ArrayList<String> u_log : g_u_log.values()){
			max=Math.max(max, Integer.parseInt((String)u_log.get(0)));
		}
		ArrayList<Integer> winner_list=new ArrayList<Integer>();
		for(Entry<Integer, ArrayList<String>> entry : g_u_log.entrySet()){
			if(Integer.parseInt((String)g_u_log.get(entry.getKey()).get(0))==max){
				winner_list.add(entry.getKey());
			}
		}
		return winner_list;
	}
	public void setWinner(){
		winner_list=new ArrayList();
	}
}
