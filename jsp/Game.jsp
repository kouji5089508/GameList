<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*" %>

<%@ include file="../WEB-INF/all_jsp.inc" %>

<%
	if(game_id!=null){
		master.deletePlayUser(Integer.parseInt(game_id),id);//他のゲームにユーザーいたら削除
		game.putUserData(id);//playuser登録
	}
	else if(game_id==null){
		game_id=master.getWelcomeGameId(id)+"";
		game=master.getGame(Integer.parseInt(game_id));
	}
	String mode=game.getPlayUser(id).getMode();

%>

<html ng-app="myApp">
<head>

<title>大喜利</title>
	<link rel="stylesheet" type="text/css" href="../css/jquery-letterfx.min.css">
	<script src="../js/jquery-2.2.2.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.4/angular.js"></script>
	<%@ include file="../WEB-INF/all.inc" %>
	<script src="../js/master.js"></script>
	<script src="../js/game.js"></script>
	<script src="../js/jquery-letterfx.min.js"></script>
	<script src="../js/user.js"></script>
	<script src="../js/request.js"></script>
	<%@ include file="../js/main.inc" %>

</head>

<body style="background-color:#ffffff" ng-app="myApp" >
	<ul class="nav nav-tabs">
	    <li ><a href="Home.spc">Home</a></li>
	    <!--  <li class="active" ><a href="Welcome.spc">Play</a></li>-->
	    <li  class="active" ><a href="GameList.spc">GameList</a></li>
	    <li><a href="Profile.spc">Profile</a></li>
	    <li><a href="Help.jsp">Help</a></li>
	     <!-- <li ><a href="#">Help</a></li>-->
	</ul>
<%@ include file="../WEB-INF/display.inc" %>
