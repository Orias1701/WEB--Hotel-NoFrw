<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <!-- Modal Overlay for KhachHang Form -->
    <div id="modalKH" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                Dữ liệu chi tiết Khách hàng
            </div>

            <form id="frmKH" action="khach-hang-data" method="post" onsubmit="return validateKHForm(event)">
                <input type="hidden" id="khAction" name="action" value="add">

                <div class="modal-form-grid">
                    <div class="form-group full-width">
                        <label>ID:</label>
                        <input type="text" id="maKhachHang" name="maKhachHang" class="rounded-input bg-readonly" readonly
                            placeholder="Tự động tạo">
                    </div>

                    <div class="form-group">
                        <label>Tên khách hàng:</label>
                        <input type="text" id="tenKhachHang" name="tenKhachHang" class="rounded-input" required>
                    </div>

                    <div class="form-group">
                        <label>Số điện thoại:</label>
                        <input type="text" id="khSoDienThoai" name="soDienThoai" class="rounded-input" required>
                    </div>

                    <div class="form-group full-width">
                        <label>Email:</label>
                        <input type="email" id="khEmail" name="email" class="rounded-input">
                    </div>
                </div>

                <div class="modal-footer flex-between w-full">
                    <div>
                        <button type="button" id="btnDeleteKH" class="btn-swing btn-danger" style="display: none;"
                            onclick="confirmDeleteKH()">Xóa</button>
                    </div>
                    <div class="flex-gap-10">
                        <button type="submit" class="btn-swing btn-primary">Lưu</button>
                        <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalKH')">Hủy</button>
                    </div>
                </div>
            </form>

            <!-- Hidden Delete Form -->
            <form id="frmDelKH" action="khach-hang-data" method="post" style="display:none;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="delMaKH" name="maKhachHang">
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
                document.getElementById('khSoDienThoai').value = row_dataset.sdt;
                document.getElementById('khEmail').value = row_dataset.email;

                document.getElementById('btnDeleteKH').style.display = 'block';
                document.getElementById('delMaKH').value = row_dataset.id;
            } else {
                document.getElementById('maKhachHang').value = '';
                document.getElementById('btnDeleteKH').style.display = 'none';
            }

            openModal('modalKH');
        }

        function confirmDeleteKH() {
            const id = document.getElementById('delMaKH').value;
            if (confirm('Bạn có chắc chắn muốn xóa khách hàng #' + id + '?')) {
                document.getElementById('frmDelKH').submit();
            }
        }

        async function validateKHForm(event) {
            event.preventDefault(); // Stop default submit temporarily
            
            const form = event.target;
            const phone = document.getElementById('khSoDienThoai').value;
            const email = document.getElementById('khEmail').value;
            const id = document.getElementById('maKhachHang').value || "0";
            
            try {
                // Encode params to safely handle special chars
                const query = "type=khachhang&id=" + id + "&phone=" + encodeURIComponent(phone) + "&email=" + encodeURIComponent(email);
                const response = await fetch('check-duplicate?' + query);
                const data = await response.json();
                
                if (data.isDuplicate) {
                    alert(data.message); // Inform user, do not submit
                } else {
                    form.submit(); // Valid! Proceed with standard form submit to Servlet
                }
            } catch (err) {
                console.error("Validation error:", err);
                alert("Lỗi kiểm tra thông tin. Vui lòng thử lại!");
            }
            
            return false;
        }
    </script>