package repository;

import config.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List; // Import cần thiết
import model.LoaiPhong;

public class LoaiPhongDao {

    public List<LoaiPhong> getAll() {
        List<LoaiPhong> list = new ArrayList<>();
        String sql = "SELECT * FROM a_loaiphong";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new LoaiPhong(
                        rs.getInt("maLoaiPhong"),
                        rs.getString("tenLoaiPhong"),
                        // ✅ Đã sửa: Dùng getBigDecimal()
                        rs.getBigDecimal("giaCoBan") 
                ));
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi load LoaiPhong: " + e.getMessage());
        }
        return list;
    }

    public boolean insert(LoaiPhong lp) {
        String sql = "INSERT INTO a_LoaiPhong (tenLoaiPhong, giaCoBan) VALUES (?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, lp.getTenLoaiPhong());
            // ✅ Đã sửa: Dùng setBigDecimal()
            ps.setBigDecimal(2, lp.getGiaCoBan()); 

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi insert LP: " + e.getMessage());
            return false;
        }
    }

    public boolean update(LoaiPhong lp) {
        String sql = "UPDATE a_LoaiPhong SET tenLoaiPhong=?, giaCoBan=? WHERE maLoaiPhong=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, lp.getTenLoaiPhong());
            // ✅ Đã sửa: Dùng setBigDecimal()
            ps.setBigDecimal(2, lp.getGiaCoBan()); 
            ps.setInt(3, lp.getMaLoaiPhong());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi update LP: " + e.getMessage());
            return false;
        }
    }
    
    // Phương thức delete không liên quan đến BigDecimal nên giữ nguyên
    public boolean delete(int id) {
        String sql = "DELETE FROM a_LoaiPhong WHERE maLoaiPhong=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi delete LP: " + e.getMessage());
            return false;
        }
    }
}