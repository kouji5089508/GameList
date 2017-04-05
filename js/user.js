Master.oogiri.service("user",function($http){
		this.callInfo=function(){
			return	$http({
		            method : 'POST',
		            url : "UserInfo.spc"
		        }).success(function(data, status, headers, config) {
		            return data.user_info;
		        }).error(function(data, status, headers, config) {
		            //console.log(status);
		        });
		};
	});

Master.user={
	id:null,
	name:null,
	status:1,
	statusMap:{0:"準備中",1:"考え中",2:"回答済み",3:"投票中",4:"投票済み"},
	played:true,
	vote_flg:false,
	choice_flg:false,
	getStringStatus:function(int){
		return this.statusMap[int];
	},
	setUserData:function(user_info){
		this.id=user_info.id;
		this.name=user_info.name;
		//this.status=user_info.int_status;
	},
	setPlayStatus:function(p_info){
		this.status=p_info.status;
		this.played=p_info.played;
		Master.mode=p_info.mode;
	},
	setWatchStatus:function(w_info){
		this.vote_flg=w_info.voteFlg;
	}
}
