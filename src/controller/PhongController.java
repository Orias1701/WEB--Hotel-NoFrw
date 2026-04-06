package controller;

import java.util.List;

import model.LoaiPhong;
import model.Phong;
import service.PhongService;

public class PhongController {

    private PhongService service = new PhongService();

    public List<Phong> getAll() {
        return service.getAll();
    }

    public boolean add(Phong p) {
        return service.add(p);
    }

    public boolean update(Phong p) {
        return service.update(p);
    }

    public boolean delete(int id) {
        return service.delete(id);
    }
    public Phong getById(int id) {
        return service.getById(id);
    }

    public LoaiPhong getLoaiPhongByPhong(int maPhong) {
        return service.getLoaiPhongByPhong(maPhong);
    }
    public boolean updateStatus(int maPhong, String trangThai) {
        return service.updateStatus(maPhong, trangThai);
    }

     public int countPhongTrong() {
        return service.countPhongTrong();
    }
    public int countPhongDangSuDung() {
        return service.countPhongDangSuDung();
    }

}
