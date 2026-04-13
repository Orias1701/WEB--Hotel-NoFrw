<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div id="modalPhong" class="modal-overlay">
            <div class="modal-content" style="max-width: 600px;">
                <div class="modal-header">
                    Dữ liệu chi tiết Phòng
                </div>

                <form id="frmPhong" action="phong-data" method="post" onsubmit="return submitPhongForm(event)">
                    <input type="hidden" id="action" name="action" value="add">

                <div class="modal-form-grid">
                    <div class="form-group full-width">
                        <label>ID:</label>
                        <input type="text" id="maPhong" name="maPhong" class="rounded-input bg-readonly" readonly
                            placeholder="Tự động tạo">
                    </div>

                    <div class="form-group">
                        <label>Số phòng:</label>
                        <input type="text" id="soPhong" name="soPhong" class="rounded-input" required>
                    </div>

                    <div class="form-group">
                        <label>Loại phòng:</label>
                        <select id="maLoaiPhong" name="maLoaiPhong" class="rounded-input">
                            <c:forEach var="lp" items="${listLoaiPhong}">
                                <option value="${lp.getMaLoaiPhong()}">${lp.getTenLoaiPhong()}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group full-width">
                        <label>Trạng thái:</label>
                        <select id="trangThai" name="trangThai" class="rounded-input">
                            <option value="Trống">Trống</option>
                            <option value="Đã đặt">Đã đặt</option>
                            <option value="Đang ở">Đang ở</option>
                            <option value="Bảo trì">Bảo trì</option>
                        </select>
                    </div>
                </div>

                <div class="modal-footer flex-between w-full">
                    <div>
                        <button type="button" id="btnDeletePhong" class="btn-swing btn-danger" style="display: none;"
                            onclick="confirmDeletePhong()">Xóa</button>
                    </div>
                    <div class="flex-gap-10">
                        <button type="submit" class="btn-swing btn-primary">Lưu</button>
                        <button type="button" class="btn-swing btn-secondary"
                            onclick="closeModal('modalPhong')">Hủy</button>
                    </div>
                </div>
                </form>

                <!-- Hidden Delete Form -->
                <form id="frmDelPhong" action="phong-data" method="post" style="display:none;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" id="delMaPhong" name="maPhong">
                </form>
            </div>
        </div>

        <script>
            function openPhongForm(action, row_dataset) {
                const frm = document.getElementById('frmPhong');
                frm.reset();
                document.getElementById('action').value = action;

                if (action === 'update' && row_dataset) {
                    document.getElementById('maPhong').value = row_dataset.id;
                    document.getElementById('soPhong').value = row_dataset.sophong;
                    document.getElementById('maLoaiPhong').value = row_dataset.maloai;
                    document.getElementById('trangThai').value = row_dataset.trangthai;

                    document.getElementById('btnDeletePhong').style.display = 'block';
                    document.getElementById('delMaPhong').value = row_dataset.id;
                } else {
                    document.getElementById('maPhong').value = '';
                    document.getElementById('btnDeletePhong').style.display = 'none';
                }

                openModal('modalPhong');
            }

            async function confirmDeletePhong() {
                const id = document.getElementById('delMaPhong').value;
                if (confirm('Bạn có chắc chắn muốn xóa phòng #' + id + '?')) {
                    const form = document.getElementById('frmDelPhong');
                    const formData = new FormData(form);
                    await fetch(form.getAttribute('action'), {
                        method: form.getAttribute('method') || 'POST',
                        body: new URLSearchParams(formData)
                    });
                    closeModal('modalPhong');
                    loadModule('phong', 'Phòng');
                }
            }

            async function submitPhongForm(event) {
                event.preventDefault();
                const form = event.target;
                const formData = new FormData(form);
                await fetch(form.getAttribute('action'), {
                    method: form.getAttribute('method') || 'POST',
                    body: new URLSearchParams(formData)
                });
                closeModal('modalPhong');
                loadModule('phong', 'Phòng');
                return false;
            }
        </script>