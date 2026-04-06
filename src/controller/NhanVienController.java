package controller;

import java.util.List;

import model.NhanVien;
import service.NhanVienService;

public class NhanVienController {
    private final NhanVienService service = new NhanVienService();

    public List<NhanVien> getAll() { return service.getAll(); }
    public boolean add(NhanVien nv) { return service.add(nv); }
    public boolean update(NhanVien nv) { return service.update(nv); }
    public boolean delete(int id) { return service.delete(id); }
    public NhanVien getById(int id) { return service.getById(id); }

        public int countNhanVien() {
            return service.countNhanVien();
        }
}
