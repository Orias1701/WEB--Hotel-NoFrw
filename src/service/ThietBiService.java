package service;

import java.util.List;
import model.ThietBi;
import repository.ThietBiDAO;

public class ThietBiService {

    private ThietBiDAO dao = new ThietBiDAO();

    // Lấy tất cả thiết bị
    public List<ThietBi> getAll() {
        return dao.getAll();
    }

    // Lấy thiết bị theo ID
    public ThietBi getById(int maThietBi) {
        return dao.getById(maThietBi);
    }

    // Thêm thiết bị
    public boolean add(ThietBi tb) {
        return dao.add(tb);
    }

    // Cập nhật thiết bị
    public boolean update(ThietBi tb) {
        return dao.update(tb);
    }

    // Xóa thiết bị
    public boolean delete(int id) {
        return dao.delete(id);
    }
    public int countThietBi() {
        return dao.countThietBi();
    }

}
