package servlet;

import java.io.IOException;
// import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.TaiKhoan;
// import model.NhanVien;
// import model.VaiTro;
import service.TaiKhoanService;
import service.NhanVienService;
import service.VaiTroService;

@WebServlet("/tai-khoan-data")
public class TaiKhoanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TaiKhoanService taiKhoanService = new TaiKhoanService();
    private NhanVienService nhanVienService = new NhanVienService();
    private VaiTroService vaiTroService = new VaiTroService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        java.util.List<TaiKhoan> listTaiKhoan = taiKhoanService.getAll();
        request.setAttribute("listTaiKhoan", listTaiKhoan);
        request.setAttribute("listNhanVien", nhanVienService.getAll());
        request.setAttribute("listVaiTro", vaiTroService.getAll());

        request.getRequestDispatcher("tai-khoan.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String user = request.getParameter("taiKhoan");
                String pass = request.getParameter("matKhau");
                int maNV = Integer.parseInt(request.getParameter("maNhanVien"));
                int maVT = Integer.parseInt(request.getParameter("maVaiTro"));

                TaiKhoan tk = new TaiKhoan(0, user, pass, maNV, maVT);
                taiKhoanService.add(tk);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String user = request.getParameter("taiKhoan");
                String pass = request.getParameter("matKhau");
                int maNV = Integer.parseInt(request.getParameter("maNhanVien"));
                int maVT = Integer.parseInt(request.getParameter("maVaiTro"));

                TaiKhoan tk = new TaiKhoan(id, user, pass, maNV, maVT);
                taiKhoanService.update(tk);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                taiKhoanService.delete(id);
            }

            response.sendRedirect("main?view=tai-khoan");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý tài khoản");
        }
    }
}
