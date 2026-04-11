<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="section-title">DANH SÁCH PHÒNG</div>

        <div style="padding: 10px 25px;">
            <!-- Toolbar -->
            <div class="toolbar"
                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 15px 25px; background-color: white; border: 1px solid var(--color-border); border-radius: 10px;">
                <div class="search-box">
                    <label style="margin-right: 10px; font-weight: bold;">Tìm kiếm:</label>
                    <input type="text" id="txtSearchPhong" class="rounded-input" placeholder="Nhập từ khóa..."
                        onkeyup="filterPhongTable()" style="width: 250px;">

                    <label style="margin-left: 20px; margin-right: 10px; font-weight: bold;">Lọc theo:</label>
                    <select id="cboFilterPhong" class="rounded-input" onchange="filterPhongTable()">
                        <option value="all">Tất cả</option>
                        <option value="soPhong">Số phòng</option>
                        <option value="loaiPhong">Loại phòng</option>
                        <option value="trangThai">Trạng thái</option>
                    </select>
                </div>
                <button class="btn-swing btn-primary" onclick="openPhongForm('add', null)">+ Thêm mới</button>
            </div>

            <!-- Table Content -->
            <div class="swing-table-container" style="max-height: calc(100vh - 220px); overflow-y: auto; padding: 0;">
                <table class="swing-table" id="tblPhong">
                    <thead>
                        <tr>
                            <th class="center_cell">ID</th>
                            <th>Số phòng</th>
                            <th>Loại phòng</th>
                            <th class="center_cell">Trạng thái</th>
                            <th class="center_cell" style="width: 121px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${listPhong}">
                            <tr onclick="openPhongForm('update', this.dataset)" data-id="${p.getMaPhong()}"
                                data-sophong="${p.getSoPhong()}" data-maloai="${p.getMaLoaiPhong()}"
                                data-tenloai="${p.getTenLoaiPhong()}" data-trangthai="${p.getTrangThai()}">
                                <td class="center_cell">${p.getMaPhong()}</td>
                                <td>${p.getSoPhong()}</td>
                                <td>${p.getTenLoaiPhong()}</td>
                                <td class="center_cell">
                                    <span
                                        class="status-badge ${p.getTrangThai() == 'Trống' ? 'status-trong' : (p.getTrangThai() == 'Đang thuê' ? 'status-thue' : 'status-sua')}">
                                        ${p.getTrangThai()}
                                    </span>
                                </td>
                                <td class="action-cell center_cell">
                                    <form id="frmDelPhong_${p.getMaPhong()}" action="phong-data" method="post"
                                        style="display:none;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="maPhong" value="${p.getMaPhong()}">
                                    </form>
                                    <button type="button" class="btn-swing btn-danger"
                                        style="padding: 5px 10px; font-size: 13px;"
                                        onclick="event.stopPropagation(); confirmDelete('Bạn có chắc chắn muốn xóa phòng này?', 'phong', this.closest('tr').dataset.id, 'frmDelPhong_' + this.closest('tr').dataset.id);">Xóa</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <jsp:include page="phong-form.jsp" />

        <script>
            /**
             * Basic client-side search filtering
             */
            function filterPhongTable() {
                const key = document.getElementById('txtSearchPhong').value.toLowerCase();
                const type = document.getElementById('cboFilterPhong').value;
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