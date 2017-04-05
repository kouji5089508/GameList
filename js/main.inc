<%@ page pageEncoding="UTF-8" %>
<script type="text/javascript">
Master.mode="<%=mode%>";
Master.oogiri.controller('myController', function($scope,$http,$interval,$log,user,request) {
		$scope.vote_button_display="none";
		$scope.shim_display="inline";
		$scope.row_display="none";
		user.callInfo().then(function(data){
			$scope.user_info=data.data.userInfo;
			$scope.user_id=data.data.id;
			 Master.user.setUserData(data.data);
		});//まずは最初にユーザーインフォ
		$interval(function(){
			Master.setWatchConf();//watch_area調整
		   request.callSecondInfo().then(function(data){
			   data=data.data;
			   var init_flg=Master.game.setGameInfo(data);
			   if(init_flg){
				   user.callInfo().then(function(data){//ユーザーインフォ変更
						$scope.user_info=data.data.userInfo;
						 Master.user.setUserData(data.data);
					});
					Master.init();
			   }else if(Master.game.result_flg){
					Master.result_anime();
					Master.game.result_flg=false;
			   }
			   $scope.count=Master.getCountMap(data.count);
			   $scope.status_discript=data.statusDescript;
			   var status=data.status+1;
			   var user_info=data.usersData;
			   if(user_info[Master.user.id]){
				   Master.user.setPlayStatus(user_info[Master.user.id]);//play_userの属性も追加
			   }
			   if(Master.mode=="watch"){
				   var watch_user_info=data.watchUsersData;
				   if(watch_user_info[Master.user.id]){
					   Master.user.setWatchStatus(watch_user_info[Master.user.id]);//自身のwatch_user_の属性追加
				   }
			   }
			   $scope.vote_button_display=Master.getVoteButtonDisplay();//投票ボタン
			   $scope.play_area_display=Master.getPlayAreaDiplay();//回答エリア
			   $scope.vote_resutl_display=Master.getVoteResultDiplay();//結果発表エリア
			   $scope.winner_name=Master.getWinnerName();//勝者名前
			   $scope.winner_count=Master.getWinnerCount();//勝者票数

			   $scope.image_source=Master.getImageSource();//画像のソース
			   $scope.image_display=Master.getImageDisplay();//画像の表示
			   $scope.image_text=Master.getImageText();//画像のテキスト
			   $scope.watch_display=Master.getWatchDisplay();
			   $scope.watch_offset=Master.getWatchStatus();//watch_area用パラメータ

			   $scope.choice_display=Master.getChoiceDisplay();//選択の表示
			   $scope.choice_comment=Master.getChoiceComment();//選択ボタンの文字
			   for(useri in user_info){//ユーザー上方修正は後
				   user_info[useri].string_status=Master.user.getStringStatus(user_info[useri].status);
				   if(Master.mode=="play"){
				   		if(status!=1 || useri==Master.user.id){
						   user_info[useri].answer=user_info[useri].answer;
				   		}
					    else{
						   user_info[useri].answer="";
					    }
					    if(user_info[useri].notValid){//答えていなかったら
							//delete user_info[useri];
					    }
				   }
			   }
			   $scope.users_info_list=user_info;
			   $scope.mode=Master.mode;
			   Master.setComment();//コメントセット
			   Master.animation();
			   if(Master.mode=="play"){
				   if(!Master.getIsAlived()){
					   Master.changeMode("watch");
				   }
			   }
			   $scope.shim_display="none";
			   $scope.row_display="inline";
		   });

	   },<%=interval%>);

	   $interval(function() {
		      $scope.comments = Master.moveComment();//コメント同期
	   }, 100);
	   $scope.vote=function($event){
		   $scope.vote_button_display="none";//投票ボタン非表示
		   var vote_id= $event.target.getAttribute("vote_id");
		   $http({
		         method : 'POST',
		         url : "Vote.spc",
		         params:{vote_user_id:vote_id,mode:Master.mode}
		     }).success(function(data, status, headers, config) {
		     }).error(function(data, status, headers, config) {
		    	 $scope.vote_button_display="inline";//投票ボタン再表示
		     });
	   }

	   $scope.answer=function($event){
		   $scope.play_area_diplay="none";//アンサーエリア非表示
		   $http({
		         method : 'POST',
		         url : "Action.spc",
		         params:{answer:document.getElementById("answer_area").value}
		     }).success(function(data, status, headers, config) {
		    	 $scope.answer_string="";
		     }).error(function(data, status, headers, config) {
		    	 $scope.play_area_diplay="inline";//アンサーエリア再表示
		     });
	   }

	   $scope.comment=function($event){
		   $http({
		         method : 'POST',
		         url : "Comment.spc",
		         params:{comment:$scope.watch_comment,game_id:"<%=game_id%>"}
		     }).success(function(data, status, headers, config) {
		    	 $scope.watch_comment="";
		     }).error(function(data, status, headers, config) {
		     });
	   }

	   $scope.choice=function(choice){
			Master.mode=choice;
			Master.user.choice_flg=true;
			$scope.choice_display='none';
			$scope.mode=choice;
		   $http({
		         method : 'POST',
		         url : "Choice.spc",
		         params:{mode:choice,game_id:"<%=game_id%>"}
		     }).success(function(data, status, headers, config) {
		     }).error(function(data, status, headers, config) {
		     });
	   }
	});
</script>
