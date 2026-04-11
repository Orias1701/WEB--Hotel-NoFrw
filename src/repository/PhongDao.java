package repository;

import config.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.LoaiPhong;
import model.Phong;

public class PhongDao {

    // Lấy danh sách phòng
    public List<Phong> getAll() {
        List<Phong> list = new ArrayList<>();
        String sql = """
                    SELECT p.maPhong, p.soPhong, p.maLoaiPhong, l.tenLoaiPhong, p.trangThai
                    FROM a_phong p
                    LEFT JOIN a_loaiphong l ON p.maLoaiPhong = l.maLoaiPhong
                    ORDER BY p.maPhong DESC
                """;

        try (Connection conn = DBConnection.getConnection();
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                list.add(new Phong(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getInt(3),
                        rs.getString(4),
                        rs.getString(5)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm phòng
    public boolean add(Phong p) {
        String sql = "INSERT INTO a_phong(soPhong, maLoaiPhong, trangThai) VALUES(?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getSoPhong());
            ps.setInt(2, p.getMaLoaiPhong());
            ps.setString(3, p.getTrangThai());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật phòng
    public boolean update(Phong p) {
        String sql = "UPDATE a_phong SET soPhong=?, maLoaiPhong=?, trangThai=? WHERE maPhong=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getSoPhong());
            ps.setInt(2, p.getMaLoaiPhong());
            ps.setString(3, p.getTrangThai());
            ps.setInt(4, p.getMaPhong());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa phòng
    public boolean delete(int id) {
        String sql = "DELETE FROM a_phong WHERE maPhong=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy phòng theo ID
    public Phong getById(int id) {
        String sql = "SELECT maPhong, soPhong, maLoaiPhong, trangThai FROM a_phong WHERE maPhong = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Phong(
                        rs.getInt("maPhong"),
                        rs.getString("soPhong"),
                        rs.getInt("maLoaiPhong"),
                        null, // tenLoaiPhong not needed for byId usually, or fetch it if needed
                        rs.getString("trangThai"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy loại phòng qua mã phòng
    public LoaiPhong getLoaiPhongByPhong(int maPhong) {
        String sql = """
                    SELECT lp.* FROM a_phong p
                    JOIN a_loaiphong lp ON p.maLoaiPhong = lp.maLoaiPhong
                    WHERE p.maPhong = ?
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maPhong);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new LoaiPhong(
                        rs.getInt("maLoaiPhong"),
                        rs.getString("tenLoaiPhong"),
                        rs.getBigDecimal("giaCoBan"));
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi getLoaiPhongByPhong: " + e.getMessage());
        }
        return null;
    }

    // Cập nhật trạng thái phòng (Trống / Đã đặt / Đang ở)
    public boolean updateStatus(int maPhong, String trangThai) {
        String sql = "UPDATE a_phong SET trangThai=? WHERE maPhong=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, trangThai);
            ps.setInt(2, maPhong);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countPhongTrong() {
        String sql = "SELECT COUNT(*) FROM a_phong WHERE LTRIM(RTRIM(trangThai)) = 'Trống'";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi countPhongTrong: " + e.getMessage());
        }
        return 0;
    }

    public int countPhongDangSuDung() {
        String sql = """
                    SELECT COUNT(*)
                    FROM a_phong
                    WHERE LTRIM(RTRIM(trangThai)) <> 'Trống'
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi countPhongDangSuDung: " + e.getMessage());
        }
        return 0;
    }

}
