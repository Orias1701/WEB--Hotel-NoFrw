package controller;

import java.util.List;

import model.ThietBi;
import service.ThietBiService;

public class ThietBiController {

    private ThietBiService service = new ThietBiService();

    // Lấy tất cả thiết bị
    public List<ThietBi> getAll() {
        return service.getAll();
    }

    // Lấy thiết bị theo ID
    public ThietBi getById(int id) {
        return service.getById(id);
    }

    // Thêm thiết bị
    public boolean add(ThietBi tb) {
        return service.add(tb);
    }

    // Cập nhật thiết bị
    public boolean update(ThietBi tb) {
        return service.update(tb);
    }

    // Xóa thiết bị
    public boolean delete(int id) {
        return service.delete(id);
    }
    public int countThietBi() {
        return service.countThietBi();
    }

}
