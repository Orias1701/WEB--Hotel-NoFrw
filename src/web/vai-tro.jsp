<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section-title">VAI TRÒ</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearchVT" class="rounded-input" placeholder="Nhập tên vai trò..." onkeyup="filterVTTable()">
        
        <label style="margin-left: 20px;">Lọc theo:</label>
        <select id="cboFilterVT" class="rounded-input" onchange="filterVTTable()">
            <option value="all">Tất cả</option>
            <option value="ten">Tên vai trò</option>
        </select>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 400px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblVT">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên vai trò</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="vt" items="${listVaiTro}">
                    <tr onclick="onVTRowClick(this)" 
                        data-id="${vt.getMaVaiTro()}" 
                        data-ten="${vt.getTenVaiTro()}">
                        <td>${vt.getMaVaiTro()}</td>
                        <td>${vt.getTenVaiTro()}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Input Form -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative; background: white;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Dữ liệu chi tiết vai trò
        </span>
        
        <form id="frmVT" action="vai-tro-data" method="post">
            <input type="hidden" id="vtAction" name="action" value="add">
            
            <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
                <label>ID:</label>
                <input type="text" id="maVaiTro" name="maVaiTro" class="rounded-input" readonly style="background-color: #f0f0f0;">
                
                <label>Tên vai trò:</label>
                <input type="text" id="tenVaiTro" name="tenVaiTro" class="rounded-input" required>
                
                <label></label>
                <label></label>
                <label></label>
                <label></label>
            </div>

            <!-- Button Panel -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button type="submit" onclick="document.getElementById('vtAction').value='add'" class="btn-swing btn-primary">Thêm</button>
                <button type="submit" onclick="document.getElementById('vtAction').value='update'" class="btn-swing btn-warning" style="color: white;">Sửa</button>
                <button type="submit" onclick="document.getElementById('vtAction').value='delete'" class="btn-swing btn-danger">Xóa</button>
                <button type="button" onclick="clearVTForm()" class="btn-swing" style="background-color: #6c757d; color: white;">Làm mới</button>
            </div>
        </form>
    </div>
</div>

<script>
function onVTRowClick(row) {
    const rows = document.querySelectorAll('#tblVT tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    document.getElementById('maVaiTro').value = row.dataset.id;
    document.getElementById('tenVaiTro').value = row.dataset.ten;
}

function clearVTForm() {
    document.getElementById('frmVT').reset();
    document.getElementById('maVaiTro').value = '';
    const rows = document.querySelectorAll('#tblVT tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

function filterVTTable() {
    const key = document.getElementById('txtSearchVT').value.toLowerCase();
    const table = document.getElementById('tblVT');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const ten = row.dataset.ten.toLowerCase();

        let match = ten.includes(key);
        row.style.display = match ? '' : 'none';
    }
}
</script>
