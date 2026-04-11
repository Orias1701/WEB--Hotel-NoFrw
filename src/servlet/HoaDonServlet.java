package servlet;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.HoaDon;
import service.HoaDonService;
import service.KhachHangService;

@WebServlet("/hoa-don-data")
public class HoaDonServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private HoaDonService hoaDonService = new HoaDonService();
    private KhachHangService khachHangService = new KhachHangService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<HoaDon> listHoaDon = hoaDonService.getAll();
        request.setAttribute("listHoaDon", listHoaDon);
        request.setAttribute("listKhachHang", khachHangService.getAll());
        
        request.getRequestDispatcher("hoa-don.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("pay".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maHoaDon"));
                HoaDon hd = hoaDonService.getById(id);
                if (hd != null && !"Đã thanh toán".equals(hd.getTrangThai())) {
                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    hd.setTrangThai("Đã thanh toán");
                    hd.setNgayThanhToan(now);
                    hoaDonService.update(hd);

                    // Tự động làm thủ tục trả phòng cho TOÀN BỘ danh sách phòng trong đoàn
                    service.DatPhongService dpService = new service.DatPhongService();
                    service.PhongService pService = new service.PhongService();
                    List<model.DatPhong> listDP = dpService.getAllByMaHoaDon(id);
                    
                    java.math.BigDecimal tongTienDoan = java.math.BigDecimal.ZERO;

                    for (model.DatPhong dp : listDP) {
                        java.math.BigDecimal tienCuaPhongNay = java.math.BigDecimal.ZERO;
                        
                        if (dp.getNgayTraPhong() == null) {
                            // Phòng chưa trả -> Làm thủ tục tự động
                            model.LoaiPhong lp = pService.getLoaiPhongByPhong(dp.getMaPhong());
                            java.math.BigDecimal giaGio = lp.getGiaCoBan();

                            java.math.BigDecimal tienPhong = dp.getTienPhong() != null ? dp.getTienPhong() : java.math.BigDecimal.ZERO;
                            java.math.BigDecimal tienPhat = util.DatPhongUtils.tinhPhatTheoGio(dp.getNgayHenTra(), now, giaGio);

                            if (dpService.traPhong(dp.getMaDatPhong(), now, tienPhong, tienPhat)) {
                                pService.updateStatus(dp.getMaPhong(), "Trống");
                                tienCuaPhongNay = tienPhong.add(tienPhat);
                            }
                        } else {
                            // Phòng đã trả trước đó -> Lấy số tiền đã chốt
                            java.math.BigDecimal tienPhong = dp.getTienPhong() != null ? dp.getTienPhong() : java.math.BigDecimal.ZERO;
                            java.math.BigDecimal tienPhat = dp.getTienPhat() != null ? dp.getTienPhat() : java.math.BigDecimal.ZERO;
                            tienCuaPhongNay = tienPhong.add(tienPhat);
                        }
                        
                        tongTienDoan = tongTienDoan.add(tienCuaPhongNay);
                    }
                    
                    // Cập nhật lại tổng tiền Hóa đơn dựa trên tất cả các phòng
                    hd.setTongTien(tongTienDoan);
                    hoaDonService.update(hd);
                }
            }
            response.sendRedirect("main?view=hoa-don");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi thanh toán hóa đơn");
        }
    }
}
