package servlet;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ap.Master;

import com.mysql.jdbc.Blob;

import db.DBUtil;

public class ImageServlet extends HttpServlet {
	Master master;
	public void init(ServletConfig config) throws ServletException{
		super.init(config);
		//ServletContextインタフェースのオブジェクトを取得
	    ServletContext sc = getServletContext();
	    //useridデータをapplicationスコープで保存
	    master=new Master();
	    sc.setAttribute("master",master);
	}

	public void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		doPost(request, response);
	}
	public void doPost (HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		String url=request.getRequestURI();
		url=url.replace(".ri",".jsp");
		url=url.replace("/Oogiri2","");
		 ServletContext sc = getServletContext();
		 Master mast=(Master)sc.getAttribute("master");
		 request.setAttribute("master", mast);
	    //IDの取得
        String ID = request.getParameter("ID");



        Blob blob = (Blob)DBUtil.getOneObjectColumn("select picture from theme where id=3");
        InputStream is=null;
		try {
			is = blob.getBinaryStream();
		} catch (SQLException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}
        ServletOutputStream output = response.getOutputStream();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer = new byte[10000];
        while(true){
            int length = is.read(buffer);
            if(length==-1){
                break;
            }
            baos.write(buffer,0,length);
        }
        baos.writeTo(output);
        output.flush();

        /*//画像を返す
        response.setContentType("image/jpeg");
        OutputStream OS = response.getOutputStream();
        ImageIO.write(BIMG, "jpg", OS);
        OS.flush();
		getServletContext().getRequestDispatcher(url).forward(request, response);
		*/
	}
}
