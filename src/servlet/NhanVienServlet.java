package servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.NhanVien;
import service.NhanVienService;

@WebServlet("/nhan-vien-data")
public class NhanVienServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NhanVienService nhanVienService = new NhanVienService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<NhanVien> listNhanVien = nhanVienService.getAll();
        request.setAttribute("listNhanVien", listNhanVien);
        
        request.getRequestDispatcher("nhan-vien.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                String ten = request.getParameter("tenNhanVien");
                String sdt = request.getParameter("soDienThoai");
                String email = request.getParameter("email");
                
                NhanVien nv = new NhanVien(0, ten, sdt, email);
                nhanVienService.add(nv);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maNhanVien"));
                String ten = request.getParameter("tenNhanVien");
                String sdt = request.getParameter("soDienThoai");
                String email = request.getParameter("email");
                
                NhanVien nv = new NhanVien(id, ten, sdt, email);
                nhanVienService.update(nv);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maNhanVien"));
                nhanVienService.delete(id);
            }
            
            response.sendRedirect("main?view=nhan-vien");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý nhân viên");
        }
    }
}
