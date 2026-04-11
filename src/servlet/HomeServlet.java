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

import repository.ThongKeDao;

@WebServlet("/home-data")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private PhongService phongService = new PhongService();
    private NhanVienService nhanVienService = new NhanVienService();
    private KhachHangService khachHangService = new KhachHangService();

    private ThongKeDao thongKeDao = new ThongKeDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Gather statistics
        request.setAttribute("countPhongTrong", phongService.countPhongTrong());
        request.setAttribute("countPhongDangSuDung", phongService.countPhongDangSuDung());
        request.setAttribute("countNhanVien", nhanVienService.countNhanVien());
        request.setAttribute("countKhachHang", khachHangService.countKhachHang());

        
        // Revenue logic
        String currentMonthKey = YearMonth.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        String displayMonth = YearMonth.now().format(DateTimeFormatter.ofPattern("MM/yyyy"));
        Map<String, Double> revenueMap = thongKeDao.getDoanhThuTheoThang();
        Double currentRevenue = revenueMap.getOrDefault(currentMonthKey, 0.0);
        
        request.setAttribute("displayMonth", displayMonth);
        request.setAttribute("currentRevenue", currentRevenue);

        // 3. New Dashboard Stats (30 days daily)
        Map<String, Double> rev30 = thongKeDao.getDoanhThu30NgayGanNhat();
        Map<String, Integer> book30 = thongKeDao.getDatPhong30NgayGanNhat();
        Map<String, Double> ratio = thongKeDao.getTiLeTienPhongPhat();

        // Format for Chart.js (Standard JSON with double quotes)
        request.setAttribute("labels30", "[\"" + String.join("\",\"", rev30.keySet()) + "\"]");
        request.setAttribute("dataRev30", rev30.values().toString());
        request.setAttribute("dataBook30", book30.values().toString());
        
        request.setAttribute("labelsRatio", "[\"" + String.join("\",\"", ratio.keySet()) + "\"]");
        request.setAttribute("dataRatio", ratio.values().toString());
        
        // Forward to the home page
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
