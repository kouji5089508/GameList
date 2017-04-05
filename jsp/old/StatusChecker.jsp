<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*" %>




<%
    Master master=(Master)request.getAttribute("master");
	request.setCharacterEncoding("utf-8");
	Session o_session=(Session)session.getAttribute("session");
	String user_name="";
	String id;
	String out_data=null;
	if(o_session!=null){
		id=o_session.getUserId();
		user_name=o_session.getUserName();

		String game_id=master.getGameId(Integer.parseInt(id))+"";
		HashMap <Integer,PlayUser> users_data=master.getUsersData(Integer.parseInt(game_id));
		Game game=master.getGame(Integer.parseInt(game_id));
		String countdown_flg=request.getParameter("countdown_flg");
		//if(countdown_flg!=null){
		//	if(countdown_flg.equals("true")){
		game.countDown();
		//	}
		//}
		 out_data="count:"+master.getGame(Integer.parseInt(game_id)).getCount()+"";
		out_data+="/status:"+game.getStatus().getStatus();
		for(Map.Entry<Integer, PlayUser>  entry : users_data.entrySet()){
			PlayUser pu=users_data.get(entry.getKey());
			if(pu.isNotValid()){
			}
			else{
				out_data+="/"+entry.getKey()+":"+users_data.get(entry.getKey()).getStatus()+":"+users_data.get(entry.getKey()).getAnswer()+":"+users_data.get(entry.getKey()).getName();
			}
		}
		if(game.getStatus()==Status.vote_result){
			HashMap <Integer,Integer> winner_map=game.getVoteMap();
			for(Map.Entry<Integer, Integer>  entry : winner_map.entrySet()){
				Integer count=winner_map.get(entry.getKey());
				out_data+="/vote_result:"+entry.getKey()+":"+count;
			}
		}
	}

%>
<%if(o_session!=null){
	out.print(out_data.replaceAll("\r\n", "").replaceAll("/r/n", ""));
   }
%>


