<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*" %>


<%
	Master master=(Master)request.getAttribute("master");
	request.setCharacterEncoding("utf-8");
	Session o_session=(Session)session.getAttribute("session");
	String user_name="";
	String id;
	id=o_session.getUserId();
	user_name=o_session.getUserName();
	String game_id=request.getParameter("game_id");
	String mode=request.getParameter("mode");
	if(game_id==null){
		game_id=master.getGameId(Integer.parseInt(id))+"";
	}
	Game game=master.getGame(Integer.parseInt(game_id));
	PlayUser pu=game.getPlayUser(Integer.parseInt(id));
	pu.setMode(mode);
%>




