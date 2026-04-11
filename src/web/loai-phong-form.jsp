<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <!-- Modal Overlay for LoaiPhong Form -->
    <div id="modalLP" class="modal-overlay">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                Dữ liệu chi tiết Loại phòng
            </div>

            <form id="frmLP" action="loai-phong-data" method="post">
                <input type="hidden" id="lpAction" name="action" value="add">

                <div class="modal-form-grid">
                    <div class="form-group full-width">
                        <label>ID:</label>
                        <input type="text" id="maLoaiPhong" name="maLoaiPhong" class="rounded-input" readonly
                            style="background-color: #f0f0f0;" placeholder="Tự động tạo">
                    </div>

                    <div class="form-group full-width">
                        <label>Tên loại phòng:</label>
                        <input type="text" id="tenLoaiPhong" name="tenLoaiPhong" class="rounded-input" required>
                    </div>

                    <div class="form-group full-width">
                        <label>Giá cơ bản (VND):</label>
                        <input type="number" id="giaCoBan" name="giaCoBan" class="rounded-input" required step="1000">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="submit" class="btn-swing btn-primary">Lưu</button>
                    <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalLP')">Hủy</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openLPForm(action, row_dataset) {
            const frm = document.getElementById('frmLP');
            frm.reset();
            document.getElementById('lpAction').value = action;

            if (action === 'update' && row_dataset) {
                document.getElementById('maLoaiPhong').value = row_dataset.id;
                document.getElementById('tenLoaiPhong').value = row_dataset.ten;
                document.getElementById('giaCoBan').value = row_dataset.gia;
            } else {
                document.getElementById('maLoaiPhong').value = '';
            }

            openModal('modalLP');
        }
    </script>