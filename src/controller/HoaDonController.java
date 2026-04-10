package controller;

import java.math.BigDecimal;
// import java.sql.Timestamp;
import java.util.List;
import model.HoaDon;

import service.HoaDonService;

public class HoaDonController {

    private HoaDonService service = new HoaDonService();

    public List<HoaDon> getAll() {
        return service.getAll();
    }

    public HoaDon getById(int id) {
        return service.getById(id);
    }

    public List<HoaDon> getByKhachHang(int maKhachHang) {
        return service.getByKhachHang(maKhachHang);
    }

    public int create(HoaDon hd) {
        return service.create(hd);
    }

    public boolean update(HoaDon hd) {
        return service.update(hd);
    }

    public boolean delete(int id) {
        return service.delete(id);
    }

    public boolean updateTongTien(int maHD, BigDecimal tongTien) {
        return service.updateTongTien(maHD, tongTien);
    }

    public boolean updateTrangThai(int maHD, String trangThai) {
        return service.updateTrangThai(maHD, trangThai);
    }

    public BigDecimal getDoanhThu() {
        return service.getDoanhThu();
    }

}
