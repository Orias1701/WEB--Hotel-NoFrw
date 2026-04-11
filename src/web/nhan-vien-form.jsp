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
                        <input type="text" id="maNhanVien" name="maNhanVien" class="rounded-input" readonly
                            style="background-color: #f0f0f0;" placeholder="Tự động tạo">
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

                <div id="accountSection" style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee;">
                    <label
                        style="font-weight: bold; color: var(--color-primary); display: block; margin-bottom: 15px;">DANH
                        SÁCH TÀI KHOẢN LIÊN KẾT</label>
                    <div id="accountListContainer"
                        style="display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 15px;">
                        <!-- Accounts will be appended here via JS -->
                    </div>
                    <div id="noAccountMsg" style="color: #888; font-style: italic; display: none;">Chưa có tài khoản nào
                        liên kết.</div>
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

                // Populate accounts
                const accountsStr = row_dataset.accounts;
                if (accountsStr && accountsStr.trim() !== '') {
                    const accounts = accountsStr.split(',');
                    accounts.forEach(acc => {
                        const parts = acc.split('|');
                        if (parts.length === 4) {
                            const accDiv = document.createElement('div');
                            accDiv.className = 'info-card';
                            accDiv.style.padding = '15px';
                            accDiv.style.background = '#f9f9f9';
                            accDiv.style.border = '1px solid #eee';
                            accDiv.style.borderRadius = '8px';
                            accDiv.style.boxShadow = '0 2px 4px rgba(0,0,0,0.05)';

                            accDiv.innerHTML =
                                '<div style="font-size: 13px; color: #666; margin-bottom: 12px;">🔖 Vai trò: <span style="color: var(--color-primary); font-weight: bold;">' + parts[2] + '</span></div>' +
                                '<div style="display: flex; flex-direction: column; gap: 5px; margin-bottom: 10px;">' +
                                '<label style="font-size: 11px; color: #888;">Tên tài khoản:</label>' +
                                '<input type="text" name="acc_user_' + parts[0] + '" value="' + parts[1] + '" class="rounded-input" style="width: 90%; padding: 5px 10px; font-size: 13px;">' +
                                '</div>' +
                                '<div style="display: flex; flex-direction: column; gap: 5px;">' +
                                '<label style="font-size: 11px; color: #888;">Mật khẩu:</label>' +
                                '<input type="password" name="acc_pass_' + parts[0] + '" value="' + parts[3] + '" class="rounded-input" style="width: 90%; padding: 5px 10px; font-size: 13px;">' +
                                '</div>';
                            container.appendChild(accDiv);
                        }
                    });
                } else {
                    document.getElementById('noAccountMsg').style.display = 'block';
                }
            } else {
                document.getElementById('maNhanVien').value = '';
            }

            openModal('modalNV');
        }
    </script>