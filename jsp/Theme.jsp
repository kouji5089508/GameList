<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*" %>


<%
	Master master=(Master)request.getAttribute("master");
	request.setCharacterEncoding("utf-8");
	String test="";
	Session o_session=(Session)session.getAttribute("session");
	String user_name="";
	String id;
	id=o_session.getUserId();
	user_name=o_session.getUserName();
	String game_id=master.getGameId(Integer.parseInt(id))+"";
	HashMap <Integer,PlayUser> users_data=master.getUsersData(Integer.parseInt(game_id));
	Game game=master.getGame(Integer.parseInt(game_id));
	PlayUser p_user=game.getPlayUser(Integer.parseInt(id));
	p_user.vote(Integer.parseInt(vote_user_id));
%>




