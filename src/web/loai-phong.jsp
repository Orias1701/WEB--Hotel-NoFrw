<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="section-title">LOẠI PHÒNG</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearchLP" class="rounded-input" placeholder="Nhập tên loại phòng hoặc giá..." onkeyup="filterLPTable()">
        
        <label style="margin-left: 20px;">Lọc theo:</label>
        <select id="cboFilterLP" class="rounded-input" onchange="filterLPTable()">
            <option value="all">Tất cả</option>
            <option value="ten">Tên loại phòng</option>
        </select>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 400px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblLP">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên loại phòng</th>
                    <th>Giá cơ bản</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="lp" items="${listLoaiPhong}">
                    <tr onclick="onLPRowClick(this)" 
                        data-id="${lp.getMaLoaiPhong()}" 
                        data-ten="${lp.getTenLoaiPhong()}" 
                        data-gia="${lp.getGiaCoBan()}">
                        <td>${lp.getMaLoaiPhong()}</td>
                        <td>${lp.getTenLoaiPhong()}</td>
                        <td><fmt:formatNumber value="${lp.getGiaCoBan()}" type="currency" currencyCode="VND" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Input Form -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Dữ liệu chi tiết loại phòng
        </span>
        
        <form id="frmLP" action="loai-phong-data" method="post">
            <input type="hidden" id="lpAction" name="action" value="add">
            
            <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
                <label>ID:</label>
                <input type="text" id="maLoaiPhong" name="maLoaiPhong" class="rounded-input" readonly style="background-color: #f0f0f0;">
                
                <label>Tên loại phòng:</label>
                <input type="text" id="tenLoaiPhong" name="tenLoaiPhong" class="rounded-input" required>
                
                <label>Giá cơ bản:</label>
                <input type="number" id="giaCoBan" name="giaCoBan" class="rounded-input" required step="1000">
                
                <label></label>
                <label></label>
            </div>

            <!-- Button Panel -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button type="submit" onclick="document.getElementById('lpAction').value='add'" class="btn-swing btn-primary">Thêm</button>
                <button type="submit" onclick="document.getElementById('lpAction').value='update'" class="btn-swing btn-warning" style="color: white;">Sửa</button>
                <button type="submit" onclick="document.getElementById('lpAction').value='delete'" class="btn-swing btn-danger">Xóa</button>
                <button type="button" onclick="clearLPForm()" class="btn-swing" style="background-color: #6c757d; color: white;">Làm mới</button>
            </div>
        </form>
    </div>
</div>

<script>
function onLPRowClick(row) {
    const rows = document.querySelectorAll('#tblLP tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    document.getElementById('maLoaiPhong').value = row.dataset.id;
    document.getElementById('tenLoaiPhong').value = row.dataset.ten;
    document.getElementById('giaCoBan').value = row.dataset.gia;
}

function clearLPForm() {
    document.getElementById('frmLP').reset();
    document.getElementById('maLoaiPhong').value = '';
    const rows = document.querySelectorAll('#tblLP tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

function filterLPTable() {
    const key = document.getElementById('txtSearchLP').value.toLowerCase();
    const type = document.getElementById('cboFilterLP').value;
    const table = document.getElementById('tblLP');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const ten = row.dataset.ten.toLowerCase();
        const gia = row.dataset.gia.toLowerCase();

        let match = false;
        if (type === 'ten') match = ten.includes(key);
        else match = ten.includes(key) || gia.includes(key);

        row.style.display = match ? '' : 'none';
    }
}
</script>
