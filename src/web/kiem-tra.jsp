<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="section-title">KIỂM TRA PHÒNG</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearchKT" class="rounded-input" placeholder="Nhập mã HD hoặc phòng..." onkeyup="filterKTTable()">
        
        <label style="margin-left: 20px;">Lọc theo:</label>
        <select id="cboFilterKT" class="rounded-input" onchange="filterKTTable()">
            <option value="all">Tất cả</option>
            <option value="hd">Mã hóa đơn</option>
            <option value="phong">Mã phòng</option>
        </select>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 350px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblKT">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Mã Hóa Đơn</th>
                    <th>Mã Phòng</th>
                    <th>Ngày Thanh Toán</th>
                    <th>Tiền Bồi Thường</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="kt" items="${listKiemTra}">
                    <tr onclick="onKTRowClick(this)" 
                        data-id="${kt.maKiemTraPhong}" 
                        data-mahd="${kt.maHoaDon}"
                        data-maphong="${kt.maPhong}"
                        data-ngay="<fmt:formatDate value='${kt.ngayThanhToan}' pattern='yyyy-MM-dd HH:mm' />"
                        data-tien="${kt.tienBoiThuong}">
                        <td>${kt.maKiemTraPhong}</td>
                        <td>${kt.maHoaDon}</td>
                        <td>${kt.maPhong}</td>
                        <td><fmt:formatDate value="${kt.ngayThanhToan}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td><fmt:formatNumber value="${kt.tienBoiThuong}" type="currency" currencyCode="VND" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Input Form -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative; background: white;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Dữ liệu chi tiết kiểm tra
        </span>
        
        <form id="frmKT" action="kiem-tra-data" method="post">
            <input type="hidden" id="ktAction" name="action" value="add">
            
            <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
                <label>ID:</label>
                <input type="text" id="maKiemTraPhong" name="maKiemTraPhong" class="rounded-input" readonly style="background-color: #f0f0f0;">
                
                <label>Mã hóa đơn:</label>
                <input type="number" id="maHoaDonKT" name="maHoaDon" class="rounded-input" required>
                
                <label>Mã phòng:</label>
                <input type="number" id="maPhongKT" name="maPhong" class="rounded-input" required>
                
                <label>Ngày thanh toán:</label>
                <input type="datetime-local" id="ngayThanhToan" name="ngayThanhToan" class="rounded-input" required>
                
                <label>Tiền bồi thường:</label>
                <input type="number" id="tienBoiThuong" name="tienBoiThuong" class="rounded-input" required step="1000">
                
                <label></label>
                <label></label>
            </div>

            <!-- Button Panel -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button type="submit" onclick="document.getElementById('ktAction').value='add'" class="btn-swing btn-primary">Thêm</button>
                <button type="submit" onclick="document.getElementById('ktAction').value='update'" class="btn-swing btn-warning" style="color: white;">Sửa</button>
                <button type="submit" onclick="document.getElementById('ktAction').value='delete'" class="btn-swing btn-danger">Xóa</button>
                <button type="button" onclick="clearKTForm()" class="btn-swing" style="background-color: #6c757d; color: white;">Làm mới</button>
            </div>
        </form>
    </div>
</div>

<script>
function onKTRowClick(row) {
    const rows = document.querySelectorAll('#tblKT tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    document.getElementById('maKiemTraPhong').value = row.dataset.id;
    document.getElementById('maHoaDonKT').value = row.dataset.mahd;
    document.getElementById('maPhongKT').value = row.dataset.maphong;
    document.getElementById('ngayThanhToan').value = row.dataset.ngay;
    document.getElementById('tienBoiThuong').value = row.dataset.tien;
}

function clearKTForm() {
    document.getElementById('frmKT').reset();
    document.getElementById('maKiemTraPhong').value = '';
    const rows = document.querySelectorAll('#tblKT tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

function filterKTTable() {
    const key = document.getElementById('txtSearchKT').value.toLowerCase();
    const type = document.getElementById('cboFilterKT').value;
    const table = document.getElementById('tblKT');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const hd = row.dataset.mahd.toLowerCase();
        const phong = row.dataset.maphong.toLowerCase();

        let match = false;
        if (type === 'hd') match = hd.includes(key);
        else if (type === 'phong') match = phong.includes(key);
        else match = hd.includes(key) || phong.includes(key);

        row.style.display = match ? '' : 'none';
    }
}
</script>
