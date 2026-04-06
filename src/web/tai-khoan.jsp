<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section-title">TÀI KHOẢN</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearchTK" class="rounded-input" placeholder="Nhập Username, Nhân viên hoặc Vai trò..." onkeyup="filterTKTable()">
        
        <label style="margin-left: 20px;">Lọc theo:</label>
        <select id="cboFilterTK" class="rounded-input" onchange="filterTKTable()">
            <option value="all">Tất cả</option>
            <option value="user">Username</option>
            <option value="nv">Nhân viên</option>
            <option value="vt">Vai trò</option>
        </select>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 400px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblTK">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tài khoản</th>
                    <th>Mật khẩu</th>
                    <th>Nhân viên</th>
                    <th>Vai trò</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="tk" items="${listTaiKhoan}">
                    <tr onclick="onTKRowClick(this)" 
                        data-id="${tk.getId()}" 
                        data-user="${tk.getTaiKhoan()}"
                        data-pass="${tk.getMatKhau()}"
                        data-manv="${tk.getMaNhanVien()}"
                        data-tennv="${tk.getTenNhanVien()}"
                        data-mavt="${tk.getMaVaiTro()}"
                        data-tenvt="${tk.getTenVaiTro()}">
                        <td>${tk.getId()}</td>
                        <td>${tk.getTaiKhoan()}</td>
                        <td>••••••••</td>
                        <td>${tk.getTenNhanVien()}</td>
                        <td>${tk.getTenVaiTro()}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Input Form -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative; background: white;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Dữ liệu chi tiết tài khoản
        </span>
        
        <form id="frmTK" action="tai-khoan-data" method="post">
            <input type="hidden" id="tkAction" name="action" value="add">
            
            <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
                <label>ID:</label>
                <input type="text" id="tkId" name="id" class="rounded-input" readonly style="background-color: #f0f0f0;">
                
                <label>Username:</label>
                <input type="text" id="tkUser" name="taiKhoan" class="rounded-input" required>
                
                <label>Password:</label>
                <input type="password" id="tkPass" name="matKhau" class="rounded-input" required>
                
                <label>Nhân viên:</label>
                <select id="tkMaNhanVien" name="maNhanVien" class="rounded-input" required>
                    <c:forEach var="nv" items="${listNhanVien}">
                        <option value="${nv.getMaNhanVien()}">${nv.getTenNhanVien()}</option>
                    </c:forEach>
                </select>
                
                <label>Vai trò:</label>
                <select id="tkMaVaiTro" name="maVaiTro" class="rounded-input" required>
                    <c:forEach var="vt" items="${listVaiTro}">
                        <option value="${vt.getMaVaiTro()}">${vt.getTenVaiTro()}</option>
                    </c:forEach>
                </select>
                
                <label></label>
                <label></label>
            </div>

            <!-- Button Panel -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button type="submit" onclick="document.getElementById('tkAction').value='add'" class="btn-swing btn-primary">Thêm</button>
                <button type="submit" onclick="document.getElementById('tkAction').value='update'" class="btn-swing btn-warning" style="color: white;">Sửa</button>
                <button type="submit" onclick="document.getElementById('tkAction').value='delete'" class="btn-swing btn-danger">Xóa</button>
                <button type="button" onclick="clearTKForm()" class="btn-swing" style="background-color: #6c757d; color: white;">Làm mới</button>
            </div>
        </form>
    </div>
</div>

<script>
function onTKRowClick(row) {
    const rows = document.querySelectorAll('#tblTK tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    document.getElementById('tkId').value = row.dataset.id;
    document.getElementById('tkUser').value = row.dataset.user;
    document.getElementById('tkPass').value = row.dataset.pass;
    document.getElementById('tkMaNhanVien').value = row.dataset.manv;
    document.getElementById('tkMaVaiTro').value = row.dataset.mavt;
}

function clearTKForm() {
    document.getElementById('frmTK').reset();
    document.getElementById('tkId').value = '';
    const rows = document.querySelectorAll('#tblTK tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

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
