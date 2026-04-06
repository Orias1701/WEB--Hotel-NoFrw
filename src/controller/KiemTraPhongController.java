package controller;

import java.sql.Timestamp;
import java.util.List;
import model.KiemTraPhong;
import service.KiemTraPhongService;

public class KiemTraPhongController {

    private KiemTraPhongService service = new KiemTraPhongService();

    // Lấy tất cả kiểm tra phòng
    public List<KiemTraPhong> getAll() {
        try {
            return service.getAll();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of(); // trả về danh sách rỗng nếu lỗi
        }
    }

    // Thêm kiểm tra phòng
    public boolean add(KiemTraPhong ktp) {
        try {
            return service.add(ktp);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa kiểm tra phòng theo ID
    public boolean delete(int maKiemTraPhong) {
        try {
            return service.delete(maKiemTraPhong);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy 1 kiểm tra phòng theo ID
    public KiemTraPhong getById(int maKiemTraPhong) {
        try {
            return service.getById(maKiemTraPhong);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Cập nhật kiểm tra phòng
    public boolean update(KiemTraPhong ktp) {
        try {
            return service.update(ktp);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateCompensation(int maKiemTraPhong) {
        return service.updateCompensation(maKiemTraPhong);
    }
    public boolean updateNgayThanhToanByHoaDon(int maHoaDon, Timestamp ngayThanhToan) {
        try {
            KiemTraPhongService service = new KiemTraPhongService();
            KiemTraPhong ktp = service.getByMaHoaDon(maHoaDon);
            if (ktp == null) return false;
            ktp.setNgayThanhToan(ngayThanhToan);
            return service.update(ktp);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }    
}
