<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*,etc.*" %>

<%@ include file="../WEB-INF/all_jsp.inc" %>

<%
	Theme theme=Game.getStaticTheme();
	String static_theme_id=theme.getId();
	String static_theme_text=theme.getText();
	String static_theme_type=theme.getType();
	String image_display="";
	String image_source="";
	boolean answer_flg=false;
	boolean vote_flg=false;
	String answer_display="";
	String comment_display="";
	String vote_display="none";

	if( static_theme_type!=null && (static_theme_type.equals("image") || static_theme_type.equals("double"))){
		image_source="/Oogiri2/servlet/GetImageServlet?id="+static_theme_id;
	}
	else{
		image_display="none";
	}

	String sql="select count(*) count from static_game_log where player =  \'"+user.getId()+"\' and theme = \'"+static_theme_id+"\'";
	Object[] data=DBUtil.getOneLineData(sql);
	java.sql.ResultSet rs=(java.sql.ResultSet)data[0];
	try {
		if(rs!=null){
			if(rs.next()){
				String count=rs.getString("count");
				if(!count.equals("0")){
					answer_flg=true;
					answer_display="none";
				}

			}
		}
	} catch (SQLException e) {
		e.printStackTrace();
		 Log.systemLog(e);
	}
	ArrayList<HashMap<String,String>> comment_array  =  new ArrayList<HashMap<String,String>>();
	//if(answer_flg){
		comment_display="";
		if(user.getVoteFlg()!=null){
			vote_flg=true;
		}
		else{
			vote_display="";
		}
		String comment_sql="select * from static_game_log sg join user u on sg.player=u.id where sg.theme=\'"+static_theme_id+"\'";
		Object[] comment_data=DBUtil.getOneLineData(comment_sql);
		java.sql.ResultSet comment_rs=(java.sql.ResultSet)comment_data[0];

		try {
			if(comment_rs!=null){
				while(comment_rs.next()){
					String name=comment_rs.getString("name");
					String u_id=comment_rs.getString("id");
					int vote_num=comment_rs.getInt("vote_num");
					String comment=comment_rs.getString("comment");
					HashMap<String,String> comment_map = new HashMap<String,String>();
					comment_map.put("name",name);
					comment_map.put("id",u_id);
					comment_map.put("vote_num",vote_num+"");
					comment_map.put("comment",comment);
					comment_array.add(comment_map);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			 Log.systemLog(e);
		}
	//}

%>

<html>
<head>

<title>Home</title>
<script src="../js/jquery-2.2.2.min.js"></script>
<script type="text/javascript">
	var Home={};
	Home.answer=function(){
		var a_text=$("#answer_area").val();
		$.ajax({
			url: "StaticGame.spc",
			data: {answer:a_text,theme:"<%=static_theme_id%>"},
			async: false,
			success: function(xml){
				$("#answer_div").hide();
				location.reload();
			},
			error: function(msg) {
			}
		});
	}
	Home.vote=function(v_id){
		$.ajax({
			url: "StaticGame.spc",
			data: {vote_user_id:v_id,theme:"<%=static_theme_id%>"},
			async: false,
			success: function(xml){
				$(".vote_button").hide();
				location.reload();
			},
			error: function(msg) {
			}
		});
	}
</script>
<%@ include file="../WEB-INF/all.inc" %>
<style type="text/css">
p{
	font-size:25px;
}
</style>
</head>
<body style="background-color:#ffffff">
	<ul class="nav nav-tabs">
		<li ><a href="#">Home</a></li>
	    <!-- <li ><a href="Game.spc">Play</a></li>-->
	    <li ><a href="GameList.spc">GameList</a></li>
	    <li><a href="Profile.spc">Profile</a></li>
	    <li><a href="Help.jsp">Help</a></li>
	    <!-- <li class="active"><a href="#">Help</a></li>-->
	</ul>
	<div align=center  style="margin:40px 0 0  0px"  class="page-header">
		<font color=black size=10 id="title">Home</font>
		<br>
		<br>
		<!-- <font  style="margin:20px 0 0  0px" color=black size=4>目次</font>-->

	</div>

	<div id="main" class="row" style="margin:50px 0px;">
		<div class="col col-md-2" >
		</div>
		<div  class="col col-md-8" align=center >
			<div>
				<div>
					<h1>大喜利サイトです。</h1>
					<p>お題が出てくるのでそれに回答し、いいと思った回答に投票します。<br>ニコニコ動画のようにコメントも出来ます。</p>
				</div>
			</div>

			<div  style="margin:80px 0px" class="panel panel-danger">
				<div class="panel-heading">
					<font size=15px>今月のお題</font>
				</div>
				<div style="margin:20px 0px" class="panel-body" >
					<table class="table">
						<tr>
							<td id="text_td" style="text-align:center;">
								<%=static_theme_text %>
							</td>
						</tr>
						<tr style="display:{{image_display}};width:100%;text-align:center;padding:25px 0 0 0;" >
							<td id="image_td"  style="width:50%;">
								<img  src="<%=image_source%>"  style="display:<%=image_display%>;width:50%;height:auto;" >
							</td>
						</tr>
					</table>
				</div>
				<div class="panel-footer">
					<div style="text-align:center;">
						<table class="table">
							<thead style="text-align:center;">
								<th style="text-align:center;">
									ユーザー
								</th>
								<th style="text-align:center;">
									回答
								</th>
								<th style="text-align:center;">
									獲得投票数
								</th>
								<th>
								</th>
							</thead>
							<tbody>
								<% for (int i=0;i<comment_array.size();i++){
									HashMap<String,String> comment_map=comment_array.get(i);
									String temp_vote_diplay=vote_display;
									if(comment_map.get("id").equals(id+"")){
										temp_vote_diplay="none";//自分の回答には投票できないようにする
									}
								%>
									<tr style="text-align:center;">
										<td style="width:25%;">
											<%= comment_map.get("name")%>
										</td>
										<td style="width:40%;">
											<%= comment_map.get("comment")%>
										</td>
										<td style="width:15%;">
											<%= comment_map.get("vote_num")%>
										</td>
										<td style="width:20%;">
											<button type="button" class="vote_button button btn btn-default"   style="display:<%= temp_vote_diplay%>;"  onClick="Home.vote('<%= comment_map.get("id")%>')" >投票</button>
										</td>
									</tr>
								<%} %>
							</tbody>
						</table>
					</div>
					<div id=answer_div  style="display:<%= answer_display%>;">
						<input value="<%= user.getName()%>さんも回答してみましょう！" type="text"  rows="3" cols="20" id="answer_area" class="form-control" style="text-align:center;" >
						<br>
						<button type="button" class="button btn btn-default" id="answer_button"  onClick="Home.answer()" >回答送信</button>
					</div>
				</div>
			</div>
		</div>
		<div class="col col-md-2" >
		</div>
	</div>
</body>

