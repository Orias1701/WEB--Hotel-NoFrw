package repository;

import config.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ThietBiPhong;

public class ThietBiPhongDao {

    private Connection conn = DBConnection.getConnection();

    // GET ALL
    public List<ThietBiPhong> getAll() {
        List<ThietBiPhong> list = new ArrayList<>();
        String sql = """
            SELECT tbp.*, p.soPhong, tb.tenThietBi 
            FROM b_thietbiphong tbp
            JOIN a_phong p ON tbp.maPhong = p.maPhong
            JOIN b_thietbi tb ON tbp.maThietBi = tb.maThietBi
            ORDER BY tbp.maThietBiPhong DESC
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ThietBiPhong tbp = new ThietBiPhong(
                        rs.getInt("maThietBiPhong"),
                        rs.getInt("maPhong"),
                        rs.getInt("maThietBi"),
                        rs.getInt("soLuong"),
                        rs.getString("trangThai")
                );
                tbp.setSoPhong(rs.getString("soPhong"));
                tbp.setTenThietBi(rs.getString("tenThietBi"));
                list.add(tbp);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // GET BY ID
    public ThietBiPhong getById(int id) {
        String sql = """
            SELECT tbp.*, p.soPhong, tb.tenThietBi 
            FROM b_thietbiphong tbp
            JOIN a_phong p ON tbp.maPhong = p.maPhong
            JOIN b_thietbi tb ON tbp.maThietBi = tb.maThietBi
            WHERE tbp.maThietBiPhong = ?
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ThietBiPhong tbp = new ThietBiPhong(
                            rs.getInt("maThietBiPhong"),
                            rs.getInt("maPhong"),
                            rs.getInt("maThietBi"),
                            rs.getInt("soLuong"),
                            rs.getString("trangThai")
                    );
                    tbp.setSoPhong(rs.getString("soPhong"));
                    tbp.setTenThietBi(rs.getString("tenThietBi"));
                    return tbp;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public List<ThietBiPhong> getThietBiTheoPhong(int maPhong) {
        List<ThietBiPhong> list = new ArrayList<>();
        String sql = "SELECT * FROM b_thietbiphong WHERE maPhong = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maPhong);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ThietBiPhong(
                        rs.getInt("maThietBiPhong"),
                        rs.getInt("maPhong"),
                        rs.getInt("maThietBi"),
                        rs.getInt("soLuong"),
                        rs.getString("trangThai")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    // ADD
    public boolean add(ThietBiPhong tbp) {
        String sql = "INSERT INTO b_thietbiphong (maPhong, maThietBi, soLuong, trangThai) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tbp.getMaPhong());
            ps.setInt(2, tbp.getMaThietBi());
            ps.setInt(3, tbp.getSoLuong());
            ps.setString(4, tbp.getTrangThai());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // UPDATE
    public boolean update(ThietBiPhong tbp) {
        String sql = "UPDATE b_thietbiphong SET maPhong=?, maThietBi=?, soLuong=?, trangThai=? WHERE maThietBiPhong=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tbp.getMaPhong());
            ps.setInt(2, tbp.getMaThietBi());
            ps.setInt(3, tbp.getSoLuong());
            ps.setString(4, tbp.getTrangThai());
            ps.setInt(5, tbp.getMaThietBiPhong());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // DELETE
    public boolean delete(int id) {
        String sql = "DELETE FROM b_thietbiphong WHERE maThietBiPhong=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public ThietBiPhong getByPhongVaThietBi(int maPhong, int maThietBi) {
        String sql = "SELECT * FROM b_thietbiphong WHERE maPhong = ? AND maThietBi = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maPhong);
            ps.setInt(2, maThietBi);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ThietBiPhong tbp = new ThietBiPhong();
                tbp.setMaThietBiPhong(rs.getInt("maThietBiPhong"));
                tbp.setMaPhong(rs.getInt("maPhong"));
                tbp.setMaThietBi(rs.getInt("maThietBi"));
                tbp.setSoLuong(rs.getInt("soLuong"));
                return tbp;
            }
        } catch (SQLException e) {
            e.printStackTrace(); // có thể ném exception lên Service nếu muốn hiển thị GUI
        }
        return null;
    }
    
}
