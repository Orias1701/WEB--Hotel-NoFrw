package servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.KhachHang;
import service.KhachHangService;

@WebServlet("/khach-hang-data")
public class KhachHangServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private KhachHangService khachHangService = new KhachHangService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<KhachHang> listKhachHang = khachHangService.getAll();
        request.setAttribute("listKhachHang", listKhachHang);
        request.getRequestDispatcher("khach-hang.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                String ten = request.getParameter("tenKhachHang");
                String sdt = request.getParameter("soDienThoai");
                String email = request.getParameter("email");
                
                KhachHang kh = new KhachHang(0, ten, sdt, email);
                khachHangService.add(kh);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maKhachHang"));
                String ten = request.getParameter("tenKhachHang");
                String sdt = request.getParameter("soDienThoai");
                String email = request.getParameter("email");
                
                KhachHang kh = new KhachHang(id, ten, sdt, email);
                khachHangService.update(kh);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maKhachHang"));
                khachHangService.delete(id);
            }
            
            response.sendRedirect("main?view=khach-hang");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý khách hàng");
        }
    }
}
