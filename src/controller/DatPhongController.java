package controller;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List; // Import BigDecimal
import model.DatPhong;
import service.DatPhongService;

public class DatPhongController {

    private DatPhongService service = new DatPhongService();

    public List<DatPhong> getAll() {
        return service.getAll();
    }

    public boolean add(DatPhong dp) {
        return service.add(dp);
    }

    public boolean delete(int id) {
        return service.delete(id);
    }

    // ✅ Lấy 1 đặt phòng theo id
    public DatPhong getById(int id) {
        return service.getById(id);
    }

    // ✅ Trả phòng
    public boolean traPhong(int id, Timestamp ngayTra, BigDecimal tienPhong, BigDecimal tienPhat) { // Cập nhật kiểu tham số
        return service.traPhong(id, ngayTra, tienPhong, tienPhat);
    }
}