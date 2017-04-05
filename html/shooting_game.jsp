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
	String uname=user.getName();
	String lev=request.getParameter("level");
	int level=1;
	if(lev!=null){
		level=Integer.parseInt(lev);
	}
	String action=request.getParameter("action");
	if(action!=null){
		if(action.equals("down")){
			sh.deleteLife();
		}
	}else if(lev==null){
		sh.reflesh();
	}
	int life=sh.getLife();
	int score=sh.getScore();
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
body{
	font-family:"メイリオ", Meiryo, sans-serif;
}
</style>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<!-- BootstrapのCSS読み込み -->
<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- BootstrapのJS読み込み -->
<script src="../bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" >
var svg={
	CRITERIA_WIDTH:1366,
	CRITERIA_HEIGHT:768,
	setWidth:function(width){
		$("#svg_area").get(0).setAttribute("width",width);
	},
	setHeight:function(height){
		$("#svg_area").get(0).setAttribute("height",height);
	},
	getWindowHeight:function(){
		return window.parent.screen.height;
	},
	getWindowWidth:function(){
		return window.parent.screen.width;
	},
	getRatioX:function(){
		return this.getWindowWidth()/this.CRITERIA_WIDTH;
	},
	getRatioY:function(){
		return this.getWindowHeight()/this.CRITERIA_HEIGHT;
	},
	getHeight:function(){
		return $("#svg_area").height();
	},
	getWidth:function(){
		return $("#svg_area").width();
	},
	append:function(elm){
		$("#svg_area").append(elm);
	},
	makeCircle:function(x,y,r,color){
		var circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
		circle.setAttribute("cx",x);
	    circle.setAttribute("cy",y);
	    circle.setAttribute("r",r);
	    circle.setAttribute("fill",color);
	    return circle;
	},
	makePolygon:function(color,points,config){
		var polygon = document.createElementNS("http://www.w3.org/2000/svg", "polygon");
		var config= config || {};
	    polygon.setAttribute("fill",color);
	    polygon.setAttribute("points",points);
	    if(config.stroke){
	    	polygon.setAttribute("stroke",config.stroke);
	    	polygon.setAttribute("stroke-width",(config.stroke_width || 1));
	    }
	    if(config.id){
	    	polygon.setAttribute("id",config.id);
	    }
	    return polygon;
	},
	makePolygon2:function(option){
		var polygon = document.createElementNS("http://www.w3.org/2000/svg", "polygon");
		//最低限必要な属性を付与
		option= option || {};
		option["fill"] = option["fill"] || "blue";
		option["stroke"] = option["stroke"] || "blue";
		option["stroke-width"] = option["stroke-width"] || 10;
		//ポイントは配列型を文字列型に変換する
		option["points"]=option["points"] || [[10,10],[20,12],[20,20],[10,22]];
		var points="";
		for(var i=0;i<points.length;i++){
			polygon+=points[i][0]+","+points[i][1]+" ";
		}
		for(var key in option){
			polygon.setAttribute(key,option[key]);
		}
	    return polygon;
	},
	getLength:function(x,y){
		return Math.pow(Math.pow(x,2)+Math.pow(y,2),0.5);
	},
	makeLine:function(config){
		var line = document.createElementNS("http://www.w3.org/2000/svg", "line");
		line.setAttribute("x1",config.x1);
		line.setAttribute("y1",config.y1);
		line.setAttribute("x2",config.x2);
		line.setAttribute("y2",config.y2);
		config.color = config.color || "black";
		config.width = config.width || 10;
		line.setAttribute("stroke",config.color);
		line.setAttribute("stroke-width",config.width);
		if(config.style){
			line.setAttribute("stroke-linejoin",config.style);
		}
		return line;
	},
	sin:function(rad){
		return Math.sin(rad*Math.PI/180);
	},
	cos:function(rad){
		return Math.cos(rad*Math.PI/180);
	},
	getLimitY:function(){
		return svg.getHeight()-50;
	}
}
var People=function(config){
	var config=config || {};
	var self=this;
	var group=document.createElementNS("http://www.w3.org/2000/svg", "g");
	svg.append(group);
	this.x=config.x || svg.getWidth()-100;
	this.y=config.y || svg.getHeight()-400;
	this.trans_x=0;
	this.trans_y=0;
	this.color= config.color || "red";
	this.speedX=0;
	this.speedY=0;
	this.ax=0;
	this.ay=0;
	this.type=config.type;
	this.speedMax=200;
	this.spling_flg=false;
	this.grand_flg=false;
	this.interval=100;
	this.width=45*svg.getRatioX();
	this.height=70*svg.getRatioY();
	this.r=this.width/4.5;
	this.timer;
	//バネ定数
    var k = 1.01;
    //抗力係数
    var cd = 0.02;
    this.run=function(){
		this.timer=setInterval(function(){
			self.move();
		}, self.interval);
	}
	this.stop=function(){
		clearInterval(this.timer);
	}
	this.inline=function(){
		var p_height=30;
		var f_length=15;
		/*
	    var circle=svg.makeCircle(this.x,this.y,this.r,this.color);
	    $(group).append(circle);
	    var p1=(this.x-this.r)+","+(this.y+this.r)+" "+(this.x+this.r)+","+(this.y+this.r)+" "+(this.x+this.r)+","+(this.y+this.r+p_height)+" "+(this.x-this.r)+","+(this.y+this.r+p_height);
	    var poly1=svg.makePolygon(this.color,p1);
	    $(group).append(poly1);
	    var p2=(this.x-this.r)+","+(this.y+this.r)+" "+(this.x-this.r*2.4)+","+(this.y+this.r*2.3)+" "+(this.x-this.r*1.5)+","+(this.y+this.r*2.7)+" "+(this.x)+","+(this.y+this.r*1.5);
	    var poly2=svg.makePolygon(this.color,p2);
	    $(group).append(poly2);
	    var p3=(this.x+this.r)+","+(this.y+this.r)+" "+(this.x+this.r*2.4)+","+(this.y+this.r*2.3)+" "+(this.x+this.r*1.5)+","+(this.y+this.r*2.7)+" "+(this.x)+","+(this.y+this.r*1.5);
	    var poly3=svg.makePolygon(this.color,p3);
	    $(group).append(poly3);
	    var p4=(this.x-this.r)+","+(this.y+this.r+p_height)+" "+(this.x-this.r)+","+(this.y+this.r+p_height+f_length)+" "+(this.x-this.r*0.2)+","+(this.y+this.r+p_height+f_length)+" "+(this.x-this.r*0.2)+","+(this.y+this.r+p_height);
	    var poly4=svg.makePolygon(this.color,p4);
	    $(group).append(poly4);
	    var p5=(this.x+this.r)+","+(this.y+this.r+p_height)+" "+(this.x+this.r)+","+(this.y+this.r+p_height+f_length)+" "+(this.x+this.r*0.2)+","+(this.y+this.r+p_height+f_length)+" "+(this.x+this.r*0.2)+","+(this.y+this.r+p_height);
	    var poly5=svg.makePolygon(this.color,p5);
	    $(group).append(poly5);
	    */
	      //svg.append(svg.makeCircle(this.getX(),this.getY(),30,"black"));
	     //$(group).append(svg.makeCircle(this.x,this.y,30,"black"));
	     if(this.type=="player"){
	     	var reimu=$(".akumu").eq(0).clone();
	     	$(reimu).get(0).setAttribute("width",this.width);
	     	$(reimu).get(0).setAttribute("height",this.height);
	     	$(reimu).get(0).setAttribute("x",this.x-(this.width/2));
	     	$(reimu).get(0).setAttribute("y",this.y-(this.height/2));
	     	$(group).append($(reimu).get(0));
	     }else{
	     	var marisa=$(".marisa2").eq(0).clone();
	     	$(marisa).get(0).setAttribute("width",this.width);
	     	$(marisa).get(0).setAttribute("height",this.height);
	     	$(marisa).get(0).setAttribute("x",this.x-(this.width/2));
	     	$(marisa).get(0).setAttribute("y",this.y-(this.height/2));
	     	$(group).append($(marisa).get(0));
	     }
	}
	this.getHand=function(r_l){
		if(r_l=="r"){
			return {x:this.x+this.r*2,y:this.y+this.r*2.5};
		}else{
			return {x:this.x-this.r*2,y:this.y+this.r*2.5};
		}
	}
	this.move=function(){
		this.calcAcc();
		this.calcSpeed();
		this.shift(this.speedX,this.speedY);
		this.anotherMove();
	}
	this.anotherMove=function(){
	}
	this.shift=function(t_x,t_y){
		this.trans_x+=t_x;
		this.trans_y+=t_y;
		if(this.getX()<0 || this.getX()>=$("#svg_area").width()){
			this.trans_x-=t_x*1;
			this.speedX=0;
			this.ax=0;
		}else if((this.getX()>=svg.getWidth()/3) && self.type=="enemy"){
			this.trans_x-=t_x*1;
			this.speedX=0;
			this.ax=-1;
		}
		if(this.getY()>=svg.getLimitY()){
			this.trans_y=svg.getLimitY()-this.y-(this.height/2);
			this.grand_flg=true;
			this.speedY=0;
			this.ay=-1;
		}else if(this.getY()<0 ){
			this.trans_y-=t_y*1;
			this.ay=1;
			this.speedY=0;
			this.grand_flg=false;
		}else{
			this.grand_flg=false;
		}
		if(this.getY()>= (this.getFulclum())){
			//this.spling_flg=true;
		}
		else{
			this.spling_flg=false;
		}
		group.setAttribute("transform","translate("+this.trans_x+","+this.trans_y+")");
	}
	this.getX=function(){
		return this.x*1+this.trans_x*1;
	}
	this.getY=function(){
		//console.log(this.y*1+this.trans_y*1+30);
		return this.y*1+this.trans_y*1;
	}
	this.getFulclum=function(){
		return svg.getHeight();//-100;
	}
	this.calcAcc=function(){
		if(this.spling_flg){
			//フックの法則（復元力は変化量に比例）
			//console.log(this.ay);
	        this.ay=  -(this.getY() - this.getFulclum()) * k;
	        console.log(this.ay,cd,this.speedY);
	        //復元力から空気抵抗分を減算する
	        //this.ay -= cd * this.speedY;
	        //console.log(this.ay);
		}else{
			this.ay=9.8;
		}
	}
	this.calcSpeed=function(){
		this.speedX+=this.ax;
		this.speedY+=this.ay;
		var s_size=Math.pow(Math.pow(this.speedX,2)+Math.pow(this.speedY,2),0.5);
		if(s_size*1<=this.speedMax*1){
		}
		else{
			this.speedX=this.speedX/s_size*this.speedMax;
			this.speedY=this.speedY/s_size*this.speedMax;
		}
	}
	this.spling=function(){
		//フックの法則（復元力は変化量に比例）
        this.ay=  (this.getY() - svg.getHeight()) * k;
        //復元力から空気抵抗分を減算する
        this.ay -= this.cd * this.speedY;
        //速度に加速度を加算
        this.speedY += this.ay;
	}
	this.Beem=function(v){
	    var length=this.width*4/9;
	    var beem_speed=10;
	    var beem_width=10;
	    var beem_color=v.color || "gold";
	    var v_length=svg.getLength(v.x,v.y);
	    var v_distance=v.distance || (svg.getWidth()+svg.getHeight());
	    var x=this.getX();
	    var y=this.getY();
	    var t_x=0;
	    var t_y=0;
		/*var bx=length/v_length*v.x;
		var by=length/v_length*v.y;
		var point=x+","+y+" "+(x+bx)+","+(y+by)+" "+(x+bx)+","+(y+by+beem_width)+" "+x+","+(y+beem_width);
		var beem=svg.makePolygon(beem_color,point);
		*/
		var x2=x+length/v_length*v.x;
		var y2=y+length/v_length*v.y;
		//var beem=svg.makeLine({x1:x,x2:x2,y1:y,y2:y2,color:this.color,width:beem_width,style:"round"});
		//var b_group=document.createElementNS("http://www.w3.org/2000/svg", "g");
		var beem;
		if(this.type=="player"){
			beem=$(".mahou_reimu").clone().get(0);
		}else{
			beem=$(".mahou_marisa").clone().get(0);
		}
		beem.setAttribute("x",x);
		beem.setAttribute("y",y);
		beem.setAttribute("width",length);
		beem.setAttribute("height",length);
		beem.getX=function(){
			return x+10+t_x;
		}
		beem.getY=function(){
			return y+10+t_y;
		}
		//svg.append(beem);
		svg.append(beem);
		//$(b_group).append(beem);
		var target=(self.type=="player" ? "enemy" : "player");
		var counter=0;
		var timer=setInterval(function(){
					 t_x+=beem_speed/v_length*v.x*svg.getRatioX();;
					 t_y+=beem_speed/v_length*v.y*svg.getRatioX();;
					 beem.setAttribute("transform","translate("+t_x+","+t_y+")");
					 beem.setAttribute("class","beem "+self.type);
					 if(People.static.judgeConfliction(beem,target,{dy:((self.height+length)/2-5),dx:((self.width+length)/2)-13})){
					 	beem.remove();
					 	if(self.type=="enemy"){
						 	Game.lose();
						}else{
							Gage.reduceGage(10);
							var val=Gage.getValue();
							if(val==0){
								Game.win();
							}
						}
					 }
					 if(svg.getLength(t_x,t_y)>=v_distance){
					 	beem.remove();
					 }
				  }, 100);
		if(this.type=="player"){
			//Gage.zeroGage();
		}
		beem.remove=function(){
			clearInterval(timer);
			$(beem).remove();
		}
	}
	this.Bomb=function(option){
		var x=option.x;
		var y=option.y;
		var color=option.color || "black";
		var shade_color="gray";
		var explode_r=(option.explode_r || 60)*svg.getRatioX();
		var r=1;
		var bomb=svg.makeCircle(x,y,r,shade_color);
		bomb.setAttribute("fill-opacity",0.3);
		svg.append(bomb);
		bomb.getX=function(){
			return x;
		}
		bomb.getY=function(){
			return y;
		}
		var target=(self.type=="player" ? "enemy" : "player");
		var explode_speed=4*svg.getRatioX();
		var timer=setInterval(function(){
					 r+=explode_speed;
					 bomb.setAttribute("r",r);
					 if(r>=explode_r){
					 	bomb.explode();
					 }
				  }, 100);
		bomb.explode=function(){
			bomb.setAttribute("fill",option.color);
			bomb.setAttribute("stroke","red");
			bomb.setAttribute("stroke-width",10);
			bomb.setAttribute("fill-opacity",1);
			bomb.setAttribute("class","bomb");
			if(People.static.judgeConfliction(bomb,target,{dy:(r+(self.height/2)),dx:(r+(self.width/2)-10)})){
			 	bomb.remove();
			 	Game.lose();
			}
			setTimeout(function(){
				bomb.remove();
			},500);
		}
		bomb.remove=function(){
			$(bomb).remove();
			clearInterval(timer);
		}
	}
	this.Sord=function(){
		var hand;
		var s_length=30;
		if(this.type=="player"){
			hand=this.getHand("l");
		}else{
			hand=this.getHand("r");
		}
		var option={};
		var rad=60;
		option.x1=hand.x;
		option.y1=hand.y;
		option.x2=option.x1+svg.cos(rad)*(this.type=="player" ? -1:1)*s_length;
		option.y2=option.y1+svg.sin(rad)*-1*s_length;
		option.color=this.color;
		option.width=5;
		var sord=svg.makeLine(option);
		sord.getX=function(){
			return self.getX()-self.x+option.x2;
		}
		sord.getY=function(){
			return self.getY()-self.y+option.y2;
		}
		$(group).append(sord);
		var timer=setInterval(function(){
					 if(People.static.judgeConfliction(sord,(self.type=="player" ? "enemy" : "player"))){
					 	clearInterval(timer);
					 	$(sord).remove();
					 	alert("あなたの"+(self.type=="player" ? "勝ちです" : "負けです"));
					 	location.reload();
					 }
					 if(rad<=-60){
					 	clearInterval(timer);
					 	$(sord).remove();
					 }
					 rad-=20;
					 option.x2=option.x1+svg.cos(rad)*(self.type=="player" ? -1:1)*s_length;
					 option.y2=option.y1+svg.sin(rad)*-1*s_length;
					 sord.setAttribute("x2",option.x2);
					 sord.setAttribute("y2",option.y2);
					 $(".beem").each(function(){
					 	if(People.static.judgeConfliction(sord,this)){
						 	this.remove();
						 }
					 });
				  }, 50);
	}
}
People.static=(function(){
	var player;
	var enemy;
	return {
		getPlayer:function(){
			return player;
		},
		getEnemy:function(){
			return enemy;
		},
		setPlayer:function(p){
			player=p;
		},
		setEnemy:function(e){
			enemy=e;
		},
		getVector:function(p_flg){
			var player_flg=(p_flg === undefined  ? true:p_flg);//player側からenemyへのベクトルかどうか
			var vx=enemy.getX()-player.getX();
			var vy=enemy.getY()-player.getY();
			if(player_flg){
				return {vx:vx,vy:vy};
			}else{
				return {vx:vx*-1,vy:vy*-1};
			}
		},
		judgeConfliction:function(obj,target,option){
			var option=option || {};
			var adx=option.dx || self.width/2;
			var ady=option.dy || self.height/2;
			if(target=="player"){
				target=player;
			}else if(target=="enemy"){
				target=enemy;
			}
			var v1={x:obj.getX(),y:obj.getY()};
			var v2={x:target.getX(),y:target.getY()};
			/*var distance=this.getDistance(v1,v2);
			if(distance<=allow_distance){
				return true;
			}else{
				return false;
			}*/
			if(Math.abs(v1.x-v2.x)<=(adx) && Math.abs(v1.y-v2.y)<=ady){
				if(this.getDistance(v1,v2)<=ady){
					return true;
				}
			}else{
				return false;
			}
		},
		getDistance:function(v1,v2){
			var dx=v1.x-v2.x;
			var dy=v1.y-v2.y;
			return svg.getLength(dx,dy);
		}
	}
}());

var Gage={
	value:null,
	max_value:null,
	x:null,
	y:null,
	length:null,
	color:null,
	height:null,
	appendGage:function(option){
			option = option || {};
			this.value=this.max_value=option.hp || 100;
			this.x=option.x;
			this.y=option.y;
			this.length=option.length || 200*svg.getRatioX();
			this.height= option.height || 10*svg.getRatioY();
			this.color=option.color || "black";
			var point=(this.x)+","+(this.y)+" "+(this.x+this.length)+","+(this.y)+" "+(this.x+this.length)+","+(this.y+this.height)+" "+(this.x)+","+(this.y+this.height);
			var gage=svg.makePolygon(this.color,point,{id:"gage"});
			svg.append(gage);
			//var frame_point=(svg.getWidth()-300)+","+(svg.getHeight()-30)+" "+(svg.getWidth()-100)+","+(svg.getHeight()-30)+" "+(svg.getWidth()-100)+","+(svg.getHeight()-20)+" "+(svg.getWidth()-300)+","+(svg.getHeight()-20);
			var gage_frame=svg.makePolygon("transparent",point,{stroke:this.color});
			svg.append(gage_frame);
	},addGage:function(va){
		if(this.value>=max_value){
		}else{
			this.value+=va;
			this.reflect();
		}
	},reflect:function(){
	    var point=(this.x)+","+(this.y)+" "+(this.x+this.value*(this.length/this.max_value))+","+(this.y)+" "+(this.x+this.value*(this.length/this.max_value))+","+(this.y+this.height)+" "+(this.x)+","+(this.y+this.height);
		$("#gage").get(0).setAttribute("points",point);
	},zeroGage:function(){
		this.value=0;
		this.reflect();
	},
	reduceGage:function(val){
		this.value-=val;
		if(this.value>=0){
			this.reflect();
		}else{
			this.value=0;
			this.reflect();
		}
	},getValue:function(){
		return this.value;
	},getHPPer:function(){
		return (this.value/this.max_value)*100;
	}
}

var Player=function(config){
	People.call(this,config);
	var self=this;
	this.shiftSpeed=30;
	this.shiftSpeedY=this.shiftSpeed;
	this.key=null;
	this.move=function(){
	};
}
var Enemy=function(config){
	People.call(this,config);
	var self=this;
	this.hp=100;
	this.circulate_count=15;
	this.cc=0;
	this.low_acceell=0.1;
	this.acc_count=this.circulate_count;
	this.accell=0.5*svg.getRatioX();
	this.speedMax=20*svg.getRatioX();
	this.anotherMove=function(){
		var v=People.static.getVector(false);
		var v_len=svg.getLength(v.vx,v.vy);
	 	var rx=v.vx/v_len*3+Math.random()*5-2.5;
	 	var ry=v.vy/v_len*3+Math.random()*5-2.5;
	 	var slot=Math.floor(Math.random()*100);
	 	if(slot>=8 && slot <=80){
			this.Beem({x:rx,y:ry,color:"red"});
		}else if(slot<=2){
			this.Bomb({x:self.getX()+v.vx/2,y:self.getY()+v.vy/2});
		}else if(slot>=3 && slot<=5){
			this.Bomb({x:self.getX()+v_len/svg.getWidth()*v.vx*0.4,y:self.getY()+v_len/svg.getHeight()*v.vy*0.4});
		}/*else if(slot>=7 && slot <=7){
			this.Bomb({x:self.getX()+v.vx,y:self.getY()+v.vy});
		}*/
	}
	this.calcAcc=function(){
		var accr=this.cc%4;
		//console.log(accr,this.speedX,this.speedY,this.ax,this.ay,this.acc_count);
		if(this.acc_count==this.circulate_count){
			//this.speedX=0;
			//this.speedY=0;
			var random=Math.random()*0.2+0.8;
			if(accr==0){
				this.ax = this.accell*(Math.random()*0.3+0.4);
				if(this.ay!=0){
					this.ay = this.accell*random*1;
				}else{
					this.ay = this.low_acceell;
				}
			}else if(accr==1){
				this.ax = this.accell*(Math.random()*0.3+0.5)*-1;
				this.ay = this.accell*random;

			}else if(accr==2){
				this.ax = this.accell*(Math.random()*0.3+0.5)*-1;
				this.ay = this.accell*random*-1;

			}else if(accr==3){
				this.ax = this.accell*(Math.random()*0.3+0.4)*1;
				this.ay = this.accell*random*-1;
			}
			this.acc_count=0;
			this.cc++;
		}else{
			this.acc_count++;
		}
	}
	this.startBomb=function(){
		this.Bomb({x:svg.getWidth()/2,y:svg.getHeight()*0.1});
		setTimeout(function(){
			self.Bomb({x:svg.getWidth()/2,y:svg.getHeight()*0.3});
		},500);
		setTimeout(function(){
			self.Bomb({x:svg.getWidth()/2,y:svg.getHeight()*0.5});
		},500);
		setTimeout(function(){
			self.Bomb({x:svg.getWidth()/2,y:svg.getHeight()*0.7});
		},500);
		setTimeout(function(){
			self.Bomb({x:svg.getWidth()/2,y:svg.getHeight()*0.9});
		},500);
		setTimeout(function(){
			self.Bomb({x:svg.getWidth()/3,y:svg.getHeight()*0.9});
		},500);
		setTimeout(function(){
			self.Bomb({x:svg.getWidth()/3,y:svg.getHeight()*0.7});
		},500);
		setTimeout(function(){
			self.Bomb({x:svg.getWidth()/3,y:svg.getHeight()*0.5});
		},500);
		setTimeout(function(){
			self.Bomb({x:svg.getWidth()/3,y:svg.getHeight()*0.3});
		},500);
		setTimeout(function(){
			self.Bomb({x:svg.getWidth()/3,y:svg.getHeight()*0.1});
		},500);
	}
}

var Enemy_level_one=function(config){
	Enemy.call(this,config);
	this.hp=30;
	var self=this;
	this.anotherMove=function(){
		var v=People.static.getVector(false);
		var v_len=svg.getLength(v.vx,v.vy);
	 	var rx=v.vx/v_len*3+Math.random()*5-2.5;
	 	var ry=v.vy/v_len*3+Math.random()*5-2.5;
	 	var slot=Math.floor(Math.random()*100);
	 	if(slot>=1 && slot<=30){
			this.Beem({x:rx,y:ry,color:"red"});
		}
	}
	this.startBomb=function(){

	}
}
var Enemy_level_two=function(config){
	Enemy.call(this,config);
	this.hp=30;
	var self=this;
	this.anotherMove=function(){
		var v=People.static.getVector(false);
		var v_len=svg.getLength(v.vx,v.vy);
	 	var rx=v.vx/v_len*3+Math.random()*5-2.5;
	 	var ry=v.vy/v_len*3+Math.random()*5-2.5;
	 	var slot=Math.floor(Math.random()*100);
	 	if(slot>=1 && slot<=50){
			this.Beem({x:rx,y:ry,color:"red"});
		}
	}
}

var Enemy_level_three=function(config){
	Enemy.call(this,config);
	this.hp=50;
	var self=this;
	this.anotherMove=function(){
		var v=People.static.getVector(false);
		var v_len=svg.getLength(v.vx,v.vy);
	 	var rx=v.vx/v_len*3+Math.random()*5-2.5;
	 	var ry=v.vy/v_len*3+Math.random()*5-2.5;
	 	var slot=Math.floor(Math.random()*100);
	 	if(slot>=1 && slot<=60){
			this.Beem({x:rx,y:ry,color:"red"});
		}
	}
}

var Enemy_level_four=function(config){
	Enemy.call(this,config);
}

var Enemy_level_five=function(config){
	Enemy.call(this,config);
	var self=this;
	this.hp=400;
	this.anotherMove=function(){
		var v=People.static.getVector(false);
		var v_len=svg.getLength(v.vx,v.vy);
	 	var rx=v.vx/v_len*3+Math.random()*5-2.5;
	 	var ry=v.vy/v_len*3+Math.random()*5-2.5;
	 	var slot=Math.floor(Math.random()*100);
	 	if(slot>=10){
			this.Beem({x:rx,y:ry,color:"red"});
		}else if(slot<=2){
			this.Bomb({x:self.getX()+v.vx/2,y:self.getY()+v.vy/2});
		}else if(slot>=3 && slot<=5){
			this.Bomb({x:self.getX()+v_len/svg.getWidth()*v.vx*0.4,y:self.getY()+v_len/svg.getHeight()*v.vy*0.4});
		}else if(slot>=6 && slot <=6){
			this.Bomb({x:self.getX()+v.vx,y:self.getY()+v.vy});
		}
	}
}
var Enemy_level_six=function(config){
	Enemy.call(this,config);
	var self=this;
	this.interval=80;
	this.hp=400;
	this.anotherMove=function(){
		var v=People.static.getVector(false);
		var v_len=svg.getLength(v.vx,v.vy);
	 	var rx=v.vx/v_len*3+Math.random()*5-2.5;
	 	var ry=v.vy/v_len*3+Math.random()*5-2.5;
	 	var slot=Math.floor(Math.random()*100);
	 	if(slot>=40 && slot <=80){
			this.Beem({x:rx,y:ry,color:"red"});
		}else if(slot<=5){
			this.Bomb({x:self.getX()+v.vx/2,y:self.getY()+v.vy/2});
		}else if(slot>=6 && slot<=10){
			this.Bomb({x:self.getX()+v_len/svg.getWidth()*v.vx*0.4,y:self.getY()+v_len/svg.getHeight()*v.vy*0.4});
		}else if(slot>=11 && slot <=20){
			this.Bomb({x:self.getX()+v.vx+Math.random()*400-200,y:self.getY()+v.vy+Math.random()*400-200});
		}else{
			this.Bomb({x:Math.random()*svg.getWidth()-svg.getWidth()/2,y:Math.random()*svg.getHeight()-svg.getHeight()/2,explode_r:30});
		}
	}
}
Game={
	level:1,
	life:5,
	score:<%=score%>,
	remove:function(){
		$("g").remove();
		$("beem").remove();
		$("#game").remove();
	},
	top:null,
	left:null,
	bottom:null,
	right:null,
	beem_button:null,
	init:function(){
		//svg.setWidth(svg.getWindowWidth());
		//svg.setHeight(svg.getWindowHeight());
		$("#text_div").text("レベル"+Game.level);
		this.judge_ua();//UA判定
		if(this._ua.Mobile){
			var length=60;
			var rad=30;
			var padding=40;
			var svg_width=svg.getWidth();
			var svg_height=svg.getHeight();
			this.right=svg.makePolygon2({points:[[svg_width-padding,svg_height-padding*2-length*svg.cos(rad)-length*svg.sin(rad)],[svg_width-padding-length*svg.cos(rad),svg_height-padding*2-length*svg.cos(rad)],[svg_width-padding-length*svg.cos(rad),svg_height-padding*2-length*svg.cos(rad)-length]],fill:"transparent",stroke:"blue","stroke-width":10});
			this.bottom=svg.makePolygon2({points:[[svg_width-padding*2-length*(svg.sin(rad)+svg.cos(rad)),svg_height-padding],[svg_width-padding*2-length*svg.cos(rad),svg_height-padding-length*svg.cos(rad)],[svg_width-padding*2-length*(svg.cos(rad)+1),svg_height-padding-length*svg.cos(rad)]],fill:"transparent",stroke:"blue","stroke-width":10});
			this.beem_button=svg.makePolygon2({points:[[svg_width-padding*2-length*(svg.cos(rad)),svg_height-padding*2-length*svg.cos(rad)],[svg_width-padding*2-length*(svg.cos(rad)),svg_height-padding*2-length*svg.cos(rad)-length],[svg_width-padding*2-length*(svg.cos(rad))-length,svg_height-padding*2-length*svg.cos(rad)-length],[svg_width-padding*2-length*(svg.cos(rad))-length,svg_height-padding*2-length*svg.cos(rad)]],fill:"transparent",stroke:"blue","stroke-width":10});
			this.left=svg.makePolygon2({points:[[svg_width-padding*3-length*svg.cos(rad)-length,svg_height-padding*2-length*svg.cos(rad)],[svg_width-padding*3-length*(svg.cos(rad)+svg.cos(rad))-length,svg_height-padding*2-length*(svg.sin(rad)+svg.cos(rad))],[svg_width-padding*3-length*svg.cos(rad)-length,svg_height-padding*2-length*svg.cos(rad)-length]],fill:"transparent",stroke:"blue","stroke-width":10});
			this.top=svg.makePolygon2({points:[[svg_width-padding*2-length*svg.cos(rad),svg_height-padding*3-length*(svg.cos(rad)+1)],[svg_width-padding*2-length*(svg.cos(rad)+1),svg_height-padding*3-length*(1+svg.cos(rad))],[svg_width-padding*2-length*(svg.sin(rad)+svg.cos(rad)),svg_height-padding*3-length*(svg.cos(rad)*2+1)]],fill:"transparent",stroke:"blue","stroke-width":10});
			svg.CRITERIA_WIDTH=500;
			svg.CRITERIA_HEIGHT=200;
		}
	},
	start:function(){
		this.init();
		var player=new Player({type:"player",color:"blue"});
		var enemy=this.makeNewEnemy({type:"enemy",x:100,level:this.level});
		player.inline();
		enemy.inline();
		enemy.startBomb();
		//player.run();
		enemy.run();
		People.static.setPlayer(player);
		People.static.setEnemy(enemy);
		Gage.appendGage({x:5,y:(svg.getHeight()-30),color:"black",hp:enemy.hp});
		if(!this._ua.Mobile){
			$(window).keydown(function(e){
				var key=e.keyCode;
				if(key==88){
					player.Beem({x:-1,y:0,color:player.color,distance:svg.getLength(svg.getWidth(),svg.getHeight())*0.5});
				}else if(key==37){
					player.shift(player.shiftSpeed*-1,0);
				}else if(key==38){
					player.shift(0,player.shiftSpeedY*-1);
				}else if(key==39){
					player.shift(player.shiftSpeed*1,0);
				}else if(key==40){
					player.shift(0,player.shiftSpeedY*1);
				}
			});
		}else{
			svg.append(this.right);
			svg.append(this.bottom);
			svg.append(this.beem_button);
			svg.append(this.left);
			svg.append(this.top);
			$(this.right).click(function(){
				player.shift(player.shiftSpeed*1,0);
			});
			$(this.left).click(function(){
				player.shift(player.shiftSpeed*-1,0);
			});
			$(this.top).click(function(){
				player.shift(0,player.shiftSpeedY*-1);
			});
			$(this.bottom).click(function(){
				player.shift(0,player.shiftSpeedY*1);
			});
			$(this.beem_button).click(function(){
				player.Beem({x:-1,y:0,color:player.color,distance:svg.getLength(svg.getWidth(),svg.getHeight())*0.5});
			});
		}
	},
	makeNewEnemy:function(option){
		var level=option.level;
		if(level==1){
			return new Enemy_level_one(option);
		}else if(level==2){
			return new Enemy_level_two(option);
		}else if(level==3){
			return new Enemy_level_three(option);
		}else if(level==4){
			return new Enemy_level_four(option);
		}else if(level==5){
			return new Enemy_level_five(option);
		}else if(level==6){
			return new Enemy_level_six(option);
		}else{
			return new Enemy(option);
		}
	},
	save:function(){
		$.ajax({
			url: "../jsp/Shooting.jsp",
			data: {action:"save"},
			async: false,
			success: function(xml){},
			error: function(msg) {
			}
		});
	},
	finish:function(){
		Modal.inline("ゲーム終了","ライフが無くなりました","終了");
		$("#close_button").css("display","none");
		$("#modal").on('hidden.bs.modal', function () {
			Game.save();
			Game.setHiddenLevel(1);
			setTimeout(function(){
				Game.display_finish_score();
			}, 0);
		});
	},
	win:function(){
		//alert("Configuration!! You Win!!");
		if(this.level==6){
			Modal.inline("ラストステージクリア！","全クリです！");
		}
		else{
			$("#close_button").text("次ステージへ");
			Modal.inline("ステージ"+this.level+"クリア！","あなたの勝ちです。");
		}
		$("#close_button").click(function(){
			if(this.level==6){
				//window.location.href=window.location.pathname+"?level="+(Game.level*1);
				Game.save();
				Game.setHiddenLevel(Game.level*1);
				Game.submit();
			}else{
				//window.location.href=window.location.pathname+"?level="+(Game.level*1+1);
				Game.addScore();
				Game.setHiddenLevel(Game.level*1+1)
				Game.submit();
			}
		});
		$("#finish_button").click(function(){
			Game.addScore();
			Game.save();
			Game.setHiddenLevel(Game.level*1);
			setTimeout(function(){
				Game.display_finish_score();
			}, 0);
		});
		/*window.location.href=window.location.pathname+"?level="+(this.level*1+1);
		this.level++;
		this.init();
		this.start();
		*/
	},
	lose:function(){
		//alert("あなたはやられました");
		$("#close_button").text("再チャレンジ");
		Modal.inline("敗北","あなたはやられました・・・");
		$("#close_button").click(function(){
			Game.setAction("down");
			Game.submit();
		});
		$("#finish_button").click(function(){
			Game.save();
			Game.setHiddenLevel(Game.level*1);
			setTimeout(function(){
				Game.display_finish_score();
			}, 0);
		});
		/*
		location.reload();
		this.init();
		this.start();
		*/
	},
	display_finish_score:function(){
		setTimeout(function(){
			$("#close_button").css("display","none");
			$("#finish_button").text("終了");
			$("#finish_button").unbind();
			var rank=Game.getNowRank();
			Modal.inline("最終スコア","お疲れ様でした<br><br>最終スコア："+Game.score+"<br>順位："+rank["all"]+"人中  "+rank["rank"]+"位");
			$("#finish_button").click(function(){
				Game.reflesh();
				$("#hidden_level").remove();
				Game.submit();
			});
		}, 150);

	},
	getLevel:function(){
		var url = location.href;
		if(url.indexOf("?")!= -1){
			var params    = url.split("?");
			var spparams   = params[1].split("&");
			var paramArray = [];
			for ( i = 0; i < spparams.length; i++ ) {
			    vol = spparams[i].split("=");
			    paramArray.push(vol[0]);
			    paramArray[vol[0]] = vol[1];
			}
			return paramArray["level"];
		}
		else{
			return 1;
		}
	},
	stop:function(){
		if(People.static.getPlayer()){
			People.static.getPlayer().stop();
			People.static.getEnemy().stop();
			$(window).unbind("keydown");
			$(".beem").each(function(){
				this.remove();
			});
			$(".bomb").each(function(){
				this.remove();
			});
		}
	},
	judge_ua:function(){
		 this._ua = (function(u){
		  return {
		    Tablet:(u.indexOf("windows") != -1 && u.indexOf("touch") != -1 && u.indexOf("tablet pc") == -1)
		      || u.indexOf("ipad") != -1
		      || (u.indexOf("android") != -1 && u.indexOf("mobile") == -1)
		      || (u.indexOf("firefox") != -1 && u.indexOf("tablet") != -1)
		      || u.indexOf("kindle") != -1
		      || u.indexOf("silk") != -1
		      || u.indexOf("playbook") != -1,
		    Mobile:(u.indexOf("windows") != -1 && u.indexOf("phone") != -1)
		      || u.indexOf("iphone") != -1
		      || u.indexOf("ipod") != -1
		      || (u.indexOf("android") != -1 && u.indexOf("mobile") != -1)
		      || (u.indexOf("firefox") != -1 && u.indexOf("mobile") != -1)
		      || u.indexOf("blackberry") != -1
		  }
		})(window.navigator.userAgent.toLowerCase());
	},
	_ua:null,
	submit:function(){
		$("form").get(0).submit();
	},
	setHiddenLevel:function(lev){
		$("#hidden_level").val(lev);
	},
	setAction:function(action){
		$("#hidden_action").val(action);
	},
	addScore:function(){
		var add_score=this.calculateScore();
		$.ajax({
			url: "../jsp/Shooting.jsp",
			data: {action:"addScore",value:add_score},
			async: false,
			success: function(xml){},
			error: function(msg) {
			}
		});
		Game.score+=add_score;
	},
	calculateScore:function(){
		var temp_score=0;
		var clear=100;
		var full_vonus=10;
		temp_score+=(clear-Gage.getHPPer());
		if(<%=life%>==5){
			temp_score+=full_vonus;
		}
		return temp_score;
	},saveName:function(){
		var new_name=$("#name_text").val();
		$.ajax({
			url: "../jsp/Shooting.jsp",
			data: {action:"saveName",value:new_name},
			async: false,
			success: function(xml){},
			error: function(msg) {
			}
		});
	},getNowRank:function(){
		var hash={};
		$.ajax({
			url: "../jsp/Shooting.jsp",
			data: {action:"getNowRank"},
			async: false,
			success: function(result){
				result=Game.clear(result);
				result=result.split("/");
				var arr1=result[0].split(":");
				var arr2=result[1].split(":");
				hash[arr1[0]]=arr1[1];
				hash[arr2[0]]=arr2[1];
			},
			error: function(msg) {
			}
		});
		return hash;
	},clear:function(text){
		text=text.replace(/\r?\n/g,"");
		text=text.replace(/\s+/g, "");
		return text;
	},reflesh:function(){
		$.ajax({
			url: "../jsp/Shooting.jsp",
			data: {action:"reflesh"},
			async: false,
			success: function(result){
			},
			error: function(msg) {
			}
		});
	}
}

Modal={
	title:function(text){
		$(".modal-title").eq(0).html(text);
	},
	content:function(text){
		$("#modal_content").html(text);
	},
	close_text:function(text){
		$("#close_button").html(text);
	},
	inline:function(title,content,close){
		if(title){
			Modal.title(title);
		}
		if(content){
			Modal.content(content);
		}
		if(close){
			Modal.close_text(close);
		}
		Game.stop();//ゲームの処理は止める
		$("#modal").modal();
	},
	name_change:function(){
		$("#name_text").css("display","");
		$("#finish_button").css("display","none");
		$("#close_button").text("決定");
		Modal.inline("ニックネーム入力","ニックネームを入力してください");
		$("#close_button").click(function(){
			Game.saveName();
			Game.submit();
		});
	}
}

$(document).ready(function(){
	Game.level=<%= level%>;
	Game.life=<%=life%>;
	if("<%=uname%>"=="名無し" || "<%=uname%>"==""){
		Modal.name_change();
	}else{
		if(Game.life>=1){
		Game.start();
		}else{
			Game.finish();
		}
	}
});




</script>
</head>
<body style="background-color:#ffffff">

<svg x=0 y=0 width="100%" height="100%" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1"  id="svg_area" overflow="hidden"  >
	<image  class="akumu" width=0 height=0 x=0 y=0  xlink:href="akumu.png" />
	<image  class="marisa2" width=0 height=0 x=0 y=0  xlink:href="marisa2.png" />
	<image  class="mahou_marisa" width=0 height=0 x=0 y=0 xlink:href="mahou_marisa.png" />
	<image  class="mahou_reimu" width=0 height=0 x=0 y=0 xlink:href="mahou_reimu.png" />
</svg>
<div  id=text_div style="display:inline;position:absolute;top:20;right:100;font-size:30px;">
</div>
<div  id=life_div style="display:inline;position:absolute;bottom:20;right:30;font-size:30px;">
	HP：<%

		for(int i=0;i<life;i++){
			out.print("<img  src=\"heart.png\" width=\"25\" height=\"25\" style=\"margin:0 2px;\" >");
		}
	%>

</div>
<div  id=score_div style="display:inline;position:absolute;bottom:20;right:300;font-size:30px;">
	スコア：<%= score%>
</div>
<div  id=score_div style="display:inline;position:absolute;bottom:20;right:500;font-size:30px;">
	ユーザー名：<%= uname%>
</div>

<div id="modal"  class="modal fade">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title">Modal title</h4>
      </div>
      <div class="modal-body">
        <p id="modal_content">One fine body&hellip;</p>
        <input type="text" id="name_text" style="display:none;">
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal" id=close_button>次へ</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" id=finish_button>終了</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<form method="POST" action="shooting_game.spc" >
	<input type="hidden" name="level" value="<%=level %>" id="hidden_level">
	<input type="hidden" name="action" id="hidden_action">
</form>
</body>
</html>