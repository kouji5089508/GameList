Master={
	init:function(){
		this.user.choice_flg=false;//choice_flgのみブラウザ側で管理
	},
	getVoteResultDiplay:function(){//投票結果表示
		if(this.game.status==3){
		   return "";//inline
	   }
	   else{
		   return "none";
	   }
	},
	getVoteButtonDisplay:function(){
		if(this.mode=="watch"){
			if(this.game.status==2){
				if(this.user.vote_flg){
					return "none";
				}
				else{
					return "";
				}
			}
			else{
				return "none";
			}
		}
		else{
			 if(this.user.status==3){
				   return "";//inlineとすると表示がずれる
			 }
			 else {
				   return "none";
			 }
		}
	},
	getPlayAreaDiplay:function(){
		if(this.mode=="watch"){
			return "none";
		}
		else{
		  if(this.user.status==1){
			   return "";//inline
		   }
		   else{
			   return "none";
		   }
		}
	},
	getWinnerName:function(){
		var r_st="";
		for(var user in Master.game.winner_map){
			if(r_st!=""){
				r_st+="、";
			}
			r_st+=Master.game.user_list[user].name;
		}
		return r_st;
	},
	getWinnerCount:function(){
		for(var user in Master.game.winner_map){
			return Master.game.winner_map[user];
		}
		return 0;
	},
	getImageDisplay:function(){
		var type=this.game.theme.type;
		if(type=="image" || type=="double"){
			return "";//inlineはまずい
		}
		else{
			return "none";
		}
	},
	getImageSource:function(){
		var type=this.game.theme.type;
		if(type=="image" || type=="double"){
			return "/Oogiri2/servlet/GetImageServlet?id="+this.game.theme.id;
		}
		else{
			return "";
		}
	},
	getImageText:function(){
		return Master.game.theme.text;
	},
	getIsAlived:function(){
		return Master.user.played;
	},
	getWatchDisplay:function(){
		if(this.mode=="watch"){
			return "inine";
		}
		else{
			var u_status=this.user.status;
			if(u_status==1 || u_status==2){
				return "none";
			}
			else{
				return "";//inlineはやらない
			}
		}
	},
	getChoiceDisplay:function(){
		if(this.game.status==0){
			if(this.user.choice_flg){
				return 'none';
			}
			return "";
		}
		else{
			return "none";
		}
	},
	getChoiceComment:function(){
		if(this.mode=="play"){
			return "観戦する";
		}
		else{
			return "参可する";
		}
	},
	absolute_left:null,
	absolute_top:null,
	watch_x:null,
	watch_y:null,
	setWatchConf:function(){
		var comment_space=$("body");
		this.absolute_left=comment_space.get(0).offsetLeft;
		this.absolute_top=comment_space.get(0).offsetTop+10;
		this.watch_x=comment_space.width()/150;
		this.watch_y=comment_space.height()/5;
	},
	getWatchStatus:function(){
		return {absolute_left:this.absolute_left,absolute_top:this.absolute_top,watch_x:this.watch_x,watch_y:this.watch_y};
	},
	mode:null,
	comments:{},
	setComment:function(){
		var come=this.game.comment;
		for(var x=0;x<come.length;x++){
			var come_x= come[x];
			for(var y=0;y<come_x.length;y++){
				var come_y=come_x[y];
				var id=come_y.id;
				var comment=come_y.comment;
				if(!Master.comments[id] && id!=999999999){
					var t_id=id;
					console.log(t_id,x,y);
					Master.comments[t_id]={};
					Master.comments[t_id].comment=comment;
					Master.comments[t_id].x=140;
					Master.comments[t_id].y=5*Math.random();
					//Master.setCommentTimer(t_id);
				}
			}
		}
	},
	setCommentTimer:function(t_id){
		Master.timer[t_id]=setInterval(function(){
			Master.commentTimer(t_id);
		},100);
	},
	commentTimer:function(id){
		if(Master.comments[id]){
			Master.comments[id].x=Master.comments[id].x*1-2;
			if(Master.comments[id].x*1<=0){
				delete Master.comments[id];//100を超えたら削除
				clearInterval(Master.timer[id]);
				delete Master.timer[id];//100を超えたら削除
			}
		}
	},
	moveComment:function(){
		for (var key in Master.comments) {
		    if (Master.comments.hasOwnProperty(key)) {
		        var come = Master.comments[key];
		        come.x=come.x*1-2;
				if(come.x*1<=0){
					delete Master.comments[key];//100を超えたら削除
				}
		    }
		}
		return Master.comments;
	},
	result_anime:function(){
		var winner_flg=false;
		for(var user in Master.game.winner_map){
			if(user==Master.user.id){
				winner_flg=true;
			}
		}
		if(winner_flg){
			this.fallText("YOU WIN!!");
		}
	},
	getCountMap:function(c){
		var c_map={};
		c_map.number=c;
		if(c*1<=3){
			c_map.size=100;
			c_map.color="red";
		}
		else{
			c_map.size=50;
			c_map.color="black";
		}
		Master.game.count=c;
		return c_map;
	},
	scaleText:function(text){
		var x=50;
		setTimeout(function(){
			$("#anime_text").text(text);
			$("#anime_text").css("font-size",20+"px");
			$("#anime_box").css("display","inline");
			var timer=setInterval(function(){
				x+=8;
				$("#anime_text").css("font-size",x+"px");
				if(x*1>=300){
					clearInterval(timer);
					$("#anime_box").css("display","none");
				}
			},10);
		},900);
	},
	fallText:function(text){
		$("#anime_text").text(text);
		$("#anime_text").css("font-size",100+"px");
		$("#anime_box").css("display","inline");
		$("#anime_text").letterfx({"fx":"fall"});
		setTimeout(function(){
			$("#anime_box").css("display","none");
		}, 1500);

	},
	anime_flg:false,//一度のアニメを2回連続でしないようにする為
	animation:function(){
		if(this.anime_flg){
			this.anime_flg=false;
		}
		else{
			if(Master.game.count==0){
				if(Master.game.status==0){
					this.anime_flg=true;
					this.fallText("START");
				}
			}
		}
	},
	changeMode:function(m){
		this.mode=m;
		$.ajax({
			url: "Choice.spc",
			data: {mode:this.mode},
			async: false,
			success: function(xml){},
			error: function(msg) {
			}
		});
	}

}
Master.oogiri = angular.module('myApp', []);