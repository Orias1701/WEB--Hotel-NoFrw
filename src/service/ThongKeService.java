package service;

import java.util.Map;

import repository.ThongKeDao;

public class ThongKeService {

    private ThongKeDao repo = new ThongKeDao();

    public Map<String, Integer> thongKeDatPhongTheoThang() {
        return repo.getSoLuongDatPhongTheoThang();
    }

    public Map<String, Double> thongKeDoanhThuTheoThang() {
        return repo.getDoanhThuTheoThang();
    }
}

