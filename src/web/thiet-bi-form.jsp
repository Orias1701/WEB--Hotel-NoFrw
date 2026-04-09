<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Modal Overlay for ThietBi Form -->
<div id="modalTB" class="modal-overlay">
    <div class="modal-content" style="max-width: 500px;">
        <div class="modal-header">
            Dữ liệu chi tiết Thiết bị
        </div>
        
        <form id="frmTB" action="thiet-bi-data" method="post">
            <input type="hidden" id="tbAction" name="action" value="add">
            
            <div class="modal-form-grid">
                <div class="form-group full-width">
                    <label>ID:</label>
                    <input type="text" id="maThietBi" name="maThietBi" class="rounded-input" readonly style="background-color: #f0f0f0;" placeholder="Tự động tạo">
                </div>
                
                <div class="form-group full-width">
                    <label>Tên thiết bị:</label>
                    <input type="text" id="tenThietBi" name="tenThietBi" class="rounded-input" required>
                </div>
                
                <div class="form-group full-width">
                    <label>Giá thiết bị (VND):</label>
                    <input type="number" id="giaThietBi" name="giaThietBi" class="rounded-input" required step="1000">
                </div>
            </div>

            <div class="modal-footer">
                <button type="submit" class="btn-swing btn-primary">Lưu</button>
                <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalTB')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<script>
function openTBForm(action, row_dataset) {
    const frm = document.getElementById('frmTB');
    frm.reset();
    document.getElementById('tbAction').value = action;
    
    if (action === 'update' && row_dataset) {
        document.getElementById('maThietBi').value = row_dataset.id;
        document.getElementById('tenThietBi').value = row_dataset.ten;
        document.getElementById('giaThietBi').value = row_dataset.gia;
    } else {
        document.getElementById('maThietBi').value = '';
    }
    
    openModal('modalTB');
}
</script>
