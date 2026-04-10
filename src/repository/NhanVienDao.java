package repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import config.DBConnection;
import model.NhanVien;

public class NhanVienDao {

    public List<NhanVien> getAll() {
        List<NhanVien> list = new ArrayList<>();
        String sql = "SELECT * FROM y_nhanvien ORDER BY maNhanVien DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new NhanVien(
                        rs.getInt("maNhanVien"),
                        rs.getString("tenNhanVien"),
                        rs.getString("soDienThoai"),
                        rs.getString("email")
                ));
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi getAll NV: " + e.getMessage());
        }
        return list;
    }

    public NhanVien getById(int id) {
        String sql = "SELECT * FROM y_nhanvien WHERE maNhanVien = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new NhanVien(
                        rs.getInt("maNhanVien"),
                        rs.getString("tenNhanVien"),
                        rs.getString("soDienThoai"),
                        rs.getString("email")
                );
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi getById NV: " + e.getMessage());
        }

        return null; // không tìm thấy
    }



    public int insertAndReturnId(NhanVien nv) {
        String sql = "INSERT INTO y_nhanvien (tenNhanVien, soDienThoai, email) VALUES (?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, nv.getTenNhanVien());
            ps.setString(2, nv.getSoDienThoai());
            ps.setString(3, nv.getEmail());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            System.out.println("❌ Lỗi insert NV: " + e.getMessage());
        }
        return -1;
    }

    public boolean update(NhanVien nv) {
        String sql = "UPDATE y_nhanvien SET tenNhanVien=?, soDienThoai=?, email=? WHERE maNhanVien=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nv.getTenNhanVien());
            ps.setString(2, nv.getSoDienThoai());
            ps.setString(3, nv.getEmail());
            ps.setInt(4, nv.getMaNhanVien());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi update NV: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM y_nhanvien WHERE maNhanVien=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi delete NV: " + e.getMessage());
            return false;
        }
    }

    public int countNhanVien() {
    String sql = "SELECT COUNT(*) FROM y_nhanvien";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            return rs.getInt(1);   
        }

    } catch (Exception e) {
        System.out.println("❌ Lỗi countNhanVien: " + e.getMessage());
    }
    return 0;
}
}
