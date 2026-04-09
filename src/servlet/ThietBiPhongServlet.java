package servlet;

import java.io.IOException;
// import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ThietBiPhong;
// import model.Phong;
// import model.ThietBi;
import service.ThietBiPhongService;
import service.PhongService;
import service.ThietBiService;

@WebServlet("/thiet-bi-phong-data")
public class ThietBiPhongServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ThietBiPhongService tbpService = new ThietBiPhongService();
    private PhongService phongService = new PhongService();
    private ThietBiService thietBiService = new ThietBiService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        java.util.List<ThietBiPhong> listTBP = tbpService.getAll();
        request.setAttribute("listThietBiPhong", listTBP);
        request.setAttribute("listPhong", phongService.getAll());
        request.setAttribute("listThietBi", thietBiService.getAll());

        request.getRequestDispatcher("thiet-bi-phong.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                int maPhong = Integer.parseInt(request.getParameter("maPhong"));
                int maThietBi = Integer.parseInt(request.getParameter("maThietBi"));
                int soLuong = Integer.parseInt(request.getParameter("soLuong"));
                String trangThai = request.getParameter("trangThai");

                ThietBiPhong tbp = new ThietBiPhong(0, maPhong, maThietBi, soLuong, trangThai);
                tbpService.add(tbp);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maThietBiPhong"));
                int maPhong = Integer.parseInt(request.getParameter("maPhong"));
                int maThietBi = Integer.parseInt(request.getParameter("maThietBi"));
                int soLuong = Integer.parseInt(request.getParameter("soLuong"));
                String trangThai = request.getParameter("trangThai");

                ThietBiPhong tbp = new ThietBiPhong(id, maPhong, maThietBi, soLuong, trangThai);
                tbpService.update(tbp);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maThietBiPhong"));
                tbpService.delete(id);
            }

            response.sendRedirect("main?view=thiet-bi-phong");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý thiết bị phòng");
        }
    }
}
