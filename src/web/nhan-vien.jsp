<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section-title">NHÂN VIÊN</div>

<div style="padding: 10px 25px;">
    <!-- Toolbar -->
    <div class="toolbar" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 15px 25px; background-color: white; border: 1px solid var(--color-border); border-radius: 10px;">
        <div class="search-box">
            <label style="margin-right: 10px; font-weight: bold;">Tìm kiếm:</label>
            <input type="text" id="txtSearchNV" class="rounded-input" placeholder="Nhập tên, Email hoặc SĐT..." onkeyup="filterNVTable()" style="width: 250px;">
            
            <label style="margin-left: 20px; margin-right: 10px; font-weight: bold;">Lọc theo:</label>
            <select id="cboFilterNV" class="rounded-input" onchange="filterNVTable()">
                <option value="all">Tất cả</option>
                <option value="ten">Tên nhân viên</option>
                <option value="email">Email</option>
                <option value="sdt">SĐT</option>
            </select>
        </div>
        <button class="btn-swing btn-primary" onclick="openNVForm('add', null)">+ Thêm mới</button>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: calc(100vh - 220px); overflow-y: auto; padding: 0;">
        <table class="swing-table" id="tblNV">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên nhân viên</th>
                    <th>Số điện thoại</th>
                    <th>Email</th>
                    <th style="width: 100px; text-align: center;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="nv" items="${listNhanVien}">
                    <tr onclick="openNVForm('update', this.dataset)" 
                        data-id="${nv.getMaNhanVien()}" 
                        data-ten="${nv.getTenNhanVien()}" 
                        data-sdt="${nv.getSoDienThoai()}"
                        data-email="${nv.getEmail()}">
                        <td>${nv.getMaNhanVien()}</td>
                        <td>${nv.getTenNhanVien()}</td>
                        <td>${nv.getSoDienThoai()}</td>
                        <td>${nv.getEmail()}</td>
                        <td class="action-cell">
                                                            <form id="frmDelNV_${nv.getMaNhanVien()}" action="nhan-vien-data" method="post" style="display:none;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="maNhanVien" value="${nv.getMaNhanVien()}">
                                </form>
                                <button type="button" class="btn-swing btn-danger" style="padding: 5px 10px; font-size: 13px;" onclick="event.stopPropagation(); confirmDelete('Bạn có chắc chắn muốn xóa nhân viên này?', 'nhanvien', this.closest('tr').dataset.id, 'frmDelNV_' + this.closest('tr').dataset.id);">Xóa</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="nhan-vien-form.jsp" />

<script>
/**
 * Basic client-side search filtering
 */
function filterNVTable() {
    const key = document.getElementById('txtSearchNV').value.toLowerCase();
    const type = document.getElementById('cboFilterNV').value;
    const table = document.getElementById('tblNV');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const ten = row.dataset.ten.toLowerCase();
        const sdt = row.dataset.sdt.toLowerCase();
        const email = row.dataset.email.toLowerCase();

        let match = false;
        if (type === 'ten') match = ten.includes(key);
        else if (type === 'sdt') match = sdt.includes(key);
        else if (type === 'email') match = email.includes(key);
        else match = ten.includes(key) || sdt.includes(key) || email.includes(key);

        row.style.display = match ? '' : 'none';
    }
}
</script>
