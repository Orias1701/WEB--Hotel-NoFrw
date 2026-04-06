package service;

import java.util.List;
import model.LoaiPhong;
import repository.LoaiPhongDAO;

public class LoaiPhongService {
    private LoaiPhongDAO dao = new LoaiPhongDAO();

    // Các phương thức này sẽ tự động làm việc với BigDecimal thông qua LoaiPhong
    public List<LoaiPhong> getAll() { return dao.getAll(); }
    public boolean add(LoaiPhong lp) { return dao.insert(lp); }
    public boolean update(LoaiPhong lp) { return dao.update(lp); }
    public boolean delete(int id) { return dao.delete(id); }
}