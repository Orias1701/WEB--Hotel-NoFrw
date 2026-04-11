package servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.VaiTro;
import service.VaiTroService;

@WebServlet("/vai-tro-data")
public class VaiTroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private VaiTroService vaiTroService = new VaiTroService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<VaiTro> listVaiTro = vaiTroService.getAll();
        request.setAttribute("listVaiTro", listVaiTro);
        
        request.getRequestDispatcher("vai-tro.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                String ten = request.getParameter("tenVaiTro");
                VaiTro vt = new VaiTro(0, ten);
                vaiTroService.add(vt);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maVaiTro"));
                String ten = request.getParameter("tenVaiTro");
                VaiTro vt = new VaiTro(id, ten);
                vaiTroService.update(vt);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maVaiTro"));
                if (new service.DeletionCheckService().canDelete("vaitro", id)) {
                    vaiTroService.delete(id);
                } else {
                    System.out.println("⚠️ Chặn xóa Vai trò #" + id + " do có ràng buộc dữ liệu.");
                }
            }
            
            response.sendRedirect("main?view=vai-tro");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý vai trò");
        }
    }
}
