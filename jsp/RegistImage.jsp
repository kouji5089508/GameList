<%@ page contentType="text/html;charset=utf-8"
    pageEncoding="utf-8"
    import="org.apache.commons.*,java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,db.*,ap.*,org.apache.commons.fileupload.*,org.apache.commons.fileupload.disk.*,org.apache.commons.fileupload.servlet.*" %>


<%
	request.setCharacterEncoding("utf-8");
	String text=request.getParameter("text");
	String test_flg=request.getParameter("test_flg");
	// (2) アップロードファイルを受け取る準備
	// ディスク領域を利用するアイテムファクトリーを作成
	DiskFileItemFactory factory = new DiskFileItemFactory();

	// tempディレクトリをアイテムファクトリーの一次領域に設定
	ServletContext servletContext = this.getServletConfig().getServletContext();
	factory.setRepository((File) servletContext.getAttribute("javax.servlet.context.tempdir"));

	// ServletFileUploadを作成
	ServletFileUpload upload = new ServletFileUpload(factory);
	String strTitle=null;
	String strFileName=null;
	byte[] stream=null;
	try {
	      // (3) リクエストをファイルアイテムのリストに変換
	      List<FileItem> items = upload.parseRequest(request);

	      // アップロードパス取得
	      String upPath = servletContext.getRealPath("/") + "upload/";
	      byte[] buff = new byte[1024];
	      int size = 0;

	      for(FileItem item:items) {
	    	    if (item.isFormField()) {    //フォームのフィールド
	    	        String strFieldName = item.getFieldName();
	    	        if(strFieldName.equals("text")){//テキストだったら
	    	            text = item.getString("UTF-8");
	    	        }
	    	    } else {    //ファイル転送
	    	        if(item.getString().equals("")){    //ファイル添付なし
	    	        }else{
	    	            strFileName=item.getName();
	    	            int intPBackslash = strFileName.lastIndexOf("\\");
	    	            if(intPBackslash!=-1){
	    	                strFileName = strFileName.substring(intPBackslash+1);
	    	            }
	    	            stream = item.get();
	    	        }
	    	    }
	    	}
	    } catch (FileUploadException e) {
	      // 例外処理
	      e.printStackTrace();
	    }
	  finally{
		  response.getWriter().flush();
	  }
	java.sql.Connection db=DBUtil.getConnection();
	if(db==null){
		Context context=new InitialContext();
		 Class.forName("com.mysql.jdbc.Driver");
		 Connection db2 =  DriverManager.getConnection(Conf.getConfAttr(Conf.DB_URL),Conf.getConfAttr(Conf.DB_USER_NAME),Conf.getConfAttr(Conf.DB_PASSWORD));
		DBUtil.setDB(db2);
		db=DBUtil.getConnection();
	}
	PreparedStatement ps=db.prepareStatement("insert into theme(type,text,picture,test_flg) values(?,?,?,?)");
	String type="text";
	if(text==null){
		if(stream==null){
			type="none";
		}
		else{
			type="image";
		}
	}
	else{
		if(stream==null){
			type="text";
		}
		else{
			type="double";
		}
	}
	ps.setString(1,type);
	ps.setString(2, text);
	ps.setBytes(3,stream);
	ps.setString(4,test_flg);

	if(!type.equals("none")){
		DBUtil.executeQuery(ps);
	}


%>


<%!

/**InputStreamをバイト配列に変換*/
public byte[] getByteArray(InputStream is) {
	ByteArrayOutputStream b = new ByteArrayOutputStream();
	OutputStream os = new BufferedOutputStream(b);
	int c;
	try{
		while((c=is.read())!=-1){
			os.write(c);
		}
	}catch(IOException e) {
			//e.printStackTrace();
	}finally{
		if(os!=null){
			try{
				os.flush();
				os.close();
			}catch(IOException e){
				e.printStackTrace();
			}
		}
	}
	return b.toByteArray();
}
%>

<html>
	<head>
	<title>image登録</title>
	</head>
	<body>
		<form method="post" ENCTYPE="multipart/form-data">
			<p>
			テキスト：<br>
			<textarea name="text" rows="4" cols="40"></textarea>
			</p>
			<input type="file" name="image">

			<p>
				<input type="radio" name="test_flg" value="0" checked="checked">本番用
				<input type="radio" name="test_flg" value="1">テスト用
			</p>
			<p>
				<input type="submit" value="送信">
			</p>
		</form>
	</body>
</html>

