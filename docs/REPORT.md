# BÁO CÁO DỰ ÁN: HỆ THỐNG QUẢN LÝ KHÁCH SẠN (HOTEL MANAGEMENT SYSTEM)

## LỜI MỞ ĐẦU

Trong thời đại chuyển đổi số, việc ứng dụng công nghệ thông tin vào quản lý quy trình nghiệp vụ là yếu tố sống còn của doanh nghiệp. Hệ thống Quản lý Khách sạn được xây dựng nhằm tối ưu hóa việc quản lý lưu trú, giảm thiểu sai sót thủ công và cung cấp dữ liệu thống kê chính xác cho nhà quản lý. Báo cáo này trình bày chi tiết từ khâu phân tích yêu cầu, thiết kế hệ thống, xây dựng ứng dụng đến kiểm thử và đánh giá kết quả thực hiện.

---

## CHƯƠNG 1. GIỚI THIỆU CHUNG

### 1.1. Lý do chọn đề tài

Quản lý khách sạn là một lĩnh vực đòi hỏi tính chính xác cao về thời gian và tài chính. Việc sử dụng các phần mềm rời rạc hoặc sổ sách gây khó khăn cho việc tra cứu phòng trống và tính phí phạt khi khách hủy lịch. Đề tài "Hệ thống Quản lý Khách sạn" được chọn nhằm tạo ra một giải pháp tập trung, nhất quán và hiệu quả.

### 1.2. Mục tiêu của đề tài

- Xây ứng dụng đa nền tảng (Web & Desktop) quản lý toàn diện quy trình khách sạn.
- Đảm bảo tính toán tài chính chính xác (tiền phòng, tiền phạt, hóa đơn).
- Lưu trữ dữ liệu an toàn trên hệ quản trị cơ sở dữ liệu hiện đại (PostgreSQL).

### 1.3. Phạm vi nghiên cứu

- Đối tượng: Quản lý Phòng, Loại phòng, Khách hàng, Nhân viên, Đơn đặt phòng và Hóa đơn.
- Phạm vi: Nghiệp vụ tại quầy (Front-desk) và quản trị hệ thống (Back-office).

### 1.4. Công cụ và công nghệ

- **Ngôn ngữ:** Java 21, Maven.
- **CSDL:** PostgreSQL.
- **UI:** JSP/Servlet (Web) và Swing (Desktop).
- **Report:** JasperReports 7.0.

---

## CHƯƠNG 2. PHÂN TÍCH YÊU CẦU HỆ THỐNG

### 2.1. Sơ đồ Use Case

```text
       +-----------------------------------------------------------+
       |                  Hệ thống Quản lý Khách sạn               |
       |                                                           |
       |  +------------------+           +----------------------+  |
       |  |   Quản lý Phòng  |           |   Quản lý Nhân viên  |  |
       |  +--------+---------+           +----------+-----------+  |
       |           |                                |              |
       |  +--------v---------+           +----------v-----------+  |
       |  |  Đặt/Trả Phòng   |           |  Quản lý Tài khoản   |  |
       |  +--------+---------+           +----------+-----------+  |
       |           |                                |              |
       |  +--------v---------+           +----------v-----------+  |
       |  |   In Hóa đơn     |           |  Thống kê báo cáo    |  |
       |  +------------------+           +----------------------+  |
       |                                                           |
       +-----------------------------------------------------------+
            ^                                     ^
            |                                     |
      +-----+-----+                         +-----+-----+
      | Nhân viên |                         | Quản trị  |
      +-----------+                         +-----------+
```

### 2.2. Sơ đồ luồng dữ liệu (DFD)

**DFD Mức 0 (Sơ đồ ngữ cảnh):**

```text
  [Khách hàng] --- Thông tin đặt phòng ---> ( HỆ THỐNG ) --- Hóa đơn ---> [Khách hàng]
  [Ban quản lý] <--- Báo cáo doanh thu ---- ( HỆ THỐNG ) <--- Cấu hình ---> [Ban quản lý]
```

**DFD Mức 1 (Quy trình Đặt phòng):**

```text
  [Nhân viên] --(1) Chọn phòng--> [P1: Kiểm tra trống] --(2) Có sẵn--> [P2: Tạo Đơn đặt]
                                                                          |
                                                                    (D1: CSDL Booking)
                                                                          |
  [Khách hàng] <--(4) Xác nhận---- [P3: Ghi nhận Hóa đơn] <--(3) Lưu thông tin--+
```

---

## CHƯƠNG 3. THIẾT KẾ HỆ THỐNG

### 3.1. Thiết kế cơ sở dữ liệu (ERD)

```text
  [y_vaitro] 1 --- n [y_taikhoan] n --- 1 [y_nhanvien]
                          |                    |
                          |                    1
                          |                    |
  [a_phong] n --- 1 [a_loaiphong]              n
       |                                   [a_datphong] n --- 1 [z_hoadon]
       |                                       |              |
       +----------------- n -------------------+              1
                                                              |
                                                              n
                                                        [x_khachhang]
```

### 3.2. Mô tả chi tiết các bảng dữ liệu

| STT | Tên bảng      | Ý nghĩa                                                  |
| --- | --------------- | ---------------------------------------------------------- |
| 1   | `y_vaitro`    | Danh mục chức vụ (Admin, Nhân viên)                   |
| 2   | `y_nhanvien`  | Thông tin cá nhân nhân viên                           |
| 3   | `y_taikhoan`  | Tài khoản đăng nhập hệ thống                        |
| 4   | `x_khachhang` | Danh sách khách hàng lưu trú                          |
| 5   | `a_loaiphong` | Định nghĩa loại phòng và giá giờ                   |
| 6   | `a_phong`     | Danh sách phòng vật lý và trạng thái                |
| 7   | `z_hoadon`    | Thông tin tài chính chung của đợt thanh toán        |
| 8   | `a_datphong`  | Chi tiết thời gian nhận/trả và tiền phòng thực tế |

#### Chi tiết bảng `a_datphong` (Trọng tâm):

| Tên cột      | Kiểu dữ liệu | Ràng buộc | Diễn giải                        |
| -------------- | --------------- | ----------- | ---------------------------------- |
| `maDatPhong` | SERIAL          | Primary Key | Mã định danh tự tăng          |
| `maHoaDon`   | INT             | Foreign Key | Liên kết bảng hóa đơn        |
| `maPhong`    | INT             | Foreign Key | Phòng được đặt               |
| `ngayNhan`   | TIMESTAMP       | NOT NULL    | Thời điểm khách nhận phòng   |
| `ngayHenTra` | TIMESTAMP       | NOT NULL    | Thời điểm dự kiến trả        |
| `tienPhong`  | DECIMAL         | DEFAULT 0   | Tổng tiền phòng tính theo giờ |
| `tienPhat`   | DECIMAL         | DEFAULT 0   | Phí trả muộn hoặc phí hủy    |

### 3.3. Sơ đồ lớp (Class Diagram)

```text
  +-------------------+       +-------------------+       +-------------------+
  |      Servlet      |       |      Service      |       |        DAO        |
  +-------------------+       +-------------------+       +-------------------+
  | - doAdd()         |------>| - addBooking()    |------>| - insert()        |
  | - doCheckout()    |       | - calculateFee()  |       | - updateStatus()  |
  +-------------------+       +-------------------+       +-------------------+
            |                           |                           |
     (Web Requests)              (Business Logic)            (JDBC Database)
```

### 3.4. Sơ đồ tuần tự (Sequence Diagram) - Nghiệp vụ Đặt phòng

```text
  Actor       JSP/View        Servlet         Service          DAO            DB
    |            |               |               |              |              |
    |--Submit--->|               |               |              |              |
    |            |---Request---->|               |              |              |
    |            |               |---validate()->|              |              |
    |            |               |               |--add()------>|              |
    |            |               |               |              |--SQL INSERT->|
    |            |               |               |              |<---Success---|
    |            |<---Redirect---|               |              |              |
    |<--Notify---|               |               |              |              |
```

---

## CHƯƠNG 4. XÂY DỰNG ỨNG DỤNG

### 4.1. Luồng xử lý yêu cầu (Request Pipeline)

1. **Client:** Người dùng chọn phòng từ `phong.jsp` và gửi form.
2. **Servlet:** `DatPhongServlet` tiếp nhận, parse dữ liệu ngày tháng.
3. **Service:** `DatPhongService` phối hợp với `HoaDonService` để tạo hóa đơn trước, sau đó tạo các bản ghi đặt phòng.
4. **DAO:** `DatPhongDao` thực thi mã SQL truy vấn vào PostgreSQL.
5. **DB:** Cơ sở dữ liệu cập nhật trạng thái phòng sang "Đang ở".

### 4.2. Mã nguồn minh họa nghiệp vụ quan trọng

#### Logic tính phí trả muộn (10% giá mỗi giờ trễ):

```java
public static BigDecimal tinhPhatTheoGio(Timestamp henTra, Timestamp tra, BigDecimal giaGio) {
    long millisDiff = tra.getTime() - henTra.getTime();
    long hoursDiff = millisDiff / (1000 * 60 * 60); 
    if (hoursDiff < 1) return BigDecimal.ZERO;

    BigDecimal phatMoiGio = giaGio.multiply(BigDecimal.valueOf(0.10));
    return phatMoiGio.multiply(BigDecimal.valueOf(hoursDiff));
}
```

#### Logic hủy phòng (Phí phạt 50% tiền phòng dự kiến):

```java
public boolean huyDatPhong(int id) {
    DatPhong dp = dao.getById(id);
    BigDecimal originalTienPhong = dp.getTienPhong();
    BigDecimal tienPhat = originalTienPhong.multiply(new BigDecimal("0.5"));
    return dao.huyDatPhong(id, tienPhat); // Cập nhật phí phạt vào DB
}
```

---

## CHƯƠNG 5. KIỂM THỬ HỆ THỐNG

| ID   | Kịch bản kiểm thử         | Dữ liệu đầu vào           | Kết quả mong đợi        | Kết quả thực tế  | Trạng thái |
| ---- | ----------------------------- | ------------------------------ | --------------------------- | -------------------- | ------------ |
| TC01 | Đăng nhập thành công     | Tài khoản đúng             | Chuyển đến trang chủ    | Như mong đợi      | PASS         |
| TC02 | Đặt phòng quá khứ        | Ngày nhận < Ngày hiện tại | Báo lỗi không hợp lệ   | Hệ thống chặn     | PASS         |
| TC03 | Tính tiền trả muộn        | Trễ 2 giờ, giá 100k         | Phạt 20k (10% * 2)         | Tính đúng 20k     | PASS         |
| TC04 | Xóa loại phòng đang dùng | Mã loại đang có phòng     | Chặn xóa (Ràng buộc KH) | Báo lỗi FK         | PASS         |
| TC05 | Hủy đặt phòng             | Chọn "Hủy"                   | Tính phạt 50%             | Hiển thị 50% phạt | PASS         |

---

## CHƯƠNG 6. KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN

Hệ thống đã đáp ứng tốt các yêu cầu về nghiệp vụ quản lý khách sạn cơ bản. Tính năng tính phí tự động và quản lý trạng thái phòng giúp giảm thời gian vận hành đáng kể. Trong tương lai, hệ thống sẽ được mở rộng tích hợp thanh toán mã QR và ứng dụng di động cho khách hàng.

---

## PHỤ LỤC

### A1. Script tạo bảng SQL (Trích đoạn)

```sql
CREATE TABLE a_phong (
    maPhong SERIAL PRIMARY KEY,
    soPhong VARCHAR(10) UNIQUE NOT NULL,
    maLoaiPhong INT REFERENCES a_loaiphong(maLoaiPhong),
    trangThai VARCHAR(20) DEFAULT 'Trống'
);
```

### A2. Phân công công việc

| Thành viên     | Vai trò       | Công việc chính                                    |
| ---------------- | -------------- | ----------------------------------------------------- |
| **Thắng** | Backend Lead   | Thiết kế Database, viết Service & DAO logic        |
| **Long**   | Frontend Lead  | Xây dựng giao diện JSP, xử lý Servlet flow       |
| **Hiếu**  | UI/UX Refactor | Tối ưu hóa CSS, thiết kế báo cáo JasperReports |

### A3. Tài liệu tham khảo

1. Java Documentation - Oracle.
2. PostgreSQL 16 Manual.
3. TutorialsPoint - Java Servlet & JSP.
