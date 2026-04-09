<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section-title">THIẾT BỊ PHÒNG</div>

<div style="padding: 10px 25px;">
    <!-- Toolbar -->
    <div class="toolbar" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 15px 25px; background-color: white; border: 1px solid var(--color-border); border-radius: 10px;">
        <div class="search-box">
            <label style="margin-right: 10px; font-weight: bold;">Tìm kiếm:</label>
            <input type="text" id="txtSearchTBP" class="rounded-input" placeholder="Nhập tên phòng hoặc thiết bị..." onkeyup="filterTBPTable()" style="width: 250px;">
            
            <label style="margin-left: 20px; margin-right: 10px; font-weight: bold;">Lọc theo:</label>
            <select id="cboFilterTBP" class="rounded-input" onchange="filterTBPTable()">
                <option value="all">Tất cả</option>
                <option value="phong">Phòng</option>
                <option value="thietBi">Thiết bị</option>
            </select>
        </div>
        <button class="btn-swing btn-primary" onclick="openTBPForm('add', null)">+ Thêm mới</button>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: calc(100vh - 220px); overflow-y: auto; padding: 0;">
        <table class="swing-table" id="tblTBP">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Phòng</th>
                    <th>Thiết bị</th>
                    <th>Số lượng</th>
                    <th>Trạng thái</th>
                    <th style="width: 100px; text-align: center;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="tbp" items="${listThietBiPhong}">
                    <tr onclick="openTBPForm('update', this.dataset)" 
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
                        <td class="action-cell">
                                                            <form id="frmDelTBP_${tbp.getMaThietBiPhong()}" action="thiet-bi-phong-data" method="post" style="display:none;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="maThietBiPhong" value="${tbp.getMaThietBiPhong()}">
                                </form>
                                <button type="button" class="btn-swing btn-danger" style="padding: 5px 10px; font-size: 13px;" onclick="event.stopPropagation(); confirmDelete('Bạn có chắc chắn muốn xóa thiết bị phòng này?', 'thietbiphong', this.closest('tr').dataset.id, 'frmDelTBP_' + this.closest('tr').dataset.id);">Xóa</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="thiet-bi-phong-form.jsp" />

<script>
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
