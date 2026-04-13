<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <!-- Modal Overlay for LoaiPhong Form -->
    <div id="modalLP" class="modal-overlay">
        <div class="modal-content mw-600">
            <div class="modal-header">
                Dữ liệu chi tiết Loại phòng
            </div>

            <form id="frmLP" action="loai-phong-data" method="post" onsubmit="return submitLPForm(event)">
                <input type="hidden" id="lpAction" name="action" value="add">

                <div class="modal-form-grid">
                    <div class="form-group full-width">
                        <label>ID:</label>
                        <input type="text" id="maLoaiPhong" name="maLoaiPhong" class="rounded-input bg-readonly" readonly
                            placeholder="Tự động tạo">
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

                <div class="modal-footer flex-between w-full">
                    <div>
                        <button type="button" id="btnDeleteLP" class="btn-swing btn-danger" style="display: none;"
                            onclick="confirmDeleteLP()">Xóa</button>
                    </div>
                    <div class="flex-gap-10">
                        <button type="submit" class="btn-swing btn-primary">Lưu</button>
                        <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalLP')">Hủy</button>
                    </div>
                </div>
            </form>

            <!-- Hidden Delete Form -->
            <form id="frmDelLP" action="loai-phong-data" method="post" style="display:none;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="delMaLP" name="maLoaiPhong">
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

                document.getElementById('btnDeleteLP').style.display = 'block';
                document.getElementById('delMaLP').value = row_dataset.id;
            } else {
                document.getElementById('maLoaiPhong').value = '';
                document.getElementById('btnDeleteLP').style.display = 'none';
            }

            openModal('modalLP');
        }

        async function confirmDeleteLP() {
            const id = document.getElementById('delMaLP').value;
            if (confirm('Bạn có chắc chắn muốn xóa Loại phòng #' + id + '?')) {
                const form = document.getElementById('frmDelLP');
                const formData = new FormData(form);
                await fetch(form.getAttribute('action'), {
                    method: form.getAttribute('method') || 'POST',
                    body: new URLSearchParams(formData)
                });
                closeModal('modalLP');
                loadModule('loai-phong', 'Loại phòng');
            }
        }

        async function submitLPForm(event) {
            event.preventDefault();
            const form = event.target;
            const formData = new FormData(form);
            await fetch(form.getAttribute('action'), {
                method: form.getAttribute('method') || 'POST',
                body: new URLSearchParams(formData)
            });
            closeModal('modalLP');
            loadModule('loai-phong', 'Loại phòng');
            return false;
        }
    </script>