<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section-title">KHÁCH HÀNG</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearchKH" class="rounded-input" placeholder="Nhập tên, SĐT hoặc Email..." onkeyup="filterKHTable()">
        
        <label style="margin-left: 20px;">Lọc theo:</label>
        <select id="cboFilterKH" class="rounded-input" onchange="filterKHTable()">
            <option value="all">Tất cả</option>
            <option value="ten">Tên khách</option>
            <option value="sdt">Số điện thoại</option>
            <option value="email">Email</option>
        </select>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 400px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblKH">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên khách</th>
                    <th>Số điện thoại</th>
                    <th>Email</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="kh" items="${listKhachHang}">
                    <tr onclick="onKHRowClick(this)" 
                        data-id="${kh.getMaKhachHang()}" 
                        data-ten="${kh.getTenKhachHang()}" 
                        data-sdt="${kh.getSoDienThoai()}"
                        data-email="${kh.getEmail()}">
                        <td>${kh.getMaKhachHang()}</td>
                        <td>${kh.getTenKhachHang()}</td>
                        <td>${kh.getSoDienThoai()}</td>
                        <td>${kh.getEmail()}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Input Form (TitledBorder replication) -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Dữ liệu chi tiết khách hàng
        </span>
        
        <form id="frmKH" action="khach-hang-data" method="post">
            <input type="hidden" id="khAction" name="action" value="add">
            
            <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
                <label>ID:</label>
                <input type="text" id="maKhachHang" name="maKhachHang" class="rounded-input" readonly style="background-color: #f0f0f0;">
                
                <label>Tên khách hàng:</label>
                <input type="text" id="tenKhachHang" name="tenKhachHang" class="rounded-input" required>
                
                <label>Số điện thoại:</label>
                <input type="text" id="soDienThoai" name="soDienThoai" class="rounded-input" required>
                
                <label>Email:</label>
                <input type="email" id="email" name="email" class="rounded-input">
            </div>

            <!-- Button Panel -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button type="submit" onclick="document.getElementById('khAction').value='add'" class="btn-swing btn-primary">Thêm</button>
                <button type="submit" onclick="document.getElementById('khAction').value='update'" class="btn-swing btn-warning" style="color: white;">Sửa</button>
                <button type="submit" onclick="document.getElementById('khAction').value='delete'" class="btn-swing btn-danger">Xóa</button>
                <button type="button" onclick="clearKHForm()" class="btn-swing" style="background-color: #6c757d; color: white;">Làm mới</button>
            </div>
        </form>
    </div>
</div>

<script>
/**
 * Handle table selection
 */
function onKHRowClick(row) {
    // Highlight selection
    const rows = document.querySelectorAll('#tblKH tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    // Populate form
    document.getElementById('maKhachHang').value = row.dataset.id;
    document.getElementById('tenKhachHang').value = row.dataset.ten;
    document.getElementById('soDienThoai').value = row.dataset.sdt;
    document.getElementById('email').value = row.dataset.email;
}

function clearKHForm() {
    document.getElementById('frmKH').reset();
    document.getElementById('maKhachHang').value = '';
    const rows = document.querySelectorAll('#tblKH tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

/**
 * Basic client-side search filtering
 */
function filterKHTable() {
    const key = document.getElementById('txtSearchKH').value.toLowerCase();
    const type = document.getElementById('cboFilterKH').value;
    const table = document.getElementById('tblKH');
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
