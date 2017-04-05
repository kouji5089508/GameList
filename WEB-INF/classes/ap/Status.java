package ap;

public enum Status{
	ready(0,"準備中","PLAY  or  WATCH ?"),
	play(1,"未回答","お題に回答してください"),
	result(2,"回答済み","一番良いと思った回答に投票して下さい"),
	vote_result(3,"投票結果","結果");


	private String s;
	private Integer i;
	private String descript;
	public String getString(){
		return this.s;
	}
	public Integer getStatus(){
		return this.i;
	}
	public String getDescript(){
		return this.descript;
	}
	private Status(Integer i,String s,String descript){
		this.i=i;
		this.s=s;
		this.descript=descript;
	}
}
