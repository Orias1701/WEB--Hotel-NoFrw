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

        // Differentiate between AJAX fragment loading and full page reloads
        String module = request.getParameter("view");
        String requestedWith = request.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(requestedWith);

        if (module != null && !module.isEmpty()) {
            if (isAjax) {
                // AJAX request: Forward to the fragment-providing servlet
                request.getRequestDispatcher("/" + module + "-data").forward(request, response);
                return;
            } else {
                // Full page load (e.g. after CRUD redirect): 
                // Set initial view and load the main container
                request.setAttribute("initialView", module);
            }
        }

        // Initial load of the main layout
        request.getRequestDispatcher("main.jsp").forward(request, response);
    }
}
