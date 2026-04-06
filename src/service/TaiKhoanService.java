package service;

import java.util.List;

import model.NhanVien;
import model.TaiKhoan;
import model.VaiTro;
import repository.TaiKhoanDAO;

public class TaiKhoanService {

    private final TaiKhoanDAO dao = new TaiKhoanDAO();

    public List<TaiKhoan> getAll() { return dao.getAll(); }
    public boolean add(TaiKhoan tk) { return dao.insert(tk); }
    public boolean update(TaiKhoan tk) { return dao.update(tk); }
    public boolean delete(int id) { return dao.delete(id); }

    public List<NhanVien> loadNhanVien() { return dao.loadNhanVien(); }
    public List<VaiTro> loadVaiTro() { return dao.loadVaiTro(); }
    public TaiKhoan login(String user, String pass) {
        return dao.checkLogin(user, pass);
    }
}
