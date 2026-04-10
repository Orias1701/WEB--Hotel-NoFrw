package repository;

import config.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList; // Import BigDecimal
import java.util.List;
import model.DatPhong;

public class DatPhongDao {

    private Connection conn = DBConnection.getConnection();

    // GET ALL
    public List<DatPhong> getAll() {
        List<DatPhong> list = new ArrayList<>();

        String sql = """
            SELECT dp.*, kh.tenKhachHang, kh.maKhachHang, p.soPhong 
            FROM a_datphong dp
            JOIN z_hoadon hd ON dp.maHoaDon = hd.maHoaDon
            JOIN x_khachhang kh ON hd.maKhachHang = kh.maKhachHang
            JOIN a_phong p ON dp.maPhong = p.maPhong
            ORDER BY dp.maDatPhong DESC
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()){

            while (rs.next()) {
                DatPhong dp = new DatPhong(
                        rs.getInt("maDatPhong"),
                        rs.getInt("maHoaDon"),
                        rs.getInt("maNhanVien"),
                        rs.getInt("maPhong"),

                        rs.getTimestamp("ngayDatPhong"),
                        rs.getTimestamp("ngayNhanPhong"),
                        rs.getTimestamp("ngayHenTra"),
                        rs.getTimestamp("ngayTraPhong"),
                        rs.getTimestamp("ngayThanhToan"),

                        rs.getBigDecimal("tienPhong"),
                        rs.getBigDecimal("tienPhat")
                );
                dp.setTenKhachHang(rs.getString("tenKhachHang"));
                dp.setMaKhachHang(rs.getInt("maKhachHang"));
                dp.setSoPhong(rs.getString("soPhong"));
                list.add(dp);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // GET BY ID
    public DatPhong getById(int id) {
        String sql = """
            SELECT dp.*, kh.tenKhachHang, kh.maKhachHang, p.soPhong 
            FROM a_datphong dp
            JOIN z_hoadon hd ON dp.maHoaDon = hd.maHoaDon
            JOIN x_khachhang kh ON hd.maKhachHang = kh.maKhachHang
            JOIN a_phong p ON dp.maPhong = p.maPhong
            WHERE dp.maDatPhong = ?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DatPhong dp = new DatPhong(
                            rs.getInt("maDatPhong"),
                            rs.getInt("maHoaDon"),
                            rs.getInt("maNhanVien"),
                            rs.getInt("maPhong"),
                            rs.getTimestamp("ngayDatPhong"),
                            rs.getTimestamp("ngayNhanPhong"),
                            rs.getTimestamp("ngayHenTra"),
                            rs.getTimestamp("ngayTraPhong"),
                            rs.getTimestamp("ngayThanhToan"),
                            rs.getBigDecimal("tienPhong"),
                            rs.getBigDecimal("tienPhat")
                    );
                    dp.setTenKhachHang(rs.getString("tenKhachHang"));
                    dp.setMaKhachHang(rs.getInt("maKhachHang"));
                    dp.setSoPhong(rs.getString("soPhong"));
                    return dp;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // GET ALL BY MA HOA DON
    public List<DatPhong> getAllByMaHoaDon(int maHoaDon) {
        List<DatPhong> list = new ArrayList<>();
        String sql = """
            SELECT dp.*, kh.tenKhachHang, kh.maKhachHang, p.soPhong 
            FROM a_datphong dp
            JOIN z_hoadon hd ON dp.maHoaDon = hd.maHoaDon
            JOIN x_khachhang kh ON hd.maKhachHang = kh.maKhachHang
            JOIN a_phong p ON dp.maPhong = p.maPhong
            WHERE dp.maHoaDon = ?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maHoaDon);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DatPhong dp = new DatPhong(
                            rs.getInt("maDatPhong"),
                            rs.getInt("maHoaDon"),
                            rs.getInt("maNhanVien"),
                            rs.getInt("maPhong"),
                            rs.getTimestamp("ngayDatPhong"),
                            rs.getTimestamp("ngayNhanPhong"),
                            rs.getTimestamp("ngayHenTra"),
                            rs.getTimestamp("ngayTraPhong"),
                            rs.getTimestamp("ngayThanhToan"),
                            rs.getBigDecimal("tienPhong"),
                            rs.getBigDecimal("tienPhat")
                    );
                    dp.setTenKhachHang(rs.getString("tenKhachHang"));
                    dp.setMaKhachHang(rs.getInt("maKhachHang"));
                    dp.setSoPhong(rs.getString("soPhong"));
                    list.add(dp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ADD BOOKING
    public boolean add(DatPhong d) {

        String sql = """
            INSERT INTO a_datphong 
            (maHoaDon, maNhanVien, maPhong, ngayDatPhong, ngayNhanPhong, 
             ngayHenTra, tienPhong, tienPhat)
            VALUES (?,?,?,?,?,?,?,?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, d.getMaHoaDon());
            ps.setInt(2, d.getMaNhanVien());
            ps.setInt(3, d.getMaPhong());
            ps.setTimestamp(4, d.getNgayDatPhong());
            ps.setTimestamp(5, d.getNgayNhanPhong());
            ps.setTimestamp(6, d.getNgayHenTra());
            ps.setBigDecimal(7, d.getTienPhong()); // Đổi từ setDouble sang setBigDecimal
            ps.setBigDecimal(8, d.getTienPhat());  // Đổi từ setDouble sang setBigDecimal

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // UPDATE WHEN TRẢ PHÒNG
    public boolean traPhong(int id, Timestamp ngayTra, BigDecimal tienPhong, BigDecimal tienPhat) { // Cập nhật kiểu tham số

        String sql = """
            UPDATE a_datphong
            SET ngayTraPhong = ?,
                ngayThanhToan = ?,
                tienPhat = ?
            WHERE maDatPhong = ?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, ngayTra);
            ps.setTimestamp(2, ngayTra);
            ps.setBigDecimal(3, tienPhat); // Đổi từ setDouble sang setBigDecimal
            ps.setInt(4, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // DELETE BOOKING
    public boolean delete(int id) {
        String sql = "DELETE FROM a_datphong WHERE maDatPhong=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}