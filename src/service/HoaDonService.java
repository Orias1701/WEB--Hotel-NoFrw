package service;

import java.math.BigDecimal;
import java.util.List; // Import BigDecimal
import model.HoaDon;
import repository.HoaDonDao;

public class HoaDonService {

    private HoaDonDao repo = new HoaDonDao();

    public List<HoaDon> getAll() {
        return repo.getAll();
    }

    public HoaDon getById(int id) {
        return repo.getById(id);
    }

    public List<HoaDon> getByKhachHang(int maKhachHang) {
        return repo.getByKhachHang(maKhachHang);
    }

    public int create(HoaDon hd) {
        return repo.create(hd);
    }

    public boolean update(HoaDon hd) {
        return repo.update(hd);
    }

    public boolean delete(int id) {
        return repo.delete(id);
    }

    public boolean updateTongTien(int maHD, BigDecimal tongTien) { // Cập nhật kiểu tham số
        return repo.updateTongTien(maHD, tongTien);
    }

    public boolean updateTrangThai(int maHD, String trangThai) {
        return repo.updateTrangThai(maHD, trangThai);
    }

    public BigDecimal getDoanhThu() {
        return repo.getDoanhThu();
    }
}