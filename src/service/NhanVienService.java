package service;

import java.util.List;

import model.NhanVien;
import model.TaiKhoan;
import repository.NhanVienDao;
import repository.TaiKhoanDao;

public class NhanVienService {

    private final NhanVienDao nvDao = new NhanVienDao();
    private final TaiKhoanDao tkDao = new TaiKhoanDao();

    public boolean add(NhanVien nv) {

        int id = nvDao.insertAndReturnId(nv);

        if (id <= 0) return false;

        TaiKhoan tk = new TaiKhoan(
                0,
                nv.getEmail(),        // username = email
                nv.getSoDienThoai(),  // password = sđt
                id,
                2                     // mặc định: nhân viên
        );

        return tkDao.insert(tk);
    }

    public boolean update(NhanVien nv) { return nvDao.update(nv); }
    public boolean delete(int id) { return nvDao.delete(id); }
    public List<NhanVien> getAll() { return nvDao.getAll(); }
    public NhanVien getById(int id) { return nvDao.getById(id); }

    public int countNhanVien() {
        return nvDao.countNhanVien();
    }

}
