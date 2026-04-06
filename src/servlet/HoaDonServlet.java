package servlet;

import java.io.IOException;
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
    
    // Invoices are usually created by DatPhong or other modules, 
    // so no direct CRUD POST here for now.
}
