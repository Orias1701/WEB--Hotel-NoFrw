package service;

import java.util.List;

import model.NhanVien;
import model.TaiKhoan;
import repository.NhanVienDAO;
import repository.TaiKhoanDAO;

public class NhanVienService {

    private final NhanVienDAO nvDAO = new NhanVienDAO();
    private final TaiKhoanDAO tkDAO = new TaiKhoanDAO();

    public boolean add(NhanVien nv) {

        int id = nvDAO.insertAndReturnId(nv);

        if (id <= 0) return false;

        TaiKhoan tk = new TaiKhoan(
                0,
                nv.getEmail(),        // username = email
                nv.getSoDienThoai(),  // password = sđt
                id,
                2                     // mặc định: nhân viên
        );

        return tkDAO.insert(tk);
    }

    public boolean update(NhanVien nv) { return nvDAO.update(nv); }
    public boolean delete(int id) { return nvDAO.delete(id); }
    public List<NhanVien> getAll() { return nvDAO.getAll(); }
    public NhanVien getById(int id) { return nvDAO.getById(id); }

    public int countNhanVien() {
        return nvDAO.countNhanVien();
    }

}
