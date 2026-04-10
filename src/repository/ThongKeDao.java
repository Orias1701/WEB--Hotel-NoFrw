package repository;

import config.DBConnection;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class ThongKeDao {

    // ==================== THỐNG KÊ ĐẶT PHÒNG ====================
    public Map<String, Integer> getSoLuongDatPhongTheoThang() {
        Map<String, Integer> map = new LinkedHashMap<>();

        String sql = """
                    SELECT TO_CHAR(ngayDatPhong, 'YYYY-MM') AS thang,
                           COUNT(*) AS soLuong
                    FROM a_datphong
                    GROUP BY TO_CHAR(ngayDatPhong, 'YYYY-MM')
                    ORDER BY thang ASC
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("thang"), rs.getInt("soLuong"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }

    // ==================== THỐNG KÊ DOANH THU ====================
    public Map<String, Double> getDoanhThuTheoThang() {
        Map<String, Double> map = new LinkedHashMap<>();

        String sql = """
                    SELECT TO_CHAR(ngayThanhToan, 'YYYY-MM') AS thang,
                           COALESCE(SUM(tongTien), 0) AS doanhThu
                    FROM z_hoadon
                    WHERE trangThai = 'Đã thanh toán'
                    GROUP BY TO_CHAR(ngayThanhToan, 'YYYY-MM')
                    ORDER BY thang ASC
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("thang"), rs.getDouble("doanhThu"));
            }

            // Đảm bảo tháng hiện tại luôn có trong biểu đồ
            String currentMonth = java.time.YearMonth.now().toString();
            if (!map.containsKey(currentMonth)) {
                map.put(currentMonth, 0.0);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }
    // ==================== THỐNG KÊ DOANH THU 30 NGÀY ====================
    public Map<String, Double> getDoanhThu30NgayGanNhat() {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = """
            SELECT TO_CHAR(series.active_date, 'DD/MM') AS ngay, 
                   COALESCE(SUM(hd.tongTien), 0) AS doanhThu
            FROM generate_series(CURRENT_DATE - INTERVAL '29 days', CURRENT_DATE, '1 day') AS series(active_date)
            LEFT JOIN z_hoadon hd ON hd.ngayThanhToan::date = series.active_date::date
                                  AND hd.trangThai = 'Đã thanh toán'
            GROUP BY series.active_date
            ORDER BY series.active_date ASC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("ngay"), rs.getDouble("doanhThu"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }

    // ==================== THỐNG KÊ ĐẶT PHÒNG 30 NGÀY ====================
    public Map<String, Integer> getDatPhong30NgayGanNhat() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = """
            SELECT TO_CHAR(series.active_date, 'DD/MM') AS ngay, 
                   COUNT(dp.maDatPhong) AS soLuong
            FROM generate_series(CURRENT_DATE - INTERVAL '29 days', CURRENT_DATE, '1 day') AS series(active_date)
            LEFT JOIN a_datphong dp ON dp.ngayDatPhong::date = series.active_date::date
            GROUP BY series.active_date
            ORDER BY series.active_date ASC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("ngay"), rs.getInt("soLuong"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }

    // ==================== TỶ LỆ TIỀN PHÒNG / PHẠT ====================
    public Map<String, Double> getTiLeTienPhongPhat() {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = "SELECT SUM(tienPhong) as tongTienPhong, SUM(tienPhat) as tongTienPhat FROM a_datphong";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                map.put("Tiền phòng", rs.getDouble("tongTienPhong"));
                map.put("Tiền phạt", rs.getDouble("tongTienPhat"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }
}
