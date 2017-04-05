<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*,shooting.*" %>

<%@ include file="../WEB-INF/all_jsp.inc" %>
<%
	Shooting sh=(Shooting)o_session.getObject("shooting");
	if(sh==null){
		sh=new Shooting(user);
		o_session.setObject("shooting",sh);
	}
	ArrayList<String[]> ranking=sh.getRanking();
%>

<html>
<head>

<title>スコア</title>
<script src="../js/jquery-2.2.2.min.js"></script>
<%@ include file="../WEB-INF/all.inc" %>

</head>
<body style="background-color:#ffffff;">


	<div align=center  style="margin:40px 0 0  0px">
		<font color=black size=13>スコアランキング</font>
		<br>
		<br>
		<font  style="margin:20px 0 0  0px" color=black size=6></font>

	</div>

	<div id="main" class="row" style="margin:30px 0px">
		<div class="col col-md-4" >
		</div>
		<div  class="col col-md-4" align=center >
			<table  class="table table-bordered" style="font-size:15px;text-align:center;">
				<thead>
					<tr >
						<th style="text-align:center;">
							順位
						</th>
						<th style="text-align:center;">
							ユーザー名
						</th >
						<th style="text-align:center;">
							スコア
						</th>
					</tr>
				</thead>
				<tbody>
					<% for(int i=0;i<ranking.size();i++){%>
						<tr>
							<%
								String[] list=ranking.get(i);
								String name=list[0];
								String score=list[1];
								out.print("<td>"+(i+1)+"</td>");
								out.print("<td>"+name+"</td>");
								out.print("<td>"+score+"</td>");
							%>
						</tr>
					<%} %>
				</tbody>
			</table>
		</div>
		<div class="col col-md-4" >
		</div>
	</div>
</body>

