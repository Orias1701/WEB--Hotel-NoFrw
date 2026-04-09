package servlet;

import java.io.IOException;
import java.util.Date;
// import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.KiemTraChiTiet;
import model.TaiKhoan;
import service.KiemTraChiTietService;
import service.KiemTraPhongService;
import service.ThietBiService;
// import service.PhongService;

@WebServlet("/kiem-tra-chi-tiet-data")
public class KiemTraChiTietServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private KiemTraChiTietService ktctService = new KiemTraChiTietService();
    private KiemTraPhongService ktpService = new KiemTraPhongService();
    private ThietBiService thietBiService = new ThietBiService();
    // private PhongService phongService = new PhongService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        java.util.List<KiemTraChiTiet> listKTCT = ktctService.getAll();
        request.setAttribute("listKiemTraChiTiet", listKTCT);
        request.setAttribute("listKiemTraPhong", ktpService.getAll());
        request.setAttribute("listThietBi", thietBiService.getAll());

        request.getRequestDispatcher("kiem-tra-chi-tiet.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        TaiKhoan userLogin = (TaiKhoan) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                int maKTP = Integer.parseInt(request.getParameter("maKiemTraPhong"));
                int maTB = Integer.parseInt(request.getParameter("maThietBi"));
                int soLuong = Integer.parseInt(request.getParameter("soLuongBiHong"));

                KiemTraChiTiet ktct = new KiemTraChiTiet();
                ktct.setMaKiemTraPhong(maKTP);
                ktct.setMaThietBiPhong(maTB);
                ktct.setSoLuongBiHong(soLuong);
                ktct.setMaNhanVien(userLogin.getMaNhanVien());
                ktct.setNgayKiemTra(new Date());

                ktctService.add(ktct);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maKiemTraChiTiet"));
                int maKTP = Integer.parseInt(request.getParameter("maKiemTraPhong"));
                int maTB = Integer.parseInt(request.getParameter("maThietBi"));
                int soLuong = Integer.parseInt(request.getParameter("soLuongBiHong"));

                KiemTraChiTiet ktct = ktctService.getById(id);
                ktct.setMaKiemTraPhong(maKTP);
                ktct.setMaThietBiPhong(maTB);
                ktct.setSoLuongBiHong(soLuong);
                ktct.setMaNhanVien(userLogin.getMaNhanVien());
                ktct.setNgayKiemTra(new Date());

                ktctService.update(ktct);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maKiemTraChiTiet"));
                ktctService.delete(id);
            }

            response.sendRedirect("main?view=kiem-tra-chi-tiet");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý chi tiết kiểm tra");
        }
    }
}
