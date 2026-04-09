package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.DeletionCheckService;

@WebServlet("/check-delete")
public class DeleteCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DeletionCheckService dcs = new DeletionCheckService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        try {
            String type = request.getParameter("type");
            int id = Integer.parseInt(request.getParameter("id"));

            boolean canDelete = dcs.canDelete(type, id);
            String message = canDelete
                    ? "Có thể xóa"
                    : "Không thể xóa: bản ghi này đang được tham chiếu bởi dữ liệu khác.";

            response.getWriter().write(
                    "{\"canDelete\":" + canDelete + ",\"message\":\"" + message + "\"}");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"canDelete\":false,\"message\":\"Lỗi kiểm tra: " + e.getMessage() + "\"}");
        }
    }
}
