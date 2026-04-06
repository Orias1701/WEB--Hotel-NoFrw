package controller;

import java.util.List;
import model.ThietBiPhong;
import service.ThietBiPhongService;

public class ThietBiPhongController {

    private ThietBiPhongService service = new ThietBiPhongService();

    public List<ThietBiPhong> getAll() {
        return service.getAll();
    }

    public boolean add(ThietBiPhong tbp) {
        return service.add(tbp);
    }

    public boolean update(ThietBiPhong tbp) {
        return service.update(tbp);
    }

    public boolean delete(int id) {
        return service.delete(id);
    }

    public ThietBiPhong getById(int id) {
        return service.getById(id);
    }
    public ThietBiPhong getThietBiPhongByPhongVaThietBi(int maPhong, int maThietBi) {
        return service.getByPhongVaThietBi(maPhong, maThietBi);
    }
    public List<ThietBiPhong> getThietBiTheoPhong(int maPhong) {
        return service.getThietBiTheoPhong(maPhong);
    }
}
