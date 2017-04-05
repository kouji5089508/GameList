package ap;

import java.util.HashMap;

public class Session {
	private User user;
	private WatchUser w_user;
	private HashMap<String,Object> map=new HashMap<String,Object>();
	public Session(User u){
		this.user=u;
		this.w_user=new WatchUser(u);
	}
	public Session(){

	}

	public void setUser(User u){
		this.user=u;
		this.w_user=new WatchUser(u);
	}
	public void setObject(String key,Object value){
		map.put(key, value);
	}
	public Object getObject(String key){
		return map.get(key);
	}

	public String  getUserName(){
		return user.getName();
	}
	public String getUserId(){
		return user.getId();
	}

	public User getUser(){
		return this.user;
	}

	/*public void setWatchUser(WatchUser wu){
		this.w_user=wu;
	}*?

	/*public WatchUser getWatchUser(){
		return getWatchUser("");
	}
	/*public WatchUser getWatchUser(String game_id){
		if(w_user!=null){
			return this.w_user;
		}
		else{
			this.w_user=new WatchUser();
			return this.w_user;
		}
	}*/
	public WatchUser getWatchUser(){
		return this.w_user;
	}

}
