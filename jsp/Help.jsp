<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*,etc.*" %>


<html>
<head>

<title>Help</title>
<script src="../js/jquery-2.2.2.min.js"></script>

<%@ include file="../WEB-INF/all.inc" %>
<style type="text/css">
p{
	font-size:25px;
}
</style>
</head>
<body style="background-color:#ffffff">
	<ul class="nav nav-tabs">
		<li ><a href="Home.spc">Home</a></li>
	    <!-- <li ><a href="Game.spc">Play</a></li>-->
	    <li ><a href="GameList.spc">GameList</a></li>
	    <li><a href="Profile.spc">Profile</a></li>
	    <li><a href="Help.jsp">Help</a></li>
	    <!-- <li class="active"><a href="#">Help</a></li>-->
	</ul>
	<div align=center  style="margin:40px 0 0  0px"  class="page-header">
		<font color=black size=10 id="title">Help</font>
		<br>
		<br>
		<!-- <font  style="margin:20px 0 0  0px" color=black size=4>目次</font>-->

	</div>

	<div id="main" class="row" style="margin:50px 0px;">
		<div class="col col-md-1" >
		</div>
		<div  class="col col-md-10" align=center >
		    <div  style="margin:80px 0px">
				<h1>メニュー</h1>
				<table class="table table-bordered" style="text-align:center;">
					<!-- <thead>
						<tr >
							<th colspan=2 align=center style="text-align:center;">
								二つのモード
							</th>
						</tr>
					</thead>
					-->
					<tbody>
						<tr style="color:#2196f3;" >
							<td>Home</td>
							<td >GameList</td>
							<td >Profile</td>
							<td >Help</td>
						</tr>
						<tr  >
							<td >ホームです。月ごとの大喜利があります。</td>
							<td >現在のゲームのリストが表示されます。ここから好きなゲームに移動して下さい。</td>
							<td >自分のプロフィールを編集できます。</td>
							<td >ページの詳細な説明がされています</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div>
				<div  style="margin:0px 0px;">
					<h2>下記の流れでプレイします</h2>
					<table class="table table-bordered" style="text-align:center;">
						<!-- <thead>
							<tr >
								<th colspan=3 align=center style="text-align:center;">
									プレイの流れ
								</th>
							</tr>
						</thead>
						-->
						<tbody style="font-size:20px;">
							<tr  >
								<td width="40%" >新しいお題が表示されるので回答<br><br>
									<img class="panel panel-default" style="width:100%;" src="../img/kaitou.jpg">
								</td>
								<td  width="20%" style="vertical-align: middle;">→</td>
								<td  width="40%">気に入った回答に投票<br><br>
									<img class="panel panel-default" style="width:100%;" src="../img/vote.jpg">
								</td>
							</tr>
							<tr  >
								<td style="vertical-align: middle;">↑</td>
								<td ></td>
								<td style="vertical-align: middle;">↓</td>
							</tr>
							<tr  >
								<td >次のゲームに参加するか決定<br><br>
									<img class="panel panel-default" style="width:100%;" src="../img/choice.jpg"></td>
								<td style="vertical-align: middle;">←</td>
								<td >結果発表<br><br>
									<img class="panel panel-default" style="width:100%;" src="../img/result.jpg">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div   style="margin:80px 0px">
				<h1>画面イメージ</h1>
				<div style="width:100%;" >
					<img class="panel panel-default" style="width:80%;" src="../img/setumei.jpg">
				</div>
			</div>
			<div  style="margin:80px 0px">
				<h1>ゲームには二つのモードがあります。</h1>
				<table class="table table-bordered" style="text-align:center;">
					<!-- <thead>
						<tr >
							<th colspan=2 align=center style="text-align:center;">
								二つのモード
							</th>
						</tr>
					</thead>
					-->
					<tbody>
						<tr  >
							<td class="success">Play</td>
							<td class="warning">Watch</td>
						</tr>
						<tr  >
							<td >プレイする為のモードです。お題に回答できます。但し、コメントを見る事が出来ません。</td>
							<td >観戦する為のモードです。お題に回答できません。コメントを見る事が出来ます。</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="col col-md-1" >
		</div>
	</div>
</body>

