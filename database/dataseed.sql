-- PostgreSQL Data Seed for hotelmanage
-- Migrated from SQL Server

SET search_path TO hotelmanage;

-----------------------------------------------------------
-- 1. XÓA DỮ LIỆU CŨ (NẾU CÓ) ĐỂ TRÁNH TRÙNG LẶP
-----------------------------------------------------------
TRUNCATE b_kiemtrachitiet,
b_kiemtraphong,
a_datphong,
z_hoadon,
b_thietbiphong,
a_phong,
b_thietbi,
a_loaiphong,
y_taikhoan,
x_khachhang,
y_nhanvien,
y_vaitro RESTART IDENTITY CASCADE;

-----------------------------------------------------------
-- 2. DỮ LIỆU CƠ BẢN (VAI TRÒ, LOẠI PHÒNG, THIẾT BỊ)
-----------------------------------------------------------

-- Vai trò
INSERT INTO
    y_vaitro (maVaiTro, tenVaiTro)
VALUES (1, 'Admin'),
    (2, 'Nhân viên Đặt phòng'),
    (3, 'Nhân viên Kiểm tra');

-- Loại phòng (Luxury, Premium, VIP)
INSERT INTO
    a_loaiphong (
        maLoaiPhong,
        tenLoaiPhong,
        giaCoBan
    )
VALUES (1, 'Luxury', 80000), -- 80k/h
    (2, 'Premium', 180000), -- 180k/h
    (3, 'VIP', 300000);
-- 300k/h

-- Thiết bị (10 loại)
INSERT INTO
    b_thietbi (
        maThietBi,
        tenThietBi,
        giaThietBi
    )
VALUES (
        1,
        'Smart TV 55 inch',
        12000000
    ),
    (2, 'Tủ lạnh mini', 3500000),
    (
        3,
        'Điều hòa 2 chiều',
        9000000
    ),
    (4, 'Máy sấy tóc', 500000),
    (
        5,
        'Giường King Size',
        15000000
    ),
    (6, 'Ghế Sofa da', 8000000),
    (7, 'Bàn làm việc gỗ', 4000000),
    (
        8,
        'Đèn chùm trang trí',
        2500000
    ),
    (9, 'Két sắt điện tử', 3000000),
    (
        10,
        'Bồn tắm Massage',
        20000000
    );

-----------------------------------------------------------
-- 3. NHÂN VIÊN & TÀI KHOẢN
-------------------------------------------

-- Nhân viên (1 Admin, 2 Đặt phòng, 2 Kiểm tra)
INSERT INTO
    y_nhanvien (
        maNhanVien,
        tenNhanVien,
        soDienThoai,
        email
    )
VALUES (
        1,
        'Nguyễn Quản Lý',
        '0901000001',
        'admin@hotel.com'
    ),
    (
        2,
        'Trần Đặt Phòng A',
        '0901000002',
        'sale1@hotel.com'
    ),
    (
        3,
        'Lê Đặt Phòng B',
        '0901000003',
        'sale2@hotel.com'
    ),
    (
        4,
        'Phạm Kiểm Tra A',
        '0901000004',
        'checker1@hotel.com'
    ),
    (
        5,
        'Hoàng Kiểm Tra B',
        '0901000005',
        'checker2@hotel.com'
    );

-- Tài khoản
INSERT INTO
    y_taikhoan (
        id,
        taiKhoan,
        matKhau,
        maNhanVien,
        maVaiTro
    )
VALUES (1, 'admin', '123456', 1, 1),
    (2, 'sale1', '123456', 2, 2),
    (3, 'sale2', '123456', 3, 2),
    (4, 'check1', '123456', 4, 3),
    (5, 'check2', '123456', 5, 3);

-----------------------------------------------------------
-- 4. KHÁCH HÀNG (10 người)
-----------------------------------------------------------
INSERT INTO
    x_khachhang (
        maKhachHang,
        tenKhachHang,
        soDienThoai,
        email
    )
VALUES (
        1,
        'Nguyễn Văn Khách 1',
        '0987654321',
        'k1@gmail.com'
    ),
    (
        2,
        'Trần Thị Khách 2',
        '0987654322',
        'k2@gmail.com'
    ),
    (
        3,
        'Lê Văn Khách 3',
        '0987654323',
        'k3@gmail.com'
    ),
    (
        4,
        'Phạm Thị Khách 4',
        '0987654324',
        'k4@gmail.com'
    ),
    (
        5,
        'Hoàng Văn Khách 5',
        '0987654325',
        'k5@gmail.com'
    ),
    (
        6,
        'Đỗ Thị Khách 6',
        '0987654326',
        'k6@gmail.com'
    ),
    (
        7,
        'Vũ Văn Khách 7',
        '0987654327',
        'k7@gmail.com'
    ),
    (
        8,
        'Ngô Thị Khách 8',
        '0987654328',
        'k8@gmail.com'
    ),
    (
        9,
        'Dương Văn Khách 9',
        '0987654329',
        'k9@gmail.com'
    ),
    (
        10,
        'Lý Thị Khách 10',
        '0987654330',
        'k10@gmail.com'
    );

-----------------------------------------------------------
-- 5. TẠO PHÒNG (30 phòng, 5 tầng)
-----------------------------------------------------------
DO $$
DECLARE
    tang INT;
BEGIN
    FOR tang IN 1..5 LOOP
        -- 1 Phòng VIP mỗi tầng
        INSERT INTO a_phong (soPhong, maLoaiPhong, trangThai) 
        VALUES ('V' || tang || '01', 3, 'Trống');

        -- 2 Phòng Premium mỗi tầng
        INSERT INTO a_phong (soPhong, maLoaiPhong, trangThai) 
        VALUES ('P' || tang || '01', 2, 'Trống'),
               ('P' || tang || '02', 2, 'Trống');

        -- 3 Phòng Luxury mỗi tầng
        INSERT INTO a_phong (soPhong, maLoaiPhong, trangThai) 
        VALUES ('L' || tang || '01', 1, 'Trống'),
               ('L' || tang || '02', 1, 'Trống'),
               ('L' || tang || '03', 1, 'Trống');
    END LOOP;
END $$;

-----------------------------------------------------------
-- 6. THIẾT BỊ TRONG PHÒNG
-----------------------------------------------------------
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT maPhong FROM a_phong LOOP
        -- Thiết bị 1, 3, 5 (TV, Điều hòa, Giường) có ở tất cả các phòng
        INSERT INTO b_thietbiphong (maPhong, maThietBi, soLuong, trangThai) VALUES (r.maPhong, 1, 1, 'Tốt');
        INSERT INTO b_thietbiphong (maPhong, maThietBi, soLuong, trangThai) VALUES (r.maPhong, 3, 1, 'Tốt');
        INSERT INTO b_thietbiphong (maPhong, maThietBi, soLuong, trangThai) VALUES (r.maPhong, 5, 1, 'Tốt');

        -- Random thêm dựa trên ID phòng chẵn lẻ để tạo sự khác biệt
        IF r.maPhong % 2 = 0 THEN
            INSERT INTO b_thietbiphong (maPhong, maThietBi, soLuong, trangThai) VALUES (r.maPhong, 2, 1, 'Tốt'); -- Tủ lạnh
            INSERT INTO b_thietbiphong (maPhong, maThietBi, soLuong, trangThai) VALUES (r.maPhong, 7, 1, 'Tốt'); -- Bàn
        ELSE
            INSERT INTO b_thietbiphong (maPhong, maThietBi, soLuong, trangThai) VALUES (r.maPhong, 4, 2, 'Tốt'); -- Máy sấy (2 cái)
            INSERT INTO b_thietbiphong (maPhong, maThietBi, soLuong, trangThai) VALUES (r.maPhong, 6, 1, 'Tốt'); -- Sofa
        END IF;
        
        -- Phòng VIP (Sophong có chữ 'V') thêm Bồn tắm
        IF EXISTS (SELECT 1 FROM a_phong WHERE maPhong = r.maPhong AND soPhong LIKE 'V%') THEN
             INSERT INTO b_thietbiphong (maPhong, maThietBi, soLuong, trangThai) VALUES (r.maPhong, 10, 1, 'Tốt');
        END IF;
    END LOOP;
END $$;

-----------------------------------------------------------
-- 7. HÓA ĐƠN & ĐẶT PHÒNG & KIỂM TRA
-----------------------------------------------------------
-- Khách 1, HD1
INSERT INTO
    z_hoadon (
        maHoaDon,
        maNhanVien,
        maKhachHang,
        ngayTao,
        ngayThanhToan,
        tongTien,
        trangThai
    )
VALUES (
        1,
        2,
        1,
        '2023-09-05 10:00:00',
        '2023-09-07 12:00:00',
        0,
        'Đã thanh toán'
    );

INSERT INTO
    a_datphong (
        maDatPhong,
        maHoaDon,
        maNhanVien,
        maPhong,
        ngayDatPhong,
        ngayNhanPhong,
        ngayHenTra,
        ngayTraPhong,
        ngayThanhToan,
        tienPhong,
        tienPhat
    )
SELECT 1, 1, 2, maPhong, '2023-09-01 08:00:00', '2023-09-05 12:00:00', '2023-09-07 12:00:00', '2023-09-07 12:00:00', '2023-09-07 12:00:00', 14400000, 0
FROM a_phong
WHERE
    soPhong = 'V101';

INSERT INTO
    b_kiemtraphong (
        maKiemTraPhong,
        maHoaDon,
        maPhong,
        ngayThanhToan,
        tienBoiThuong
    )
SELECT 1, 1, maPhong, '2023-09-07 12:00:00', 0
FROM a_phong
WHERE
    soPhong = 'V101';

-- Khách 1, HD1, Room 2
INSERT INTO
    a_datphong (
        maDatPhong,
        maHoaDon,
        maNhanVien,
        maPhong,
        ngayDatPhong,
        ngayNhanPhong,
        ngayHenTra,
        ngayTraPhong,
        ngayThanhToan,
        tienPhong,
        tienPhat
    )
SELECT 2, 1, 2, maPhong, '2023-09-01 08:00:00', '2023-09-05 12:00:00', '2023-09-07 12:00:00', '2023-09-07 12:00:00', '2023-09-07 12:00:00', 3840000, 0
FROM a_phong
WHERE
    soPhong = 'L101';

INSERT INTO
    b_kiemtraphong (
        maKiemTraPhong,
        maHoaDon,
        maPhong,
        ngayThanhToan,
        tienBoiThuong
    )
SELECT 2, 1, maPhong, '2023-09-07 12:00:00', 200000
FROM a_phong
WHERE
    soPhong = 'L101';

INSERT INTO
    b_kiemtrachitiet (
        maNhanVien,
        maKiemTraPhong,
        maThietBiPhong,
        soLuongBiHong,
        ghiChu
    )
SELECT 4, 2, tp.maThietBiPhong, 1, 'Làm vỡ vỏ máy'
FROM b_thietbiphong tp
    JOIN a_phong p ON tp.maPhong = p.maPhong
WHERE
    p.soPhong = 'L101'
    AND tp.maThietBi = 4;

-- HD2
INSERT INTO
    z_hoadon (
        maHoaDon,
        maNhanVien,
        maKhachHang,
        ngayTao,
        ngayThanhToan,
        tongTien,
        trangThai
    )
VALUES (
        2,
        3,
        1,
        '2023-10-10 14:00:00',
        '2023-10-11 14:00:00',
        0,
        'Đã thanh toán'
    );

INSERT INTO
    a_datphong (
        maDatPhong,
        maHoaDon,
        maNhanVien,
        maPhong,
        ngayDatPhong,
        ngayNhanPhong,
        ngayHenTra,
        ngayTraPhong,
        ngayThanhToan,
        tienPhong,
        tienPhat
    )
SELECT 3, 2, 3, maPhong, '2023-10-01 09:00:00', '2023-10-10 14:00:00', '2023-10-11 12:00:00', '2023-10-11 14:00:00', '2023-10-11 14:00:00', 3960000, 468000
FROM a_phong
WHERE
    soPhong = 'P201';

INSERT INTO
    b_kiemtraphong (
        maKiemTraPhong,
        maHoaDon,
        maPhong,
        ngayThanhToan,
        tienBoiThuong
    )
SELECT 3, 2, maPhong, '2023-10-11 14:00:00', 0
FROM a_phong
WHERE
    soPhong = 'P201';

-- Khách 1, HD3
INSERT INTO
    z_hoadon (
        maHoaDon,
        maNhanVien,
        maKhachHang,
        ngayTao,
        ngayThanhToan,
        tongTien,
        trangThai
    )
VALUES (
        3,
        2,
        1,
        '2023-11-01 12:00:00',
        '2023-11-02 12:00:00',
        0,
        'Đã thanh toán'
    );

INSERT INTO
    a_datphong (
        maDatPhong,
        maHoaDon,
        maNhanVien,
        maPhong,
        ngayDatPhong,
        ngayNhanPhong,
        ngayHenTra,
        ngayTraPhong,
        ngayThanhToan,
        tienPhong,
        tienPhat
    )
SELECT 4, 3, 2, maPhong, '2023-11-01 10:00:00', '2023-11-01 12:00:00', '2023-11-02 12:00:00', '2023-11-02 12:00:00', '2023-11-02 12:00:00', 1920000, 0
FROM a_phong
WHERE
    soPhong = 'L301';

INSERT INTO
    b_kiemtraphong (
        maKiemTraPhong,
        maHoaDon,
        maPhong,
        ngayThanhToan,
        tienBoiThuong
    )
SELECT 4, 3, maPhong, '2023-11-02 12:00:00', 0
FROM a_phong
WHERE
    soPhong = 'L301';

-----------------------------------------------------------
-- 8. CẬP NHẬT TỔNG TIỀN HÓA ĐƠN
-----------------------------------------------------------
UPDATE z_hoadon
SET
    tongTien = (
        SELECT COALESCE(
                SUM(dp.tienPhong + dp.tienPhat), 0
            )
        FROM a_datphong dp
        WHERE
            dp.maHoaDon = z_hoadon.maHoaDon
    ) + (
        SELECT COALESCE(SUM(kt.tienBoiThuong), 0)
        FROM b_kiemtraphong kt
        WHERE
            kt.maHoaDon = z_hoadon.maHoaDon
    );

-- Update sequences
SELECT setval(pg_get_serial_sequence('y_vaitro', 'mavaitro'), COALESCE((SELECT MAX(maVaiTro) FROM y_vaitro), 1));
SELECT setval(pg_get_serial_sequence('a_loaiphong', 'maloaiphong'), COALESCE((SELECT MAX(maLoaiPhong) FROM a_loaiphong), 1));
SELECT setval(pg_get_serial_sequence('b_thietbi', 'mathietbi'), COALESCE((SELECT MAX(maThietBi) FROM b_thietbi), 1));
SELECT setval(pg_get_serial_sequence('y_nhanvien', 'manhanvien'), COALESCE((SELECT MAX(maNhanVien) FROM y_nhanvien), 1));
SELECT setval(pg_get_serial_sequence('y_taikhoan', 'id'), COALESCE((SELECT MAX(id) FROM y_taikhoan), 1));
SELECT setval(pg_get_serial_sequence('x_khachhang', 'makhachhang'), COALESCE((SELECT MAX(maKhachHang) FROM x_khachhang), 1));
SELECT setval(pg_get_serial_sequence('a_phong', 'maphong'), COALESCE((SELECT MAX(maPhong) FROM a_phong), 1));
SELECT setval(pg_get_serial_sequence('b_thietbiphong', 'mathietbiphong'), COALESCE((SELECT MAX(maThietBiPhong) FROM b_thietbiphong), 1));
SELECT setval(pg_get_serial_sequence('z_hoadon', 'mahoadon'), COALESCE((SELECT MAX(maHoaDon) FROM z_hoadon), 1));
SELECT setval(pg_get_serial_sequence('a_datphong', 'madatphong'), COALESCE((SELECT MAX(maDatPhong) FROM a_datphong), 1));
SELECT setval(pg_get_serial_sequence('b_kiemtraphong', 'makiemtraphong'), COALESCE((SELECT MAX(maKiemTraPhong) FROM b_kiemtraphong), 1));
SELECT setval(pg_get_serial_sequence('b_kiemtrachitiet', 'makiemtrachitiet'), COALESCE((SELECT MAX(maKiemTraChiTiet) FROM b_kiemtrachitiet), 1));