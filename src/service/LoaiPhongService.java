package service;

import java.util.List;
import model.LoaiPhong;
import repository.LoaiPhongDao;

public class LoaiPhongService {
    private LoaiPhongDao dao = new LoaiPhongDao();

    // Các phương thức này sẽ tự động làm việc với BigDecimal thông qua LoaiPhong
    public List<LoaiPhong> getAll() {
        return dao.getAll();
    }

    public boolean add(LoaiPhong lp) {
        return dao.insert(lp);
    }

    public boolean update(LoaiPhong lp) {
        return dao.update(lp);
    }

    public boolean delete(int id) {
        return dao.delete(id);
    }
}