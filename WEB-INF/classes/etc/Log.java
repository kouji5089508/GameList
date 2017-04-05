package etc;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import ap.Conf;

public class Log {
		private static String log_path;
		private static final String DB_LOG="db.log";
		private static final String SYSTEM_LOG="system.log";
		private static   String CONTENT_PATH="C:/workspace/design_work/Oogiri2/WebContent";
		public static void setConf(){
			log_path=Conf.getConfAttr(Conf.LOG_PLACE);
			CONTENT_PATH=Conf.getPath().substring(0, Conf.getPath().length()-7);
		}

		public static void dbLog(String str){
			String dateString=getDateString();
			File file = new File(CONTENT_PATH+log_path+dateString+DB_LOG);
			try {
				if(!file.exists()){
					file.createNewFile();
				}
				log(str,file);
			} catch (IOException e) {
				// TODO 自動生成された catch ブロック
				e.printStackTrace();
				systemLog(e);
			}
		}

		public static void systemLog(Exception e){
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			pw.flush();
			String str = sw.toString();
			systemLog(str);
		}
		public static void systemLog(String str){
			String dateString=getDateString();
			File file = new File(CONTENT_PATH+log_path+dateString+SYSTEM_LOG);
			try {
				if(!file.exists()){
					file.createNewFile();
				}
				log(str,file);
			} catch (IOException e) {
				// TODO 自動生成された catch ブロック
				e.printStackTrace();
			}
		}

		private static void log(String str,File file){
			try {
				PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file,true)));
				Date nowDate = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy'/'MM'/'dd' 'HH':'mm':'ss");
				String dateString = sdf.format(nowDate);
				pw.println(dateString+"    "+str);
				pw.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		private static String getDateString(){
			Date nowDate = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String dateString = sdf.format(nowDate);
			return dateString;
		}

		public static String getContentPath(){
			return CONTENT_PATH;
		}

}