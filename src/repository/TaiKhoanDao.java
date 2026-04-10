package repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import config.DBConnection;
import model.NhanVien;
import model.TaiKhoan;
import model.VaiTro;

public class TaiKhoanDao {

    public List<TaiKhoan> getAll() {
        List<TaiKhoan> list = new ArrayList<>();
        String sql = """
            SELECT tk.*, nv.tenNhanVien, vt.tenVaiTro 
            FROM y_taikhoan tk
            JOIN y_nhanvien nv ON tk.maNhanVien = nv.maNhanVien
            JOIN y_vaitro vt ON tk.maVaiTro = vt.maVaiTro
            ORDER BY tk.id DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TaiKhoan tk = new TaiKhoan(
                        rs.getInt("id"),
                        rs.getString("taiKhoan"),
                        rs.getString("matKhau"),
                        rs.getInt("maNhanVien"),
                        rs.getInt("maVaiTro")
                );
                tk.setTenNhanVien(rs.getString("tenNhanVien"));
                tk.setTenVaiTro(rs.getString("tenVaiTro"));
                list.add(tk);
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi getAll TK: " + e.getMessage());
        }
        return list;
    }

    public List<TaiKhoan> getByMaNhanVien(int maNV) {
        List<TaiKhoan> list = new ArrayList<>();
        String sql = """
            SELECT tk.*, nv.tenNhanVien, vt.tenVaiTro 
            FROM y_taikhoan tk
            JOIN y_nhanvien nv ON tk.maNhanVien = nv.maNhanVien
            JOIN y_vaitro vt ON tk.maVaiTro = vt.maVaiTro
            WHERE tk.maNhanVien = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maNV);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                TaiKhoan tk = new TaiKhoan(
                        rs.getInt("id"),
                        rs.getString("taiKhoan"),
                        rs.getString("matKhau"),
                        rs.getInt("maNhanVien"),
                        rs.getInt("maVaiTro")
                );
                tk.setTenNhanVien(rs.getString("tenNhanVien"));
                tk.setTenVaiTro(rs.getString("tenVaiTro"));
                list.add(tk);
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi getByMaNhanVien TK: " + e.getMessage());
        }
        return list;
    }

    public boolean insert(TaiKhoan tk) {
        String sql = "INSERT INTO y_taikhoan (taiKhoan, matKhau, maNhanVien, maVaiTro) VALUES (?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, tk.getTaiKhoan());
            ps.setString(2, tk.getMatKhau());
            ps.setInt(3, tk.getMaNhanVien());
            ps.setInt(4, tk.getMaVaiTro());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi insert TK: " + e.getMessage());
            return false;
        }
    }

    public boolean update(TaiKhoan tk) {
        String sql = "UPDATE y_taikhoan SET taiKhoan=?, matKhau=?, maNhanVien=?, maVaiTro=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, tk.getTaiKhoan());
            ps.setString(2, tk.getMatKhau());
            ps.setInt(3, tk.getMaNhanVien());
            ps.setInt(4, tk.getMaVaiTro());
            ps.setInt(5, tk.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi update TK: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM y_taikhoan WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi delete TK: " + e.getMessage());
            return false;
        }
    }

    public boolean updatePassword(int id, String newPass) {
        String sql = "UPDATE y_taikhoan SET matKhau=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newPass);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi updatePassword TK: " + e.getMessage());
            return false;
        }
    }

    public boolean updateAccount(int id, String newUser, String newPass) {
        String sql = "UPDATE y_taikhoan SET taiKhoan=?, matKhau=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newUser);
            ps.setString(2, newPass);
            ps.setInt(3, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("❌ Lỗi updateAccount TK: " + e.getMessage());
            return false;
        }
    }


    //------------------- LẤY NHÂN VIÊN ------------------
    public List<NhanVien> loadNhanVien() {
        List<NhanVien> list = new ArrayList<>();
        String sql = "SELECT * FROM y_nhanvien";

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
            System.out.println("❌ Lỗi loadNhanVien: " + e.getMessage());
        }
        return list;
    }

    //------------------- LẤY VAI TRÒ ------------------
    public List<VaiTro> loadVaiTro() {
        List<VaiTro> list = new ArrayList<>();
        String sql = "SELECT * FROM y_vaitro";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new VaiTro(
                        rs.getInt("maVaiTro"),
                        rs.getString("tenVaiTro")
                ));
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi loadVaiTro: " + e.getMessage());
        }
        return list;
    }

    public TaiKhoan checkLogin(String taiKhoan, String matKhau) {
        String sql = """
            SELECT tk.*, nv.tenNhanVien, vt.tenVaiTro 
            FROM y_taikhoan tk
            JOIN y_nhanvien nv ON tk.maNhanVien = nv.maNhanVien
            JOIN y_vaitro vt ON tk.maVaiTro = vt.maVaiTro
            WHERE tk.taiKhoan=? AND tk.matKhau=?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, taiKhoan);
            ps.setString(2, matKhau);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                TaiKhoan tk = new TaiKhoan(
                        rs.getInt("id"),
                        rs.getString("taiKhoan"),
                        rs.getString("matKhau"),
                        rs.getInt("maNhanVien"),
                        rs.getInt("maVaiTro")
                );
                tk.setTenNhanVien(rs.getString("tenNhanVien"));
                tk.setTenVaiTro(rs.getString("tenVaiTro"));
                return tk;
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi checkLogin: " + e.getMessage());
        }

        return null;
    }

}
