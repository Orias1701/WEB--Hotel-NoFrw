package controller;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import model.HoaDon;
import model.KiemTraPhong;
import service.HoaDonService;

public class HoaDonController {

    private HoaDonService service = new HoaDonService();
    private KiemTraPhongController ktpController = new KiemTraPhongController();

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

    public int createWithKiemTraPhong(HoaDon hd, int maPhong) {
        int maHD = create(hd);
        if (maHD <= 0)
            return -1;

        KiemTraPhong ktp = new KiemTraPhong();
        ktp.setMaHoaDon(maHD);
        ktp.setMaPhong(maPhong);
        ktp.setNgayThanhToan(null); // ban đầu để null
        ktp.setTienBoiThuong(BigDecimal.ZERO);

        ktpController.add(ktp);
        return maHD;
    }

    /**
     * Đồng bộ ngày thanh toán của KiemTraPhong khi hóa đơn được thanh toán
     */
    public boolean updateNgayThanhToan(int maHD, Timestamp ngayThanhToan) {
        try {
            // Cập nhật ngày thanh toán cho KiemTraPhong
            return ktpController.updateNgayThanhToanByHoaDon(maHD, ngayThanhToan);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public BigDecimal getDoanhThu() {
        return service.getDoanhThu();
    }

}
