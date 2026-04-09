<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Modal Overlay for ThietBiPhong Form -->
<div id="modalTBP" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            Phân bổ Thiết bị cho Phòng
        </div>
        
        <form id="frmTBP" action="thiet-bi-phong-data" method="post">
            <input type="hidden" id="tbpAction" name="action" value="add">
            
            <div class="modal-form-grid">
                <div class="form-group full-width">
                    <label>ID:</label>
                    <input type="text" id="maThietBiPhong" name="maThietBiPhong" class="rounded-input" readonly style="background-color: #f0f0f0;" placeholder="Tự động tạo">
                </div>
                
                <div class="form-group">
                    <label>Phòng:</label>
                    <select id="maPhong" name="maPhong" class="rounded-input" required>
                        <c:forEach var="p" items="${listPhong}">
                            <option value="${p.getMaPhong()}">${p.getSoPhong()}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Thiết bị:</label>
                    <select id="maThietBi" name="maThietBi" class="rounded-input" required>
                        <c:forEach var="tb" items="${listThietBi}">
                            <option value="${tb.getMaThietBi()}">${tb.getTenThietBi()}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Số lượng:</label>
                    <input type="number" id="soLuong" name="soLuong" class="rounded-input" required min="1">
                </div>
                
                <div class="form-group">
                    <label>Trạng thái:</label>
                    <select id="trangThaiTBP" name="trangThai" class="rounded-input">
                        <option value="Tốt">Tốt</option>
                        <option value="Hỏng">Hỏng</option>
                        <option value="Bảo trì">Bảo trì</option>
                    </select>
                </div>
            </div>

            <div class="modal-footer">
                <button type="submit" class="btn-swing btn-primary">Lưu</button>
                <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalTBP')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<script>
function openTBPForm(action, row_dataset) {
    const frm = document.getElementById('frmTBP');
    frm.reset();
    document.getElementById('tbpAction').value = action;
    
    if (action === 'update' && row_dataset) {
        document.getElementById('maThietBiPhong').value = row_dataset.id;
        document.getElementById('maPhong').value = row_dataset.phongid;
        document.getElementById('maThietBi').value = row_dataset.tbid;
        document.getElementById('soLuong').value = row_dataset.soluong;
        document.getElementById('trangThaiTBP').value = row_dataset.trangthai;
    } else {
        document.getElementById('maThietBiPhong').value = '';
    }
    
    openModal('modalTBP');
}
</script>
