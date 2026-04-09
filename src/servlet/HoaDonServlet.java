package servlet;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.HoaDon;
import service.HoaDonService;
import service.KhachHangService;

@WebServlet("/hoa-don-data")
public class HoaDonServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private HoaDonService hoaDonService = new HoaDonService();
    private KhachHangService khachHangService = new KhachHangService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<HoaDon> listHoaDon = hoaDonService.getAll();
        request.setAttribute("listHoaDon", listHoaDon);
        request.setAttribute("listKhachHang", khachHangService.getAll());
        
        request.getRequestDispatcher("hoa-don.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("pay".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maHoaDon"));
                HoaDon hd = hoaDonService.getById(id);
                if (hd != null && !"Đã thanh toán".equals(hd.getTrangThai())) {
                    hd.setTrangThai("Đã thanh toán");
                    hd.setNgayThanhToan(new Timestamp(System.currentTimeMillis()));
                    hoaDonService.update(hd);
                }
            }
            response.sendRedirect("main?view=hoa-don");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi thanh toán hóa đơn");
        }
    }
}
