package controller;

import java.util.Map;

import service.ThongKeService;

public class ThongKeController {

    private ThongKeService service = new ThongKeService();
     public Map<String, Integer> thongKeDatPhongTheoThang() {
        return service.thongKeDatPhongTheoThang();
    }

    public Map<String, Double> thongKeDoanhThuTheoThang() {
        return service.thongKeDoanhThuTheoThang();
    }
    
}
