package service;

import java.util.List;

import model.KhachHang;
import repository.KhachHangDAO;

public class KhachHangService {

    private final KhachHangDAO dao = new KhachHangDAO();

    public List<KhachHang> getAll() {
        return dao.getAll();
    }

    public boolean add(KhachHang kh) {
        return dao.insert(kh);
    }

    public boolean update(KhachHang kh) {
        return dao.update(kh);
    }

    public boolean delete(int id) {
        return dao.delete(id);
    }

    public KhachHang getById(int id) {
        return dao.getById(id);
    }

    public int countKhachHang() {
        return dao.countKhachHang();
    }

    public List<KhachHang> search(String keyword) {
        return dao.search(keyword);
    }
}
