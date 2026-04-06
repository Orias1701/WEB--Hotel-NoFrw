package controller;

import java.util.List;

import model.HoaDon;
import model.KhachHang;
import service.KhachHangService;

public class KhachHangController {

    private KhachHangService service = new KhachHangService();
    private HoaDonController hoaDonController = new HoaDonController();

    public List<KhachHang> getAllKhachHang() {
        return service.getAll();
    }

    public boolean addKhachHang(KhachHang kh) {
        return service.add(kh);
    }

    public boolean updateKhachHang(KhachHang kh) {
        return service.update(kh);
    }

    public boolean deleteKhachHang(int id) {
        return service.delete(id);
    }

    public KhachHang getById(int id) {
        return service.getById(id);
    }

    public KhachHang getByHoaDon(int maHoaDon) {
        HoaDon hd = hoaDonController.getById(maHoaDon);
        if (hd == null)
            return null;
        return service.getById(hd.getMaKhachHang());
    }

    public int countKhachHang() {
        return service.countKhachHang();
    }

    public List<KhachHang> search(String keyword) {
        return service.search(keyword);
    }

}
