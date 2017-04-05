
function Status(status){
	this.status=status;
	this.vote_map={};
	this.user_list={};
	this.vote_button_display="inline";
	this.vote_result_displya="none";
	this.tmp_user_list=[];
	this.tmp_user_list_wide={};
	this.gettheme=function(){
		document.location="/Oogiri2/jsp/Welcome.spc?theme_flg=on";
	};
	this.init=function(){
		this.status="1";
		this.vote_map={};
		$("result_area").hide();
		$("#play_area").css('display','inline');
		$("#answer_button").css('display','inline');
	};
	this.getStatusString=function(){
		if(this.status==1){
			return "play";
		}
		else if(this.status==2){
			return "result";
		}
		else if(this.status==3){
			return "vote_result";
		}
	};

	this.changeStatus=function(st){
		if(this.status!=st){
			this.status=st;
			$("#play_area").hide();
			$("#result_area").hide();
			$("#vote_result_area").hide();
			$("#"+this.getStatusString()+"_area").css('display','inline');
			$("#answer_button").css('display','inline');
			if(this.status==3){
				$(".vote_result").css('display','inline');
			}
			else{
				$(".vote_result").css('display','none');
			}
			if(this.status==1){
				this.gettheme();//ページを更新してテーマやり直し
				Master.status.vote_button_display='none';
			}
			else if(this.status==2){
				Master.status.vote_button_display='inline';
				$("#status_descript").text("一番良いと思った回答に投票して下さい");//ステータスの説明変更

			}
			else if(this.status==3){
				$("#status_descript").text("結果");//ステータスの説明変更
			}
		    /*var vote_dis='none';
		    if(this.status==1){
		    	vote_dis='inline';
		    }
		    $(".vote_button").css('display',vote_dis);//投票ボタン
		    */
		};
	};
	this.getRemoveUser=function(u_list){
		var t_user_list=[];
		for(var user in u_list){
			//t_user_list[u_list[user][0]]=u_list[user][3];
			t_user_list.push(u_list[user][0]);
		}
		var remove_user=[];
		//console.log(u_list,t_user_list,this.tmp_user_list);
		//console.log(this.tmp_user_list.length);
		for(var i=0;i<this.tmp_user_list.length;i++){
			if(t_user_list.indexOf(this.tmp_user_list[i])!=-1){//今のユーザーがいれば

			}
			else{
				remove_user.push(this.tmp_user_list[i]);
			}

		}
		this.tmp_user_list=t_user_list;
		this.tmp_user_list_wide=u_list;
		//console.log(remove_user);
		return remove_user;

	}
	this.reflectVote=function(){
		var max=0;
		var winner={};
		for(var user in this.vote_map){
			var user_id=user;
			var count=this.vote_map[user];
			max=Math.max(max,count);
			$("#"+user_id+"_vote_result").text(count+"票");
		}
		for(var user in this.vote_map){
			var user_id=user;
			var count=this.vote_map[user];
			if(max==count){
				winner[user_id]=count;
			}
		}
		var string="";
		var t_user_list={};
		for(var user in this.tmp_user_list_wide){
			t_user_list[this.tmp_user_list_wide[user][0]]=this.tmp_user_list_wide[user][3];
		}
		for(var user in winner){
			if(string!=""){
				string+="、";
			}
			string+=t_user_list[user];
		}
		$("#winner").text(string);
		$("#winner_vote_number").text(max);
	}

}