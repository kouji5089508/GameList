package etc;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.InputStream;
import java.sql.ResultSet;

import javax.imageio.ImageIO;

import db.DBUtil;

public class Image {
    private String url = "jdbc:mysql://localhost:3306/test";
    private String user = "**";
    private String passwd = "**";

    public static BufferedImage selectImageById(int ID){

        try {

            Object[] data= DBUtil.getOneLineData("select picture from theme where id="+ID);
        	ResultSet rs=(ResultSet)data[0];

            //データの取り出し
            if(rs.next()){
	            while(rs.next()){
	                InputStream is = rs.getBinaryStream("picture");
	                BufferedInputStream bis = new BufferedInputStream(is);
	                return ImageIO.read(bis);
	            }
            }
         }catch(Exception e) {
                e.printStackTrace();
                Log.systemLog(e);
         }
            return null;
         }

    }