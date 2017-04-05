package ap;

import db.DBUtil;

public class PlayUser  {
	private User user;
	private UserStatus status=UserStatus.play;
	private String answer="";
	private Game game;
	private Integer vote_player=null;//投票した相手
	private int non_play_count=0;
	private int dead_count=0;
	private String mode="watch";
	public PlayUser(User u,Game game){
		this.user=u;
		this.game=game;
		setGameStatus();//登録時にステータスを正しく入れる
	}
	public String getName(){
		return user.getName();
	}
	public String getId(){
		return user.getId();
	}

	public int getRating(){
		return user.getRaiting();
	}

	public void setMode(String s){
		this.mode=s;
		this.non_play_count=0;
	}

	public String getMode(){
		return this.mode;
	}

	public int getPlayCount(){
		return user.getPlayCount();
	}
	public synchronized void setStatus(Integer i){
		if(i==0){
			this.status=UserStatus.ready;
			user.setStatus(i);
		}
		else if(i==1){
			this.status=UserStatus.play;
			user.setStatus(i);
		}
		else if(i==2){
			this.status=UserStatus.result;
			user.setStatus(i);
		}
		else if(i==3){
			this.status=UserStatus.vote;
			user.setStatus(i);
		}
		else if(i==4){
			this.status=UserStatus.vote_result;
			user.setStatus(i);
		}
	}
	public String getStringStatus(){
		return this.status.getString();
	}
	public Integer getStatus(){
		return this.status.getStatus();
	}

	public void setRating(int rating){
		user.setRaiting(rating);
	}
	public synchronized void setAnswer(String a){
		this.answer=a;
	}
	public String getAnswer(){
		return answer;
	}

	public synchronized void init(){
		/*if(!this.isAlived()){
			this.logOut();//死んでたらログアウト
		}*/
		if(!this.isAlived()){
			this.logOut();
		}
		this.dead_count++;
		this.answer="";
		this.status=UserStatus.ready;
		this.vote_player=null;
	}

	public void vote(Integer vote_user_id){
		game.vote(Integer.parseInt(this.getId()),vote_user_id);
		setStatus(4);
		//game.modifyStatus();//watchuserもいるし調整は一旦保留
		this.vote_player=vote_user_id;
	}

	public boolean isAnswerd(){
		return answer!=null && !answer.equals("");
	}

	public boolean isNotValid(){
		return !isAnswerd() && getStatus()!=1;
	}

	public void setGameStatus(){//playuser作成時に正しくステータスを入れるため
	    if(game.getStatus().getStatus()==0){
	    	this.status=UserStatus.ready;;
	    }
		else if(game.getStatus().getStatus()==1){
			this.status=UserStatus.play;
		}
		else if(game.getStatus().getStatus()==2){
			this.status=UserStatus.vote;
		}
		else if(game.getStatus().getStatus()==3){
			this.status=UserStatus.vote_result;
		}
	}
	public boolean isVote(){
		return vote_player!=null;
	}

	public void setAlived(){
		this.dead_count=0;
	}

	public void afterTreat(){//最終チェック
		if(isNotValid() && !isVote() && mode.equals("play")){
			non_play_count++;
		}
		else{
			non_play_count=0;
			user.addPlayCount();
		}
	}

	public boolean isPlayed(){
		return non_play_count<4;
	}

	public boolean isAlived(){
		return dead_count<2;
	}


	public void saveData(){
		DBUtil.executeQuery("update user set rating="+user.getRaiting()+" where id="+ user.getId());
	}

	public User getUser(){
		return user;
	}

	public void logOut(){
		saveData();
		game.deletePlayUser(getId());
		non_play_count=0;
	}
}
