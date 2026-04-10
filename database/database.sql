-- PostgreSQL Database Schema for hotelbook
-- Migrated from SQL Server

CREATE SCHEMA IF NOT EXISTS hotelbook;
SET search_path TO hotelbook;

------------------------------------------
-- y_vaitro
------------------------------------------
CREATE TABLE y_vaitro (
  maVaiTro SERIAL PRIMARY KEY,
  tenVaiTro VARCHAR(50) NOT NULL
);

------------------------------------------
-- y_nhanvien
------------------------------------------
CREATE TABLE y_nhanvien (
  maNhanVien SERIAL PRIMARY KEY,
  tenNhanVien VARCHAR(100) NOT NULL,
  soDienThoai VARCHAR(15),
  email VARCHAR(100) UNIQUE
);

------------------------------------------
-- x_khachhang
------------------------------------------
CREATE TABLE x_khachhang (
  maKhachHang SERIAL PRIMARY KEY,
  tenKhachHang VARCHAR(100) NOT NULL,
  soDienThoai VARCHAR(15),
  email VARCHAR(100)
);

------------------------------------------
-- y_taikhoan
------------------------------------------
CREATE TABLE y_taikhoan (
  id SERIAL PRIMARY KEY,
  taiKhoan VARCHAR(50) UNIQUE NOT NULL,
  matKhau VARCHAR(255) NOT NULL,
  maNhanVien INT,
  maVaiTro INT,
  FOREIGN KEY (maNhanVien) REFERENCES y_nhanvien(maNhanVien),
  FOREIGN KEY (maVaiTro) REFERENCES y_vaitro(maVaiTro)
);

------------------------------------------
-- a_loaiphong
------------------------------------------
CREATE TABLE a_loaiphong (
  maLoaiPhong SERIAL PRIMARY KEY,
  tenLoaiPhong VARCHAR(100) NOT NULL,
  giaCoBan DECIMAL(15, 2) NOT NULL
);



------------------------------------------
-- a_phong
------------------------------------------
CREATE TABLE a_phong (
  maPhong SERIAL PRIMARY KEY,
  soPhong VARCHAR(10) UNIQUE NOT NULL,
  maLoaiPhong INT,
  trangThai VARCHAR(20),
  FOREIGN KEY (maLoaiPhong) REFERENCES a_loaiphong(maLoaiPhong)
);



------------------------------------------
-- z_hoadon
------------------------------------------
CREATE TABLE z_hoadon (
  maHoaDon SERIAL PRIMARY KEY,
  maNhanVien INT NULL,
  maKhachHang INT NULL,
  ngayTao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ngayThanhToan TIMESTAMP,
  tongTien DECIMAL(15, 2) DEFAULT 0,
  trangThai VARCHAR(20),
  FOREIGN KEY (maNhanVien) REFERENCES y_nhanvien(maNhanVien),
  FOREIGN KEY (maKhachHang) REFERENCES x_khachhang(maKhachHang)
);





------------------------------------------
-- a_datphong
------------------------------------------
CREATE TABLE a_datphong (
  maDatPhong SERIAL PRIMARY KEY,
  maHoaDon INT,
  maNhanVien INT,
  maPhong INT,
  ngayDatPhong TIMESTAMP,
  ngayNhanPhong TIMESTAMP,
  ngayHenTra TIMESTAMP,
  ngayTraPhong TIMESTAMP,
  ngayThanhToan TIMESTAMP,
  tienPhong DECIMAL(15, 2),
  tienPhat DECIMAL(15, 2),
  FOREIGN KEY (maHoaDon) REFERENCES z_hoadon(maHoaDon) ON DELETE CASCADE,
  FOREIGN KEY (maNhanVien) REFERENCES y_nhanvien(maNhanVien) ON DELETE SET NULL,
  FOREIGN KEY (maPhong) REFERENCES a_phong(maPhong) ON DELETE SET NULL
);