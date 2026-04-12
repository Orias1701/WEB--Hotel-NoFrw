# BÁO CÁO DỰ ÁN: HỆ THỐNG QUẢN LÝ KHÁCH SẠN (WEB DASHBOARD)

## 1. Mục đích dự án

Dự án được xây dựng nhằm hiện đại hóa hệ thống quản lý khách sạn từ nền tảng Desktop (Java Swing) sang nền tảng Web Dashboard. Mục tiêu chính bao gồm:

- **Tính linh hoạt:** Cho phép quản lý hệ thống từ xa qua trình duyệt web.
- **Hiệu năng cao:** Sử dụng cấu trúc "No-Framework" (thuần JSP/Servlet) để giảm thiểu độ trễ và tối ưu tốc độ phản hồi.
- **Trải nghiệm người dùng:** Chuyển đổi giao diện sang dạng Single Page Dashboard hiện đại, mượt mà với các yêu cầu không làm tải lại trang (AJAX).

## 2. Các tính năng chính

Hệ thống bao gồm các phân hệ quản lý cốt lõi:

- **Quản lý Phòng:** Theo dõi danh sách phòng, trạng thái (Trống, Có khách, Bảo trì) và loại phòng.
- **Quản lý Đặt phòng:** Quy trình tiếp nhận khách, đặt phòng và cập nhật lịch trình lưu trú.
- **Quản lý Hóa đơn:** Tự động tính toán chi phí, quản lý thu chi và lịch sử giao dịch.
- **Thống kê & Báo cáo:** Tự động tổng hợp doanh thu và hiệu suất sử dụng phòng qua JasperReports.
- **Nhân sự & Tài khoản:** Quản lý thông tin nhân viên, phân quyền truy cập (Admin, Quản lý, Nhân viên) và bảo mật tài khoản.

## 3. Công nghệ sử dụng

Dự án sử dụng bộ công nghệ (Tech Stack) mạnh mẽ và ổn định:

- **Backend:**
  - Ngôn ngữ: Java 21 LTS.
  - Công nghệ cốt lõi: Servlet 4.0, JSP 2.3.
  - Quản lý môi trường: `io.github.cdimascio:dotenv-java`.
  - Báo cáo & Biểu đồ: JasperReports, JFreeChart (Dùng cho module Thống kê).
- **Cơ sở dữ liệu:**
  - Hệ quản trị: PostgreSQL.
  - Kết nối: JDBC (PostgreSQL Driver).
- **Frontend:**
  - Cấu trúc & Giao diện: HTML5, Vanilla CSS3 (Custom Design System).
  - Logic: JavaScript ES6+ (Sử dụng Fetch API để xử lý Single Page App concept).
- **Công cụ phát triển:**
  - Build tool: Maven.
  - Web Server: Jetty 9 (Embedded server tích hợp trực tiếp vào dự án).

## 4. Cấu trúc cơ sở dữ liệu

Hệ thống sử dụng lược đồ (Schema) `hotelbook` với các bảng dữ liệu chính:

- **Nhóm Phân quyền:** `y_vaitro` (Lưu thông tin vai trò), `y_taikhoan` (Thông tin đăng nhập).
- **Nhóm Con người:** `y_nhanvien` (Dữ liệu nhân viên), `x_khachhang` (Dữ liệu khách hàng).
- **Nhóm Hạ tầng:** `a_loaiphong` (Các loại phòng và giá cơ bản), `a_phong` (Chi tiết từng phòng và trạng thái).
- **Nhóm Giao dịch:** `z_hoadon` (Thông tin tổng quát hóa đơn), `a_datphong` (Chi tiết các lượt đặt phòng, tiền phòng, tiền phạt).

## 5. Cấu trúc thư mục dự án

Cấu trúc được tổ chức theo mô hình phân lớp (Layered Architecture) giúp tách biệt rõ ràng các vai trò:

| Thư mục       | Vai trò dưới góc độ lập trình viên                                                                                                                   |
| :-------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `config/`     | Cấu hình kết nối cơ sở dữ liệu (DBConnection).                                                                                             |
| `model/`      | Các định nghĩa thực thể (Entities/POJOs).                                                                                                    |
| `repository/` | Tầng truy xuất dữ liệu (DAO) sử dụng JDBC.                                                                                                    |
| `service/`    | Tầng xử lý nghiệp vụ chính của hệ thống.                                                                                                     |
| `servlet/`    | Các Web Servlet điều phối yêu cầu người dùng.                                                                                                |
| `controller/` | Các lớp điều khiển logic (nghiệp vụ xử lý từ phiên bản Desktop).                                                                             |
| `web/`        | Các tệp giao diện (JSP Fragments, CSS, JS).                                                                                                   |
| `util/`       | Các công cụ tiện ích (Định dạng tiền tệ, mã hóa...).                                                                                          |
| `database/`   | Lưu trữ mã nguồn SQL (`database.sql`) và dữ liệu mẫu (`dataseed.sql`) để khởi tạo môi trường.                                              |
| `docs/`       | Tài liệu hướng dẫn và đặc tả kỹ thuật của dự án.                                                                                                |
| `pom.xml`     | Tệp cấu hình Maven, quản lý toàn bộ thư viện và quy trình đóng gói ứng dụng.                                                                  |

---

*Báo cáo được khởi tạo vào ngày 11/04/2026.*
