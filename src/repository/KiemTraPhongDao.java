package repository;

import config.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.KiemTraPhong;

public class KiemTraPhongDao {

    // Lấy tất cả
    public List<KiemTraPhong> getAll() {
        List<KiemTraPhong> list = new ArrayList<>();
        String sql = """
            SELECT ktp.*, p.soPhong 
            FROM b_kiemtraphong ktp
            LEFT JOIN a_phong p ON ktp.maPhong = p.maPhong
            ORDER BY ktp.maKiemTraPhong DESC
        """;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                KiemTraPhong ktp = new KiemTraPhong(
                        rs.getInt("maKiemTraPhong"),
                        rs.getInt("maHoaDon"),
                        rs.getInt("maPhong"),
                        rs.getTimestamp("ngayThanhToan"),
                        rs.getBigDecimal("tienBoiThuong"));
                ktp.setSoPhong(rs.getString("soPhong"));
                list.add(ktp);
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi load KiemTraPhong: " + e.getMessage());
        }

        return list;
    }

    // Thêm mới
    public boolean insert(KiemTraPhong ktp) {
        String sql = "INSERT INTO b_kiemtraphong (maHoaDon, maPhong, ngayThanhToan, tienBoiThuong) VALUES (?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, ktp.getMaHoaDon());
            ps.setInt(2, ktp.getMaPhong());
            ps.setTimestamp(3, ktp.getNgayThanhToan());
            ps.setBigDecimal(4, ktp.getTienBoiThuong());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi insert KiemTraPhong: " + e.getMessage());
            return false;
        }
    }

    // Cập nhật (ví dụ thay đổi tiền bồi thường hoặc ngày thanh toán)
    public boolean update(KiemTraPhong ktp) {
        String sql = "UPDATE b_kiemtraphong SET maHoaDon=?, maPhong=?, ngayThanhToan=?, tienBoiThuong=? WHERE maKiemTraPhong=?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, ktp.getMaHoaDon());
            ps.setInt(2, ktp.getMaPhong());
            ps.setTimestamp(3, ktp.getNgayThanhToan());
            ps.setBigDecimal(4, ktp.getTienBoiThuong());
            ps.setInt(5, ktp.getMaKiemTraPhong());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi update KiemTraPhong: " + e.getMessage());
            return false;
        }
    }

    // Xóa
    public boolean delete(int maKiemTraPhong) {
        String sql = "DELETE FROM b_kiemtraphong WHERE maKiemTraPhong=?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maKiemTraPhong);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi delete KiemTraPhong: " + e.getMessage());
            return false;
        }
    }

    // Lấy theo ID
    public KiemTraPhong getById(int maKiemTraPhong) {
        String sql = """
            SELECT ktp.*, p.soPhong 
            FROM b_kiemtraphong ktp
            LEFT JOIN a_phong p ON ktp.maPhong = p.maPhong
            WHERE ktp.maKiemTraPhong=?
        """;
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maKiemTraPhong);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                KiemTraPhong ktp = new KiemTraPhong(
                        rs.getInt("maKiemTraPhong"),
                        rs.getInt("maHoaDon"),
                        rs.getInt("maPhong"),
                        rs.getTimestamp("ngayThanhToan"),
                        rs.getBigDecimal("tienBoiThuong"));
                ktp.setSoPhong(rs.getString("soPhong"));
                return ktp;
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi getById KiemTraPhong: " + e.getMessage());
        }
        return null;
    }

    /**
     * Thêm KiemTraPhong dùng connection truyền vào (hỗ trợ transaction)
     */
    public boolean insertWithConnection(KiemTraPhong ktp, Connection conn) throws SQLException {
        String sql = "INSERT INTO b_kiemtraphong (maHoaDon, maPhong, ngayThanhToan, tienBoiThuong) VALUES (?,?,?,?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ktp.getMaHoaDon());
            ps.setInt(2, ktp.getMaPhong());
            ps.setTimestamp(3, ktp.getNgayThanhToan());
            ps.setBigDecimal(4, ktp.getTienBoiThuong());

            return ps.executeUpdate() > 0;
        }
    }

    public BigDecimal calculateCompensation(int maPhong, int maKiemTraPhong) {
        BigDecimal total = BigDecimal.ZERO;
        String sql = "SELECT ktct.soLuongBiHong, tbp.giaThietBi " +
                "FROM b_kiemtrachitiet ktct " +
                "JOIN b_thietbiphong tbp ON ktct.maThietBiPhong = tbp.maThietBiPhong " +
                "JOIN b_kiemtraphong ktp ON ktct.maKiemTraPhong = ktp.maKiemTraPhong " +
                "WHERE ktp.maPhong = ? AND ktp.maKiemTraPhong = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maPhong);
            ps.setInt(2, maKiemTraPhong);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int soLuongBiHong = rs.getInt("soLuongBiHong");
                    BigDecimal gia = rs.getBigDecimal("giaThietBi");
                    if (gia != null) {
                        total = total.add(gia.multiply(BigDecimal.valueOf(soLuongBiHong)));
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            // nếu lỗi, trả về 0
        }

        return total;
    }

    public boolean updateCompensation(int maKiemTraPhong) {
        String sql = """
                    UPDATE b_kiemtraphong
                    SET tienBoiThuong = (
                        SELECT SUM(ktct.soLuongBiHong * tb.giaThietBi)
                        FROM b_kiemtrachitiet ktct
                        JOIN b_thietbiphong tbp ON ktct.maThietBiPhong = tbp.maThietBiPhong
                        JOIN b_thietbi tb ON tbp.maThietBi = tb.maThietBi
                        WHERE ktct.maKiemTraPhong = ?
                    )
                    WHERE maKiemTraPhong = ?
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maKiemTraPhong);
            ps.setInt(2, maKiemTraPhong);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<KiemTraPhong> getByMaPhong(int maPhong) {
        List<KiemTraPhong> list = new ArrayList<>();
        String sql = "SELECT * FROM b_kiemtraphong WHERE maPhong = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maPhong);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                KiemTraPhong ktp = new KiemTraPhong();
                ktp.setMaKiemTraPhong(rs.getInt("maKiemTraPhong"));
                ktp.setMaPhong(rs.getInt("maPhong"));
                ktp.setTienBoiThuong(rs.getBigDecimal("tienBoiThuong"));
                ktp.setNgayThanhToan(rs.getTimestamp("ngayThanhToan"));
                // map thêm các trường khác nếu cần
                list.add(ktp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public KiemTraPhong getByMaHoaDon(int maHoaDon) {
        KiemTraPhong kt = null;
        String sql = "SELECT * FROM b_kiemtraphong WHERE maHoaDon = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maHoaDon);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    kt = new KiemTraPhong();
                    kt.setMaKiemTraPhong(rs.getInt("maKiemTraPhong"));
                    kt.setMaHoaDon(rs.getInt("maHoaDon"));
                    kt.setMaPhong(rs.getInt("maPhong"));
                    kt.setNgayThanhToan(rs.getTimestamp("ngayThanhToan"));
                    kt.setTienBoiThuong(rs.getBigDecimal("tienBoiThuong"));
                    // map thêm các trường khác nếu cần
                }
            }

        } catch (SQLException e) {
            System.out.println("❌ Lỗi getByMaHoaDon KiemTraPhong: " + e.getMessage());
            e.printStackTrace();
        }

        return kt;
    }

}
