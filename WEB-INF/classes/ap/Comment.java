package ap;

public class Comment {
	private String comment;
	private static Integer sequence=0;
	private final Integer BLANK_ID=999999999;
	private Integer id;
	public Comment(String c){
		this.comment=c;
		this.id=makeId();
		System.out.println(id);
	}
	public Comment(String s,boolean blank){
		this.comment=s;
		if(blank){
			this.id=BLANK_ID;
		}
	}

	@Override
	public String toString(){
		return this.comment;
	}

	public String getComment(){
		return this.comment;
	}

	private static Integer  makeId(){
		synchronized(sequence){
			return ++sequence;
		}
	}

	public Integer getId(){
		return id;
	}
}
