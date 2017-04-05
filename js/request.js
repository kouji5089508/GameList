Master.oogiri.service('request',function($http){
	 this.callSecondInfo=function(){
		 return $http({
	         method : 'POST',
	         url : "StatusCheckerJson.spc",
	         params:{mode:Master.mode}
	     }).success(function(data, status, headers, config) {
	         return data;
	     }).error(function(data, status, headers, config) {
	        if(Master.mode=="play"){
	        	//window.location.href="/Oogiri2/jsp/logout.spc";//ログアウト
	        }
	     });
	 }
});

