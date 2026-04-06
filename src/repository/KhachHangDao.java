package repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import config.DBConnection;
import model.KhachHang;

public class KhachHangDao {

    public List<KhachHang> getAll() {
        List<KhachHang> list = new ArrayList<>();
        String sql = "SELECT * FROM x_khachhang";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new KhachHang(
                        rs.getInt("maKhachHang"),
                        rs.getString("tenKhachHang"),
                        rs.getString("soDienThoai"),
                        rs.getString("email")));
            }
        } catch (Exception e) {
            System.out.println("❌ Lỗi getAll: " + e.getMessage());
        }
        return list;
    }

    public boolean insert(KhachHang kh) {
        String sql = "INSERT INTO x_khachhang (tenKhachHang, soDienThoai, email) VALUES (?,?,?)";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, kh.getTenKhachHang());
            ps.setString(2, kh.getSoDienThoai());
            ps.setString(3, kh.getEmail());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi insert: " + e.getMessage());
            return false;
        }
    }

    public boolean update(KhachHang kh) {
        String sql = "UPDATE x_khachhang SET tenKhachHang=?, soDienThoai=?, email=? WHERE maKhachHang=?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, kh.getTenKhachHang());
            ps.setString(2, kh.getSoDienThoai());
            ps.setString(3, kh.getEmail());
            ps.setInt(4, kh.getMaKhachHang());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi update: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM x_khachhang WHERE maKhachHang=?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi delete: " + e.getMessage());
            return false;
        }
    }

    public KhachHang getById(int id) {
        String sql = "SELECT * FROM x_khachhang WHERE maKhachHang=?";
        KhachHang kh = null;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                kh = new KhachHang(
                        rs.getInt("maKhachHang"),
                        rs.getString("tenKhachHang"),
                        rs.getString("soDienThoai"),
                        rs.getString("email"));
            }

            rs.close();
        } catch (Exception e) {
            System.out.println("❌ Lỗi getById: " + e.getMessage());
        }

        return kh;
    }

    public int countKhachHang() {
        String sql = "SELECT COUNT(*) FROM x_khachhang";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi countKhachHang: " + e.getMessage());
        }
        return 0;
    }

    public List<KhachHang> search(String keyword) {
        List<KhachHang> list = new ArrayList<>();
        String sql = "SELECT * FROM x_khachhang WHERE tenKhachHang LIKE ? OR soDienThoai LIKE ?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            String query = "%" + keyword + "%";
            ps.setString(1, query);
            ps.setString(2, query);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new KhachHang(
                        rs.getInt("maKhachHang"),
                        rs.getString("tenKhachHang"),
                        rs.getString("soDienThoai"),
                        rs.getString("email")));
            }
        } catch (Exception e) {
            System.out.println("❌ Lỗi search: " + e.getMessage());
        }
        return list;
    }

}
