package repository;

import config.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ThietBi;

public class ThietBiDao {

    private Connection conn = DBConnection.getConnection();

    // GET ALL
    public List<ThietBi> getAll() {
        List<ThietBi> list = new ArrayList<>();
        String sql = "SELECT * FROM b_thietbi ORDER BY maThietBi DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new ThietBi(
                        rs.getInt("maThietBi"),
                        rs.getString("tenThietBi"),
                        rs.getBigDecimal("giaThietBi") // BigDecimal
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // GET BY ID
    public ThietBi getById(int id) {
        String sql = "SELECT * FROM b_thietbi WHERE maThietBi = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ThietBi(
                            rs.getInt("maThietBi"),
                            rs.getString("tenThietBi"),
                            rs.getBigDecimal("giaThietBi")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ADD
    public boolean add(ThietBi tb) {
        String sql = "INSERT INTO b_thietbi (tenThietBi, giaThietBi) VALUES (?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tb.getTenThietBi());
            ps.setBigDecimal(2, tb.getGiaThietBi()); // BigDecimal
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // UPDATE
    public boolean update(ThietBi tb) {
        String sql = "UPDATE b_thietbi SET tenThietBi = ?, giaThietBi = ? WHERE maThietBi = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tb.getTenThietBi());
            ps.setBigDecimal(2, tb.getGiaThietBi());
            ps.setInt(3, tb.getMaThietBi());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // DELETE
    public boolean delete(int id) {
        String sql = "DELETE FROM b_thietbi WHERE maThietBi = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public int countThietBi() {
    String sql = "SELECT COUNT(*) FROM b_thietbi";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            return rs.getInt(1);
        }

    } catch (Exception e) {
        System.out.println("❌ Lỗi countThietBi: " + e.getMessage());
    }
    return 0;
}

}
