package servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ThietBi;
import service.ThietBiService;

@WebServlet("/thiet-bi-data")
public class ThietBiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ThietBiService thietBiService = new ThietBiService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<ThietBi> listThietBi = thietBiService.getAll();
        request.setAttribute("listThietBi", listThietBi);
        
        request.getRequestDispatcher("thiet-bi.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                String ten = request.getParameter("tenThietBi");
                BigDecimal gia = new BigDecimal(request.getParameter("giaThietBi"));
                
                ThietBi tb = new ThietBi(0, ten, gia);
                thietBiService.add(tb);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maThietBi"));
                String ten = request.getParameter("tenThietBi");
                BigDecimal gia = new BigDecimal(request.getParameter("giaThietBi"));
                
                ThietBi tb = new ThietBi(id, ten, gia);
                thietBiService.update(tb);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maThietBi"));
                thietBiService.delete(id);
            }
            
            response.sendRedirect("main?view=thiet-bi");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý thiết bị");
        }
    }
}
