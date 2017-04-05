<%@ page pageEncoding="UTF-8" %>
<%
	Master master=(Master)request.getAttribute("master");

    String interval=master.getConfAttr("count_interval");
	request.setCharacterEncoding("utf-8");
	Session o_session=(Session)session.getAttribute("session");
	String user_name="";
	if(o_session==null){
		Context context=new InitialContext();
		 Class.forName("com.mysql.jdbc.Driver");
		 Connection db =  DriverManager.getConnection(Conf.getConfAttr(Conf.DB_URL),Conf.getConfAttr(Conf.DB_USER_NAME),Conf.getConfAttr(Conf.DB_PASSWORD));
		DBUtil.setDB(db);
	}
	int id=0;
	String tmp_id=(String)request.getAttribute("cookie_id");
	if(tmp_id!=null){
		id=Integer.parseInt(tmp_id);
	}
	//以下クッキー確認
	Cookie cook=null;
	Cookie[] cookies = request.getCookies();

	if(cookies!=null && id==0){
		for(int i=0;i < cookies.length; i++){
			if(cookies[i].getName().equals("oogiri") == true){
				 id=Integer.parseInt(cookies[i].getValue());
				 break;
			}
		}
	}

	if(id==0){//クッキーが無い場合
		int max_id=0;
		max_id=Integer.parseInt(DBUtil.getOneColumn("select  max(right(concat('0000',id),5)) from user"));
		max_id++;
		//以下クッキー確認
		cook = new Cookie("oogiri",max_id+"");
		cook.setMaxAge(60*60*24*30);
		response.addCookie(cook);//クッキー登録
		User.registDefaultUser(max_id);//デフォルト登録
		o_session=new Session();
		session.setAttribute("session", o_session);
		request.setAttribute("cookie_id",max_id+"");
		String url=request.getRequestURI();
		url=url.replace(".jsp",".spc");
		url=url.replace("/Oogiri2","");

		%>
			<jsp:forward page="<%=url%>" />
		<%
	}

	User user=null;

	if(o_session==null){
		o_session=new Session(new User(id+""));
		session.setAttribute("session", o_session);
	}
	else if(o_session.getUser()==null){
		o_session.setUser(new User(id+""));
	}

	String game_id=(String)request.getAttribute("game_id");
	Game game=null;
	if(game_id!=null){
		game=master.getGame(Integer.parseInt(game_id));
	}
	/*String mode=(String)request.getAttribute("mode");
	if(game_id==null){//基本的にはplayの場合を想定
	    if(mode!=null && mode.equals("play")){
			game_id=master.getWelcomeGameId(id)+"";
			game=master.getGame(Integer.parseInt(game_id));
		}
	}
	else{
		 if(mode!=null && mode.equals("play")){//watchからplayへの場合を想定
		 	PlayUser pu=master.getPlayUser(id);
		 	pu.logOut();//まずは既存のユーザーをログアウト
		 	game=master.getGame(Integer.parseInt(game_id));
		 	game.putUserData(id);//ユーザー登録
		 }
		 else if(mode!=null && mode.equals("watch")){
		 	game=master.getGame(Integer.parseInt(game_id));
		 }
	}*/
	user=o_session.getUser();

%>