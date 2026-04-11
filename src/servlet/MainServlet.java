package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/main")
public class MainServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        model.TaiKhoan user = (model.TaiKhoan) session.getAttribute("user");
        service.NhanVienService nvService = new service.NhanVienService();
        model.NhanVien profile = nvService.getById(user.getMaNhanVien());
        request.setAttribute("profile", profile);

        // Check if it's an AJAX request to load a module
        String module = request.getParameter("view");
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        if (module != null && !module.isEmpty() && isAjax) {
            // Forward to the data-providing servlet for this module
            request.getRequestDispatcher("/" + module + "-data").forward(request, response);
            return;
        }

        // Initial load of the main layout
        request.getRequestDispatcher("main.jsp").forward(request, response);
    }
}
