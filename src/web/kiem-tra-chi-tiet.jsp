<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="section-title">CHI TIẾT KIỂM TRA</div>

<div style="padding: 10px 25px;">
    <!-- Filter Panel -->
    <div class="filter-panel">
        <label>Tìm kiếm:</label>
        <input type="text" id="txtSearchKTCT" class="rounded-input" placeholder="Nhập mã kiểm tra hoặc phòng..." onkeyup="filterKTCTTable()">
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: 350px; overflow-y: auto; padding: 20px 0;">
        <table class="swing-table" id="tblKTCT">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Mã kiểm tra</th>
                    <th>Phòng</th>
                    <th>Thiết bị</th>
                    <th>Số lượng hỏng</th>
                    <th>Nhân viên</th>
                    <th>Ngày kiểm tra</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ktct" items="${listKiemTraChiTiet}">
                    <tr onclick="onKTCTRowClick(this)" 
                        data-id="${ktct.maKiemTraChiTiet}" 
                        data-maktp="${ktct.maKiemTraPhong}"
                        data-matb="${ktct.maThietBiPhong}"
                        data-soluong="${ktct.soLuongBiHong}"
                        data-manv="${ktct.maNhanVien}"
                        data-ngay="<fmt:formatDate value='${ktct.ngayKiemTra}' pattern='dd/MM/yyyy' />">
                        <td>${ktct.maKiemTraChiTiet}</td>
                        <td>${ktct.maKiemTraPhong}</td>
                        <td>${ktct.tenPhong}</td>
                        <td>${ktct.tenThietBi}</td>
                        <td style="color: #ff4d4d; font-weight: bold;">${ktct.soLuongBiHong}</td>
                        <td>${ktct.maNhanVien}</td>
                        <td><fmt:formatDate value="${ktct.ngayKiemTra}" pattern="dd/MM/yyyy" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Input Form -->
    <div style="margin-top: 30px; border: 1px solid var(--excel-green); border-radius: 10px; padding: 25px; position: relative; background: white;">
        <span style="position: absolute; top: -12px; left: 20px; background: white; padding: 0 10px; color: var(--excel-green); font-weight: bold; font-size: 16px;">
            Dữ liệu chi tiết thiết bị hỏng
        </span>
        
        <form id="frmKTCT" action="kiem-tra-chi-tiet-data" method="post">
            <input type="hidden" id="ktctAction" name="action" value="add">
            <input type="hidden" id="maKiemTraChiTiet" name="maKiemTraChiTiet">
            
            <div style="display: grid; grid-template-columns: 1fr 2fr 1fr 2fr; gap: 20px; align-items: center;">
                <label>Kiểm tra phòng:</label>
                <select id="maKiemTraPhong" name="maKiemTraPhong" class="rounded-input" required>
                    <c:forEach var="ktp" items="${listKiemTraPhong}">
                        <option value="${ktp.getMaKiemTraPhong()}">Kiểm tra ID: ${ktp.getMaKiemTraPhong()} (Phòng: ${ktp.getMaPhong()})</option>
                    </c:forEach>
                </select>
                
                <label>Thiết bị:</label>
                <select id="maThietBiKTCT" name="maThietBi" class="rounded-input" required>
                    <c:forEach var="tb" items="${listThietBi}">
                        <option value="${tb.getMaThietBi()}">${tb.getTenThietBi()}</option>
                    </c:forEach>
                </select>
                
                <label>Số lượng hỏng:</label>
                <input type="number" id="soLuongBiHong" name="soLuongBiHong" class="rounded-input" required min="0">
                
                <label></label>
                <label></label>
            </div>

            <!-- Button Panel -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button type="submit" onclick="document.getElementById('ktctAction').value='add'" class="btn-swing btn-primary">Thêm</button>
                <button type="submit" onclick="document.getElementById('ktctAction').value='update'" class="btn-swing btn-warning" style="color: white;">Cập nhật</button>
                <button type="submit" onclick="document.getElementById('ktctAction').value='delete'" class="btn-swing btn-danger">Xóa</button>
                <button type="button" onclick="clearKTCTForm()" class="btn-swing" style="background-color: #6c757d; color: white;">Làm mới</button>
            </div>
        </form>
    </div>
</div>

<script>
function onKTCTRowClick(row) {
    const rows = document.querySelectorAll('#tblKTCT tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
    row.style.backgroundColor = 'var(--excel-light-green)';

    document.getElementById('maKiemTraChiTiet').value = row.dataset.id;
    document.getElementById('maKiemTraPhong').value = row.dataset.maktp;
    document.getElementById('maThietBiKTCT').value = row.dataset.matb;
    document.getElementById('soLuongBiHong').value = row.dataset.soluong;
}

function clearKTCTForm() {
    document.getElementById('frmKTCT').reset();
    document.getElementById('maKiemTraChiTiet').value = '';
    const rows = document.querySelectorAll('#tblKTCT tbody tr');
    rows.forEach(r => r.style.backgroundColor = '');
}

function filterKTCTTable() {
    const key = document.getElementById('txtSearchKTCT').value.toLowerCase();
    const table = document.getElementById('tblKTCT');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const makt = row.cells[1].innerText.toLowerCase();
        const phong = row.cells[2].innerText.toLowerCase();

        let match = makt.includes(key) || phong.includes(key);
        row.style.display = match ? '' : 'none';
    }
}
</script>
