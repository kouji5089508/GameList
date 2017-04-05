<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*,shooting.*" %>


<%
	Master master=(Master)request.getAttribute("master");
	request.setCharacterEncoding("utf-8");
	Session o_session=(Session)session.getAttribute("session");
	String user_name="";
	String id;
	id=o_session.getUserId();
	user_name=o_session.getUserName();
	String action=request.getParameter("action");
	String value=request.getParameter("value");
	Shooting sh=(Shooting)o_session.getObject("shooting");
	String display="";
	if(action.equals("addScore")){
		sh.addScore(Integer.parseInt(value));
	}else if(action.equals("save")){
		sh.save();
		//sh.reflesh();
	}else if(action.equals("saveName")){
		sh.changeName(value);
	}else if(action.equals("getNowRank")){
		display=sh.getNowRank()+"";
	}else if(action.equals("reflesh")){
		sh.reflesh();
	}

%>
<%= display%>




