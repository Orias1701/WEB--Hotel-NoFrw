package controller;

import java.util.List;

import model.NhanVien;
import model.TaiKhoan;
import model.VaiTro;
import service.TaiKhoanService;

public class TaiKhoanController {

    private final TaiKhoanService service = new TaiKhoanService();

    public List<TaiKhoan> getAll() { return service.getAll(); }
    public boolean add(TaiKhoan tk) { return service.add(tk); }
    public boolean update(TaiKhoan tk) { return service.update(tk); }
    public boolean delete(int id) { return service.delete(id); }

    public List<NhanVien> loadNhanVien() { return service.loadNhanVien(); }
    public List<VaiTro> loadVaiTro() { return service.loadVaiTro(); }
    public TaiKhoan login(String user, String pass) {
        return service.login(user, pass);
    }

}
