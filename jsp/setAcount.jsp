<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*" %>

<%
	request.setCharacterEncoding("utf-8");
	String new_name=null;
	String new_age=null;
	String new_sex=null;
	new_name=(String)request.getParameter("new_name");
	new_age=(String)request.getParameter("new_age");
	new_sex=(String)request.getParameter("new_sex");
	//以下クッキー確認
	Cookie cook=null;
	Cookie[] cookies = request.getCookies();
	int id=0;
	String tmp_id=request.getParameter("cookie");
	if(tmp_id!=null){
		id=Integer.parseInt(tmp_id);
	}
	if(cookies!=null && id==0){
		for(int i=0;i < cookies.length; i++){
			if(cookies[i].getName().equals("oogiri") == true){
				 id=Integer.parseInt(cookies[i].getValue());
				 break;
			}
		}
	}
	if(id==0){
		int max_id=0;
		max_id=Integer.parseInt(DBUtil.getOneColumn("select  max(right(concat('0000',id),5)) from user"));
		max_id++;
		//以下クッキー確認
		cook = new Cookie("oogiri",max_id+"");
		cook.setMaxAge(60*60*24*30);
		response.addCookie(cook);
	}
	if(new_name!=null){
		int max_id=0;
		max_id=Integer.parseInt(DBUtil.getOneColumn("select  max(right(concat('0000',id),5)) from user"));
		max_id++;
		String insert_new_user="insert into user (id,name,startdate,age,sex) values("+"'"+max_id+"'"+","+"'"+new_name+"'"+","+"now(),'"+new_age+"','"+new_sex+"' );";
		DBUtil.executeQuery(insert_new_user);
		request.setAttribute("cookie",max_id );
		%>
			<jsp:forward page="Game.spc" />
		<%
	}


%>

<html>
<head>

<title>WELCOME!</title>
<script src="../js/jquery-2.2.2.min.js"></script>
<%@ include file="../WEB-INF/all.inc" %>

</head>
<body style="background-color:#ffffff">
	<div align=center  style="margin:40px 0 0  0px">
		<font color=black size=13>はじめまして！</font>
		<br>
		<br>
		<font  style="margin:20px 0 0  0px" color=black size=6>必要な情報を記述して登録して下さい</font>

	</div>

	<div id="main" class="row" style="margin:200px 0px">
		<div class="col col-md-3" >
		</div>
		<div  class="col col-md-6" align=center >
			<form action="/Oogiri2/jsp/setAcount.spc" method="post">
				<table border="0">
				  <tr>
				    <td align="right"><font size=5px>名前：</font></td>
				    <td><input type="text" name="new_name" size="30" maxlength="20" class="form-control"  ></td>
				  </tr>
				   <tr height=20px>
				  </tr>
				  <tr>
				    <td align="right"><font size=5px>名前：</font></td>
				    <td>
				    	<label class="radio-inline"><input type="radio" value="1" checked name="new_sex" >男性</label>
						<label class="radio-inline"><input type="radio" value="2"  name="new_sex" >女性</label>
				    </td>
				  </tr>
				   <tr height=20px>
				  </tr>
				  <tr>
				    <td align="right"><font size=5px>年齢：</font></td>
				    <td><input type="text" name="new_age" size="30" maxlength="20" class="form-control"  value="秘密"></td>
				  </tr>
				  <tr height=60px>
				  </tr>
				  <tr align=center >
				  	<td colspan=2>
				  		　　　<input type=submit value="登録"  class="button btn btn-default form-control " >
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

