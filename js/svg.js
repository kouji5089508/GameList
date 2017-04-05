var SVG={
	getHeight:function(){
		return $("#svg_area").height();
	},
	getWidth:function(){
		return $("#svg_area").width();
	},
	append:function(elm){
		$("#svg_area").append(elm);
	},
	makeCircle:function(x,y,r,color,option){
		var circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
		circle.setAttribute("cx",x);
	    circle.setAttribute("cy",y);
	    circle.setAttribute("r",r);
	    circle.setAttribute("fill",color);
	    for(var key in option){
			circle.setAttribute(key,option[key]);
		}
	    return circle;
	},
	makePolygon:function(color,points,option){
		var polygon = document.createElementNS("http://www.w3.org/2000/svg", "polygon");
		var option= option || {};
	    polygon.setAttribute("fill",color);
	    polygon.setAttribute("points",points);
	    if(option.stroke){
	    	polygon.setAttribute("stroke",option.stroke);
	    	polygon.setAttribute("stroke-width",(option.stroke_width || 1));
	    }
	    if(option.id){
	    	polygon.setAttribute("id",option.id);
	    }
	    return polygon;
	},
	makeLine:function(option){
		var line = document.createElementNS("http://www.w3.org/2000/svg", "line");
		//最低限必要な属性を付与
		option = option || {};
		option['x1'] = option['x1'] || 100;
		option['y1'] = option['y1'] || 100;
		option['x2'] = option['x2'] || 200;
		option['y2'] = option['y2'] || 200;
		option['stroke-width'] = option['stroke-width'] || 10;
		option['stroke'] = option['stroke'] || "red";
		for(var key in option){
			line.setAttribute(key,option[key]);
		}
		return line;
	},
	makeText:function(option){
		var text = document.createElementNS("http://www.w3.org/2000/svg", "text");
		for(var key in option){
			if(key=="text"){
				$(text).text(option[key]);
			}else{
				text.setAttribute(key,option[key]);
			}
		}
		return text;
	}
}
