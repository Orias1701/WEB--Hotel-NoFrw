package servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Phong;
import model.LoaiPhong;
import service.PhongService;
import service.LoaiPhongService;

@WebServlet("/phong-data")
public class PhongServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PhongService phongService = new PhongService();
    private LoaiPhongService loaiPhongService = new LoaiPhongService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get all rooms
        List<Phong> listPhong = phongService.getAll();
        request.setAttribute("listPhong", listPhong);

        // 2. Get all room types for the dropdown
        List<LoaiPhong> listLoaiPhong = loaiPhongService.getAll();
        request.setAttribute("listLoaiPhong", listLoaiPhong);

        request.getRequestDispatcher("phong.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                String soPhong = request.getParameter("soPhong");
                int maLoaiPhong = Integer.parseInt(request.getParameter("maLoaiPhong"));
                String trangThai = request.getParameter("trangThai");
                
                Phong p = new Phong(0, soPhong, maLoaiPhong, trangThai);
                phongService.add(p);
            } else if ("update".equals(action)) {
                int maPhong = Integer.parseInt(request.getParameter("maPhong"));
                String soPhong = request.getParameter("soPhong");
                int maLoaiPhong = Integer.parseInt(request.getParameter("maLoaiPhong"));
                String trangThai = request.getParameter("trangThai");
                
                Phong p = new Phong(maPhong, soPhong, maLoaiPhong, trangThai);
                phongService.update(p);
            } else if ("delete".equals(action)) {
                int maPhong = Integer.parseInt(request.getParameter("maPhong"));
                phongService.delete(maPhong);
            }
            
            // Redirect back to main?view=phong to refresh (handled by AJAX or full reload)
            response.sendRedirect("main?view=phong");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý dữ liệu phòng");
        }
    }
}
