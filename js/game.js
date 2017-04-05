Master.game={
	status:null,
	winner_map:null,
	user_list:null,
	theme:null,
	count:null,
	comment:null,
	result_flg:false,//結果発表にステータスが変更
	setGameInfo:function(ginfo){
		var init_flg=false;
		var result_flg=false;
		if(this.status!=(ginfo.status) && (ginfo.status)==0){
			init_flg=true;
		}else if(this.status!=(ginfo.status) && (ginfo.status)==3){
			this.result_flg=true;
		}



		this.status=ginfo.status;//ゲームのステータスは+1
		this.winner_map=ginfo.winnerMap;
		this.user_list=ginfo.usersData;
		this.theme=ginfo.nowTheme;
		if(ginfo.CMap){
			this.comment=ginfo.CMap.CMap;
		}
		return init_flg;
	}
}