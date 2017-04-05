package servlet;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ap.Conf;
import ap.Master;

public class InitServlet extends HttpServlet {
	Master master;
	public void init(ServletConfig config) throws ServletException{
		super.init(config);
		//ServletContextインタフェースのオブジェクトを取得
	    ServletContext sc = getServletContext();
	    Conf.setPath(sc.getRealPath("WEB-INF"));//WEB-INFへのパスをセット
	    //useridデータをapplicationスコープで保存
	    master=new Master();
	    sc.setAttribute("master",master);

	}

	public void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		doPost(request, response);
	}
	public void doPost (HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
		String url=request.getRequestURI();
		url=url.replace(".spc",".jsp");
		url=url.replace("/Oogiri2","");
		/*if(url.indexOf("Welcome")!=-1){
			request.setAttribute("mode", "play");
		}
		else if(url.indexOf("Watch")!=-1){
			request.setAttribute("mode", "watch");
		}*/
		 ServletContext sc = getServletContext();
		 Master mast=(Master)sc.getAttribute("master");
		 response.setContentType("text/html; charset=utf-8");
		 request.setAttribute("master", mast);
		getServletContext().getRequestDispatcher(url).forward(request, response);
	}
}
