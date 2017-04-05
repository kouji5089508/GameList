package ap;

import java.util.ArrayList;

public class CommentMap {
	private Comment c_map[][];
	private ArrayList<Comment> comment_array;
	private int c_x=2;
	private int c_y=5;
	public CommentMap(ArrayList<Comment> c){
		c_map=new Comment[c_x][c_y];
		this.comment_array=c;
	}
	public void proceedComment(){
		Comment c[]=new Comment[c_y];
		for(int i=0;i<c_y;i++){
			c[i]=spoilComment();
		}
		for(int x=0;x<c_x;x++){
			for(int y=0;y<c_y;y++){
				if(x==(c_x-1)){
					c_map[x][y]=c[y];
				}
				else{
					c_map[x][y]=c_map[x+1][y];
				}
			}
		}
	}

	public Comment[][] getCMap(){
		return this.c_map;
	}

	public  Comment spoilComment(){
		if(comment_array.size()>0){
			Comment c=comment_array.get(0);
			comment_array.remove(0);
			return c;
		}
		else{
			synchronized(comment_array){
				return new Comment("",true);
			}
		}
	}
}
