package ap;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import db.DBUtil;
import etc.Log;

public class Game {
	private Integer game_id;
	private static  Master master;
	private HashMap <Integer,PlayUser>users_data=new HashMap<Integer,PlayUser>();
	private HashMap <Integer,WatchUser>watch_users_data=new HashMap<Integer,WatchUser>();
	private HashMap <Integer,Integer>vote_map=new HashMap<Integer,Integer>();//投票したユーザー、投票されたユーザー
	private HashMap <Integer,Integer>winner_map=new HashMap<Integer,Integer>();//投票されたユーザー、票数
	private ArrayList<Comment> comment_array=new ArrayList<Comment>();
	private CommentMap c_map=new CommentMap(comment_array);
	private static  Integer MAX_READY_TIME_COUNT;
	private  Integer ready_time_count;
	private static  Integer MAX_TIME_COUNT;
	private  Integer time_count;
	private static  Integer MAX_RESULT_TIME_COUNT;
	private  Integer result_time_count;
	private  Integer vote_result_time_count;
	private static Integer MAX_VOTE_RESULT_TIME;
	private Status status=Status.ready;
	private Integer error_count=0;
	private Integer before_count=0;
	private boolean count_flg=false;
	private HashMap <Integer,GameLog>game_log=new HashMap<Integer,GameLog>();
	private ArrayList<String> theme_list=new ArrayList<String>();
	private Theme now_theme;
	private boolean comment_thread_flg=true;
	public Game(Integer gid){
		this.game_id=gid;
		ready_time_count=MAX_READY_TIME_COUNT;
		time_count=MAX_TIME_COUNT;
		result_time_count=MAX_RESULT_TIME_COUNT;
		vote_result_time_count=MAX_VOTE_RESULT_TIME;
		setNewTheme();//最初にテーマを設定
		proceedComment();//コメント用のタイマースタート
	}
	public  static void setMaster(Master m){
		master=m;
		MAX_READY_TIME_COUNT=Integer.parseInt(master.getConfAttr("max_ready_time_count"));
		MAX_TIME_COUNT=Integer.parseInt(master.getConfAttr("max_time_count"));
		MAX_RESULT_TIME_COUNT=Integer.parseInt(master.getConfAttr("max_result_time_count"));
		MAX_VOTE_RESULT_TIME=Integer.parseInt(master.getConfAttr("max_vote_result_time_count"));
	}
	public Integer getNumber(){
		return users_data.size();
	}

	public Integer getPlayNumber(){
		Integer p_num=0;
		for(Map.Entry<Integer, PlayUser>  entry : users_data.entrySet()){
			PlayUser p_user=users_data.get(entry.getKey());
			if(p_user.getMode().equals("play")){
				p_num++;
			}
		}
		return p_num;
	}
	public boolean hasUser(String user_id){
		return users_data.containsKey(Integer.parseInt(user_id));
	}
	public HashMap <Integer,WatchUser> getWatchUsersData(){
		return watch_users_data;
	}
	public HashMap <Integer,PlayUser> getUsersData(){
		return users_data;
	}
	public Integer getId(){
		return game_id;
	}
	public synchronized void  putUserData(Integer user_id){
		this.putPlayUserData(user_id,master.makeNewPlayUser(user_id,this));
	}
	public synchronized void putPlayUserData(Integer user_id,PlayUser pu){
		users_data.put(user_id,pu);
		if(this.getNumber()>= master.getMaxNuber()){
			master.makeNewGame();//ゲームは数が増えすぎた時点で作成する
		}
		System.out.println("putPlayUsersData="+user_id);
	}
	public synchronized void  putWatchUserData(WatchUser w_user){
		if(watch_users_data.containsKey(w_user.getId())){

		}
		else{
			watch_users_data.put(w_user.getId(),w_user);
			System.out.println("putWatchUserData="+w_user.getId());
		}
	}
	private  synchronized void setCountFlg(boolean b){
		this.count_flg=b;
		System.out.println("set count_flg="+b);
	}

	public void putComment(String c){
		synchronized(comment_array){
			comment_array.add(new Comment(c));
		}
	}
	public Comment flowComment(){
		Comment come=comment_array.get(0);
		comment_array.remove(0);
		return come;
	}

	public  CommentMap getCMap(){
		return this.c_map;
	}

	public  boolean getCountFlg(){
		return count_flg;
	}
	public void stopCommentThread(){
		this.comment_thread_flg=false;
	}
	public void proceedComment(){//コメントを進める
		new Thread(){
			public void run(){
				while(comment_thread_flg){
					try{
		            	c_map.proceedComment();
		                // 指定ミリ秒の間眠る
		                Thread.sleep(500);
		            }
		            catch(InterruptedException e){
		            	e.printStackTrace();
		            	 Log.systemLog(e);
		            }
				}
			};
		}.start();
	}
	public synchronized void countDown(){
		System.out.println(status.getString()+":"+time_count+":"+result_time_count+":"+vote_result_time_count+":"+error_count+status);
		if(ready_time_count==MAX_READY_TIME_COUNT && status==Status.ready && !count_flg){
			Log.systemLog("count start!!");
			setCountFlg(true);
			new Thread(){
				public void run(){
					for (int i = 0; i < MAX_READY_TIME_COUNT; i++) {
						if(status!=Status.ready  ){//途中で他の要因でステータス変わったら中止
							ready_time_count=MAX_READY_TIME_COUNT;
							return;
						}
						if(ready_time_count<=0){
							break;
						}
			            try{
			            	ready_time_count--;
			                // 指定ミリ秒の間眠る
			                Thread.sleep(1000);
			            }
			            catch(InterruptedException e){
			            	e.printStackTrace();
			            	 Log.systemLog(e);
			            }
			        }
					changeStatus();
				};
			}.start();
		}
		else if(time_count==MAX_TIME_COUNT && status==Status.play && !count_flg){
			Log.systemLog("カウントダウン開始");
			setCountFlg(true);
			new Thread(){
				public void run(){
					for (int i = 0; i < MAX_TIME_COUNT; i++) {
						if(status!=Status.play  ){//途中で他の要因でステータス変わったら中止
							time_count=MAX_TIME_COUNT;
							return;
						}
						if(time_count<=0){
							break;
						}
			            try{
			            	time_count--;
			                // 指定ミリ秒の間眠る
			                Thread.sleep(1000);
			            }
			            catch(InterruptedException e){
			            	e.printStackTrace();
			            	 Log.systemLog(e);
			            }
			        }
					changeStatus();
				};
			}.start();
		}
		else if(result_time_count==MAX_RESULT_TIME_COUNT && status==Status.result){
			setCountFlg(true);
			new Thread(){
				public void run(){
					for (int i = 0; i < MAX_RESULT_TIME_COUNT; i++) {
						if(status!=Status.result){//途中で他の要因でステータス変わったら中止
							result_time_count=MAX_RESULT_TIME_COUNT;
							return;
						}
						if(result_time_count<=0){
							break;
						}
			            try{
			            	result_time_count--;
			                // 指定ミリ秒の間眠る
			                Thread.sleep(1000);
			            }
			            catch(InterruptedException e){
			            	e.printStackTrace();
			            	 Log.systemLog(e);
			            }
			        }
					changeStatus();
				};
			}.start();
		}
		else if(vote_result_time_count==MAX_VOTE_RESULT_TIME && status==Status.vote_result){
			setCountFlg(true);
			new Thread(){
				public void run(){
					for (int i = 0; i < MAX_VOTE_RESULT_TIME; i++) {
						if(status!=Status.vote_result){//途中で他の要因でステータス変わったら中止
							vote_result_time_count=MAX_VOTE_RESULT_TIME;
							return;
						}
						if(vote_result_time_count<=0){
							break;
						}
			            try{
			            	vote_result_time_count--;
			                // 指定ミリ秒の間眠る
			                Thread.sleep(1000);
			            }
			            catch(InterruptedException e){
			            	e.printStackTrace();
			            	 Log.systemLog(e);
			            }
			        }
					changeStatus();
				};
			}.start();
		}
		else if(status==Status.ready){
			if(before_count==ready_time_count){
				error_count++;
			}
			if(error_count>=20){
				ready_time_count=MAX_READY_TIME_COUNT;
			}
			before_count=ready_time_count;
		}
		else if(status==Status.play){
			if(before_count==time_count){
				error_count++;
			}
			if(error_count>=20){
				time_count=MAX_TIME_COUNT;
			}
			before_count=time_count;
		}
		else if(status==Status.result){
			if(before_count==result_time_count){
				error_count++;
			}
			if(error_count>=20){
				result_time_count=MAX_RESULT_TIME_COUNT;
			}
			before_count=result_time_count;
		}
		else if(status==Status.vote_result){
			if(before_count==vote_result_time_count){
				error_count++;
			}
			if(error_count>=20){
				vote_result_time_count=MAX_VOTE_RESULT_TIME;
			}
			before_count=vote_result_time_count;
		}
		error_count=0;

	}
	private synchronized void changeStatus(){
		if(status==Status.ready){
			setNewTheme();//新しいテーマをセット
			ready_time_count=MAX_READY_TIME_COUNT;
			status=Status.play;
			for(Map.Entry<Integer, PlayUser>  entry : users_data.entrySet()){
				PlayUser pu=users_data.get(entry.getKey());
				pu.setStatus(1);//全員投票中に変更
			}
			setCountFlg(false);
		}
		else if(status==Status.play){
			time_count=MAX_TIME_COUNT;
			status=Status.result;
			for(Map.Entry<Integer, PlayUser>  entry : users_data.entrySet()){
				PlayUser pu=users_data.get(entry.getKey());
				pu.setStatus(3);//全員投票中に変更
			}
			setCountFlg(false);
		}
		else if(status==Status.result){
			result_time_count=MAX_RESULT_TIME_COUNT;
			status=Status.vote_result;
			setCountFlg(false);
			makeWiinerMap();//勝者を求める
			for(Map.Entry<Integer, PlayUser>  entry : users_data.entrySet()){
				PlayUser pu=users_data.get(entry.getKey());
				pu.setStatus(4);//全員投票終了に変更
			}
		}
		else if(status==Status.vote_result){
			vote_result_time_count=MAX_VOTE_RESULT_TIME;
			setCountFlg(false);
			recordLog();
			afterTreat();
			init();
		}
	}

	private void afterTreat(){
		for(Map.Entry<Integer, PlayUser>  entry : users_data.entrySet()){
			users_data.get(entry.getKey()).afterTreat();//全ユーザー最終チェック
		}
		calculateRating();//レート計算
	}

	private void calculateRating(){
		HashMap <Integer,Integer> winner=getWinner();
		ArrayList <Integer> looser=getLooser();
		for(Map.Entry<Integer, Integer>  entry : winner.entrySet()){
			PlayUser win=users_data.get(entry.getKey());
			for(int i=0;i<looser.size();i++){
				PlayUser loose =users_data.get(looser.get(i));
				twoRating(win,loose,true);
			}

			/*for(Map.Entry<Integer, Integer>  entry_draw : winner.entrySet()){//ドロー
				if(!entry_draw.getKey().equals(entry.getKey())){//現在のプレーヤーとは違えば

				}
			}*/
		}

		for(int i=0;i<looser.size();i++){
			PlayUser loose =users_data.get(looser.get(i));
			for(Map.Entry<Integer, Integer>  entry : winner.entrySet()){
				PlayUser win=users_data.get(entry.getKey());
				twoRating(loose,win,false);
			}
		}
	}

	public void twoRating(PlayUser home, PlayUser away ,boolean win){//２人の勝敗によるレート
		int home_rate=home.getRating();
		int away_rate=away.getRating();
		int home_play_count=modifyPlayCount(home.getPlayCount());
		int away_play_count=modifyPlayCount(away.getPlayCount());
		int rate=1;
		if(!win){
			rate=-1;
		}
		int new_rate=home_rate;
		if((home_rate-away_rate>=400) && win){

		}
		else{
			new_rate=home_rate+((away_rate-home_rate)+400*rate)/home_play_count;
		}
		home.setRating(new_rate);
	}

	private  int modifyPlayCount(int i){
		if(i<25){
			if(i<10){
				return 10;
			}
			else{
				return i+1;
			}
		}
		else{
			return i;
		}
	}
	private  synchronized void init(){
		status=Status.ready;
		vote_map=new HashMap<Integer,Integer>();
		synchronized(users_data){
			for(Map.Entry<Integer, PlayUser>  entry : users_data.entrySet()){
				users_data.get(entry.getKey()).init();//全ユーザ初期化、死んでたらログアウト
			}
		}
		/*for(Map.Entry<Integer, WatchUser>  entry : watch_users_data.entrySet()){
			watch_users_data.get(entry.getKey()).init();//全ウォッチユーザ初期化、死んでたらログアウト
		}*/
		//setNewTheme();//新しいテーマをセット
	}
	private void recordLog(){
		GameLog glog=new GameLog(now_theme.getId(),this.getUsersData());
		HashMap <Integer,Integer> v_map=getVoteMap();
		for(Map.Entry<Integer, PlayUser>  entry : users_data.entrySet()){
			String answer=users_data.get(entry.getKey()).getAnswer();
			if(answer!=null && !answer.equals("")){
				PlayUser pu=users_data.get(entry.getKey());
				Integer id=Integer.parseInt(pu.getId());
				glog.addLog(id, v_map.get(id)+"", answer);
			}
		}
		Integer g_num;
		g_num = glog.getId();
		glog.recordLog();//DBに保存
		game_log.put(g_num,glog);
	}
	public synchronized void modifyStatus(){//全員が回答済みならresultに変更
		int result_count=0;
		int vote_count=0;
		int number=users_data.size();
		int p_number=getPlayNumber();
		for(Map.Entry<Integer, PlayUser>  entry : users_data.entrySet()){
			if(users_data.get(entry.getKey()).getStatus()==2){
				result_count++;
			}
			else if(users_data.get(entry.getKey()).getStatus()==4){
				vote_count++;
			}
		}
		if(result_count==p_number || vote_count==number){
			changeStatus();
		}
	}

	public Integer getCount(){
		if(status==Status.ready){
			return ready_time_count;
		}
		else if(status==Status.play){
			return time_count;
		}
		else if(status==Status.result){
			return result_time_count;
		}
		else if(status==Status.vote_result){
			return vote_result_time_count;
		}
		else{
			return null;
		}
	}

	public PlayUser getPlayUser(Integer user_id){
		return users_data.get(user_id);
	}

	public Status getStatus(){
		return status;
	}

	public void setUserStatus(){

	}

	public void vote(Integer user_id,Integer vote_user_id){
		this.vote_map.put(user_id,vote_user_id);
	}

	public  HashMap <Integer,Integer> getVoteMap(){
		HashMap <Integer,Integer>tmp_vote_map=new HashMap<Integer,Integer>();
		for(Map.Entry<Integer, Integer>  entry : vote_map.entrySet()){
			tmp_vote_map.put(entry.getKey(), 0);
		}
		for(Map.Entry<Integer, Integer>  entry : vote_map.entrySet()){
			Integer vote_user_id=vote_map.get(entry.getKey());//投票される人
			if(tmp_vote_map.containsKey(vote_user_id)){
				Integer value=tmp_vote_map.get(vote_user_id);
				value++;
				tmp_vote_map.put(vote_user_id, value);
			}
			else{
				tmp_vote_map.put(vote_user_id,1);
			}
		}
		return tmp_vote_map;
	}

	public void makeWiinerMap(){
		winner_map=getWinner();
	}

	public HashMap getWinnerMap(){
		return winner_map;
	}

	public HashMap <Integer,Integer> getWinner(){
		HashMap <Integer,Integer>tmp_vote_map=new HashMap<Integer,Integer>();
		for(Map.Entry<Integer, Integer>  entry : vote_map.entrySet()){
			Integer vote_user_id=vote_map.get(entry.getKey());
			if(tmp_vote_map.containsKey(vote_user_id)){
				Integer value=tmp_vote_map.get(vote_user_id);
				tmp_vote_map.put(vote_user_id, ++value);
			}
			else{
				tmp_vote_map.put(vote_user_id,1);
			}
		}
		int max=0;
		for(Map.Entry<Integer, Integer>  entry : tmp_vote_map.entrySet()){
			Integer count=tmp_vote_map.get(entry.getKey());
			max=Math.max(count, max);
		}
		HashMap <Integer,Integer>return_vote_map=new HashMap<Integer,Integer>();
		for(Map.Entry<Integer, Integer>  entry : tmp_vote_map.entrySet()){
			Integer count=tmp_vote_map.get(entry.getKey());
			if(count==max){
				return_vote_map.put(entry.getKey(), count);
			}
		}
		return return_vote_map;
	}

	public ArrayList<Integer> getLooser(){
		HashMap <Integer,Integer> winner=getWinner();
		ArrayList <Integer> winner_array=new ArrayList<Integer>();
		ArrayList <Integer> looser_array=new ArrayList<Integer>();
		for(Map.Entry<Integer, Integer>  entry : winner.entrySet()){
			winner_array.add(entry.getKey());
		}
		for(Map.Entry<Integer, Integer>  entry : vote_map.entrySet()){
			int u_id=entry.getKey();
			if(!winner_array.contains(entry.getKey())){
				looser_array.add(entry.getKey());
			}
		}

		return looser_array;
	}

	public void setNewTheme(){
		String id_list="";
		String id=null;
		for(int i=0;i<theme_list.size();i++){
			if(i!=0){
				id_list+=",";
			}
			id_list+=theme_list.get(i);
		}
		if(id_list==""){
			id_list="9999999999999999999999";
		}
		String test_flg=Conf.getConfAttr(Conf.TEST_FLG);
		String test_sql="   (test_flg !=1  or test_flg is null ) ";
		if(test_flg !=null && test_flg.equals("on")){
			test_sql="  test_flg='1'  ";
		}
		String sql="select id,type,text,picture from theme where   "+ test_sql+"  and  not id in("+id_list+") ORDER BY RAND() LIMIT 1 ";
		Object[] data=DBUtil.getOneLineData(sql);
		java.sql.ResultSet rs=(java.sql.ResultSet)data[0];
		Theme theme=null;
		try {
			if(rs!=null){
				if(rs.next()){
					id=rs.getString("id");
					String type=rs.getString("type");
					String text=rs.getString("text");
					//Blob image=(Blob) rs.getBlob("picture");
					theme=new Theme(id,type,text,null);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			 Log.systemLog(e);
		}
		if(id==null){//お題を全てやり切ってしまった場合
			sql="select id,type,text,picture from theme   where  "+ test_sql+"  ORDER BY RAND() LIMIT 1 ";
			data=DBUtil.getOneLineData(sql);
			rs=(java.sql.ResultSet)data[0];
			theme=null;
			try {
				rs.next();
				id=rs.getString("id");
				String type=rs.getString("type");
				String text=rs.getString("text");
				//Blob image=(Blob) rs.getBlob("picture");
				theme=new Theme(id,type,text,null);
			} catch (SQLException e) {
				e.printStackTrace();
				 Log.systemLog(e);
			}
			theme_list=new ArrayList<String>();
		}
		theme_list.add(id);
		now_theme=theme;
	}

	public static Theme getStaticTheme(){//月ごとのお題取得
		String test_flg=Conf.getConfAttr(Conf.TEST_FLG);
		String test_sql="   (test_flg !=1  or test_flg is null ) ";
		if(test_flg !=null && test_flg.equals("on")){
			test_sql="  test_flg='1'  ";
		}
		String id=null;
		//String sql="select id,type,text,picture from theme where   "+ test_sql+"   ORDER BY last_static_used asc  LIMIT 1 ";
		String sql="select id,type,text,picture,now_static_theme from theme where   now_static_theme is not null   ORDER BY last_static_used asc  LIMIT 1 ";
		boolean redo_flg=false;
		Object[] data=DBUtil.getOneLineData(sql);
		java.sql.ResultSet rs=(java.sql.ResultSet)data[0];
		Date now_date=new Date();
		int now_month=now_date.getMonth();
		Theme theme=null;
		try {
			if(rs!=null){
				if(rs.next()){
					id=rs.getString("id");
					String type=rs.getString("type");
					String text=rs.getString("text");
					java.sql.Date now_static_theme=rs.getDate("now_static_theme");
					int month=now_static_theme.getMonth();
					if(now_month==month){
						//Blob image=(Blob) rs.getBlob("picture");
						String use_theme_sql="update theme set last_static_used=now() where id=\'"+id+"\'";
						DBUtil.executeQuery(use_theme_sql);
						theme=new Theme(id,type,text,null);
					}
					else{
						redo_flg=true;
					}
				}
				else{
					redo_flg=true;
				}
			}
			else{//現在使用されているテーマが無い場合
				redo_flg=true;
			}
			if(redo_flg){
				DBUtil.executeQuery("update theme set now_static_theme=null where now_static_theme is not null ");
				DBUtil.executeQuery("update user set vote_flg=null where vote_flg is not null");//全ユーザーと投票権初期化
				String redo_sql="select id,type,text,picture from theme where   "+ test_sql+"   ORDER BY last_static_used asc  LIMIT 1 ";
				Object[] redo_data=DBUtil.getOneLineData(redo_sql);
				java.sql.ResultSet redo_rs=(java.sql.ResultSet)redo_data[0];
				if(redo_rs!=null){
					if(redo_rs.next()){
						id=redo_rs.getString("id");
						String type=redo_rs.getString("type");
						String text=redo_rs.getString("text");
						//Blob image=(Blob) rs.getBlob("picture");
						String use_theme_sql="update theme set now_static_theme=now() where id=\'"+id+"\'";
						DBUtil.executeQuery(use_theme_sql);
						theme=new Theme(id,type,text,null);
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			 Log.systemLog(e);
		}
		return theme;
	}
	public Theme getNowTheme(){
		return now_theme;
	}

	public String getStatusDescript(){
		return this.status.getDescript();
	}

	public  void deletePlayUser(String userid){
		synchronized(users_data){
			users_data.remove(Integer.parseInt(userid));//ユーザー削除
		}
		if(users_data.size()==0 && watch_users_data.size()==0){//ユーザーが全員消えたら
			//master.deleteGame(game_id);//ゲームは消さない。消すとややこしくなるから
		}
	}
	public void deleteWatchUser(Integer w_user_id){
		watch_users_data.remove(w_user_id);
	}
}
