package service;
import java.util.List;

import model.LoaiPhong;
import model.Phong;
import repository.PhongDao;

public class PhongService {

    private PhongDao repo = new PhongDao();

    public List<Phong> getAll() {
        return repo.getAll();
    }

    public boolean add(Phong p) {
        // Validate cơ bản
        if (p.getSoPhong().isEmpty()) return false;
        return repo.add(p);
    }

    public boolean update(Phong p) {
        if (p.getMaPhong() <= 0) return false;
        return repo.update(p);
    }

    public boolean delete(int id) {
        return repo.delete(id);
    }

    public Phong getById(int id) {
        return repo.getById(id);
    }

    public LoaiPhong getLoaiPhongByPhong(int maPhong) {
        return repo.getLoaiPhongByPhong(maPhong);
    }

    public boolean updateStatus(int maPhong, String trangThai) {
        return repo.updateStatus(maPhong, trangThai);
    }

    public int countPhongTrong() {
        return repo.countPhongTrong();
    }
    public int countPhongDangSuDung() {
        return repo.countPhongDangSuDung();
    }

    public java.util.List<Phong> getAllByStatus(String status) {
        java.util.List<Phong> all = repo.getAll();
        java.util.List<Phong> filtered = new java.util.ArrayList<>();
        for (Phong p : all) {
            String ts = p.getTrangThai();
            if (ts != null && ts.trim().equalsIgnoreCase(status.trim())) {
                filtered.add(p);
            }
        }
        return filtered;
    }
}
