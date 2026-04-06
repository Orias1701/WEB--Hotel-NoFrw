<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="section-title">THIẾT BỊ</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearchTB" class="rounded-input" placeholder="Nhập tên thiết bị hoặc giá..." onkeyup="filterTBTable()">
        
        <label style="margin-left: 20px;">Lọc theo:</label>
        <select id="cboFilterTB" class="rounded-input" onchange="filterTBTable()">
            <option value="all">Tất cả</option>
            <option value="ten">Tên thiết bị</option>
        </select>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 400px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblTB">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên thiết bị</th>
                    <th>Giá thiết bị</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="tb" items="${listThietBi}">
                    <tr onclick="onTBRowClick(this)" 
                        data-id="${tb.getMaThietBi()}" 
                        data-ten="${tb.getTenThietBi()}" 
                        data-gia="${tb.getGiaThietBi()}">
                        <td>${tb.getMaThietBi()}</td>
                        <td>${tb.getTenThietBi()}</td>
                        <td><fmt:formatNumber value="${tb.getGiaThietBi()}" type="currency" currencyCode="VND" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Input Form -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Dữ liệu chi tiết thiết bị
        </span>
        
        <form id="frmTB" action="thiet-bi-data" method="post">
            <input type="hidden" id="tbAction" name="action" value="add">
            
            <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
                <label>ID:</label>
                <input type="text" id="maThietBi" name="maThietBi" class="rounded-input" readonly style="background-color: #f0f0f0;">
                
                <label>Tên thiết bị:</label>
                <input type="text" id="tenThietBi" name="tenThietBi" class="rounded-input" required>
                
                <label>Giá thiết bị:</label>
                <input type="number" id="giaThietBi" name="giaThietBi" class="rounded-input" required step="1000">
                
                <label></label>
                <label></label>
            </div>

            <!-- Button Panel -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button type="submit" onclick="document.getElementById('tbAction').value='add'" class="btn-swing btn-primary">Thêm</button>
                <button type="submit" onclick="document.getElementById('tbAction').value='update'" class="btn-swing btn-warning" style="color: white;">Sửa</button>
                <button type="submit" onclick="document.getElementById('tbAction').value='delete'" class="btn-swing btn-danger">Xóa</button>
                <button type="button" onclick="clearTBForm()" class="btn-swing" style="background-color: #6c757d; color: white;">Làm mới</button>
            </div>
        </form>
    </div>
</div>

<script>
function onTBRowClick(row) {
    const rows = document.querySelectorAll('#tblTB tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    document.getElementById('maThietBi').value = row.dataset.id;
    document.getElementById('tenThietBi').value = row.dataset.ten;
    document.getElementById('giaThietBi').value = row.dataset.gia;
}

function clearTBForm() {
    document.getElementById('frmTB').reset();
    document.getElementById('maThietBi').value = '';
    const rows = document.querySelectorAll('#tblTB tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

function filterTBTable() {
    const key = document.getElementById('txtSearchTB').value.toLowerCase();
    const type = document.getElementById('cboFilterTB').value;
    const table = document.getElementById('tblTB');
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
