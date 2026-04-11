package model;

import java.math.BigDecimal;
import java.sql.Timestamp; // Import BigDecimal

public class HoaDon {

    private int maHoaDon;
    private int maNhanVien;
    private int maKhachHang;
    private Timestamp ngayTao;
    private Timestamp ngayThanhToan;
    private BigDecimal tongTien; // Đổi từ double sang BigDecimal
    private String trangThai;

    private String tenKhachHang;
    private String tenNhanVien;

    public String getTenKhachHang() { return tenKhachHang; }
    public void setTenKhachHang(String ten) { this.tenKhachHang = ten; }

    public String getTenNhanVien() { return tenNhanVien; }
    public void setTenNhanVien(String ten) { this.tenNhanVien = ten; }

    public HoaDon() {
    }

    public HoaDon(int maHD, int maNV, int maKH, Timestamp ngayTao, Timestamp ngayTT,
            BigDecimal tongTien, String trangThai) { // Cập nhật kiểu dữ liệu trong constructor
        this.maHoaDon = maHD;
        this.maNhanVien = maNV;
        this.maKhachHang = maKH;
        this.ngayTao = ngayTao;
        this.ngayThanhToan = ngayTT;
        this.tongTien = tongTien;
        this.trangThai = trangThai;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String tt) {
        this.trangThai = tt;
    }

    // constructor khi tạo mới
    public HoaDon(int nv, int kh) {
        this.maNhanVien = nv;
        this.maKhachHang = kh;
        this.ngayTao = new Timestamp(System.currentTimeMillis());
        this.tongTien = BigDecimal.ZERO; // Khởi tạo bằng BigDecimal.ZERO thay vì 0
    }

    public int getMaHoaDon() {
        return maHoaDon;
    }

    public int getMaNhanVien() {
        return maNhanVien;
    }

    public int getMaKhachHang() {
        return maKhachHang;
    }

    public Timestamp getNgayTao() {
        return ngayTao;
    }

    public Timestamp getNgayThanhToan() {
        return ngayThanhToan;
    }

    public BigDecimal getTongTien() {
        return tongTien;
    } // Cập nhật kiểu trả về

    public void setMaHoaDon(int maHoaDon) {
        this.maHoaDon = maHoaDon;
    }

    public void setNgayTao(Timestamp ngayTao) {
        this.ngayTao = ngayTao;
    }

    public void setNgayThanhToan(Timestamp tt) {
        this.ngayThanhToan = tt;
    }

    public void setTongTien(BigDecimal tongTien) {
        this.tongTien = tongTien;
    } // Cập nhật kiểu tham số
}