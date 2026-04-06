package service;

import java.util.List;
import model.KiemTraChiTiet;
import model.KiemTraPhong;
import model.ThietBiPhong;
import repository.KiemTraChiTietDAO;

public class KiemTraChiTietService {

    private KiemTraChiTietDAO dao = new KiemTraChiTietDAO();
    private ThietBiPhongService tbPhongService = new ThietBiPhongService();
    private KiemTraPhongService ktPhongService = new KiemTraPhongService();
    // private ThietBiService thietBiService = new ThietBiService();

    // Lấy tất cả chi tiết kiểm tra
    public List<KiemTraChiTiet> getAll() {
        return dao.getAll();
    }

    // Lấy tất cả chi tiết theo maKiemTraPhong
    public List<KiemTraChiTiet> getAllByMaKiemTraPhong(int maKiemTraPhong) {
        return dao.getAllByMaKiemTraPhong(maKiemTraPhong);
    }

    // Lấy chi tiết kiểm tra theo ID
    public KiemTraChiTiet getById(int id) throws Exception {
        KiemTraChiTiet ktct = dao.getById(id);
        if (ktct == null) throw new Exception("Chi tiết kiểm tra không tồn tại");
        return ktct;
    }

    // Thêm chi tiết kiểm tra
    public boolean add(KiemTraChiTiet ktct) throws Exception {
        if (ktct == null) throw new Exception("Chi tiết kiểm tra trống");

        KiemTraPhong ktp = ktPhongService.getById(ktct.getMaKiemTraPhong());
        if (ktp == null) throw new Exception("Kiểm tra phòng không tồn tại");
        int maPhong = ktp.getMaPhong();

        ThietBiPhong tbp = tbPhongService.getByPhongVaThietBi(maPhong, ktct.getMaThietBiPhong());
        if (tbp == null) throw new Exception("Thiết bị trong phòng không tồn tại");

        // ====== Sửa tại đây: tính tổng số lượng đã tồn tại ======
        List<KiemTraChiTiet> list = dao.getAllByMaKiemTraPhong(ktct.getMaKiemTraPhong());
        int tongDaCo = list.stream()
                        .filter(x -> x.getMaThietBiPhong() == ktct.getMaThietBiPhong())
                        .mapToInt(KiemTraChiTiet::getSoLuongBiHong)
                        .sum();

        if (ktct.getSoLuongBiHong() + tongDaCo > tbp.getSoLuong()) {
            throw new Exception("Số lượng hỏng vượt quá số lượng thiết bị trong phòng");
        }
        // ==========================================================

        boolean added = dao.add(ktct);

        if (added) {
            ktPhongService.updateTienBoiThuong(ktct.getMaKiemTraPhong());
        }

        return added;
    }

    // Cập nhật chi tiết kiểm tra
    public boolean update(KiemTraChiTiet ktct) throws Exception {
        if (ktct == null) throw new Exception("Chi tiết kiểm tra trống");

        KiemTraPhong ktp = ktPhongService.getById(ktct.getMaKiemTraPhong());
        if (ktp == null) throw new Exception("Kiểm tra phòng không tồn tại");
        int maPhong = ktp.getMaPhong();

        ThietBiPhong tbp = tbPhongService.getByPhongVaThietBi(maPhong, ktct.getMaThietBiPhong());
        if (tbp == null) throw new Exception("Thiết bị trong phòng không tồn tại");

        // ====== Sửa tại đây: tổng số lượng các bản ghi khác ======
        List<KiemTraChiTiet> list = dao.getAllByMaKiemTraPhong(ktct.getMaKiemTraPhong());
        int tongKhac = list.stream()
                            .filter(x -> x.getMaThietBiPhong() == ktct.getMaThietBiPhong() 
                                    && x.getMaKiemTraChiTiet() != ktct.getMaKiemTraChiTiet())
                            .mapToInt(KiemTraChiTiet::getSoLuongBiHong)
                            .sum();

        if (ktct.getSoLuongBiHong() + tongKhac > tbp.getSoLuong()) {
            throw new Exception("Số lượng hỏng vượt quá số lượng thiết bị trong phòng");
        }
        // ==========================================================

        boolean updated = dao.update(ktct);

        if (updated) {
            ktPhongService.updateTienBoiThuong(ktct.getMaKiemTraPhong());
        }

        return updated;
    }


    // Xóa chi tiết kiểm tra
    public boolean delete(int id) throws Exception {
        KiemTraChiTiet ktct = dao.getById(id);
        if (ktct == null) throw new Exception("Chi tiết kiểm tra không tồn tại");

        boolean deleted = dao.delete(id);

        // Cập nhật tiền bồi thường sau khi xóa
        if (deleted) {
            ktPhongService.updateTienBoiThuong(ktct.getMaKiemTraPhong());
        }

        return deleted;
    }
}
