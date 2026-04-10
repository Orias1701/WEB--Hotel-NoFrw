-- PostgreSQL Data Seed for hotelbook
-- Cập nhật dữ liệu mẫu (Mock Data) với số lượng lớn và logic thời gian thực tế

SET search_path TO hotelbook;

-----------------------------------------------------------
-- 1. XÓA DỮ LIỆU CŨ VÀ RESET ID SEQUENCE
-----------------------------------------------------------
TRUNCATE a_datphong,
z_hoadon,
a_phong,
a_loaiphong,
y_taikhoan,
x_khachhang,
y_nhanvien,
y_vaitro RESTART IDENTITY CASCADE;

-----------------------------------------------------------
-- 2. DỮ LIỆU CƠ BẢN: VAI TRÒ & LOẠI PHÒNG
-----------------------------------------------------------
-- Vai trò (Giữ nguyên 2 vai trò)
INSERT INTO
    y_vaitro (maVaiTro, tenVaiTro)
VALUES (1, 'Admin'),
    (2, 'Nhân viên');

-- Loại phòng (Standard, Luxury, VIP theo yêu cầu chữ cái S, L, V)
INSERT INTO
    a_loaiphong (
        maLoaiPhong,
        tenLoaiPhong,
        giaCoBan
    )
VALUES (1, 'Standard', 80000), -- Ký hiệu S (Normal)
    (2, 'Luxury', 180000), -- Ký hiệu L
    (3, 'VIP', 300000);
-- Ký hiệu V

-----------------------------------------------------------
-- 3. NHÂN VIÊN & TÀI KHOẢN (1 Admin, 10 Nhân viên)
-----------------------------------------------------------
-- Admin (Giữ nguyên như cũ)
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
    );

INSERT INTO
    y_taikhoan (
        id,
        taiKhoan,
        matKhau,
        maNhanVien,
        maVaiTro
    )
VALUES (1, 'admin', '123456', 1, 1);

-- 10 Nhân viên (Sinh tự động)
DO $$
DECLARE 
    i INT;
    v_sdt VARCHAR;
    v_email VARCHAR;
BEGIN
    FOR i IN 2..11 LOOP
        v_sdt := '0912000' || lpad(i::text, 3, '0');
        v_email := 'nhanvien' || i || '@hotel.com';
        
        -- Thêm Nhân viên
        INSERT INTO y_nhanvien (maNhanVien, tenNhanVien, soDienThoai, email)
        VALUES (i, 'Trần Nhân Viên ' || (i-1), v_sdt, v_email);
        
        -- Thêm Tài khoản (Tài khoản = email, Mật khẩu = SĐT)
        INSERT INTO y_taikhoan (id, taiKhoan, matKhau, maNhanVien, maVaiTro)
        VALUES (i, v_email, v_sdt, i, 2);
    END LOOP;
END $$;

-----------------------------------------------------------
-- 4. KHÁCH HÀNG (30 Khách hàng)
-----------------------------------------------------------
DO $$
DECLARE 
    i INT;
BEGIN
    FOR i IN 1..30 LOOP
        INSERT INTO x_khachhang (maKhachHang, tenKhachHang, soDienThoai, email)
        VALUES (
            i, 
            'Khách hàng thứ ' || i, 
            '0988000' || lpad(i::text, 3, '0'), 
            'khachhang' || i || '@gmail.com'
        );
    END LOOP;
END $$;

-----------------------------------------------------------
-- 5. TẠO PHÒNG (9 Tầng, mỗi tầng 9 phòng)
-----------------------------------------------------------
-- Quy ước: 3 phòng đầu Standard (S), 3 phòng giữa Luxury (L), 3 phòng cuối VIP (V)
DO $$
DECLARE
    f INT; -- Tầng (Floor)
    r INT; -- Phòng (Room)
    v_loai INT;
    v_prefix VARCHAR(1);
    v_soPhong VARCHAR(10);
BEGIN
    FOR f IN 1..9 LOOP
        FOR r IN 1..9 LOOP
            IF r <= 3 THEN 
                v_loai := 1; v_prefix := 'S'; -- Standard
            ELSIF r <= 6 THEN 
                v_loai := 2; v_prefix := 'L'; -- Luxury
            ELSE 
                v_loai := 3; v_prefix := 'V'; -- VIP
            END IF;
            
            -- Định dạng số phòng: Ký tự + 2 số tầng + 2 số phòng (VD: N0102)
            v_soPhong := v_prefix || lpad(f::text, 2, '0') || lpad(r::text, 2, '0');
            
            INSERT INTO a_phong (soPhong, maLoaiPhong, trangThai) 
            VALUES (v_soPhong, v_loai, 'Trống');
        END LOOP;
    END LOOP;
END $$;

-----------------------------------------------------------
-- 6. HOÁ ĐƠN & ĐẶT PHÒNG (50 Hoá đơn, logic thời gian phức tạp)
-----------------------------------------------------------
DO $$
DECLARE
    i INT; j INT;
    v_maKhach INT; v_maNV INT;
    v_ngayTao TIMESTAMP;
    v_ngayThanhToan_calc TIMESTAMP;
    v_ngayThanhToan_real TIMESTAMP;
    v_trangThaiHD VARCHAR;
    v_soLuongPhong INT;
    v_maPhong INT; v_giaCoBan DECIMAL;
    v_ngayHenTra TIMESTAMP;
    v_ngayTra_calc TIMESTAMP;
    v_ngayTra_real TIMESTAMP;
    v_tienPhong DECIMAL;
    
    -- Lấy thời điểm hiện tại làm mốc so sánh
    v_now TIMESTAMP := CURRENT_TIMESTAMP; 
    -- Khởi tạo mốc thời gian ngày tạo hoá đơn đầu tiên là 30 ngày trước
    v_ngayTao_base TIMESTAMP := CURRENT_TIMESTAMP - interval '30 days';
BEGIN
    FOR i IN 1..50 LOOP
        -- Phân bổ đều khách hàng (30 khách, ai cũng có ít nhất 1, vài người 2)
        v_maKhach := (i % 30) + 1;
        
        -- Phân bổ đều nhân viên (11 nhân viên, ai cũng từng lập hoá đơn)
        v_maNV := (i % 11) + 1;
        
        -- Ngày tạo: Đồng biến với ID. Hoá đơn sau có ngày tạo trễ hơn.
        -- Với 50 hoá đơn rải đều trong 30 ngày, trung bình mỗi hoá đơn cách nhau ~14 giờ.
        -- Thêm một lượng thời gian ngẫu nhiên từ 0-10 giờ để đảm bảo không trùng lặp và tính tự nhiên.
        v_ngayTao := v_ngayTao_base + ((i - 1) * 14 + random() * 10 || ' hours')::interval;
        
        -- Thời gian thanh toán dự kiến: 2 đến 5 ngày sau khi tạo
        v_ngayThanhToan_calc := v_ngayTao + ((random() * 3 + 2) || ' days')::interval;
        
        -- Xử lý logic chưa thanh toán nếu vượt quá thời gian hiện tại
        IF v_ngayThanhToan_calc > v_now THEN
            v_ngayThanhToan_real := NULL;
            v_trangThaiHD := 'Chưa thanh toán';
        ELSE
            v_ngayThanhToan_real := v_ngayThanhToan_calc;
            v_trangThaiHD := 'Đã thanh toán';
        END IF;

        -- Tạo Hoá Đơn
        INSERT INTO z_hoadon (maHoaDon, maNhanVien, maKhachHang, ngayTao, ngayThanhToan, tongTien, trangThai)
        VALUES (i, v_maNV, v_maKhach, v_ngayTao, v_ngayThanhToan_real, 0, v_trangThaiHD);

        -- Sinh từ 1 đến 5 phòng cho mỗi hoá đơn
        v_soLuongPhong := floor(random() * 5 + 1)::INT;
        
        FOR j IN 1..v_soLuongPhong LOOP
            -- Chọn ngẫu nhiên 1 phòng
            SELECT p.maPhong, l.giaCoBan INTO v_maPhong, v_giaCoBan
            FROM a_phong p JOIN a_loaiphong l ON p.maLoaiPhong = l.maLoaiPhong
            ORDER BY random() LIMIT 1;
            
            -- Hẹn trả: sớm hơn 1 ngày cho đến bằng với thời gian thanh toán
            v_ngayHenTra := v_ngayThanhToan_calc - (random() * 1 || ' days')::interval;
            
            -- Ngày trả phòng thực tế dự kiến: Giữa ngày nhận và ngày thanh toán
            v_ngayTra_calc := v_ngayTao + (random() * EXTRACT(EPOCH FROM (v_ngayThanhToan_calc - v_ngayTao)) * interval '1 second');
            
            -- Xử lý logic phòng chưa trả
            IF v_ngayTra_calc > v_now THEN
                v_ngayTra_real := NULL;
            ELSE
                v_ngayTra_real := v_ngayTra_calc;
            END IF;

            -- Tính tiền phòng tạm (theo giờ)
            IF v_ngayTra_real IS NOT NULL THEN
                v_tienPhong := (EXTRACT(EPOCH FROM (v_ngayTra_real - v_ngayTao)) / 3600.0) * v_giaCoBan;
            ELSE
                -- Nếu chưa trả thì tính đến thời điểm hiện tại
                v_tienPhong := (EXTRACT(EPOCH FROM (v_now - v_ngayTao)) / 3600.0) * v_giaCoBan;
            END IF;

            -- Thêm chi tiết đặt phòng (Đảm bảo mã nhân viên trùng với hoá đơn)
            INSERT INTO a_datphong (
                maHoaDon, maNhanVien, maPhong, 
                ngayDatPhong, ngayNhanPhong, ngayHenTra, ngayTraPhong, ngayThanhToan, 
                tienPhong, tienPhat
            )
            VALUES (
                i, v_maNV, v_maPhong, 
                v_ngayTao - interval '1 day', -- Cho ngày đặt sớm hơn 1 ngày
                v_ngayTao, v_ngayHenTra, v_ngayTra_real, v_ngayThanhToan_real, 
                v_tienPhong, 0
            );
        END LOOP;
    END LOOP;
END $$;

-----------------------------------------------------------
-- 7. CẬP NHẬT DỮ LIỆU CUỐI CÙNG (TỔNG TIỀN & TRẠNG THÁI PHÒNG)
-----------------------------------------------------------
-- Cập nhật tổng tiền Hoá đơn
UPDATE z_hoadon
SET
    tongTien = (
        SELECT COALESCE(
                SUM(dp.tienPhong + dp.tienPhat), 0
            )
        FROM a_datphong dp
        WHERE
            dp.maHoaDon = z_hoadon.maHoaDon
    );

-- Cập nhật trạng thái "Đang thuê" cho những phòng có lịch đặt chưa trả
UPDATE a_phong
SET
    trangThai = 'Đang thuê'
WHERE
    maPhong IN (
        SELECT DISTINCT
            maPhong
        FROM a_datphong
        WHERE
            ngayTraPhong IS NULL
    );

-----------------------------------------------------------
-- 8. ĐỒNG BỘ LẠI CÁC SEQUENCE CỦA POSTGRESQL
-----------------------------------------------------------
SELECT setval(
        pg_get_serial_sequence('y_vaitro', 'mavaitro'), COALESCE(
            (
                SELECT MAX(maVaiTro)
                FROM y_vaitro
            ), 1
        )
    );

SELECT setval(
        pg_get_serial_sequence('a_loaiphong', 'maloaiphong'), COALESCE(
            (
                SELECT MAX(maLoaiPhong)
                FROM a_loaiphong
            ), 1
        )
    );

SELECT setval(
        pg_get_serial_sequence('y_nhanvien', 'manhanvien'), COALESCE(
            (
                SELECT MAX(maNhanVien)
                FROM y_nhanvien
            ), 1
        )
    );

SELECT setval(
        pg_get_serial_sequence('y_taikhoan', 'id'), COALESCE(
            (
                SELECT MAX(id)
                FROM y_taikhoan
            ), 1
        )
    );

SELECT setval(
        pg_get_serial_sequence('x_khachhang', 'makhachhang'), COALESCE(
            (
                SELECT MAX(maKhachHang)
                FROM x_khachhang
            ), 1
        )
    );

SELECT setval(
        pg_get_serial_sequence('a_phong', 'maphong'), COALESCE(
            (
                SELECT MAX(maPhong)
                FROM a_phong
            ), 1
        )
    );

SELECT setval(
        pg_get_serial_sequence('z_hoadon', 'mahoadon'), COALESCE(
            (
                SELECT MAX(maHoaDon)
                FROM z_hoadon
            ), 1
        )
    );

SELECT setval(
        pg_get_serial_sequence('a_datphong', 'madatphong'), COALESCE(
            (
                SELECT MAX(maDatPhong)
                FROM a_datphong
            ), 1
        )
    );