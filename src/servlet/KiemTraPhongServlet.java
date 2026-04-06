package servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.KiemTraPhong;
import service.KiemTraPhongService;

@WebServlet("/kiem-tra-data")
public class KiemTraPhongServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private KiemTraPhongService ktpService = new KiemTraPhongService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<KiemTraPhong> listKiemTra = ktpService.getAll();
        request.setAttribute("listKiemTra", listKiemTra);
        
        request.getRequestDispatcher("kiem-tra.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                int maHD = Integer.parseInt(request.getParameter("maHoaDon"));
                int maPhong = Integer.parseInt(request.getParameter("maPhong"));
                Timestamp ngayTT = Timestamp.valueOf(request.getParameter("ngayThanhToan").replace("T", " ") + ":00");
                BigDecimal tienBT = new BigDecimal(request.getParameter("tienBoiThuong"));
                
                KiemTraPhong ktp = new KiemTraPhong(0, maHD, maPhong, ngayTT, tienBT);
                ktpService.add(ktp);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maKiemTraPhong"));
                int maHD = Integer.parseInt(request.getParameter("maHoaDon"));
                int maPhong = Integer.parseInt(request.getParameter("maPhong"));
                Timestamp ngayTT = Timestamp.valueOf(request.getParameter("ngayThanhToan").replace("T", " ") + ":00");
                BigDecimal tienBT = new BigDecimal(request.getParameter("tienBoiThuong"));
                
                KiemTraPhong ktp = new KiemTraPhong(id, maHD, maPhong, ngayTT, tienBT);
                ktpService.update(ktp);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maKiemTraPhong"));
                ktpService.delete(id);
            }
            
            response.sendRedirect("main?view=kiem-tra");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý kiểm tra phòng");
        }
    }
}
