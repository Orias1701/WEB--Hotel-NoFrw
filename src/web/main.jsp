<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Hệ Thống Quản Lý Khách Sạn - Trang chủ</title>
            <link rel="stylesheet" href="css/style.css">
            <!-- Load Chart.js globally to avoid race conditions in AJAX modules -->
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        </head>

        <body>
            <div class="app-container">
                <!-- Sidebar - mimicking FrmMain sidebar -->
                <aside class="sidebar">
                    <div class="sidebar-header">
                        <c:set var="pAccs" value="" />
                        <c:forEach var="ptk" items="${profile.getListTaiKhoan()}" varStatus="st">
                            <c:set var="pAccs"
                                value="${pAccs}${ptk.getId()}|${ptk.getTaiKhoan()}|${ptk.getTenVaiTro()}|${ptk.getMatKhau()}${not st.last ? ',' : ''}" />
                        </c:forEach>
                        <div class="user-info" style="cursor: pointer; transition: opacity 0.2s;"
                            onmouseover="this.style.opacity='0.8'" onmouseout="this.style.opacity='1'"
                            onclick="openNVForm('update', this.dataset)" data-id="${profile.getMaNhanVien()}"
                            data-ten="${profile.getTenNhanVien()}" data-sdt="${profile.getSoDienThoai()}"
                            data-email="${profile.getEmail()}" data-accounts="${pAccs}">
                            👤 ${user.getTenNhanVien()}
                        </div>
                    </div>
                    <nav class="sidebar-nav">
                        <c:set var="role" value="${user.getMaVaiTro()}" />

                        <c:if test="${role == 1}">
                            <div class="nav-item active" onclick="loadModule('home', 'Trang chủ')">Trang chủ</div>
                            <div class="nav-item" onclick="loadModule('dat-phong', 'Đặt phòng')">Đặt phòng</div>
                            <div class="nav-item" onclick="loadModule('hoa-don', 'Hóa đơn')">Hóa đơn</div>
                            <div class="nav-item" onclick="loadModule('phong', 'Phòng')">Phòng</div>
                            <div class="nav-item" onclick="loadModule('loai-phong', 'Loại phòng')">Loại phòng</div>

                            <div class="nav-item" onclick="loadModule('khach-hang', 'Khách hàng')">Khách hàng</div>
                            <div class="nav-item" onclick="loadModule('nhan-vien', 'Nhân viên')">Nhân viên</div>
                            <%-- <div class="nav-item" onclick="loadModule('tai-khoan', 'Tài khoản')">Tài khoản
            </div> --%>

            </c:if>

            <c:if test="${role == 2}">
                <div class="nav-item active" onclick="loadModule('home', 'Trang chủ')">Trang chủ</div>
                <div class="nav-item" onclick="loadModule('dat-phong', 'Đặt phòng')">Đặt phòng</div>
                <div class="nav-item" onclick="loadModule('hoa-don', 'Hóa đơn')">Hóa đơn</div>
                <div class="nav-item" onclick="loadModule('phong', 'Phòng')">Phòng</div>
                <div class="nav-item" onclick="loadModule('loai-phong', 'Loại phòng')">Loại phòng</div>
                <div class="nav-item" onclick="loadModule('khach-hang', 'Khách hàng')">Khách hàng</div>
            </c:if>

            <c:if test="${role != 1 && role != 2}">
                <div class="nav-item active" onclick="loadModule('hoa-don', 'Hóa đơn')">Hóa đơn</div>
            </c:if>

            <a href="logout" class="nav-item logout" style="text-decoration: none;">Đăng xuất</a>
            </nav>
            </aside>

            <!-- Main Content Area -->
            <main class="main-content">
                <div id="content-area">
                    <!-- AJAX fragments loaded here -->
                    <div class="section-title" id="page-title">Chào mừng quay lại!</div>
                    <div>
                        <h3>Vui lòng chọn một mục từ thanh điều hướng bên trái để bắt đầu.</h3>
                    </div>
                </div>
            </main>
            </div>

            <div id="app-config" data-role="${role}"></div>
            <jsp:include page="nhan-vien-form.jsp" />
            <script src="js/app.js"></script>
            <script>
                // Auto-load home based on role
                window.addEventListener('scroll', function () { }); // placeholder to ensure DOM is ready? 
                // Actually window.onload is fine.
                window.onload = function () {
                    const role = document.getElementById('app-config').getAttribute('data-role');
                    const params = new URLSearchParams(window.location.search);
                    const viewParam = params.get('view');

                    if (viewParam) {
                        let title = '';
                        const navItems = document.querySelectorAll('.nav-item');
                        navItems.forEach(item => {
                            if (item.getAttribute('onclick') && item.getAttribute('onclick').includes("('" + viewParam + "'")) {
                                title = item.innerText;
                            }
                        });
                        loadModule(viewParam, title || 'Hệ thống');
                    } else if (role === '1' || role === '2') {
                        loadModule('home', 'Trang chủ');
                    } else {
                        loadModule('hoa-don', 'Hóa đơn');
                    }
                };
            </script>
        </body>

        </html>