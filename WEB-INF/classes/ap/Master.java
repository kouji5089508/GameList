package ap;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import net.arnx.jsonic.JSON;
import etc.Log;

public class Master implements Serializable{
	private  HashMap <Integer,Game> gameMap;
	private  HashMap <Integer,User> m_user_list;
	private  Integer latest_game=0;
	private  Integer max_number=6;
	private Log log;
	public Master(){
		Conf.fileRead(Conf.getConfPath());
		Conf.setRealPath();
		Log.setConf();
		Game.setMaster(this);
		User.setMaster(this);
		gameMap=new HashMap();
		m_user_list=new HashMap();
	}
	public void testPrint(){
		for(Map.Entry<Integer, Game>  entry : gameMap.entrySet()){
			System.out.println(entry.getKey());
		}
	}

	public Integer getGameId(Integer user_id){
		String game_id=null;
		for(Map.Entry<Integer, Game>  entry : gameMap.entrySet()){
			if(gameMap.get(entry.getKey()).hasUser(user_id+"")){
				game_id=entry.getKey()+"";
			}
		}
		if(game_id!=null){
			return Integer.parseInt(game_id);//既に登録されているゲームが有る場合
		}
		else{
			return null;
		}
	}

	public void deletePlayUser(Integer new_game_id,Integer p_id){
		for(Map.Entry<Integer, Game>  entry : gameMap.entrySet()){
			if(gameMap.get(entry.getKey()).hasUser(p_id+"")){
				if(new_game_id!=entry.getKey()){
					gameMap.get(entry.getKey()).deletePlayUser(p_id+"");
				}
			}
		}
	}
	public PlayUser getPlayUser(Integer user_id){
		String game_id=getGameId(user_id)+"";
		if(game_id==null){
			return null;
		}
		else{
			PlayUser pu=this.getGame(Integer.parseInt(game_id)).getPlayUser(user_id);
			return pu;
		}
	}
	public Integer  getWelcomeGameId(Integer user_id){
		Integer game_id=null;
		game_id=getGameId(user_id);
		if(game_id!=null ){
			return game_id;
		}
		else{
			if(latest_game==0){
				Game new_game=makeNewGame();
				new_game.putUserData(user_id);//ユーザー登録
				return latest_game;
			}
			else{
				if(gameMap.get(latest_game)!=null && gameMap.get(latest_game).getNumber()<max_number){
					Game l_game=gameMap.get(latest_game);
					l_game.putUserData(user_id);//ユーザー登録
					return latest_game;
				}
				makeNewGame();
				return latest_game;
			}

		}
	}

	public Game getGame(Integer game_id){
		return gameMap.get(game_id);
	}

	private Integer  getGameCount(Integer gid){
		return gameMap.get(gid).getNumber();
	}

	public HashMap <Integer,Game> getGameMap(){
		if(gameMap.size()==0){
			makeNewGame();
		}
		return this.gameMap;
	}

	public synchronized Game makeNewGame(){
		latest_game++;
		Game new_game= new Game(latest_game);
		gameMap.put(latest_game, new_game);
		return new_game;
	}
	public HashMap<Integer,PlayUser>  getUsersData(Integer game_id){
		return gameMap.get(game_id).getUsersData();
	}
	public synchronized void setUserData(User u){
		m_user_list.put(Integer.parseInt(u.getId()),u);
	}
	public synchronized PlayUser makeNewPlayUser(Integer user_id,Game game){
		User u=m_user_list.get(user_id);
		return u.makePlayUser(game);
	}
	public int  getMaxNuber(){
		return this.max_number;
	}
	public String toString(){
		String return_s="";
		for(Map.Entry<Integer, Game>  entry : gameMap.entrySet()){
			Game game=gameMap.get(entry.getKey());
			HashMap <Integer,PlayUser> userdatas=game.getUsersData();
			for(Map.Entry<Integer, PlayUser>  entry2 : userdatas.entrySet()){
				PlayUser p=userdatas.get(entry2.getKey());
				return_s+=game.getId()+":"+p.getName()+":"+p.getAnswer()+"//";
			}
		}
		return return_s;
	}
	public String getConfAttr(String attr){
		return Conf.getConfAttr(attr);
	}

	public void deleteGame(Integer gameid){
		synchronized(gameMap.get(gameid)){
			gameMap.get(gameid).stopCommentThread();//コメントスレッドも止める
			gameMap.remove(gameid);
		}
	}

	public String encode(Object o){
		return JSON.encode(o);
	}


}
