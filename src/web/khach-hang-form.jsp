<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Modal Overlay for KhachHang Form -->
<div id="modalKH" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            Dữ liệu chi tiết Khách hàng
        </div>
        
        <form id="frmKH" action="khach-hang-data" method="post">
            <input type="hidden" id="khAction" name="action" value="add">
            
            <div class="modal-form-grid">
                <div class="form-group full-width">
                    <label>ID:</label>
                    <input type="text" id="maKhachHang" name="maKhachHang" class="rounded-input" readonly style="background-color: #f0f0f0;" placeholder="Tự động tạo">
                </div>
                
                <div class="form-group">
                    <label>Tên khách hàng:</label>
                    <input type="text" id="tenKhachHang" name="tenKhachHang" class="rounded-input" required>
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
                <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalKH')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<script>
function openKHForm(action, row_dataset) {
    const frm = document.getElementById('frmKH');
    frm.reset();
    document.getElementById('khAction').value = action;
    
    if (action === 'update' && row_dataset) {
        document.getElementById('maKhachHang').value = row_dataset.id;
        document.getElementById('tenKhachHang').value = row_dataset.ten;
        document.getElementById('soDienThoai').value = row_dataset.sdt;
        document.getElementById('email').value = row_dataset.email;
    } else {
        document.getElementById('maKhachHang').value = '';
    }
    
    openModal('modalKH');
}
</script>
