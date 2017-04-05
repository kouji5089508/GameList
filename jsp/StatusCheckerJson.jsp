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
	String mode=request.getParameter("mode");//モ―ド
	if(o_session!=null){
		id=o_session.getUserId();
		user_name=o_session.getUserName();

		Game game=null;
		Integer game_id=master.getGameId(Integer.parseInt(id));
		if(game_id!=null){//
			HashMap <Integer,PlayUser> users_data=master.getUsersData(game_id);
			game=master.getGame(game_id);
			if(!game.getCountFlg()){
				game.countDown();
			}
			PlayUser pu=users_data.get(Integer.parseInt(id));
			pu.setAlived();
			//PlayUser pu=users_data.get(Integer.parseInt(id));
			/*if(!pu.isAlived()){
				pu.logOut();//死んでたらログアウト
			}*/
		}
		if(game!=null){//playuserがログアウトしている場合
			out.print(master.encode(game));
		}
	}

%>



