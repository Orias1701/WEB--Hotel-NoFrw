package servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.LoaiPhong;
import service.LoaiPhongService;

@WebServlet("/loai-phong-data")
public class LoaiPhongServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LoaiPhongService loaiPhongService = new LoaiPhongService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<LoaiPhong> listLoaiPhong = loaiPhongService.getAll();
        request.setAttribute("listLoaiPhong", listLoaiPhong);
        
        request.getRequestDispatcher("loai-phong.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                String ten = request.getParameter("tenLoaiPhong");
                BigDecimal gia = new BigDecimal(request.getParameter("giaCoBan"));
                
                LoaiPhong lp = new LoaiPhong(0, ten, gia);
                loaiPhongService.add(lp);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maLoaiPhong"));
                String ten = request.getParameter("tenLoaiPhong");
                BigDecimal gia = new BigDecimal(request.getParameter("giaCoBan"));
                
                LoaiPhong lp = new LoaiPhong(id, ten, gia);
                loaiPhongService.update(lp);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maLoaiPhong"));
                if (new service.DeletionCheckService().canDelete("loaiphong", id)) {
                    loaiPhongService.delete(id);
                } else {
                    System.out.println("⚠️ Chặn xóa Loại phòng #" + id + " do có ràng buộc dữ liệu.");
                }
            }
            
            response.sendRedirect("main?view=loai-phong");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý loại phòng");
        }
    }
}
