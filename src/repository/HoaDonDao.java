package repository;

import config.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List; // Import BigDecimal
import model.HoaDon;

public class HoaDonDao {

    private Connection conn = DBConnection.getConnection();

    // ================= GET ALL =================
    public List<HoaDon> getAll() {
        List<HoaDon> list = new ArrayList<>();

        String sql = """
            SELECT hd.*, kh.tenKhachHang 
            FROM z_hoadon hd
            JOIN x_khachhang kh ON hd.maKhachHang = kh.maKhachHang
            ORDER BY hd.maHoaDon DESC
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                HoaDon hd = new HoaDon(
                        rs.getInt("maHoaDon"),
                        rs.getInt("maNhanVien"),
                        rs.getInt("maKhachHang"),
                        rs.getTimestamp("ngayTao"),
                        rs.getTimestamp("ngayThanhToan"),
                        rs.getBigDecimal("tongTien"),
                        rs.getString("trangThai"));
                hd.setTenKhachHang(rs.getString("tenKhachHang"));
                list.add(hd);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= GET BY ID =================
    public HoaDon getById(int id) {

        String sql = """
            SELECT hd.*, kh.tenKhachHang 
            FROM z_hoadon hd
            JOIN x_khachhang kh ON hd.maKhachHang = kh.maKhachHang
            WHERE hd.maHoaDon=?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HoaDon hd = new HoaDon(
                        rs.getInt("maHoaDon"),
                        rs.getInt("maNhanVien"),
                        rs.getInt("maKhachHang"),
                        rs.getTimestamp("ngayTao"),
                        rs.getTimestamp("ngayThanhToan"),
                        rs.getBigDecimal("tongTien"),
                        rs.getString("trangThai"));
                hd.setTenKhachHang(rs.getString("tenKhachHang"));
                return hd;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ================= GET BY KHACH HANG =================
    public List<HoaDon> getByKhachHang(int maKhachHang) {
        List<HoaDon> list = new ArrayList<>();
        String sql = "SELECT * FROM z_hoadon WHERE maKhachHang = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maKhachHang);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new HoaDon(
                        rs.getInt("maHoaDon"),
                        rs.getInt("maNhanVien"),
                        rs.getInt("maKhachHang"),
                        rs.getTimestamp("ngayTao"),
                        rs.getTimestamp("ngayThanhToan"),
                        rs.getBigDecimal("tongTien"),
                        rs.getString("trangThai")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= CREATE =================
    public int create(HoaDon hd) {

        String sql = """
                    INSERT INTO z_hoadon(maNhanVien, maKhachHang, ngayTao, tongTien, trangThai)
                    VALUES (?,?,?,?,?)
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, hd.getMaNhanVien());
            ps.setInt(2, hd.getMaKhachHang());
            ps.setTimestamp(3, hd.getNgayTao());
            ps.setBigDecimal(4, hd.getTongTien()); // Đổi từ setDouble sang setBigDecimal
            ps.setString(5, "Chưa thanh toán");

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next())
                return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    // ================= UPDATE =================
    public boolean update(HoaDon hd) {
        String sql = """
                    UPDATE z_hoadon SET
                        maNhanVien=?,
                        maKhachHang=?,
                        ngayTao=?,
                        ngayThanhToan=?,
                        tongTien=?,
                        trangThai=?
                    WHERE maHoaDon=?
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, hd.getMaNhanVien());
            ps.setInt(2, hd.getMaKhachHang());
            ps.setTimestamp(3, hd.getNgayTao());
            ps.setTimestamp(4, hd.getNgayThanhToan());
            ps.setBigDecimal(5, hd.getTongTien()); // Đổi từ setDouble sang setBigDecimal
            ps.setString(6, hd.getTrangThai());
            ps.setInt(7, hd.getMaHoaDon());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= DELETE =================
    public boolean delete(int maHD) {
        String sql = "DELETE FROM z_hoadon WHERE maHoaDon = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maHD);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= UPDATE TỔNG TIỀN =================
    public boolean updateTongTien(int maHD, BigDecimal tongTien) { // Cập nhật kiểu tham số

        String sql = "UPDATE z_hoadon SET tongTien=?, ngayThanhToan=? WHERE maHoaDon=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBigDecimal(1, tongTien); // Đổi từ setDouble sang setBigDecimal
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis())); // GIỜ ĐÚNG 100%
            ps.setInt(3, maHD);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= UPDATE TRẠNG THÁI =================
    public boolean updateTrangThai(int maHD, String trangThai) {
        String sql = "UPDATE z_hoadon SET trangThai = ? WHERE maHoaDon = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, trangThai);
            ps.setInt(2, maHD);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Tạo Hóa Đơn dùng connection truyền vào (hỗ trợ transaction)
     * Trả về maHoaDon mới tạo
     */
    public int createWithConnection(HoaDon hd, Connection conn) throws SQLException {
        String sql = """
                    INSERT INTO z_hoadon(maNhanVien, maKhachHang, ngayTao, tongTien, trangThai)
                    VALUES (?,?,?,?,?)
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, hd.getMaNhanVien());
            ps.setInt(2, hd.getMaKhachHang());
            ps.setTimestamp(3, hd.getNgayTao());
            ps.setBigDecimal(4, hd.getTongTien()); // Đổi từ setDouble sang setBigDecimal
            ps.setString(5, "Chưa thanh toán");

            int affected = ps.executeUpdate();
            if (affected == 0)
                throw new SQLException("Tạo Hóa Đơn thất bại, không có hàng nào bị ảnh hưởng.");

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next())
                    return rs.getInt(1);
            }

            throw new SQLException("Tạo Hóa Đơn thất bại, không lấy được maHoaDon.");
        }
    }

    // Doanh thu tháng hiện tại = tổng tiền hóa đơn + tiền bồi thường
    public BigDecimal getDoanhThu() {
        String sql = """
                    SELECT
                        COALESCE(SUM(h.tongTien), 0) + COALESCE(SUM(k.tienBoiThuong), 0) AS doanhThu
                    FROM z_hoadon h
                    LEFT JOIN b_kiemtraphong k ON h.maHoaDon = k.maHoaDon
                    WHERE h.trangThai = 'Đã thanh toán'
                    AND EXTRACT(MONTH FROM h.ngayThanhToan) = EXTRACT(MONTH FROM CURRENT_TIMESTAMP)
                    AND EXTRACT(YEAR FROM h.ngayThanhToan) = EXTRACT(YEAR FROM CURRENT_TIMESTAMP);
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal("doanhThu");
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi getDoanhThu: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

}