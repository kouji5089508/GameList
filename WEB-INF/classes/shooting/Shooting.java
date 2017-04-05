package shooting;


import java.sql.SQLException;
import java.util.ArrayList;

import ap.User;
import db.DBUtil;

public class Shooting {
	User user;
	private Integer score=0;
	private final int MAX_LIFE=5;
	private int life=MAX_LIFE;
	public Shooting(User u){
		this.user=u;
	}
	public void deleteLife(){
		life-=1;
	}
	public int getLife(){
		return life;
	}
	public void addScore(int x){
		score+=x;
	};
	public int getScore(){
		return score;
	}
	public void setScore(int s){
		this.score=s;
	}
	public void calculateScore(int time,int level,int enemy_hp){
		int temp_score=0;
		int clear=100;
		int full_vonus=10;
		temp_score+=(clear-enemy_hp);
		if(life==MAX_LIFE){
			temp_score+=full_vonus;
		}
		addScore(temp_score);
	}
	public void save(){
		String sql=" insert into SHOOTING_LOG(user,score) values("+user.getId()+","+score+")";
		DBUtil.executeQuery(sql);
	}
	public void changeName(String name){
		String sql=" update user set name='"+name+"'"+" where id='"+user.getId()+"'";
		DBUtil.executeQuery(sql);
		user.setName(name);
	}
	public void reflesh(){
		this.score=0;
		this.life=MAX_LIFE;
	}
	public int getHighScore(){
		String sql="select max(score) from SHOOTING_LOG where user='"+user.getId()+"'";
		String highscore=DBUtil.getOneColumn(sql);
		if(highscore!=null){
			return Integer.parseInt(highscore);
		}else{
			return 0;
		}
	}
	public String getNowRank(){
		String sql="SELECT COUNT(*) +1 as rank   FROM SHOOTING_LOG s2     WHERE s2.score > '"+this.score+"'";
		String rank=DBUtil.getOneColumn(sql);
		String sql2=" select count(*) from SHOOTING_LOG ";
		String count=DBUtil.getOneColumn(sql2);
		if(rank!=null){
			return "rank:"+rank+"/all:"+count;
		}else{
			return "rank:"+0+"/all:"+0;
		}
	}
	public ArrayList<String[]> getRanking(){
		String sql="select u.name,s.score from SHOOTING_LOG s join user u on s.user=u.id order by score desc limit 100";
		Object[] data=DBUtil.getOneLineData(sql);
		java.sql.ResultSet rs=(java.sql.ResultSet)data[0];
		ArrayList<String[]> ranking=new ArrayList<String[]>();
		if(rs!=null){
			try {
				while(rs.next()){
					try {
						String name=rs.getString("name");
						String score=rs.getString("score");
						String [] list={name,score};
						ranking.add(list);
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return ranking;
	}
}
