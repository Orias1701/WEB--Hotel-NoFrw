<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section-title">KHÁCH HÀNG</div>

<div style="padding: 10px 25px;">
    <!-- Toolbar -->
    <div class="toolbar" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 15px 25px; background-color: white; border: 1px solid var(--color-border); border-radius: 10px;">
        <div class="search-box">
            <label style="margin-right: 10px; font-weight: bold;">Tìm kiếm:</label>
            <input type="text" id="txtSearchKH" class="rounded-input" placeholder="Nhập tên, SĐT hoặc Email..." onkeyup="filterKHTable()" style="width: 250px;">
            
            <label style="margin-left: 20px; margin-right: 10px; font-weight: bold;">Lọc theo:</label>
            <select id="cboFilterKH" class="rounded-input" onchange="filterKHTable()">
                <option value="all">Tất cả</option>
                <option value="ten">Tên khách</option>
                <option value="sdt">Số điện thoại</option>
                <option value="email">Email</option>
            </select>
        </div>
        <button class="btn-swing btn-primary" onclick="openKHForm('add', null)">+ Thêm mới</button>
    </div>

    <!-- Table Content -->
    <div class="swing-table-container" style="max-height: calc(100vh - 220px); overflow-y: auto; padding: 0;">
        <table class="swing-table" id="tblKH">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên khách</th>
                    <th>Số điện thoại</th>
                    <th>Email</th>
                    <th style="width: 100px; text-align: center;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="kh" items="${listKhachHang}">
                    <tr onclick="openKHForm('update', this.dataset)" 
                        data-id="${kh.getMaKhachHang()}" 
                        data-ten="${kh.getTenKhachHang()}" 
                        data-sdt="${kh.getSoDienThoai()}"
                        data-email="${kh.getEmail()}">
                        <td>${kh.getMaKhachHang()}</td>
                        <td>${kh.getTenKhachHang()}</td>
                        <td>${kh.getSoDienThoai()}</td>
                        <td>${kh.getEmail()}</td>
                        <td class="action-cell">
                            <form id="frmDelKH_${kh.getMaKhachHang()}" action="khach-hang-data" method="post" style="display:none;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="maKhachHang" value="${kh.getMaKhachHang()}">
                            </form>
                            <button type="button" class="btn-swing btn-danger" style="padding: 5px 10px; font-size: 13px;" onclick="event.stopPropagation(); confirmDelete('Xóa khách hàng này?', 'khachhang', this.closest('tr').dataset.id, 'frmDelKH_' + this.closest('tr').dataset.id);">Xóa</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="khach-hang-form.jsp" />

<script>
/**
 * Basic client-side search filtering
 */
function filterKHTable() {
    const key = document.getElementById('txtSearchKH').value.toLowerCase();
    const type = document.getElementById('cboFilterKH').value;
    const table = document.getElementById('tblKH');
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
