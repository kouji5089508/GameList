package ap;

public enum UserStatus{
	ready(0,"準備中"),
	play(1,"未回答"),
	result(2,"回答済み"),
	vote(3,"投票中"),
	vote_result(4,"投票済み");

	private String s;
	private Integer i;
	public String getString(){
		return this.s;
	}
	public Integer getStatus(){
		return this.i;
	}
	private UserStatus(Integer i,String s){
		this.i=i;
		this.s=s;
	}

}
