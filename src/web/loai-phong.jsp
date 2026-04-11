<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <div class="section-title">LOẠI PHÒNG</div>

            <div style="padding: 10px 25px;">
                <!-- Toolbar -->
                <div class="toolbar"
                    style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 15px 25px; background-color: white; border: 1px solid var(--color-border); border-radius: 10px;">
                    <div class="search-box">
                        <label style="margin-right: 10px; font-weight: bold;">Tìm kiếm:</label>
                        <input type="text" id="txtSearchLP" class="rounded-input"
                            placeholder="Nhập tên loại phòng hoặc giá..." onkeyup="filterLPTable()"
                            style="width: 250px;">

                        <label style="margin-left: 20px; margin-right: 10px; font-weight: bold;">Lọc theo:</label>
                        <select id="cboFilterLP" class="rounded-input" onchange="filterLPTable()">
                            <option value="all">Tất cả</option>
                            <option value="ten">Tên loại phòng</option>
                        </select>
                    </div>
                    <button class="btn-swing btn-primary" onclick="openLPForm('add', null)">+ Thêm mới</button>
                </div>

                <!-- Table Content -->
                <div class="swing-table-container"
                    style="max-height: calc(100vh - 220px); overflow-y: auto; padding: 0;">
                    <table class="swing-table" id="tblLP">
                        <thead>
                            <tr>
                                <th class="center_cell">ID</th>
                                <th>Tên loại phòng</th>
                                <th class="currency-cell">Giá cơ bản</th>
                                <th class="center_cell" style="width: 121px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="lp" items="${listLoaiPhong}">
                                <tr onclick="openLPForm('update', this.dataset)" data-id="${lp.getMaLoaiPhong()}"
                                    data-ten="${lp.getTenLoaiPhong()}" data-gia="${lp.getGiaCoBan()}">
                                    <td class="center_cell">${lp.getMaLoaiPhong()}</td>
                                    <td>${lp.getTenLoaiPhong()}</td>
                                    <td class="currency-cell">
                                        <fmt:setLocale value="vi_VN" />
                                        <fmt:formatNumber value="${lp.getGiaCoBan()}" pattern="#,###" /> VNĐ
                                    </td>
                                    <td class="action-cell center_cell">
                                        <form id="frmDelLP_${lp.getMaLoaiPhong()}" action="loai-phong-data"
                                            method="post" style="display:none;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="maLoaiPhong" value="${lp.getMaLoaiPhong()}">
                                        </form>
                                        <button type="button" class="btn-swing btn-danger"
                                            style="padding: 5px 10px; font-size: 13px;"
                                            onclick="event.stopPropagation(); confirmDelete('Bạn có chắc chắn muốn xóa Loại phòng này?', 'loaiphong', this.closest('tr').dataset.id, 'frmDelLP_' + this.closest('tr').dataset.id);">Xóa</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <jsp:include page="loai-phong-form.jsp" />

            <script>
                function filterLPTable() {
                    const key = document.getElementById('txtSearchLP').value.toLowerCase();
                    const type = document.getElementById('cboFilterLP').value;
                    const table = document.getElementById('tblLP');
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