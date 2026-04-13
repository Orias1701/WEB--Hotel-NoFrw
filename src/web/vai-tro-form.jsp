<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <!-- Modal Overlay for VaiTro Form -->
    <div id="modalVT" class="modal-overlay">
        <div class="modal-content mw-400">
            <div class="modal-header">
                Dữ liệu chi tiết Vai trò
            </div>

            <form id="frmVT" action="vai-tro-data" method="post" onsubmit="return submitVTForm(event)">
                <input type="hidden" id="vtAction" name="action" value="add">

                <div class="modal-form-grid">
                    <div class="form-group full-width">
                        <label>ID:</label>
                        <input type="text" id="maVaiTro" name="maVaiTro" class="rounded-input bg-readonly" readonly
                            placeholder="Tự động tạo">
                    </div>

                    <div class="form-group full-width">
                        <label>Tên vai trò:</label>
                        <input type="text" id="tenVaiTro" name="tenVaiTro" class="rounded-input" required>
                    </div>
                </div>

                <div class="modal-footer flex-between w-full">
                    <div>
                        <button type="button" id="btnDeleteVT" class="btn-swing btn-danger" style="display: none;"
                            onclick="confirmDeleteVT()">Xóa</button>
                    </div>
                    <div class="flex-gap-10">
                        <button type="submit" class="btn-swing btn-primary">Lưu</button>
                        <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalVT')">Hủy</button>
                    </div>
                </div>
            </form>

            <!-- Hidden Delete Form -->
            <form id="frmDelVT" action="vai-tro-data" method="post" style="display:none;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="delMaVT" name="maVaiTro">
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

                document.getElementById('btnDeleteVT').style.display = 'block';
                document.getElementById('delMaVT').value = row_dataset.id;
            } else {
                document.getElementById('maVaiTro').value = '';
                document.getElementById('btnDeleteVT').style.display = 'none';
            }

            openModal('modalVT');
        }

        async function confirmDeleteVT() {
            const id = document.getElementById('delMaVT').value;
            if (confirm('Bạn có chắc chắn muốn xóa vai trò #' + id + '?')) {
                const form = document.getElementById('frmDelVT');
                const formData = new FormData(form);
                await fetch(form.getAttribute('action'), {
                    method: form.getAttribute('method') || 'POST',
                    body: new URLSearchParams(formData)
                });
                closeModal('modalVT');
                loadModule('vai-tro', 'Vai trò');
            }
        }

        async function submitVTForm(event) {
            event.preventDefault();
            const form = event.target;
            const formData = new FormData(form);
            await fetch(form.getAttribute('action'), {
                method: form.getAttribute('method') || 'POST',
                body: new URLSearchParams(formData)
            });
            closeModal('modalVT');
            loadModule('vai-tro', 'Vai trò');
            return false;
        }
    </script>