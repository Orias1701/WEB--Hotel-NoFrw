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

        // Check if it's an AJAX request to load a module
        String module = request.getParameter("view");
        if (module != null && !module.isEmpty()) {
            // Forward to the data-providing servlet for this module
            request.getRequestDispatcher("/" + module + "-data").forward(request, response);
            return;
        }

        // Initial load of the main layout
        request.getRequestDispatcher("main.jsp").forward(request, response);
    }
}
