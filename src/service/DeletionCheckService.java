package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import config.DBConnection;

public class DeletionCheckService {
    
    // Returns true if the entity can be safely deleted (no critical foreign keys depend on it)
    public boolean canDelete(String type, int id) {
        String sql = "";
        try (Connection con = DBConnection.getConnection()) {
            switch(type) {
                case "vaitro":
                    sql = "SELECT COUNT(*) FROM y_taikhoan WHERE maVaiTro = ?";
                    break;
                case "nhanvien":
                    sql = "SELECT (SELECT COUNT(*) FROM y_taikhoan WHERE maNhanVien = ?) + " +
                          "(SELECT COUNT(*) FROM z_hoadon WHERE maNhanVien = ?) + " + 
                          "(SELECT COUNT(*) FROM a_datphong WHERE maNhanVien = ?)";
                    return executeCount(con, sql, id, id, id) == 0;
                case "taikhoan":
                    return true;
                case "khachhang":
                    sql = "SELECT COUNT(*) FROM z_hoadon WHERE maKhachHang = ?";
                    break;
                case "loaiphong":
                    sql = "SELECT COUNT(*) FROM a_phong WHERE maLoaiPhong = ?";
                    break;
                case "phong":
                    sql = "SELECT COUNT(*) FROM a_datphong WHERE maPhong = ?";
                    break;
                case "hoadon":
                    sql = "SELECT COUNT(*) FROM a_datphong WHERE maHoaDon = ?";
                    break;
                case "datphong":
                    return true;
                default:
                    return true;
            }
            if (!sql.isEmpty() && sql.contains("?")) {
                return executeCount(con, sql, id) == 0;
            }
        } catch (Exception e) {
            System.out.println("❌ Lỗi canDelete: " + e.getMessage());
        }
        return true; 
    }

    private int executeCount(Connection con, String sql, int... ids) throws Exception {
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, ids[i]);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }
}
