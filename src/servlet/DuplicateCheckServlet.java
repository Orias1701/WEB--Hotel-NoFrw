package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import repository.KhachHangDao;
import repository.NhanVienDao;

@WebServlet("/check-duplicate")
public class DuplicateCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private KhachHangDao khDao = new KhachHangDao();
    private NhanVienDao nvDao = new NhanVienDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        try {
            String type = request.getParameter("type");
            String idStr = request.getParameter("id");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            int id = 0;
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    id = Integer.parseInt(idStr);
                } catch (NumberFormatException e) {
                    // ignore, assume 0 for new records
                }
            }

            boolean isDuplicate = false;
            String message = "";

            if ("nhanvien".equals(type)) {
                if (phone != null && nvDao.existsByPhone(phone, id)) {
                    isDuplicate = true;
                    message = "Số điện thoại '" + phone + "' đã được nhân viên khác sử dụng.";
                } else if (email != null && !email.trim().isEmpty() && nvDao.existsByEmail(email, id)) {
                    isDuplicate = true;
                    message = "Email '" + email + "' đã được nhân viên khác sử dụng.";
                }
            } else if ("khachhang".equals(type)) {
                if (phone != null && khDao.existsByPhone(phone, id)) {
                    isDuplicate = true;
                    message = "Số điện thoại '" + phone + "' đã được khách hàng khác sử dụng.";
                } else if (email != null && !email.trim().isEmpty() && khDao.existsByEmail(email, id)) {
                    isDuplicate = true;
                    message = "Email '" + email + "' đã được khách hàng khác sử dụng.";
                }
            }

            // Return JSON: e.g. {"isDuplicate": true, "message": "Email trùng lặp"}
            response.getWriter().write(
                    "{\"isDuplicate\":" + isDuplicate + ",\"message\":\"" + message + "\"}");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"isDuplicate\":false,\"message\":\"Lỗi kiểm tra server: " + e.getMessage() + "\"}");
        }
    }
}
