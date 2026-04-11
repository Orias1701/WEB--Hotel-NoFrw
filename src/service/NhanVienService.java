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
    
    public List<NhanVien> getAll() { 
        List<NhanVien> listNhanVien = nvDao.getAll();
        List<TaiKhoan> listAllTaiKhoan = tkDao.getAll();
        
        // Group accounts by employee ID for fast lookup
        java.util.Map<Integer, List<TaiKhoan>> group = new java.util.HashMap<>();
        for (TaiKhoan tk : listAllTaiKhoan) {
            group.computeIfAbsent(tk.getMaNhanVien(), k -> new java.util.ArrayList<>()).add(tk);
        }
        
        // Match accounts to employees in memory
        for (NhanVien nv : listNhanVien) {
            nv.setListTaiKhoan(group.getOrDefault(nv.getMaNhanVien(), new java.util.ArrayList<>()));
        }
        
        return listNhanVien; 
    }
    
    public NhanVien getById(int id) { 
        NhanVien nv = nvDao.getById(id);
        if (nv != null) {
            nv.setListTaiKhoan(tkDao.getByMaNhanVien(nv.getMaNhanVien()));
        }
        return nv;
    }

    public int countNhanVien() {
        return nvDao.countNhanVien();
    }

}
