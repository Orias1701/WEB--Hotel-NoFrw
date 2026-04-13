<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Modal Overlay for TaiKhoan Form -->
        <div id="modalTK" class="modal-overlay">
            <div class="modal-content">
                <div class="modal-header">
                    Dữ liệu chi tiết Tài khoản
                </div>

                <form id="frmTK" action="tai-khoan-data" method="post" onsubmit="return submitTKForm(event)">
                    <input type="hidden" id="tkAction" name="action" value="add">

                <div class="modal-form-grid">
                    <div class="form-group full-width">
                        <label>ID:</label>
                        <input type="text" id="tkId" name="id" class="rounded-input bg-readonly" readonly
                            placeholder="Tự động tạo">
                    </div>

                    <div class="form-group">
                        <label>Username:</label>
                        <input type="text" id="tkUser" name="taiKhoan" class="rounded-input" required>
                    </div>

                    <div class="form-group">
                        <label>Password:</label>
                        <input type="password" id="tkPass" name="matKhau" class="rounded-input" required>
                    </div>

                    <div class="form-group">
                        <label>Nhân viên:</label>
                        <select id="tkMaNhanVien" name="maNhanVien" class="rounded-input" required>
                            <c:forEach var="nv" items="${listNhanVien}">
                                <option value="${nv.getMaNhanVien()}">${nv.getTenNhanVien()}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Vai trò:</label>
                        <select id="tkMaVaiTro" name="maVaiTro" class="rounded-input" required>
                            <c:forEach var="vt" items="${listVaiTro}">
                                <option value="${vt.getMaVaiTro()}">${vt.getTenVaiTro()}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="modal-footer flex-between w-full">
                    <div>
                        <button type="button" id="btnDeleteTK" class="btn-swing btn-danger" style="display: none;"
                            onclick="confirmDeleteTK()">Xóa</button>
                    </div>
                    <div class="flex-gap-10">
                        <button type="submit" class="btn-swing btn-primary">Lưu</button>
                        <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalTK')">Hủy</button>
                    </div>
                </div>
            </form>

            <!-- Hidden Delete Form -->
            <form id="frmDelTK" action="tai-khoan-data" method="post" style="display:none;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="delMaTK" name="id">
            </form>
        </div>
    </div>

        <script>
            function openTKForm(action, row_dataset) {
                const frm = document.getElementById('frmTK');
                frm.reset();
                document.getElementById('tkAction').value = action;

                if (action === 'update' && row_dataset) {
                    document.getElementById('tkId').value = row_dataset.id;
                    document.getElementById('tkUser').value = row_dataset.user;
                    document.getElementById('tkPass').value = row_dataset.pass;
                    document.getElementById('tkMaNhanVien').value = row_dataset.manv;
                    document.getElementById('tkMaVaiTro').value = row_dataset.mavt;

                    document.getElementById('btnDeleteTK').style.display = 'block';
                    document.getElementById('delMaTK').value = row_dataset.id;
                } else {
                    document.getElementById('tkId').value = '';
                    document.getElementById('btnDeleteTK').style.display = 'none';
                }

                openModal('modalTK');
            }

            async function confirmDeleteTK() {
                const id = document.getElementById('delMaTK').value;
                if (confirm('Bạn có chắc chắn muốn xóa tài khoản #' + id + '?')) {
                    const form = document.getElementById('frmDelTK');
                    const formData = new FormData(form);
                    await fetch(form.getAttribute('action'), {
                        method: form.getAttribute('method') || 'POST',
                        body: new URLSearchParams(formData)
                    });
                    closeModal('modalTK');
                    loadModule('tai-khoan', 'Tài khoản');
                }
            }

            async function submitTKForm(event) {
                event.preventDefault();
                const form = event.target;
                const formData = new FormData(form);
                await fetch(form.getAttribute('action'), {
                    method: form.getAttribute('method') || 'POST',
                    body: new URLSearchParams(formData)
                });
                closeModal('modalTK');
                loadModule('tai-khoan', 'Tài khoản');
                return false;
            }
        </script>