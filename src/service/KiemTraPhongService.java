package service;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import model.KiemTraChiTiet;
import model.KiemTraPhong;
import model.ThietBi;
import model.ThietBiPhong;
import repository.KiemTraPhongDao;
// import service.ThietBiPhongService;

public class KiemTraPhongService {

    private KiemTraPhongDao repo = new KiemTraPhongDao();
    // private ThietBiPhongService tbPhongService = new ThietBiPhongService();

    // Lấy tất cả kiểm tra phòng
    public List<KiemTraPhong> getAll() {
        return repo.getAll();
    }

    // Lấy 1 kiểm tra phòng theo ID
    public KiemTraPhong getById(int maKiemTraPhong) throws Exception {
        KiemTraPhong ktp = repo.getById(maKiemTraPhong);
        if (ktp == null)
            throw new Exception("Không tìm thấy kiểm tra phòng");
        return ktp;
    }

    // Thêm kiểm tra phòng mới
    public boolean add(KiemTraPhong ktp) throws Exception {
        if (ktp == null)
            throw new Exception("Dữ liệu kiểm tra phòng trống");
        if (ktp.getMaPhong() <= 0)
            throw new Exception("Mã phòng không hợp lệ");

        // Tự động lấy thời gian hiện tại nếu chưa có
        if (ktp.getNgayThanhToan() == null) {
            ktp.setNgayThanhToan(new Timestamp(System.currentTimeMillis()));
        }

        // Tính tiền bồi thường dựa trên thiết bị hỏng trong phòng
        if (ktp.getTienBoiThuong() == null) {
            BigDecimal tongBoiThuong = repo.calculateCompensation(ktp.getMaPhong(), ktp.getMaKiemTraPhong());
            ktp.setTienBoiThuong(tongBoiThuong);
        }

        return repo.insert(ktp);
    }

    // Cập nhật kiểm tra phòng
    public boolean update(KiemTraPhong ktp) throws Exception {
        if (ktp == null)
            throw new Exception("Dữ liệu kiểm tra phòng trống");
        if (ktp.getMaPhong() <= 0)
            throw new Exception("Mã phòng không hợp lệ");
        return repo.update(ktp);
    }

    // Xóa kiểm tra phòng
    public boolean delete(int maKiemTraPhong) throws Exception {
        KiemTraPhong ktp = repo.getById(maKiemTraPhong);
        if (ktp == null)
            throw new Exception("Không tìm thấy kiểm tra phòng để xóa");
        return repo.delete(maKiemTraPhong);
    }

    public boolean updateCompensation(int maKiemTraPhong) {
        return repo.updateCompensation(maKiemTraPhong);
    }

    public boolean updateTienBoiThuong(int maKiemTraPhong) {
        try {
            List<KiemTraChiTiet> chiTiets = new KiemTraChiTietService()
                    .getAllByMaKiemTraPhong(maKiemTraPhong);

            BigDecimal tong = BigDecimal.ZERO;

            ThietBiPhongService tbPhongService = new ThietBiPhongService();
            ThietBiService thietBiService = new ThietBiService();

            for (KiemTraChiTiet ct : chiTiets) {

                // Lấy TBP (chứa mapping MaPhong <-> MaThietBi)
                ThietBiPhong tbp = tbPhongService.getById(ct.getMaThietBiPhong());
                if (tbp == null)
                    continue;

                // Lấy thiết bị gốc để lấy giá
                ThietBi tb = thietBiService.getById(tbp.getMaThietBi());
                if (tb == null || tb.getGiaThietBi() == null)
                    continue;

                BigDecimal donGia = tb.getGiaThietBi(); // ✔ BigDecimal chuẩn
                BigDecimal soLuongHong = new BigDecimal(ct.getSoLuongBiHong());

                tong = tong.add(donGia.multiply(soLuongHong)); // ✔ tính đúng
            }

            KiemTraPhong ktp = getById(maKiemTraPhong);
            ktp.setTienBoiThuong(tong);

            return update(ktp);

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public BigDecimal getTienBoiThuongByPhong(int maPhong) {
        try {
            // Lấy danh sách tất cả KiemTraPhong của phòng này (thường chỉ 1 bản ghi)
            List<KiemTraPhong> list = repo.getByMaPhong(maPhong);
            BigDecimal tong = BigDecimal.ZERO;
            for (KiemTraPhong ktp : list) {
                if (ktp.getTienBoiThuong() == null) {
                    updateTienBoiThuong(ktp.getMaKiemTraPhong());
                    ktp = getById(ktp.getMaKiemTraPhong());
                }
                tong = tong.add(ktp.getTienBoiThuong() != null ? ktp.getTienBoiThuong() : BigDecimal.ZERO);
            }
            return tong;
        } catch (Exception e) {
            e.printStackTrace();
            return BigDecimal.ZERO;
        }
    }

    public KiemTraPhong getByMaHoaDon(int maHoaDon) {
        return repo.getByMaHoaDon(maHoaDon);
    }

}
