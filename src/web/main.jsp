<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ Thống Quản Lý Khách Sạn - Trang chủ</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar - mimicking FrmMain sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="user-info">👤 ${user.getTaiKhoan()}</div>
            </div>
            <nav class="sidebar-nav">
                <c:set var="role" value="${user.getMaVaiTro()}" />
                
                <c:if test="${role == 1}">
                    <div class="nav-item active" onclick="loadModule('home', 'Trang chủ')">Trang chủ</div>
                    <div class="nav-item" onclick="loadModule('dat-phong', 'Đặt phòng')">Đặt phòng</div>
                    <div class="nav-item" onclick="loadModule('hoa-don', 'Hóa đơn')">Hóa đơn</div>
                    <div class="nav-item" onclick="loadModule('phong', 'Phòng')">Phòng</div>
                    <div class="nav-item" onclick="loadModule('loai-phong', 'Loại phòng')">Loại phòng</div>
                    <div class="nav-item" onclick="loadModule('thiet-bi', 'Thiết bị')">Thiết bị</div>
                    <div class="nav-item" onclick="loadModule('thiet-bi-phong', 'Thiết bị phòng')">Thiết bị phòng</div>
                    <div class="nav-item" onclick="loadModule('kiem-tra', 'Kiểm tra phòng')">Kiểm tra phòng</div>
                    <div class="nav-item" onclick="loadModule('kiem-tra-chi-tiet', 'Chi tiết kiểm tra')">Chi tiết kiểm tra</div>
                    <div class="nav-item" onclick="loadModule('khach-hang', 'Khách hàng')">Khách hàng</div>
                    <div class="nav-item" onclick="loadModule('nhan-vien', 'Nhân viên')">Nhân viên</div>
                    <div class="nav-item" onclick="loadModule('tai-khoan', 'Tài khoản')">Tài khoản</div>
                    <div class="nav-item" onclick="loadModule('vai-tro', 'Vai trò')">Vai trò</div>
                </c:if>

                <c:if test="${role == 3}">
                    <div class="nav-item active" onclick="loadModule('dat-phong', 'Đặt phòng')">Đặt phòng</div>
                    <div class="nav-item" onclick="loadModule('hoa-don', 'Hóa đơn')">Hóa đơn</div>
                    <div class="nav-item" onclick="loadModule('phong', 'Phòng')">Phòng</div>
                    <div class="nav-item" onclick="loadModule('loai-phong', 'Loại phòng')">Loại phòng</div>
                    <div class="nav-item" onclick="loadModule('thiet-bi', 'Thiết bị')">Thiết bị</div>
                    <div class="nav-item" onclick="loadModule('thiet-bi-phong', 'Thiết bị phòng')">Thiết bị phòng</div>
                    <div class="nav-item" onclick="loadModule('kiem-tra', 'Kiểm tra phòng')">Kiểm tra phòng</div>
                    <div class="nav-item" onclick="loadModule('kiem-tra-chi-tiet', 'Chi tiết kiểm tra')">Chi tiết kiểm tra</div>
                    <div class="nav-item" onclick="loadModule('khach-hang', 'Khách hàng')">Khách hàng</div>
                </c:if>

                <c:if test="${role != 1 && role != 3}">
                    <div class="nav-item active" onclick="loadModule('kiem-tra', 'Kiểm tra phòng')">Kiểm tra phòng</div>
                    <div class="nav-item" onclick="loadModule('kiem-tra-chi-tiet', 'Chi tiết kiểm tra')">Chi tiết kiểm tra</div>
                    <div class="nav-item" onclick="loadModule('thiet-bi', 'Thiết bị')">Thiết bị</div>
                    <div class="nav-item" onclick="loadModule('thiet-bi-phong', 'Thiết bị phòng')">Thiết bị phòng</div>
                </c:if>

                <a href="logout" class="nav-item logout" style="text-decoration: none;">Đăng xuất</a>
            </nav>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            <div id="content-area">
                <!-- AJAX fragments loaded here -->
                <div class="section-title" id="page-title">Chào mừng quay lại!</div>
                <div style="padding: 25px;">
                    <h3>Vui lòng chọn một mục từ thanh điều hướng bên trái để bắt đầu.</h3>
                </div>
            </div>
        </main>
    </div>

    <div id="app-config" data-role="${role}"></div>
    <script src="js/app.js"></script>
    <script>
        // Auto-load home based on role
        window.addEventListener('scroll', function() {}); // placeholder to ensure DOM is ready? 
        // Actually window.onload is fine.
        window.onload = function() {
            const role = document.getElementById('app-config').getAttribute('data-role');
            if (role === '1') {
                loadModule('home', 'Trang chủ');
            } else if (role === '3') {
                loadModule('dat-phong', 'Đặt phòng');
            } else {
                loadModule('kiem-tra', 'Kiểm tra phòng');
            }
        };
    </script>
</body>
</html>
