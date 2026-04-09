<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="section-title">HÓA ĐƠN</div>

<style>
    .status-badge { padding: 4px 10px; border-radius: 20px; font-size: 13px; font-weight: bold; }
    .status-paid { background-color: #e6f7ef; color: var(--excel-green); border: 1px solid var(--excel-green); }
    .status-unpaid { background-color: #fff0f0; color: #ff4d4d; border: 1px solid #ff4d4d; }
</style>

<div style="padding: 10px 25px;">
    <!-- Toolbar -->
    <div class="toolbar" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 15px 25px; background-color: white; border: 1px solid var(--color-border); border-radius: 10px;">
        <div class="search-box">
            <label style="margin-right: 10px; font-weight: bold;">Tìm kiếm:</label>
            <input type="text" id="txtSearchHD" class="rounded-input" placeholder="Nhập mã HD hoặc tên khách..." onkeyup="filterHDTable()" style="width: 280px;">
            
            <label style="margin-left: 20px; margin-right: 10px; font-weight: bold;">Trạng thái:</label>
            <select id="cboFilterHD" class="rounded-input" onchange="filterHDTable()">
                <option value="all">Tất cả</option>
                <option value="Chưa thanh toán">Chưa thanh toán</option>
                <option value="Đã thanh toán">Đã thanh toán</option>
            </select>
        </div>
        <span style="font-size: 13px; color: #888;">Hóa đơn được tạo tự động qua Đặt phòng</span>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: calc(100vh - 220px); overflow-y: auto; padding: 0;">
        <table class="swing-table" id="tblHD">
            <thead>
                <tr>
                    <th>Mã HD</th>
                    <th>Khách hàng</th>
                    <th>Ngày tạo</th>
                    <th>Ngày thanh toán</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th style="width: 110px; text-align: center;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="hd" items="${listHoaDon}">
                    <tr onclick="onHDRowClick(this)" 
                        data-id="${hd.getMaHoaDon()}" 
                        data-makhach="${hd.getMaKhachHang()}"
                        data-tenkhach="${hd.getTenKhachHang()}"
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
                        <td class="action-cell">
                            <c:if test="${hd.getTrangThai() != 'Đã thanh toán'}">
                                <form id="frmPayHD_${hd.getMaHoaDon()}" action="hoa-don-data" method="post" style="display:none;">
                                    <input type="hidden" name="action" value="pay">
                                    <input type="hidden" name="maHoaDon" value="${hd.getMaHoaDon()}">
                                </form>
                                <button type="button" class="btn-swing btn-primary" style="padding: 5px 10px; font-size: 13px; background-color: #217346;"
                                    onclick="event.stopPropagation(); confirmPay(this.closest('tr').dataset.id);">Thanh toán</button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="hoa-don-form.jsp" />

<script>
function onHDRowClick(row) {
    const rows = document.querySelectorAll('#tblHD tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    openHoaDonModal(row.dataset);
}

function confirmPay(hoaDonId) {
    if (confirm('Xác nhận thanh toán hóa đơn #' + hoaDonId + '?')) {
        document.getElementById('frmPayHD_' + hoaDonId).submit();
    }
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
