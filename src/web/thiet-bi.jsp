<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="section-title">THIẾT BỊ</div>

<div style="padding: 10px 25px;">
    <!-- Toolbar -->
    <div class="toolbar" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 15px 25px; background-color: white; border: 1px solid var(--color-border); border-radius: 10px;">
        <div class="search-box">
            <label style="margin-right: 10px; font-weight: bold;">Tìm kiếm:</label>
            <input type="text" id="txtSearchTB" class="rounded-input" placeholder="Nhập tên thiết bị hoặc giá..." onkeyup="filterTBTable()" style="width: 250px;">
            
            <label style="margin-left: 20px; margin-right: 10px; font-weight: bold;">Lọc theo:</label>
            <select id="cboFilterTB" class="rounded-input" onchange="filterTBTable()">
                <option value="all">Tất cả</option>
                <option value="ten">Tên thiết bị</option>
            </select>
        </div>
        <button class="btn-swing btn-primary" onclick="openTBForm('add', null)">+ Thêm mới</button>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: calc(100vh - 220px); overflow-y: auto; padding: 0;">
        <table class="swing-table" id="tblTB">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên thiết bị</th>
                    <th>Giá thiết bị</th>
                    <th style="width: 100px; text-align: center;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="tb" items="${listThietBi}">
                    <tr onclick="openTBForm('update', this.dataset)" 
                        data-id="${tb.getMaThietBi()}" 
                        data-ten="${tb.getTenThietBi()}" 
                        data-gia="${tb.getGiaThietBi()}">
                        <td>${tb.getMaThietBi()}</td>
                        <td>${tb.getTenThietBi()}</td>
                        <td><fmt:formatNumber value="${tb.getGiaThietBi()}" type="currency" currencyCode="VND" /></td>
                        <td class="action-cell">
                                                            <form id="frmDelTB_${tb.getMaThietBi()}" action="thiet-bi-data" method="post" style="display:none;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="maThietBi" value="${tb.getMaThietBi()}">
                                </form>
                                <button type="button" class="btn-swing btn-danger" style="padding: 5px 10px; font-size: 13px;" onclick="event.stopPropagation(); confirmDelete('Bạn có chắc chắn muốn xóa thiết bị này?', 'thietbi', this.closest('tr').dataset.id, 'frmDelTB_' + this.closest('tr').dataset.id);">Xóa</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="thiet-bi-form.jsp" />

<script>
function filterTBTable() {
    const key = document.getElementById('txtSearchTB').value.toLowerCase();
    const type = document.getElementById('cboFilterTB').value;
    const table = document.getElementById('tblTB');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const ten = row.dataset.ten.toLowerCase();
        const gia = row.dataset.gia.toLowerCase();

        let match = false;
        if (type === 'ten') match = ten.includes(key);
        else match = ten.includes(key) || gia.includes(key);

        row.style.display = match ? '' : 'none';
    }
}
</script>
