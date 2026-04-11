package service;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List; // Import BigDecimal
import model.DatPhong;
import repository.DatPhongDao;

public class DatPhongService {

    private final DatPhongDao dao = new DatPhongDao();

    public List<DatPhong> getAll() {
        return dao.getAll();
    }

    public boolean add(DatPhong dp) {
        return dao.add(dp);
    }

    public boolean delete(int id) {
        return dao.delete(id);
    }

    // ✅ Lấy 1 đặt phòng theo id
    public DatPhong getById(int id) {
        return dao.getById(id);
    }

    public List<DatPhong> getAllByMaHoaDon(int maHoaDon) {
        return dao.getAllByMaHoaDon(maHoaDon);
    }

    // ✅ Trả phòng
    public boolean traPhong(int id, Timestamp ngayTra, BigDecimal tienPhong, BigDecimal tienPhat) {
        return dao.traPhong(id, ngayTra, tienPhong, tienPhat);
    }
    // ✅ Hủy đặt phòng
    public boolean huyDatPhong(int id) {
        DatPhong dp = dao.getById(id);
        if (dp == null || "Đã hủy".equals(dp.getTrangThai())) return false;

        // Tính phạt: 50% tiền phòng gốc
        BigDecimal originalTienPhong = dp.getTienPhong() != null ? dp.getTienPhong() : BigDecimal.ZERO;
        BigDecimal tienPhat = originalTienPhong.multiply(new BigDecimal("0.5"));

        if (dao.huyDatPhong(id, tienPhat)) {
            // Cập nhật phòng trả về trạng thái Trống
            new repository.PhongDao().updateStatus(dp.getMaPhong(), "Trống");
            return true;
        }
        return false;
    }
}