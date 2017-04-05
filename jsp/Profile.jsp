<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*" %>

<%@ include file="../WEB-INF/all_jsp.inc" %>
<%
	String new_name=null;
	String new_age=null;
	String new_sex=null;
	String margin="15";
	new_name=(String)request.getParameter("new_name");
	new_age=(String)request.getParameter("new_age");
	new_sex=(String)request.getParameter("new_sex");

	if(new_name!=null){
		user.update(new_name,new_sex,new_age);
	}


%>

<html>
<head>

<title>Profile</title>
<script src="../js/jquery-2.2.2.min.js"></script>
<%@ include file="../WEB-INF/all.inc" %>

</head>
<body style="background-color:#ffffff">
    <ul class="nav nav-tabs">
	    <!--  <li ><a href="Game.spc">Play</a></li>-->
	    <li ><a href="Home.spc">Home</a></li>
	    <li ><a href="GameList.spc">GameList</a></li>
	    <li  class="active" ><a href="Profile.spc">Profile</a></li>
	    <li><a href="Help.jsp">Help</a></li>
	    <!-- <li><a href="Help.spc">Help</a></li>-->
	</ul>
	<div align=center  style="margin:40px 0 0  0px">
		<font color=black size=13>Profile</font>
		<br>
		<br>
		<font  style="margin:20px 0 0  0px" color=black size=6></font>

	</div>

	<div id="main" class="row" style="margin:30px 0px">
		<div class="col col-md-3" >
		</div>
		<div  class="col col-md-6" align=center >
			<form action="/Oogiri2/jsp/Profile.spc" method="post">
				<table border="0">
				  <tr>
				    <td align="right"><font size=5px>名前：</font></td>
				    <td><input type="text" name="new_name" size="30" maxlength="20" class="form-control" value="<%= user.getName() %>" ></td>
				  </tr>
				   <tr height=<%=15 %>px>
				  </tr>
				  <tr>
				    <td align="right"><font size=5px>性別：</font></td>
				    <td>
				    	<label class="radio-inline"><input type="radio" value="1" <%= getSex(user,"1")%> name="new_sex" >男性</label>
						<label class="radio-inline"><input type="radio" value="2"  <%= getSex(user,"2")%>   name="new_sex" >女性</label>
						<label class="radio-inline"><input type="radio" value="0"  <%= getSex(user,"0")%>  name="new_sex" >未登録</label>
				    </td>
				  </tr>
				   <tr height=<%=15 %>px>
				  </tr>
				  <tr>
				    <td align="right"><font size=5px>年齢：</font></td>
				    <td><input type="text" name="new_age" size="30" maxlength="20" class="form-control"  value="<%= user.getAge() %>"></td>
				  </tr>
				  <tr height=<%=15 %>px>
				  </tr>
				   <tr>
				    <td align="right"><font size=5px>登録日：</font></td>
				    <td><input type="text" name="new_rating" size="30" maxlength="20" class="form-control" readonly="readonly" value="<%= user.getStartDate() %>" ></td>
				  </tr>
				   <tr height=<%=15 %>px>
				  </tr>
				   <tr>
				    <td align="right"><font size=5px>プレイ回数：</font></td>
				    <td><input type="text" name="new_rating" size="30" maxlength="20" class="form-control" readonly="readonly" value="<%= user.getCount() %>" ></td>
				  </tr>
				   <tr height=<%=15 %>px>
				  </tr>
				  <tr>
				    <td align="right"><font size=5px>レーティング：</font></td>
				    <td><input type="text" name="new_rating" size="30" maxlength="20" class="form-control" readonly="readonly" value="<%= user.getRaiting() %>" ></td>
				  </tr>
				   <tr height=<%=15 %>px>
				  </tr>
				  <tr align=center >
				  	<td colspan=2>
				  		　　　<input type=submit value="プロフィール変更"  class="button btn btn-default form-control " >
				  	</td>
				  </tr>

				</table>
				<input type="hidden" name="cookie" value="<%= id %>" >
			</form>
		</div>
		<div class="col col-md-3" >
		</div>
	</div>
</body>

<%!
String getSex(User u,String value){
	String sex=u.getIntSex()+"";
	if(sex.equals(value)){
		return "checked";
	}
	else{
		return null;
	}
}
%>

