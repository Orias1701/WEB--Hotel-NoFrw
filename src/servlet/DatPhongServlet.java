package servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DatPhong;
import model.HoaDon;
import model.LoaiPhong;
import model.TaiKhoan;
import model.KiemTraPhong;
import service.DatPhongService;
import service.KhachHangService;
import service.PhongService;
import service.HoaDonService;
import service.KiemTraPhongService;
import util.DatPhongUtils;

@WebServlet("/dat-phong-data")
public class DatPhongServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DatPhongService datPhongService = new DatPhongService();
    private KhachHangService khachHangService = new KhachHangService();
    private PhongService phongService = new PhongService();
    private HoaDonService hoaDonService = new HoaDonService();
    private KiemTraPhongService ktPhongService = new KiemTraPhongService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get all bookings
        List<DatPhong> dataList = datPhongService.getAll();
        request.setAttribute("dataList", dataList);

        // 2. Get help data for the form
        request.setAttribute("listKhachHang", khachHangService.getAll());
        request.setAttribute("listPhongTrong", phongService.getAllByStatus("Trống"));
        
        // 3. Forward to fragment
        request.getRequestDispatcher("dat-phong.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        TaiKhoan userLogin = (TaiKhoan) session.getAttribute("user");
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                doAdd(request, userLogin);
            } else if ("checkout".equals(action)) {
                doTraPhong(request);
            } else if ("delete".equals(action)) {
                doDelete(request);
            }
            
            response.sendRedirect("main?view=dat-phong");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý đặt phòng: " + e.getMessage());
        }
    }

    private void doAdd(HttpServletRequest request, TaiKhoan userLogin) throws Exception {
        int maKhachHang = Integer.parseInt(request.getParameter("maKhachHang"));
        int maPhong = Integer.parseInt(request.getParameter("maPhong"));
        
        // Parse date-time inputs (Format: yyyy-MM-ddTHH:mm)
        Timestamp ngayNhan = Timestamp.valueOf(request.getParameter("ngayNhan").replace("T", " ") + ":00");
        Timestamp ngayHenTra = Timestamp.valueOf(request.getParameter("ngayHenTra").replace("T", " ") + ":00");

        LoaiPhong lp = phongService.getLoaiPhongByPhong(maPhong);
        BigDecimal giaNgay = lp.getGiaCoBan();

        BigDecimal tienPhong = DatPhongUtils.tinhTienPhong(ngayNhan, ngayHenTra, giaNgay);

        // 1. Create Invoice
        HoaDon hd = new HoaDon(0, userLogin.getMaNhanVien(), maKhachHang,
                new Timestamp(System.currentTimeMillis()), null, BigDecimal.ZERO, "Chưa thanh toán");

        int maHoaDon = hoaDonService.create(hd);
        
        // 2. Create Booking
        DatPhong d = new DatPhong(
                0, maHoaDon, userLogin.getMaNhanVien(), maPhong,
                new Timestamp(System.currentTimeMillis()),
                ngayNhan, ngayHenTra,
                null, null,
                tienPhong,
                BigDecimal.ZERO);

        if (datPhongService.add(d)) {
            phongService.updateStatus(maPhong, "Đang ở");
        }
    }

    private void doTraPhong(HttpServletRequest request) throws Exception {
        int id = Integer.parseInt(request.getParameter("maDatPhong"));
        DatPhong dp = datPhongService.getById(id);
        
        HoaDon hd = hoaDonService.getById(dp.getMaHoaDon());
        if (hd.getTrangThai().equals("Đã thanh toán")) return;

        Timestamp now = new Timestamp(System.currentTimeMillis());
        LoaiPhong lp = phongService.getLoaiPhongByPhong(dp.getMaPhong());
        BigDecimal giaNgay = lp.getGiaCoBan();

        BigDecimal tienPhong = dp.getTienPhong() != null ? dp.getTienPhong() : BigDecimal.ZERO;
        BigDecimal tienPhat = DatPhongUtils.tinhPhatTheoGio(dp.getNgayHenTra(), now, giaNgay);

        KiemTraPhong kt = ktPhongService.getByMaHoaDon(dp.getMaHoaDon());
        BigDecimal tienBoiThuong = kt != null && kt.getTienBoiThuong() != null ? kt.getTienBoiThuong() : BigDecimal.ZERO;

        if (datPhongService.traPhong(id, now, tienPhong, tienPhat)) {
            BigDecimal tongTien = tienPhong.add(tienPhat).add(tienBoiThuong);

            hd.setTongTien(tongTien);
            hd.setTrangThai("Đã thanh toán");
            hd.setNgayThanhToan(now);
            hoaDonService.update(hd);

            phongService.updateStatus(dp.getMaPhong(), "Trống");
        }
    }

    private void doDelete(HttpServletRequest request) throws Exception {
        int id = Integer.parseInt(request.getParameter("maDatPhong"));
        DatPhong dp = datPhongService.getById(id);
        
        HoaDon hd = hoaDonService.getById(dp.getMaHoaDon());
        if (hd.getTrangThai().equals("Đã thanh toán")) return;

        phongService.updateStatus(dp.getMaPhong(), "Trống");
        datPhongService.delete(id);
        hoaDonService.delete(dp.getMaHoaDon());
    }
}
