<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Modal Overlay for NhanVien Form -->
<div id="modalNV" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            Dữ liệu chi tiết Nhân viên
        </div>
        
        <form id="frmNV" action="nhan-vien-data" method="post">
            <input type="hidden" id="nvAction" name="action" value="add">
            
            <div class="modal-form-grid">
                <div class="form-group full-width">
                    <label>ID:</label>
                    <input type="text" id="maNhanVien" name="maNhanVien" class="rounded-input" readonly style="background-color: #f0f0f0;" placeholder="Tự động tạo">
                </div>
                
                <div class="form-group">
                    <label>Tên nhân viên:</label>
                    <input type="text" id="tenNhanVien" name="tenNhanVien" class="rounded-input" required>
                </div>
                
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="text" id="soDienThoai" name="soDienThoai" class="rounded-input" required>
                </div>
                
                <div class="form-group full-width">
                    <label>Email:</label>
                    <input type="email" id="email" name="email" class="rounded-input">
                </div>
            </div>

            <div class="modal-footer">
                <button type="submit" class="btn-swing btn-primary">Lưu</button>
                <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalNV')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<script>
function openNVForm(action, row_dataset) {
    const frm = document.getElementById('frmNV');
    frm.reset();
    document.getElementById('nvAction').value = action;
    
    if (action === 'update' && row_dataset) {
        document.getElementById('maNhanVien').value = row_dataset.id;
        document.getElementById('tenNhanVien').value = row_dataset.ten;
        document.getElementById('soDienThoai').value = row_dataset.sdt;
        document.getElementById('email').value = row_dataset.email;
    } else {
        document.getElementById('maNhanVien').value = '';
    }
    
    openModal('modalNV');
}
</script>
