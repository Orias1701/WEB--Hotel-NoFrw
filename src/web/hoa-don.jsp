<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="section-title">HÓA ĐƠN</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearchHD" class="rounded-input" placeholder="Nhập mã HD hoặc tên khách..." onkeyup="filterHDTable()">
        
        <label style="margin-left: 20px;">Trạng thái:</label>
        <select id="cboFilterHD" class="rounded-input" onchange="filterHDTable()">
            <option value="all">Tất cả</option>
            <option value="Chưa thanh toán">Chưa thanh toán</option>
            <option value="Đã thanh toán">Đã thanh toán</option>
        </select>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 350px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblHD">
            <thead>
                <tr>
                    <th>Mã HD</th>
                    <th>Khách hàng</th>
                    <th>Ngày tạo</th>
                    <th>Ngày thanh toán</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="hd" items="${listHoaDon}">
                    <tr onclick="onHDRowClick(this)" 
                        data-id="${hd.getMaHoaDon()}" 
                        data-makhach="${hd.getMaKhachHang()}"
                        data-ngaytao="<fmt:formatDate value='${hd.getNgayTao()}' pattern='dd/MM/yyyy HH:mm' />"
                        data-ngaytt="<fmt:formatDate value='${hd.getNgayThanhToan()}' pattern='dd/MM/yyyy HH:mm' />"
                        data-tongtien="${hd.getTongTien()}"
                        data-trangthai="${hd.getTrangThai()}">
                        <td>${hd.getMaHoaDon()}</td>
                        <td>${hd.getTenKhachHang()}</td>
                        <td><fmt:formatDate value="${hd.getNgayTao()}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td><fmt:formatDate value="${hd.getNgayThanhToan()}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td><fmt:formatNumber value="${hd.getTongTien()}" type="currency" currencyCode="VND" /></td>
                        <td>
                            <span class="status-badge ${hd.getTrangThai() == 'Đã thanh toán' ? 'status-paid' : 'status-unpaid'}">
                                ${hd.getTrangThai()}
                            </span>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Details View (TitledBorder style) -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative; background: white;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Chi tiết hóa đơn
        </span>
        
        <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
            <label>Mã hóa đơn:</label>
            <input type="text" id="hdMa" class="rounded-input" readonly style="background-color: #f0f0f0;">
            
            <label>Khách hàng:</label>
            <input type="text" id="hdKhach" class="rounded-input" readonly style="background-color: #f0f0f0;">
            
            <label>Ngày tạo:</label>
            <input type="text" id="hdNgayTao" class="rounded-input" readonly style="background-color: #f0f0f0;">
            
            <label>Ngày thanh toán:</label>
            <input type="text" id="hdNgayTT" class="rounded-input" readonly style="background-color: #f0f0f0;">
            
            <label>Tổng tiền:</label>
            <input type="text" id="hdTongTien" class="rounded-input" readonly style="background-color: #f0f0f0; color: var(--excel-green); font-weight: bold;">
            
            <label>Trạng thái:</label>
            <input type="text" id="hdTrangThai" class="rounded-input" readonly style="background-color: #f0f0f0;">
        </div>

        <div style="margin-top: 25px; display: flex; justify-content: center; gap: 15px;">
            <button class="btn-swing btn-primary" onclick="window.print()">In hóa đơn (A4)</button>
            <button class="btn-swing" style="background: #6c757d; color: white;" onclick="clearHDView()">Làm mới</button>
        </div>
    </div>
</div>

<style>
    .status-badge {
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: bold;
    }
    .status-paid {
        background-color: #e6f7ef;
        color: var(--excel-green);
        border: 1px solid var(--excel-green);
    }
    .status-unpaid {
        background-color: #fff0f0;
        color: #ff4d4d;
        border: 1px solid #ff4d4d;
    }
</style>

<script>
function onHDRowClick(row) {
    const rows = document.querySelectorAll('#tblHD tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    document.getElementById('hdMa').value = row.dataset.id;
    document.getElementById('hdKhach').value = row.cells[1].innerText;
    document.getElementById('hdNgayTao').value = row.dataset.ngaytao;
    document.getElementById('hdNgayTT').value = row.dataset.ngaytt;
    document.getElementById('hdTongTien').value = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(row.dataset.tongtien);
    document.getElementById('hdTrangThai').value = row.dataset.trangthai;
}

function clearHDView() {
    document.getElementById('hdMa').value = '';
    document.getElementById('hdKhach').value = '';
    document.getElementById('hdNgayTao').value = '';
    document.getElementById('hdNgayTT').value = '';
    document.getElementById('hdTongTien').value = '';
    document.getElementById('hdTrangThai').value = '';
    const rows = document.querySelectorAll('#tblHD tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

function filterHDTable() {
    const key = document.getElementById('txtSearchHD').value.toLowerCase();
    const status = document.getElementById('cboFilterHD').value;
    const table = document.getElementById('tblHD');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const ma = row.cells[0].innerText.toLowerCase();
        const khach = row.cells[1].innerText.toLowerCase();
        const trangThai = row.dataset.trangthai;

        let match = (ma.includes(key) || khach.includes(key));
        if (status !== 'all') {
            match = match && (trangThai === status);
        }

        row.style.display = match ? '' : 'none';
    }
}
</script>
