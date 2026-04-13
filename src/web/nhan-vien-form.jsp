<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <!-- Modal Overlay for NhanVien Form -->
    <div id="modalNV" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                Dữ liệu chi tiết Nhân viên
            </div>

            <form id="frmNV" action="nhan-vien-data" method="post" onsubmit="return validateNVForm(event)">
                <input type="hidden" id="nvAction" name="action" value="add">

                <div class="modal-form-grid">
                    <div class="form-group full-width">
                        <label>ID:</label>
                        <input type="text" id="maNhanVien" name="maNhanVien" class="rounded-input bg-readonly" readonly
                             placeholder="Tự động tạo">
                    </div>

                    <div class="form-group">
                        <label>Tên nhân viên:</label>
                        <input type="text" id="tenNhanVien" name="tenNhanVien" class="rounded-input" required>
                    </div>

                    <div class="form-group">
                        <label>Số điện thoại:</label>
                        <input type="text" id="nvSoDienThoai" name="soDienThoai" class="rounded-input" required>
                    </div>

                    <div class="form-group full-width">
                        <label>Email:</label>
                        <input type="email" id="nvEmail" name="email" class="rounded-input">
                    </div>
                </div>

                <div id="accountSection" class="account-section">
                    <label class="text-bold color-primary mb-10 w-full" style="display: block; margin-bottom: 15px;">DANH SÁCH TÀI KHOẢN LIÊN KẾT</label>
                    <div id="accountListContainer" class="account-grid">
                        <!-- Accounts will be appended here via JS -->
                    </div>
                    <div id="noAccountMsg" class="color-gray-888 italic" style="display: none;">Chưa có tài khoản nào
                        liên kết.</div>
                </div>

                <div class="modal-footer flex-between w-full">
                    <div>
                        <button type="button" id="btnDeleteNV" class="btn-swing btn-danger" style="display: none;"
                            onclick="confirmDeleteNV()">Xóa</button>
                    </div>
                    <div class="flex-gap-10">
                        <button type="submit" class="btn-swing btn-primary">Lưu</button>
                        <button type="button" class="btn-swing btn-secondary" onclick="closeModal('modalNV')">Hủy</button>
                    </div>
                </div>
            </form>

            <!-- Hidden Delete Form -->
            <form id="frmDelNV" action="nhan-vien-data" method="post" style="display:none;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="delMaNV" name="maNhanVien">
            </form>
        </div>
    </div>

    <script>
        function openNVForm(action, row_dataset) {
            const frm = document.getElementById('frmNV');
            frm.reset();
            document.getElementById('nvAction').value = action;

            // Reset account list
            const container = document.getElementById('accountListContainer');
            container.innerHTML = '';
            document.getElementById('noAccountMsg').style.display = 'none';
            document.getElementById('accountSection').style.display = (action === 'update') ? 'block' : 'none';

            if (action === 'update' && row_dataset) {
                document.getElementById('maNhanVien').value = row_dataset.id;
                document.getElementById('tenNhanVien').value = row_dataset.ten;
                document.getElementById('nvSoDienThoai').value = row_dataset.sdt;
                document.getElementById('nvEmail').value = row_dataset.email;

                document.getElementById('btnDeleteNV').style.display = 'block';
                document.getElementById('delMaNV').value = row_dataset.id;

                // Populate accounts
                const accountsStr = row_dataset.accounts;
                if (accountsStr && accountsStr.trim() !== '') {
                    const accounts = accountsStr.split(',');
                    accounts.forEach(acc => {
                        const parts = acc.split('|');
                        if (parts.length === 4) {
                            const accDiv = document.createElement('div');
                            accDiv.className = 'info-card';
                            
                            accDiv.innerHTML =
                                '<div class="font-size-13 color-gray-666 mb-10">🔖 Vai trò: <span class="color-primary text-bold">' + parts[2] + '</span></div>' +
                                '<div class="flex-column flex-gap-5 mb-10">' +
                                '<label class="font-size-11 color-gray-888">Tên tài khoản:</label>' +
                                '<input type="text" name="acc_user_' + parts[0] + '" value="' + parts[1] + '" class="rounded-input w-90 font-size-13" style="padding: 5px 10px;">' +
                                '</div>' +
                                '<div class="flex-column flex-gap-5">' +
                                '<label class="font-size-11 color-gray-888">Mật khẩu:</label>' +
                                '<input type="password" name="acc_pass_' + parts[0] + '" value="' + parts[3] + '" class="rounded-input w-90 font-size-13" style="padding: 5px 10px;">' +
                                '</div>';
                            container.appendChild(accDiv);
                        }
                    });
                } else {
                    document.getElementById('noAccountMsg').style.display = 'block';
                }
            } else {
                document.getElementById('maNhanVien').value = '';
                document.getElementById('btnDeleteNV').style.display = 'none';
            }

            openModal('modalNV');
        }

        function confirmDeleteNV() {
            const id = document.getElementById('delMaNV').value;
            if (confirm('Bạn có chắc chắn muốn xóa nhân viên #' + id + '?')) {
                document.getElementById('frmDelNV').submit();
            }
        }

        async function validateNVForm(event) {
            event.preventDefault(); // Stop default submit temporarily
            
            const form = event.target;
            const phone = document.getElementById('nvSoDienThoai').value;
            const email = document.getElementById('nvEmail').value;
            const id = document.getElementById('maNhanVien').value || "0";
            
            try {
                // Encode params to safely handle special chars like + in phone or @ in email
                const query = "type=nhanvien&id=" + id + "&phone=" + encodeURIComponent(phone) + "&email=" + encodeURIComponent(email);
                const response = await fetch('check-duplicate?' + query);
                const data = await response.json();
                
                if (data.isDuplicate) {
                    alert(data.message); // Inform user, do not submit, keep state identical
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