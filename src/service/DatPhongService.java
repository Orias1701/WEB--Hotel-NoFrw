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
}