<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*" %>


<jsp:useBean id="master" class="ap.Master" scope="application" />

<%
	request.setCharacterEncoding("utf-8");
	Session o_session=(Session)session.getAttribute("session");
	String user_name="";
	String id;
	id=o_session.getUserId();
	user_name=o_session.getUserName();

	String game_id=master.getGameId(Integer.parseInt(id))+"";
	HashMap <Integer,PlayUser> users_data=master.getUsersData(Integer.parseInt(game_id));
%>

<html>
<head>

<title></title>
	<script src="../js/jquery-2.2.2.min.js"></script>
	<script type="text/javascript">
		setInterval("countDown()",1000);
		function countDown(){
			var count=$("#timecount").text();
			if(count==0){

			}
			else{
				count--;
				$("#timecount").text(count);
			}
		}
	</script>

</head>
<body>
	<div align=center>
		<font color=black size=13>A</font>
		<%=
			o_session.getUserName()
		%>
		<%master.testPrint();
			for(Map.Entry<Integer, PlayUser>  entry : users_data.entrySet()){
				out.print(entry.getKey()+users_data.get(entry.getKey()).getName());
			}
		%>
		さん!
	</div>
	<div align=center id="time_count_div">
		<font color=black size=13 id="timecount" >15</font>
	</div>
	<div id="info">
		<table>
			<%
				for(Map.Entry<Integer, PlayUser>  entry : users_data.entrySet()){
					out.println("<tr>");
					out.print("<td>"+users_data.get(entry.getKey()).getName()+"</td>");
					out.print("<td id=\"status\">考え中・・</td>");
					out.println("<td>");
				}
			%>
		</table>
	</div>
	<div id="main">
		<form action="" method="post">
			<textarea name=oogiri_area rows="3" cols="20">
			ここに内容を入力してください
			</textarea>
			<br>
			<input type="submit" value="送信">
		</form>

	</div>
</body>

