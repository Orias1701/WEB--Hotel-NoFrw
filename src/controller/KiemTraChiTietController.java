package controller;

import java.util.List;
import model.KiemTraChiTiet;
import service.KiemTraChiTietService;

public class KiemTraChiTietController {

    private KiemTraChiTietService service = new KiemTraChiTietService();

    // Lấy tất cả
    public List<KiemTraChiTiet> getAll() {
        try {
            return service.getAll();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of(); // trả về danh sách rỗng nếu lỗi
        }
    }

    // Thêm mới
    public boolean add(KiemTraChiTiet ktct) {
        try {
            return service.add(ktct);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật
    public boolean update(KiemTraChiTiet ktct) {
        try {
            return service.update(ktct);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa
    public boolean delete(int id) {
        try {
            return service.delete(id);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy theo ID
    public KiemTraChiTiet getById(int id) {
        try {
            return service.getById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public int getSoLuongHongTheoKiemTra(int maKiemTraPhong) {
        int tong = 0;
        for (KiemTraChiTiet ktct : getAll()) { // giả sử getAll() trả List<KiemTraChiTiet>
            if (ktct.getMaKiemTraPhong() == maKiemTraPhong) {
                tong += ktct.getSoLuongBiHong();
            }
        }
        return tong;
    }
    
}
