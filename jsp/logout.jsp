<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*" %>

<%
	Master master=(Master)request.getAttribute("master");
	request.setCharacterEncoding("utf-8");
	Session o_session=(Session)session.getAttribute("session");
	if(o_session!=null){
		String user_id=o_session.getUserId();
		Integer game_id=master.getGameId(Integer.parseInt(user_id));
		master.getGame(game_id).getPlayUser(Integer.parseInt(user_id)).logOut();//logout;
	}
	session.invalidate();//セッション破棄

%>

<html>
<head>

<title>ログアウト</title>
<script src="../js/jquery-2.2.2.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$("#back_button").click(function(){
			window.location.href="/Oogiri2/jsp/Game.spc";//戻る
		});
	});
</script>
<%@ include file="../WEB-INF/all.inc" %>

</head>
<body  style="background-color:#ffffff" >
	<div align=center  style="margin:100px">
		<font color=black size=13>ログアウトしました</font>
	</div>
	<div align=center  style="margin:200px">
		<button id="back_button"  type="button" style="width:100px;"   class="btn btn-default">戻る</button>
	</div>
</body>

