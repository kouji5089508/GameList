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
	String answer=request.getParameter("answer");
	String vote=request.getParameter("vote_user_id");
	String theme=request.getParameter("theme");
	if(answer!=null){
		String sql="insert into static_game_log (theme,player,date,vote_num,comment) values("+theme+","+id+",now(),0,\'"+answer+"\')";
		DBUtil.executeQuery(sql);
	}else if(vote!=null){
		String vote_num=DBUtil.getOneColumn("select vote_num from static_game_log where theme = \'"+theme+"\' and player = \'"+vote+"\'");
		int vote_number=(Integer.parseInt(vote_num));
		vote_number++;
		String sql="update static_game_log set vote_num = "+vote_number+"  where theme = \'"+theme+"\' and player = \'"+vote+"\'";
		DBUtil.executeQuery(sql);
		DBUtil.executeQuery("update user set vote_flg = 1 where id = "+id);
		o_session.getUser().setVoteFlg(1+"");
	}
%>




