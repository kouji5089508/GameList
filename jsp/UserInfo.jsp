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
	User user=null;
	if(o_session!=null){
		user=o_session.getUser();
	}

%>
<%if(o_session!=null){
	String json=master.encode(user);
	out.print(json);
	System.out.print(json);
   }
%>


