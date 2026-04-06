<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="section-title">ĐẶT PHÒNG</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearchDatPhong" class="rounded-input" placeholder="Nhập tên khách hoặc số phòng..." onkeyup="filterDatPhongTable()">
        
        <label style="margin-left: 20px;">Lọc theo:</label>
        <select id="cboFilterDatPhong" class="rounded-input" onchange="filterDatPhongTable()">
            <option value="all">Tất cả</option>
            <option value="khachHang">Khách hàng</option>
            <option value="phong">Phòng</option>
        </select>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 350px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblDatPhong">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Khách hàng</th>
                    <th>Phòng</th>
                    <th>Nhận</th>
                    <th>Hẹn trả</th>
                    <th>Ngày trả</th>
                    <th>Tiền phòng</th>
                    <th>Tiền phạt</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="dp" items="${dataList}">
                    <tr onclick="onDatPhongRowClick(this)" 
                        data-id="${dp.getMaDatPhong()}" 
                        data-makhach="${dp.getMaKhachHang()}"
                        data-maphong="${dp.getMaPhong()}"
                        data-nhan="${dp.getNgayNhanPhong().toString().substring(0, 16).replace(' ', 'T')}"
                        data-hentra="${dp.getNgayHenTra().toString().substring(0, 16).replace(' ', 'T')}"
                        data-trangthai="${dp.getNgayTraPhong() != null ? 'Đã trả' : 'Chưa trả'}">
                        <td>${dp.getMaDatPhong()}</td>
                        <td>${dp.getTenKhachHang()}</td>
                        <td>${dp.getSoPhong()}</td>
                        <td><fmt:formatDate value="${dp.getNgayNhanPhong()}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td><fmt:formatDate value="${dp.getNgayHenTra()}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td><fmt:formatDate value="${dp.getNgayTraPhong()}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td><fmt:formatNumber value="${dp.getTienPhong()}" type="currency" currencyCode="VND" /></td>
                        <td><fmt:formatNumber value="${dp.getTienPhat()}" type="currency" currencyCode="VND" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Input Form (TitledBorder replication) -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative; background: white;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Chi tiết đặt phòng
        </span>
        
        <form id="frmDatPhong" action="dat-phong-data" method="post">
            <input type="hidden" id="dpAction" name="action" value="add">
            <input type="hidden" id="maDatPhong" name="maDatPhong">
            
            <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
                <label>Khách hàng:</label>
                <select id="maKhachHang" name="maKhachHang" class="rounded-input" required>
                    <c:forEach var="kh" items="${listKhachHang}">
                        <option value="${kh.getMaKhachHang()}">${kh.getTenKhachHang()}</option>
                    </c:forEach>
                </select>
                
                <label>Phòng (Trống):</label>
                <select id="maPhong" name="maPhong" class="rounded-input" required>
                    <c:forEach var="p" items="${listPhongTrong}">
                        <option value="${p.getMaPhong()}">${p.getSoPhong()}</option>
                    </c:forEach>
                </select>

                <label>Ngày nhận:</label>
                <input type="datetime-local" id="ngayNhan" name="ngayNhan" class="rounded-input" required>
                
                <label>Ngày hẹn trả:</label>
                <input type="datetime-local" id="ngayHenTra" name="ngayHenTra" class="rounded-input" required>
            </div>

            <!-- Button Panel -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button type="submit" onclick="document.getElementById('dpAction').value='add'" class="btn-swing btn-primary">Đặt phòng</button>
                <button type="submit" onclick="document.getElementById('dpAction').value='checkout'" class="btn-swing btn-warning" style="color: white;">Trả phòng</button>
                <button type="submit" onclick="document.getElementById('dpAction').value='delete'" class="btn-swing btn-danger">Hủy đặt</button>
                <button type="button" onclick="clearDatPhongForm()" class="btn-swing" style="background-color: #6c757d; color: white;">Làm mới</button>
            </div>
        </form>
    </div>
</div>

<script>
/**
 * Handle table selection
 */
function onDatPhongRowClick(row) {
    // Highlight selection
    const rows = document.querySelectorAll('#tblDatPhong tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    // Populate form
    document.getElementById('maDatPhong').value = row.dataset.id;
    document.getElementById('maKhachHang').value = row.dataset.makhach;
    
    // Add existing room to select if it's not there (booked rooms aren't in listPhongTrong)
    const roomSelect = document.getElementById('maPhong');
    let roomExists = false;
    for (let i = 0; i < roomSelect.options.length; i++) {
        if (roomSelect.options[i].value === row.dataset.maphong) {
            roomExists = true;
            break;
        }
    }
    
    if (!roomExists) {
        const option = document.createElement("option");
        option.text = row.cells[2].innerText;
        option.value = row.dataset.maphong;
        roomSelect.add(option);
    }
    
    roomSelect.value = row.dataset.maphong;
    document.getElementById('ngayNhan').value = row.dataset.nhan;
    document.getElementById('ngayHenTra').value = row.dataset.hentra;
}

function clearDatPhongForm() {
    document.getElementById('frmDatPhong').reset();
    document.getElementById('maDatPhong').value = '';
    const rows = document.querySelectorAll('#tblDatPhong tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

/**
 * Basic client-side search filtering
 */
function filterDatPhongTable() {
    const key = document.getElementById('txtSearchDatPhong').value.toLowerCase();
    const type = document.getElementById('cboFilterDatPhong').value;
    const table = document.getElementById('tblDatPhong');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const khach = row.cells[1].innerText.toLowerCase();
        const phong = row.cells[2].innerText.toLowerCase();

        let match = false;
        if (type === 'khachHang') match = khach.includes(key);
        else if (type === 'phong') match = phong.includes(key);
        else match = khach.includes(key) || phong.includes(key);

        row.style.display = match ? '' : 'none';
    }
}
</script>
