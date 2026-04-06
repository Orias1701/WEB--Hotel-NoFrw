package service;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List; // Import BigDecimal
import model.DatPhong;
import repository.DatPhongDao;

public class DatPhongService {

    private DatPhongDao repo = new DatPhongDao();

    public List<DatPhong> getAll() {
        return repo.getAll();
    }

    public boolean add(DatPhong dp) {
        return repo.add(dp);
    }

    public boolean delete(int id) {
        return repo.delete(id);
    }

    // ✅ Lấy 1 đặt phòng theo id
    public DatPhong getById(int id) {
        return repo.getById(id);
    }

    // ✅ Trả phòng
    public boolean traPhong(int id, Timestamp ngayTra, BigDecimal tienPhong, BigDecimal tienPhat) { // Cập nhật kiểu tham số
        return repo.traPhong(id, ngayTra, tienPhong, tienPhat);
    }
}