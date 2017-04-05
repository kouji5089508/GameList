package servlet;

	import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import etc.ItemDao;


public class GetImageServlet extends HttpServlet {
		private static final long serialVersionUID = 1L;

		/**
		 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
		 */
		protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			// �摜��ID���擾����
			String id = request.getParameter("id");

			// �擾����ID�ɕR�Â��摜�f�[�^��DB����擾����
			ItemDao dao = new ItemDao();
			BufferedImage img = dao.selectImageById(Integer.parseInt(id));
			if(img!=null){//imageが有れば
				// �摜���N���C�A���g�ɕԋp����
				response.setContentType("image/jpeg");
				OutputStream os = response.getOutputStream();
				ImageIO.write(img, "jpg", os);
				os.flush();
			}
		}

}