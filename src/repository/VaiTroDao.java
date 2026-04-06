package repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import config.DBConnection;
import model.VaiTro;

public class VaiTroDao {

    public List<VaiTro> getAll() {
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
            System.out.println("Lỗi getAll VaiTro: " + e.getMessage());
        }
        return list;
    }

    public boolean insert(VaiTro vt) {
        String sql = "INSERT INTO y_vaitro (tenVaiTro) VALUES (?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, vt.getTenVaiTro());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Lỗi insert VaiTro: " + e.getMessage());
            return false;
        }
    }

    public boolean update(VaiTro vt) {
        String sql = "UPDATE y_vaitro SET tenVaiTro=? WHERE maVaiTro=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, vt.getTenVaiTro());
            ps.setInt(2, vt.getMaVaiTro());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Lỗi update VaiTro: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM y_vaitro WHERE maVaiTro=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Lỗi delete VaiTro: " + e.getMessage());
            return false;
        }
    }
}
