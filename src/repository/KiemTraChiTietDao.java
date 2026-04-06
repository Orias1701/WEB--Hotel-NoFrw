package repository;

import config.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.KiemTraChiTiet;

public class KiemTraChiTietDao {

    private Connection conn = DBConnection.getConnection();

    // GET ALL
    public List<KiemTraChiTiet> getAll() {
        List<KiemTraChiTiet> list = new ArrayList<>();
        String sql = """
            SELECT ktct.*, p.soPhong, tb.tenThietBi 
            FROM b_kiemtrachitiet ktct
            LEFT JOIN b_kiemtraphong ktp ON ktct.maKiemTraPhong = ktp.maKiemTraPhong
            LEFT JOIN a_phong p ON ktp.maPhong = p.maPhong
            LEFT JOIN b_thietbiphong tbp ON ktct.maThietBiPhong = tbp.maThietBiPhong
            LEFT JOIN b_thietbi tb ON tbp.maThietBi = tb.maThietBi
            ORDER BY ktct.maKiemTraChiTiet DESC
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                KiemTraChiTiet ktct = new KiemTraChiTiet(
                        rs.getInt("maKiemTraChiTiet"),
                        rs.getInt("maNhanVien"),
                        rs.getInt("maKiemTraPhong"),
                        rs.getInt("maThietBiPhong"),
                        rs.getTimestamp("ngayKiemTra"),
                        rs.getInt("soLuongBiHong"),
                        rs.getString("ghiChu")
                );
                ktct.setTenPhong(rs.getString("soPhong"));
                ktct.setTenThietBi(rs.getString("tenThietBi"));
                list.add(ktct);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // GET BY ID
    public KiemTraChiTiet getById(int id) {
        String sql = """
            SELECT ktct.*, p.soPhong, tb.tenThietBi 
            FROM b_kiemtrachitiet ktct
            LEFT JOIN b_kiemtraphong ktp ON ktct.maKiemTraPhong = ktp.maKiemTraPhong
            LEFT JOIN a_phong p ON ktp.maPhong = p.maPhong
            LEFT JOIN b_thietbiphong tbp ON ktct.maThietBiPhong = tbp.maThietBiPhong
            LEFT JOIN b_thietbi tb ON tbp.maThietBi = tb.maThietBi
            WHERE ktct.maKiemTraChiTiet = ?
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    KiemTraChiTiet ktct = new KiemTraChiTiet(
                            rs.getInt("maKiemTraChiTiet"),
                            rs.getInt("maNhanVien"),
                            rs.getInt("maKiemTraPhong"),
                            rs.getInt("maThietBiPhong"),
                            rs.getTimestamp("ngayKiemTra"),
                            rs.getInt("soLuongBiHong"),
                            rs.getString("ghiChu")
                    );
                    ktct.setTenPhong(rs.getString("soPhong"));
                    ktct.setTenThietBi(rs.getString("tenThietBi"));
                    return ktct;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ADD
    public boolean add(KiemTraChiTiet ktct) {
        String sql = "INSERT INTO b_kiemtrachitiet (maNhanVien, maKiemTraPhong, maThietBiPhong, ngayKiemTra, soLuongBiHong, ghiChu) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ktct.getMaNhanVien());
            ps.setInt(2, ktct.getMaKiemTraPhong());
            ps.setInt(3, ktct.getMaThietBiPhong());
            ps.setTimestamp(4, new Timestamp(ktct.getNgayKiemTra().getTime()));
            ps.setInt(5, ktct.getSoLuongBiHong());
            ps.setString(6, ktct.getGhiChu());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // UPDATE
    public boolean update(KiemTraChiTiet ktct) {
        String sql = "UPDATE b_kiemtrachitiet SET maNhanVien=?, maKiemTraPhong=?, maThietBiPhong=?, ngayKiemTra=?, soLuongBiHong=?, ghiChu=? WHERE maKiemTraChiTiet=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ktct.getMaNhanVien());
            ps.setInt(2, ktct.getMaKiemTraPhong());
            ps.setInt(3, ktct.getMaThietBiPhong());
            ps.setTimestamp(4, new Timestamp(ktct.getNgayKiemTra().getTime()));
            ps.setInt(5, ktct.getSoLuongBiHong());
            ps.setString(6, ktct.getGhiChu());
            ps.setInt(7, ktct.getMaKiemTraChiTiet());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // DELETE
    public boolean delete(int id) {
        String sql = "DELETE FROM b_kiemtrachitiet WHERE maKiemTraChiTiet=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<KiemTraChiTiet> getAllByMaKiemTraPhong(int maKiemTraPhong) {
        List<KiemTraChiTiet> list = new ArrayList<>();
        String sql = "SELECT * FROM b_kiemtrachitiet WHERE maKiemTraPhong = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maKiemTraPhong);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                KiemTraChiTiet ktct = new KiemTraChiTiet();
                ktct.setMaKiemTraChiTiet(rs.getInt("maKiemTraChiTiet"));
                ktct.setMaKiemTraPhong(rs.getInt("maKiemTraPhong"));
                ktct.setMaThietBiPhong(rs.getInt("maThietBiPhong"));
                ktct.setSoLuongBiHong(rs.getInt("soLuongBiHong"));
                list.add(ktct);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
}
