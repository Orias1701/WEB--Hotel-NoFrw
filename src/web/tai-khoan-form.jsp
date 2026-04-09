<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Modal Overlay for TaiKhoan Form -->
<div id="modalTK" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            Dữ liệu chi tiết Tài khoản
        </div>
        
        <form id="frmTK" action="tai-khoan-data" method="post">
            <input type="hidden" id="tkAction" name="action" value="add">
            
            <div class="modal-form-grid">
                <div class="form-group full-width">
                    <label>ID:</label>
                    <input type="text" id="tkId" name="id" class="rounded-input" readonly style="background-color: #f0f0f0;" placeholder="Tự động tạo">
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

            <div class="modal-footer">
                <button type="submit" class="btn-swing btn-primary">Lưu</button>
                <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalTK')">Hủy</button>
            </div>
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
    } else {
        document.getElementById('tkId').value = '';
    }
    
    openModal('modalTK');
}
</script>
