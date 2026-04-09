<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="section-title">TÀI KHOẢN</div>

        <div style="padding: 10px 25px;">
            <!-- Toolbar -->
            <div class="toolbar"
                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 15px 25px; background-color: white; border: 1px solid var(--color-border); border-radius: 10px;">
                <div class="search-box">
                    <label style="margin-right: 10px; font-weight: bold;">Tìm kiếm:</label>
                    <input type="text" id="txtSearchTK" class="rounded-input"
                        placeholder="Nhập Username, Nhân viên hoặc Vai trò..." onkeyup="filterTKTable()"
                        style="width: 280px;">

                    <label style="margin-left: 20px; margin-right: 10px; font-weight: bold;">Lọc theo:</label>
                    <select id="cboFilterTK" class="rounded-input" onchange="filterTKTable()">
                        <option value="all">Tất cả</option>
                        <option value="user">Username</option>
                        <option value="nv">Nhân viên</option>
                        <option value="vt">Vai trò</option>
                    </select>
                </div>
                <button class="btn-swing btn-primary" onclick="openTKForm('add', null)">+ Thêm mới</button>
            </div>

            <!-- Table Content -->
            <div class="swing-table-container" style="max-height: calc(100vh - 220px); overflow-y: auto; padding: 0;">
                <table class="swing-table" id="tblTK">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tài khoản</th>
                            <th>Mật khẩu</th>
                            <th>Nhân viên</th>
                            <th>Vai trò</th>
                            <th style="width: 100px; text-align: center;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tk" items="${listTaiKhoan}">
                            <tr onclick="openTKForm('update', this.dataset)" data-id="${tk.getId()}"
                                data-user="${tk.getTaiKhoan()}" data-pass="${tk.getMatKhau()}"
                                data-manv="${tk.getMaNhanVien()}" data-tennv="${tk.getTenNhanVien()}"
                                data-mavt="${tk.getMaVaiTro()}" data-tenvt="${tk.getTenVaiTro()}">
                                <td>${tk.getId()}</td>
                                <td>${tk.getTaiKhoan()}</td>
                                <td>••••••••</td>
                                <td>${tk.getTenNhanVien()}</td>
                                <td>${tk.getTenVaiTro()}</td>
                                <td class="action-cell">
                                    <form id="frmDelTK_${tk.getId()}" action="tai-khoan-data" method="post"
                                        style="display:none;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${tk.getId()}">
                                    </form>
                                    <button type="button" class="btn-swing btn-danger"
                                        style="padding: 5px 10px; font-size: 13px;"
                                        onclick="event.stopPropagation(); confirmDelete('Bạn có chắc chắn muốn xóa tài khoản này?', 'taikhoan', this.closest('tr').dataset.id, 'frmDelTK_' + this.closest('tr').dataset.id);">Xóa</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <jsp:include page="tai-khoan-form.jsp" />

        <script>
            function filterTKTable() {
                const key = document.getElementById('txtSearchTK').value.toLowerCase();
                const type = document.getElementById('cboFilterTK').value;
                const table = document.getElementById('tblTK');
                const rows = table.getElementsByTagName('tr');

                for (let i = 1; i < rows.length; i++) {
                    const row = rows[i];
                    const user = row.dataset.user.toLowerCase();
                    const tenNV = row.dataset.tennv.toLowerCase();
                    const tenVT = row.dataset.tenvt.toLowerCase();

                    let match = false;
                    if (type === 'user') match = user.includes(key);
                    else if (type === 'nv') match = tenNV.includes(key);
                    else if (type === 'vt') match = tenVT.includes(key);
                    else match = user.includes(key) || tenNV.includes(key) || tenVT.includes(key);

                    row.style.display = match ? '' : 'none';
                }
            }
        </script>