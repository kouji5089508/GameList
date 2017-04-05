package ap;

import java.util.ArrayList;

public class WatchUser {
	private User user;
	private Game game;
	private ArrayList<Comment> comment_array=new ArrayList<Comment>();
	private boolean isAlived=true;
	private Integer dead_count=0;
	private Integer dead_line;
	private boolean vote_flg=false;//投票済みかどうか
	public WatchUser(User u){
		this.user=u;
		this.dead_line=Integer.parseInt(Conf.getConfAttr("watch_dead_count"));
	}
	public void setGame(Game g){
		this.game=g;
	}

	public Integer getId(){
		return Integer.parseInt(user.getId());
	}
	public String getGameId(){
		if(game!=null){
			return game.getId()+"";
		}
		else{
			return null;
		}
	}


	public void vote(Integer v_id){
		game.vote(Integer.parseInt(user.getId()),v_id);
		this.setVoteFlg(true);
	}
	public void setIsAlived(boolean b){
		this.isAlived=b;
		if(b){
			dead_count=0;
		}
	}
	public void addDeadCount(){
		dead_count++;
	}
	public void die(){
		game.deleteWatchUser(this.getId());
	}
	public void setVoteFlg(boolean b){
		this.vote_flg=b;
	}
	public boolean getVoteFlg(){
		return this.vote_flg;
	}
	public void init(){
		if(!this.isAlived){//死んでいる場合
			dead_count++;
			if(dead_count>=dead_line){
				this.die();
			}
		}
		this.vote_flg=false;//投票をしていない状態とする
		this.setIsAlived(false);//一旦死んでもらい、次まで復活するか確認
	}
}
