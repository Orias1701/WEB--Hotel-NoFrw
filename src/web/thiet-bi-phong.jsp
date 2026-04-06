<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section-title">THIẾT BỊ PHÒNG</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearchTBP" class="rounded-input" placeholder="Nhập tên phòng hoặc thiết bị..." onkeyup="filterTBPTable()">
        
        <label style="margin-left: 20px;">Lọc theo:</label>
        <select id="cboFilterTBP" class="rounded-input" onchange="filterTBPTable()">
            <option value="all">Tất cả</option>
            <option value="phong">Phòng</option>
            <option value="thietBi">Thiết bị</option>
        </select>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 400px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblTBP">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Phòng</th>
                    <th>Thiết bị</th>
                    <th>Số lượng</th>
                    <th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="tbp" items="${listThietBiPhong}">
                    <tr onclick="onTBPRowClick(this)" 
                        data-id="${tbp.getMaThietBiPhong()}" 
                        data-phongid="${tbp.getMaPhong()}"
                        data-phongten="${tbp.getTenPhong()}"
                        data-tbid="${tbp.getMaThietBi()}"
                        data-tbten="${tbp.getTenThietBi()}"
                        data-soluong="${tbp.getSoLuong()}"
                        data-trangthai="${tbp.getTrangThai()}">
                        <td>${tbp.getMaThietBiPhong()}</td>
                        <td>${tbp.getTenPhong()}</td>
                        <td>${tbp.getTenThietBi()}</td>
                        <td>${tbp.getSoLuong()}</td>
                        <td>${tbp.getTrangThai()}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Input Form -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Phân bổ thiết bị cho phòng
        </span>
        
        <form id="frmTBP" action="thiet-bi-phong-data" method="post">
            <input type="hidden" id="tbpAction" name="action" value="add">
            
            <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
                <label>ID:</label>
                <input type="text" id="maThietBiPhong" name="maThietBiPhong" class="rounded-input" readonly style="background-color: #f0f0f0;">
                
                <label>Phòng:</label>
                <select id="maPhong" name="maPhong" class="rounded-input" required>
                    <c:forEach var="p" items="${listPhong}">
                        <option value="${p.getMaPhong()}">${p.getSoPhong()}</option>
                    </c:forEach>
                </select>
                
                <label>Thiết bị:</label>
                <select id="maThietBi" name="maThietBi" class="rounded-input" required>
                    <c:forEach var="tb" items="${listThietBi}">
                        <option value="${tb.getMaThietBi()}">${tb.getTenThietBi()}</option>
                    </c:forEach>
                </select>
                
                <label>Số lượng:</label>
                <input type="number" id="soLuong" name="soLuong" class="rounded-input" required min="1">
                
                <label>Trạng thái:</label>
                <select id="trangThaiTBP" name="trangThai" class="rounded-input">
                    <option value="Tốt">Tốt</option>
                    <option value="Hỏng">Hỏng</option>
                    <option value="Bảo trì">Bảo trì</option>
                </select>
            </div>

            <!-- Button Panel -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button type="submit" onclick="document.getElementById('tbpAction').value='add'" class="btn-swing btn-primary">Thêm</button>
                <button type="submit" onclick="document.getElementById('tbpAction').value='update'" class="btn-swing btn-warning" style="color: white;">Sửa</button>
                <button type="submit" onclick="document.getElementById('tbpAction').value='delete'" class="btn-swing btn-danger">Xóa</button>
                <button type="button" onclick="clearTBPForm()" class="btn-swing" style="background-color: #6c757d; color: white;">Làm mới</button>
            </div>
        </form>
    </div>
</div>

<script>
function onTBPRowClick(row) {
    const rows = document.querySelectorAll('#tblTBP tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    document.getElementById('maThietBiPhong').value = row.dataset.id;
    document.getElementById('maPhong').value = row.dataset.phongid;
    document.getElementById('maThietBi').value = row.dataset.tbid;
    document.getElementById('soLuong').value = row.dataset.soluong;
    document.getElementById('trangThaiTBP').value = row.dataset.trangthai;
}

function clearTBPForm() {
    document.getElementById('frmTBP').reset();
    document.getElementById('maThietBiPhong').value = '';
    const rows = document.querySelectorAll('#tblTBP tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

function filterTBPTable() {
    const key = document.getElementById('txtSearchTBP').value.toLowerCase();
    const type = document.getElementById('cboFilterTBP').value;
    const table = document.getElementById('tblTBP');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const phong = row.dataset.phongten.toLowerCase();
        const tb = row.dataset.tbten.toLowerCase();

        let match = false;
        if (type === 'phong') match = phong.includes(key);
        else if (type === 'thietBi') match = tb.includes(key);
        else match = phong.includes(key) || tb.includes(key);

        row.style.display = match ? '' : 'none';
    }
}
</script>
