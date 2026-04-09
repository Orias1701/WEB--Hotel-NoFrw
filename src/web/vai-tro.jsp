<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section-title">VAI TRÒ</div>

<div style="padding: 10px 25px;">
    <!-- Toolbar -->
    <div class="toolbar" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 15px 25px; background-color: white; border: 1px solid var(--color-border); border-radius: 10px;">
        <div class="search-box">
            <label style="margin-right: 10px; font-weight: bold;">Tìm kiếm:</label>
            <input type="text" id="txtSearchVT" class="rounded-input" placeholder="Nhập tên vai trò..." onkeyup="filterVTTable()" style="width: 250px;">
            
            <label style="margin-left: 20px; margin-right: 10px; font-weight: bold;">Lọc theo:</label>
            <select id="cboFilterVT" class="rounded-input" onchange="filterVTTable()">
                <option value="all">Tất cả</option>
                <option value="ten">Tên vai trò</option>
            </select>
        </div>
        <button class="btn-swing btn-primary" onclick="openVTForm('add', null)">+ Thêm mới</button>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: calc(100vh - 220px); overflow-y: auto; padding: 0;">
        <table class="swing-table" id="tblVT">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên vai trò</th>
                    <th style="width: 100px; text-align: center;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="vt" items="${listVaiTro}">
                    <tr onclick="openVTForm('update', this.dataset)" 
                        data-id="${vt.getMaVaiTro()}" 
                        data-ten="${vt.getTenVaiTro()}">
                        <td>${vt.getMaVaiTro()}</td>
                        <td>${vt.getTenVaiTro()}</td>
                        <td class="action-cell">
                                                            <form id="frmDelVT_${vt.getMaVaiTro()}" action="vai-tro-data" method="post" style="display:none;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="maVaiTro" value="${vt.getMaVaiTro()}">
                                </form>
                                <button type="button" class="btn-swing btn-danger" style="padding: 5px 10px; font-size: 13px;" onclick="event.stopPropagation(); confirmDelete('Bạn có chắc chắn muốn xóa vai trò này?', 'vaitro', this.closest('tr').dataset.id, 'frmDelVT_' + this.closest('tr').dataset.id);">Xóa</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="vai-tro-form.jsp" />

<script>
function filterVTTable() {
    const key = document.getElementById('txtSearchVT').value.toLowerCase();
    const type = document.getElementById('cboFilterVT').value; // Just incase it expands later
    const table = document.getElementById('tblVT');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const ten = row.dataset.ten.toLowerCase();

        let match = ten.includes(key);
        row.style.display = match ? '' : 'none';
    }
}
</script>
