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
}
