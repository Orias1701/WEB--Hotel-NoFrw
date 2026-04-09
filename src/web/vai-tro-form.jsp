<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Modal Overlay for VaiTro Form -->
<div id="modalVT" class="modal-overlay">
    <div class="modal-content" style="max-width: 400px;">
        <div class="modal-header">
            Dữ liệu chi tiết Vai trò
        </div>
        
        <form id="frmVT" action="vai-tro-data" method="post">
            <input type="hidden" id="vtAction" name="action" value="add">
            
            <div class="modal-form-grid">
                <div class="form-group full-width">
                    <label>ID:</label>
                    <input type="text" id="maVaiTro" name="maVaiTro" class="rounded-input" readonly style="background-color: #f0f0f0;" placeholder="Tự động tạo">
                </div>
                
                <div class="form-group full-width">
                    <label>Tên vai trò:</label>
                    <input type="text" id="tenVaiTro" name="tenVaiTro" class="rounded-input" required>
                </div>
            </div>

            <div class="modal-footer">
                <button type="submit" class="btn-swing btn-primary">Lưu</button>
                <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalVT')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<script>
function openVTForm(action, row_dataset) {
    const frm = document.getElementById('frmVT');
    frm.reset();
    document.getElementById('vtAction').value = action;
    
    if (action === 'update' && row_dataset) {
        document.getElementById('maVaiTro').value = row_dataset.id;
        document.getElementById('tenVaiTro').value = row_dataset.ten;
    } else {
        document.getElementById('maVaiTro').value = '';
    }
    
    openModal('modalVT');
}
</script>
