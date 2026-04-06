<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section-title">NHÂN VIÊN</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearchNV" class="rounded-input" placeholder="Nhập tên, Email hoặc SĐT..." onkeyup="filterNVTable()">
        
        <label style="margin-left: 20px;">Lọc theo:</label>
        <select id="cboFilterNV" class="rounded-input" onchange="filterNVTable()">
            <option value="all">Tất cả</option>
            <option value="ten">Tên nhân viên</option>
            <option value="email">Email</option>
            <option value="sdt">SĐT</option>
        </select>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 400px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblNV">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên nhân viên</th>
                    <th>Số điện thoại</th>
                    <th>Email</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="nv" items="${listNhanVien}">
                    <tr onclick="onNVRowClick(this)" 
                        data-id="${nv.getMaNhanVien()}" 
                        data-ten="${nv.getTenNhanVien()}" 
                        data-sdt="${nv.getSoDienThoai()}"
                        data-email="${nv.getEmail()}">
                        <td>${nv.getMaNhanVien()}</td>
                        <td>${nv.getTenNhanVien()}</td>
                        <td>${nv.getSoDienThoai()}</td>
                        <td>${nv.getEmail()}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Input Form (TitledBorder replication) -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Dữ liệu chi tiết nhân viên
        </span>
        
        <form id="frmNV" action="nhan-vien-data" method="post">
            <input type="hidden" id="nvAction" name="action" value="add">
            
            <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
                <label>ID:</label>
                <input type="text" id="maNhanVien" name="maNhanVien" class="rounded-input" readonly style="background-color: #f0f0f0;">
                
                <label>Tên nhân viên:</label>
                <input type="text" id="tenNhanVien" name="tenNhanVien" class="rounded-input" required>
                
                <label>Số điện thoại:</label>
                <input type="text" id="soDienThoai" name="soDienThoai" class="rounded-input" required>
                
                <label>Email:</label>
                <input type="email" id="email" name="email" class="rounded-input">
            </div>

            <!-- Button Panel -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button type="submit" onclick="document.getElementById('nvAction').value='add'" class="btn-swing btn-primary">Thêm</button>
                <button type="submit" onclick="document.getElementById('nvAction').value='update'" class="btn-swing btn-warning" style="color: white;">Sửa</button>
                <button type="submit" onclick="document.getElementById('nvAction').value='delete'" class="btn-swing btn-danger">Xóa</button>
                <button type="button" onclick="clearNVForm()" class="btn-swing" style="background-color: #6c757d; color: white;">Làm mới</button>
            </div>
        </form>
    </div>
</div>

<script>
/**
 * Handle table selection
 */
function onNVRowClick(row) {
    // Highlight selection
    const rows = document.querySelectorAll('#tblNV tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    // Populate form
    document.getElementById('maNhanVien').value = row.dataset.id;
    document.getElementById('tenNhanVien').value = row.dataset.ten;
    document.getElementById('soDienThoai').value = row.dataset.sdt;
    document.getElementById('email').value = row.dataset.email;
}

function clearNVForm() {
    document.getElementById('frmNV').reset();
    document.getElementById('maNhanVien').value = '';
    const rows = document.querySelectorAll('#tblNV tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

/**
 * Basic client-side search filtering
 */
function filterNVTable() {
    const key = document.getElementById('txtSearchNV').value.toLowerCase();
    const type = document.getElementById('cboFilterNV').value;
    const table = document.getElementById('tblNV');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const ten = row.dataset.ten.toLowerCase();
        const sdt = row.dataset.sdt.toLowerCase();
        const email = row.dataset.email.toLowerCase();

        let match = false;
        if (type === 'ten') match = ten.includes(key);
        else if (type === 'sdt') match = sdt.includes(key);
        else if (type === 'email') match = email.includes(key);
        else match = ten.includes(key) || sdt.includes(key) || email.includes(key);

        row.style.display = match ? '' : 'none';
    }
}
</script>
