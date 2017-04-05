<%@ page pageEncoding="UTF-8" %>

	<div class="container" ng-controller="myController" style="width:100%;">
		<div class="shim" style="display:{{shim_display}};position:absolute;z-index:10;background-color:white;width:100%;height:100%;"></div>
		<div class='shim'  style='display:{{shim_display}};z-index:100;position:absolute;text-align:center;top:42%;left:45%;margin:auto;'><img id='loading' style='margin-bottom:7px;' src='../gif/loading.gif'><!-- <br><font size='+1'>&nbsp;&nbsp;&nbsp;Now Loading...</font>--></div>
		<div class="row" style="display:{{row_display}};height:30%;margin:10px 0px 0px 0px;" >
			<div class="col col-md-3"  id="user_info"  >
				<div align=center style="height:30%;padding:30px 0px 0px 0px;" >
					<table class="table table-bordered" id="user_info_table">
						<tbody>
							<tr ng-repeat="u_info in user_info">
							<td>{{u_info[0]}}</td>
							<td>{{u_info[1]}}</td>
							</tr>
						</tbody>
					</table>


				</div>
			</div>
			<div class="col col-md-6" align=center >
				<div  id="time_count_div" style="font-size:{{count.size}}px;">
					<font color={{count.color}}  id="timecount" >{{count.number}}</font>
				</div>
				<div>
					<font    id="status_descript" >{{status_discript}}</font>
				</div>
			</div>
			<div  class="col col-md-3"  >
			</div>
		</div>
		<div class="row" style="display:{{row_display}};height:30%">
			<div  class="col col-md-3">

			</div>
			<div class="col col-md-6 theme">
				<table class="table">
					<thead>
						<tr>
							<th id="theme_title" style="text-align:center">
								お題
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td id="text_td" style="text-align:center;">
								{{image_text}}
							</td>
						</tr>
						<tr style="display:{{image_display}};width:100%;text-align:center;padding:25px 0 0 0;" >
							<td id="image_td"  style="width:50%;">
								<img  ng-src="{{image_source}}"  style="display:{{image_display}};width:50%;height:auto;" >
							</td>
						</tr>
					</tbody>
				</table>

			</div>
			<div  class="col col-md-3">

			</div>
		</div>
		<div class="row" style="display:{{row_display}};height:30%">
			<div  class="col col-md-2">

			</div>
			<div id="info" class="col col-md-8">
				<table class="table table-bordered" id="users_table">
					<thead>
						<tr>
							<th>
								名前
							</th>
							<!-- <th>
								年齢
							</th>
							<th>
								性別
							</th>
							<th>
								レーティング
							</th>
							<th>
								プレイ回数
							</th>-->
							<th>
								ステータス
							</th>
							<th  class="answer_td">
								答え
							</th>
							<th   style="display:{{vote_button_display}}">

							</th>
						</tr>
					</thead>
					<tbody>
						<tr ng-repeat="u_info in users_info_list" ng-show="u_info.mode=='play'">
							<td>{{u_info.name}}</td>
							<!-- <td>{{u_info.user.age}}</td>
							<td>{{u_info.user.sex}}</td>
							<td>{{u_info.user.raiting}}</td>
							<td>{{u_info.user.playCount}}</td>-->
							<td>{{u_info.string_status}}</td>
							<td class="answer_td"  ><font ng-show="u_info.id==user_id || play_area_display=='none' ">{{u_info.answer}}</font></td>
							<td    style="display:{{vote_button_display}}" ><button type="button"   class="vote_button btn btn-default" ng-click="vote($event)"  vote_id="{{u_info.id}}"  ng-show="!u_info.notValid && u_info.id!=user_id" >投票</button></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div  class="col col-md-2">

			</div>
		</div>
		<div class="row" style="display:{{row_display}};height:30%">
			<div  class="col col-md-2">
			</div>
			<div  class="col col-md-8" style="text-align:center;">
				<div id="play_area" style="display:{{play_area_display}};" >
					<div class="row">
						<div  class="col col-md-3">
						</div>
						<div  class="col col-md-6">
							<input value="ここに回答を入力してください" type="text"  name=oogiri_area rows="3" cols="20" id="answer_area" class="form-control" style="text-align:center;" ng-model="answer_string" >
							<br>
							<button type="button" class="button btn btn-default" id="answer_button"  ng-click="answer($event)" >回答送信</button>
						</div>
						<div  class="col col-md-3">
						</div>
					</div>
				</div>
				<div id="result_area" style="display:none" >


				</div>
				<div id="vote_result_area" style="display:{{vote_resutl_display}};" >
					<font >
						勝者は<font id=winner>{{winner_name}}</font>さんです！
				        獲得票数は<font id=winner_vote_number>{{winner_count}}</font>票
				    </font>
				</div>
				<div id="choice_area" style="margin:0 0 40px 0px;display:{{choice_display}};" >
					<div>
						<button type="button" style="margin:0 10px 0 0px;" class="button btn btn-success"  ng-click="choice('play')" >Play</button>
						or
						<button type="button" class="button btn btn-info" style="margin:0 0 0 10px;"  ng-click="choice('watch')" >Watch</button>
					</div>
				</div>
				<div id="watch_area" style="margin:5 0 0 0;display:{{watch_display}};" >
					<div class="row">
						<div  class="col col-md-3">
						</div>
						<div  class="col col-md-6">
							<div>
								<input type="text"  rows="1" cols="20" id="watch_comment_area" class="form-control" style="text-align:center;" ng-model="watch_comment">
								<br>
								<button type="button" class="button btn btn-default" id="watch_comment_button"  ng-click="comment($event)" >コメント送信</button>
							</div>
							<div id="comment_space" style="width:100%;height:100px;">

							</div>
						</div>
						<div  class="col col-md-3">
						</div>
					</div>
				</div>
			</div>
			<div  class="col col-md-2">
			</div>
		</div>
		<div  ng-repeat="comment in comments" style="font-size:25px;text-align:left;width:auto;position:absolute;top:{{watch_offset.absolute_top+comment.y*watch_offset.watch_y}}px;left:{{watch_offset.absolute_left+comment.x*watch_offset.watch_x}}px;" >
			{{comment.comment}}
		</div>
		<div id=anime_box style="display:none;position:absolute;top:0;left:0;width:100%;height:100%;">
			<table width="90%" height="90%" border="0" align="center">
				<tr>
				<td><div align="center" id="anime_text"></div></td>
			</tr>
			</table>
		</div>
		<span class="badge" style="position:absolute;right:10px;top:10px;" ><font size="5px">{{mode}}</font></span>
	</div>
</body>
