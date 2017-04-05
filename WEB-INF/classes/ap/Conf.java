package ap;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

public class Conf {
	private static HashMap <String,String> conf=new HashMap<String,String>();
	private  static String WEB_PATH;
	private  static String CONF_PATH="C:/workspace/design_work/Oogiri2/WebContent/WEB-INF/oogiri.conf";
	public static final String LOG_PLACE="log.place";
	public static final String IMAGE_COMMENT="image.comment";
	public static final String DB_URL="db.url";
	public static final String DB_USER_NAME="db.user";
	public static final String DB_PASSWORD="db.pass";
	public static final String TEST_FLG ="development_test";
	public static final String INTERVAL_STATIC_THEME="interval_static_theme";
	public static final String WEBCON_PATH="webcontent.path";
	public Conf(){
		fileRead(CONF_PATH);
	}

	public static String getConfPath(){
		return CONF_PATH;
	}

	public static String getConfAttr(String attr){
		return conf.get(attr);
	}

	public static String getPath(){
		return WEB_PATH;
	}

	public static void setPath(String path){
		WEB_PATH=path;
		CONF_PATH=WEB_PATH+"/oogiri.conf";
	}
	public static void setRealPath(){
		WEB_PATH=Conf.getConfAttr(WEBCON_PATH)+"/WEB-INF";
	}
	public static void fileRead(String filePath) {
	    FileReader fr = null;
	    BufferedReader br = null;
	    try {
	        fr = new FileReader(filePath);
	        br = new BufferedReader(fr);

	        String line;
	        int count=0;
	        while ((line = br.readLine()) != null) {
	           line = line.trim();
	           if(count!=0){
		           if(!line.startsWith("#")){//スタートがシャープは読み取らない
		        	   if(line.indexOf("=") != -1){
		        		   String[] array=line.split("==");
		        		   if(array.length == 2){
		        			   conf.put(array[0],array[1]);
		        		   }
		        	   }
		           }
	           }
	           else{
	        	   count++;
	           }
	        }
	    } catch (FileNotFoundException e) {
	        e.printStackTrace();
	    } catch (IOException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            br.close();
	            fr.close();
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }
	}
}
