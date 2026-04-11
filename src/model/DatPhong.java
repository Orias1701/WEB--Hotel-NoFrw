package model;

import java.math.BigDecimal;
import java.sql.Timestamp; // Import BigDecimal

public class DatPhong {

    private int maDatPhong;
    private int maHoaDon;
    private int maNhanVien;
    private int maPhong;
    private int maKhachHang; // Added to support web view

    private Timestamp ngayDatPhong;
    private Timestamp ngayNhanPhong;
    private Timestamp ngayHenTra;
    private Timestamp ngayTraPhong;
    private Timestamp ngayThanhToan;

    private BigDecimal tienPhong; // Đổi từ double sang BigDecimal
    private BigDecimal tienPhat;  // Đổi từ double sang BigDecimal

    private String tenKhachHang;
    private String soPhong;
    private String tenNhanVien;

    public DatPhong() {}

    public DatPhong(int maDatPhong, int maHoaDon, int maNhanVien, int maPhong,
                    Timestamp ngayDatPhong, Timestamp ngayNhanPhong, Timestamp ngayHenTra,
                    Timestamp ngayTraPhong, Timestamp ngayThanhToan,
                    BigDecimal tienPhong, BigDecimal tienPhat) { // Cập nhật kiểu dữ liệu trong constructor

        this.maDatPhong = maDatPhong;
        this.maHoaDon = maHoaDon;
        this.maNhanVien = maNhanVien;
        this.maPhong = maPhong;

        this.ngayDatPhong = ngayDatPhong;
        this.ngayNhanPhong = ngayNhanPhong;
        this.ngayHenTra = ngayHenTra;
        this.ngayTraPhong = ngayTraPhong;
        this.ngayThanhToan = ngayThanhToan;

        this.tienPhong = tienPhong;
        this.tienPhat = tienPhat;
    }

    // GETTERS
    public int getMaDatPhong() { return maDatPhong; }
    public int getMaHoaDon() { return maHoaDon; }
    public int getMaNhanVien() { return maNhanVien; }
    public int getMaPhong() { return maPhong; }
    public int getMaKhachHang() { return maKhachHang; }

    public Timestamp getNgayDatPhong() { return ngayDatPhong; }
    public Timestamp getNgayNhanPhong() { return ngayNhanPhong; }
    public Timestamp getNgayHenTra() { return ngayHenTra; }
    public Timestamp getNgayTraPhong() { return ngayTraPhong; }
    public Timestamp getNgayThanhToan() { return ngayThanhToan; }

    public BigDecimal getTienPhong() { return tienPhong; } // Cập nhật kiểu trả về
    public BigDecimal getTienPhat() { return tienPhat; }   // Cập nhật kiểu trả về

    public String getTenKhachHang() { return tenKhachHang; }
    public String getSoPhong() { return soPhong; }
    public String getTenNhanVien() { return tenNhanVien; }

    public void setTenKhachHang(String ten) { this.tenKhachHang = ten; }
    public void setSoPhong(String so) { this.soPhong = so; }
    public void setTenNhanVien(String ten) { this.tenNhanVien = ten; }

    // SETTERS
    public void setMaDatPhong(int maDatPhong) { this.maDatPhong = maDatPhong; }
    public void setMaHoaDon(int maHoaDon) { this.maHoaDon = maHoaDon; }
    public void setMaNhanVien(int maNhanVien) { this.maNhanVien = maNhanVien; }
    public void setMaPhong(int maPhong) { this.maPhong = maPhong; }
    public void setMaKhachHang(int maKhachHang) { this.maKhachHang = maKhachHang; }

    public void setNgayDatPhong(Timestamp ngayDatPhong) { this.ngayDatPhong = ngayDatPhong; }
    public void setNgayNhanPhong(Timestamp ngayNhanPhong) { this.ngayNhanPhong = ngayNhanPhong; }
    public void setNgayHenTra(Timestamp ngayHenTra) { this.ngayHenTra = ngayHenTra; }
    public void setNgayTraPhong(Timestamp ngayTraPhong) { this.ngayTraPhong = ngayTraPhong; }
    public void setNgayThanhToan(Timestamp ngayThanhToan) { this.ngayThanhToan = ngayThanhToan; }

    public void setTienPhong(BigDecimal tienPhong) { this.tienPhong = tienPhong; } // Cập nhật kiểu tham số
    public void setTienPhat(BigDecimal tienPhat) { this.tienPhat = tienPhat; }     // Cập nhật kiểu tham số
}