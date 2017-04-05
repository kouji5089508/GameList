package ap;

import com.mysql.jdbc.Blob;

public class Theme  {
	private String id;
	private String type;
	private String text;
	private Blob image;
	public Theme(String id,String type,String text,Blob image){
		this.id=id;
		this.type=type;
		this.text=text;
		this.image=image;
	}

	public String getText(){
		String rtext=this.text;
		if(rtext==null || rtext.equals("")){
			rtext=Conf.getConfAttr(Conf.IMAGE_COMMENT);
		}
		return rtext;
	}

	public String getId(){
		return id;
	}

	public String getType(){
		return type;
	}



}
