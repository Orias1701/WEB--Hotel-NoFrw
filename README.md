# HỆ THỐNG QUẢN LÝ KHÁCH SẠN (Web Dashboard)

Dự án này đã được chuyển đổi từ ứng dụng Desktop (Java Swing) sang ứng dụng Web dựa trên kiến trúc JSP/Servlet hiện đại, không sử dụng framework (No-Rest) để tối ưu hiệu năng và tính linh hoạt.

## 1. Cấu trúc Dự án

```
APP--Hotel-NoRest/
├─ src/
│  ├─ config/           # Cấu hình kết nối DB (DBConnection.java)
│  ├─ controller/       # Các thực thể dữ liệu (POJO)
│  ├─ exception/        # Lớp Dao (Truy xuất dữ liệu JDBC)
│  ├─ model/            # Các thực thể dữ liệu (POJO)
│  ├─ repository/       # Lớp Dao (Truy xuất dữ liệu JDBC)
│  ├─ resources/        # Lớp Dao (Truy xuất dữ liệu JDBC)
│  ├─ service/          # Lớp Xử lý nghiệp vụ (Business Logic)
│  ├─ servlet/          # Lớp Điều phối Web (Controllers)
│  ├─ util/             # Lớp Điều phối Web (Controllers)
│  ├─ view/             # Lớp Điều phối Web (Controllers)
│  └─ web/              # Tài nguyên frontend
├─ pom.xml              # Cấu hình Maven (Dependencies: Jetty, Postgres, Dotenv)
└─ .env                 # Biến môi trường (DB Credentials)
```

## 2. Công nghệ Sử dụng

- **Backend**: Java 21, Servlet 4.0, JSP 2.3.
- **Database**: PostgreSQL (JDBC).
- **Build Tool**: Maven.
- **Sever**: Jetty 9.4 (Embedded).
- **Frontend**: Vanilla HTML5, CSS3, JavaScript (ES6).

## 3. Hướng dẫn Cài đặt & Khởi chạy

```
mvn clean compile jetty:run
```

### Bước 1: Cấu hình Cơ sở dữ liệu

Tạo file `.env` tại thư mục gốc của dự án với nội dung sau:

```env
DB_URL=jdbc:postgresql://localhost:5432/ten_database
DB_USER=postgres
DB_PASSWORD=your_password
```

### Bước 2: Biên dịch dự án

Sử dụng Maven để tải dependencies và biên dịch code:

```bash
mvn clean compile
```

### Bước 3: Chạy ứng dụng

Khởi chạy server Jetty tích hợp:

```bash
mvn jetty:run
```

Sau khi server khởi động thành công, truy cập ứng dụng tại: `http://localhost:8080/`

## 4. Kiến trúc Hoạt động (SPA Concept)

Ứng dụng hoạt động theo cơ chế Single Page Dashboard:

- `main.jsp`: Đóng vai trò là khung giao diện chính.
- `app.js`: Xử lý việc chuyển đổi module bằng `fetch` AJAX tới `MainServlet`.
- `MainServlet`: Tiếp nhận yêu cầu điều hướng (`?view=...`) và chuyển tiếp (forward) tới các Servlet chức năng tương ứng để lấy dữ liệu.
- Dữ liệu được render trực tiếp thông qua JSP Fragments (`.jsp` file trong `src/web/`) và chèn vào vùng nội dung chính của `main.jsp`.

## 5. Các Chức năng Chính

- **Quản lý Phòng**: Theo dõi trạng thái, loại phòng và thông tin chi tiết.
- **Đặt phòng**: Quy trình đặt phòng cho khách hàng.
- **Hóa đơn**: Quản lý thu chi và xuất hóa đơn.
- **Kiểm tra phòng**: Quy trình kiểm tra thiết bị hỏng hóc khi khách trả phòng.
- **Thiết bị**: Quản lý danh mục và phân bổ thiết bị tại các phòng.
- **Nhân sự & Tài khoản**: Quản lý nhân viên và phân quyền truy cập hệ thống.

## 6. Lưu ý cho Nhà phát triển

- Mọi thay đổi về cấu trúc Database cần được cập nhật tương ứng trong thư mục `src/model` và `src/repository`.
- Các câu truy vấn SQL ưu tiên sử dụng `LEFT JOIN` để đảm bảo tính ổn định khi dữ liệu liên kết bị thiếu.
- Sử dụng `BigDecimal` cho tất cả các trường dữ liệu liên quan đến tiền tệ.
