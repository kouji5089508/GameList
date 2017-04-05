<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*" %>

<%@ include file="../WEB-INF/all_jsp.inc" %>

<%
		 HashMap <Integer,Game> game_map=master.getGameMap();
%>

<html ng-app="myApp">
<head>

<title>大喜利</title>
	<script src="../js/jquery-2.2.2.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.4/angular.js"></script>
	<%@ include file="../WEB-INF/all.inc" %>
	<script src="../js/master.js"></script>
	<script src="../js/game.js"></script>
	<script src="../js/user.js"></script>
	<script src="../js/request.js"></script>


</head>

<body style="background-color:#ffffff" ng-app="myApp" >
	<ul class="nav nav-tabs">
	    <li ><a href="Home.spc">Home</a></li>
	    <!-- <li ><a href="Game.spc">Play</a></li>-->
	    <li class="active"><a href="WatchList.spc">GameList</a></li>
	    <li><a href="Profile.spc">Profile</a></li>
	    <li><a href="Help.jsp">Help</a></li>
	    <!-- <li ><a href="#">Help</a></li>-->
	</ul>
	<div class="row" style="margin:100px 0 0 0">
		<div  class="col col-md-3" style="text-align:center;">
		</div>
		<div  class="col col-md-6" style="text-align:center;">
			<font size="40px">GameList</font>
			<div class="list-group" style="margin:20px 0 0 0">
				<% for(Map.Entry<Integer, Game>  entry : game_map.entrySet()){
					Game t_game=game_map.get(entry.getKey());
				%>

			    <a href="Game.spc?game_id=<%=t_game.getId() %>" class="list-group-item"><span class="badge"><%=t_game.getNumber() %>人</span>game #<%=t_game.getId() %></a>

			    <%} %>
			</div>
		</div>
		<div  class="col col-md-3" style="text-align:center;">
		</div>
	</div>
