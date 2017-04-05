package etc;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.imageio.ImageIO;

import db.DBUtil;

public class ItemDao {

	public BufferedImage selectImageById(int id)  {

		try {
			Connection conn =DBUtil.getConnection();
			// SQL�����쐬����
			StringBuffer sbSQL = new StringBuffer();
			sbSQL.append("   select");
			sbSQL.append("          picture");
			sbSQL.append("     from theme");
			sbSQL.append("    where ID = ?");

			// SQL�������s����
			PreparedStatement ps = conn.prepareStatement(sbSQL.toString());
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();

			// ���ʃZ�b�g����摜�f�[�^���擾���A�ԋp����
			if (rs.next()) {
				InputStream is = rs.getBinaryStream("picture");
				BufferedInputStream bis = new BufferedInputStream(is);
				return ImageIO.read(bis);
			}

		} catch (IOException  e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}
		return null;
	}
}