package servlet;

import java.io.IOException;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.KhachHangService;
import service.NhanVienService;
import service.PhongService;
import service.ThietBiService;
import repository.ThongKeDao;

@WebServlet("/home-data")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private PhongService phongService = new PhongService();
    private NhanVienService nhanVienService = new NhanVienService();
    private KhachHangService khachHangService = new KhachHangService();
    private ThietBiService thietBiService = new ThietBiService();
    private ThongKeDao thongKeDao = new ThongKeDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Gather statistics
        request.setAttribute("countPhongTrong", phongService.countPhongTrong());
        request.setAttribute("countPhongDangSuDung", phongService.countPhongDangSuDung());
        request.setAttribute("countNhanVien", nhanVienService.countNhanVien());
        request.setAttribute("countKhachHang", khachHangService.countKhachHang());
        request.setAttribute("countThietBi", thietBiService.countThietBi());
        
        // Revenue logic
        String currentMonthKey = YearMonth.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        String displayMonth = YearMonth.now().format(DateTimeFormatter.ofPattern("MM/yyyy"));
        Map<String, Double> revenueMap = thongKeDao.getDoanhThuTheoThang();
        Double currentRevenue = revenueMap.getOrDefault(currentMonthKey, 0.0);
        
        request.setAttribute("displayMonth", displayMonth);
        request.setAttribute("currentRevenue", currentRevenue);

        // Chart data
        Map<String, Integer> datPhongMap = thongKeDao.getSoLuongDatPhongTheoThang();
        request.setAttribute("chartLabels", "['" + String.join("','", datPhongMap.keySet()) + "']");
        request.setAttribute("chartBookingData", datPhongMap.values().toString());
        request.setAttribute("chartRevenueData", revenueMap.values().toString());
        
        // Forward to the fragment
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
