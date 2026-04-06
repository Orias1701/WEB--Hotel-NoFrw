<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section-title">DANH SÁCH PHÒNG</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearch" class="rounded-input" placeholder="Nhập từ khóa..." onkeyup="filterPhongTable()">
        
        <label style="margin-left: 20px;">Lọc theo:</label>
        <select id="cboFilter" class="rounded-input" onchange="filterPhongTable()">
            <option value="all">Tất cả</option>
            <option value="soPhong">Số phòng</option>
            <option value="loaiPhong">Loại phòng</option>
            <option value="trangThai">Trạng thái</option>
        </select>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 400px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblPhong">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Số phòng</th>
                    <th>Loại phòng</th>
                    <th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${listPhong}">
                    <tr onclick="onPhongRowClick(this)" 
                        data-id="${p.getMaPhong()}" 
                        data-sophong="${p.getSoPhong()}" 
                        data-maloai="${p.getMaLoaiPhong()}"
                        data-tenloai="${p.getTenLoaiPhong()}"
                        data-trangthai="${p.getTrangThai()}">
                        <td>${p.getMaPhong()}</td>
                        <td>${p.getSoPhong()}</td>
                        <td>${p.getTenLoaiPhong()}</td>
                        <td>${p.getTrangThai()}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Input Form (TitledBorder replication) -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Dữ liệu chi tiết
        </span>
        
        <form id="frmPhong" action="phong-data" method="post">
            <input type="hidden" id="action" name="action" value="add">
            
            <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
                <label>ID:</label>
                <input type="text" id="maPhong" name="maPhong" class="rounded-input" readonly style="background-color: #f0f0f0;">
                
                <label>Số phòng:</label>
                <input type="text" id="soPhong" name="soPhong" class="rounded-input" required>
                
                <label>Loại phòng:</label>
                <select id="maLoaiPhong" name="maLoaiPhong" class="rounded-input">
                    <c:forEach var="lp" items="${listLoaiPhong}">
                        <option value="${lp.getMaLoaiPhong()}">${lp.getTenLoaiPhong()}</option>
                    </c:forEach>
                </select>
                
                <label>Trạng thái:</label>
                <select id="trangThai" name="trangThai" class="rounded-input">
                    <option value="Trống">Trống</option>
                    <option value="Đã đặt">Đã đặt</option>
                    <option value="Đang ở">Đang ở</option>
                    <option value="Bảo trì">Bảo trì</option>
                </select>
            </div>

            <!-- Button Panel -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button type="submit" onclick="document.getElementById('action').value='add'" class="btn-swing btn-primary">Thêm</button>
                <button type="submit" onclick="document.getElementById('action').value='update'" class="btn-swing btn-warning" style="color: white;">Sửa</button>
                <button type="submit" onclick="document.getElementById('action').value='delete'" class="btn-swing btn-danger">Xóa</button>
                <button type="button" onclick="clearPhongForm()" class="btn-swing" style="background-color: #6c757d; color: white;">Làm mới</button>
            </div>
        </form>
    </div>
</div>

<script>
/**
 * Handle table selection - mimics tbl.addMouseListener
 */
function onPhongRowClick(row) {
    // Highlight selection
    const rows = document.querySelectorAll('#tblPhong tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    // Populate form
    document.getElementById('maPhong').value = row.dataset.id;
    document.getElementById('soPhong').value = row.dataset.sophong;
    document.getElementById('maLoaiPhong').value = row.dataset.maloai;
    document.getElementById('trangThai').value = row.dataset.trangthai;
}

function clearPhongForm() {
    document.getElementById('frmPhong').reset();
    document.getElementById('maPhong').value = '';
    const rows = document.querySelectorAll('#tblPhong tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

/**
 * Basic client-side search filtering
 */
function filterPhongTable() {
    const key = document.getElementById('txtSearch').value.toLowerCase();
    const type = document.getElementById('cboFilter').value;
    const table = document.getElementById('tblPhong');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const soPhong = row.dataset.sophong.toLowerCase();
        const loaiPhong = row.dataset.tenloai.toLowerCase();
        const trangThai = row.dataset.trangthai.toLowerCase();

        let match = false;
        if (type === 'soPhong') match = soPhong.includes(key);
        else if (type === 'loaiPhong') match = loaiPhong.includes(key);
        else if (type === 'trangThai') match = trangThai.includes(key);
        else match = soPhong.includes(key) || loaiPhong.includes(key) || trangThai.includes(key);

        row.style.display = match ? '' : 'none';
    }
}
</script>
