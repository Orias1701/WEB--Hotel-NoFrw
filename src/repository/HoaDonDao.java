package repository;

import config.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.HoaDon;

public class HoaDonDao {

    private Connection conn = DBConnection.getConnection();

    // ================= GET ALL (Optimized with Details) =================
    public List<HoaDon> getAll() {
        Map<Integer, HoaDon> map = new LinkedHashMap<>();

        // Join with DatPhong and Phong to get room details in one shot (Avoid N+1)
        String sql = """
                    SELECT hd.*, kh.tenKhachHang, nv.tenNhanVien,
                           dp.maDatPhong, dp.maPhong, dp.tienPhong, dp.tienPhat, p.soPhong
                    FROM z_hoadon hd
                    JOIN x_khachhang kh ON hd.maKhachHang = kh.maKhachHang
                    JOIN y_nhanvien nv ON hd.maNhanVien = nv.maNhanVien
                    LEFT JOIN a_datphong dp ON hd.maHoaDon = dp.maHoaDon
                    LEFT JOIN a_phong p ON dp.maPhong = p.maPhong
                    ORDER BY hd.maHoaDon DESC
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int maHD = rs.getInt("maHoaDon");
                HoaDon hd = map.get(maHD);
                
                if (hd == null) {
                    hd = new HoaDon(
                        maHD,
                        rs.getInt("maNhanVien"),
                        rs.getInt("maKhachHang"),
                        rs.getTimestamp("ngayTao"),
                        rs.getTimestamp("ngayThanhToan"),
                        rs.getBigDecimal("tongTien"),
                        rs.getString("trangThai"));
                    hd.setTenKhachHang(rs.getString("tenKhachHang"));
                    hd.setTenNhanVien(rs.getString("tenNhanVien"));
                    map.put(maHD, hd);
                }

                // Add room detail if exists
                int maDP = rs.getInt("maDatPhong");
                if (maDP > 0) {
                    model.DatPhong dp = new model.DatPhong();
                    dp.setMaDatPhong(maDP);
                    dp.setMaPhong(rs.getInt("maPhong"));
                    dp.setSoPhong(rs.getString("soPhong"));
                    dp.setTienPhong(rs.getBigDecimal("tienPhong"));
                    dp.setTienPhat(rs.getBigDecimal("tienPhat"));
                    hd.getChiTiet().add(dp);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(map.values());
    }


    // ================= GET BY ID =================
    public HoaDon getById(int id) {

        String sql = """
                    SELECT hd.*, kh.tenKhachHang, nv.tenNhanVien
                    FROM z_hoadon hd
                    JOIN x_khachhang kh ON hd.maKhachHang = kh.maKhachHang
                    JOIN y_nhanvien nv ON hd.maNhanVien = nv.maNhanVien
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
                hd.setTenNhanVien(rs.getString("tenNhanVien"));
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
            ps.setString(5, "Ch thanh toán");

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
            ps.setString(5, "Ch thanh toán");

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
                        COALESCE(SUM(h.tongTien), 0) AS doanhThu
                    FROM z_hoadon h
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