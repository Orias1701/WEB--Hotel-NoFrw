<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Modal Overlay for HoaDon Details -->
        <div id="modalHoaDon" class="modal-overlay">
            <div class="modal-content mw-600">
                <div class="modal-header">
                    Chi tiết Hóa đơn
                </div>

                <div class="modal-form-grid">
                    <!-- Row 1: Mã hóa đơn, Ngày tạo -->
                    <div class="form-group">
                        <label>Mã hóa đơn:</label>
                        <input type="text" id="hdMa" class="rounded-input bg-readonly" readonly>
                    </div>
                    <div class="form-group">
                        <label>Ngày tạo:</label>
                        <input type="text" id="hdNgayTao" class="rounded-input bg-readonly" readonly>
                    </div>

                    <!-- Row 2: Khách hàng, Nhân viên -->
                    <div class="form-group">
                        <label>Khách hàng:</label>
                        <input type="text" id="hdKhach" class="rounded-input bg-readonly" readonly>
                    </div>
                    <div class="form-group">
                        <label>Nhân viên thực hiện:</label>
                        <input type="text" id="hdNhanVien" class="rounded-input bg-readonly" readonly>
                    </div>

                    <!-- Section 3: Room Breakdown (Full Width) -->
                    <div class="form-group full-width">
                        <label class="text-bold">Danh sách phòng & Chi phí:</label>
                        <table class="bill-details-table">
                            <thead>
                                <tr>
                                    <th class="center_cell id_cell">ID</th>
                                    <th>Số phòng</th>
                                    <th class="currency-cell">Tiền phòng</th>
                                    <th class="currency-cell">Tiền phạt</th>
                                </tr>
                            </thead>
                            <tbody id="hdChiTietBody">
                                <!-- Dynamic rows here -->
                            </tbody>
                        </table>
                    </div>

                    <!-- Row 4: Tổng tiền, Ngày thanh toán -->
                    <div class="form-group">
                        <label>Tổng tiền:</label>
                        <input type="text" id="hdTongTien" class="rounded-input bg-readonly color-primary text-bold"
                            readonly>
                    </div>
                    <div class="form-group">
                        <label>Ngày thanh toán:</label>
                        <input type="text" id="hdNgayTT" class="rounded-input bg-readonly" readonly>
                    </div>
                </div>

                <div class="modal-footer flex-gap-10">
                    <!-- Print Action -->
                    <button type="button" id="btnInHD" class="btn-swing btn-primary" onclick="window.print()">In hóa
                        đơn</button>

                    <!-- Payment Action (Hidden/Shown via JS) -->
                    <form id="frmModalPayHD" action="hoa-don-data" method="post" style="display:none;">
                        <input type="hidden" name="action" value="pay">
                        <input type="hidden" id="modalPayMaHD" name="maHoaDon">
                    </form>
                    <button type="button" id="btnModalPay" class="btn-swing btn-warning" style="display: none;"
                        onclick="confirmModalPay();">Thanh toán</button>

                    <button type="button" class="btn-swing btn-secondary"
                        onclick="closeModal('modalHoaDon')">Đóng</button>
                </div>
            </div>
        </div>

        <script>
            function openHoaDonModal(dataset) {
                document.getElementById('hdMa').value = dataset.id;
                document.getElementById('hdKhach').value = dataset.tenkhach;
                document.getElementById('hdNhanVien').value = dataset.tennv || '';
                document.getElementById('hdNgayTao').value = dataset.ngaytao;
                document.getElementById('hdNgayTT').value = dataset.ngaytt || 'Ch thanh toán';
                document.getElementById('hdTongTien').value = new Intl.NumberFormat('vi-VN').format(dataset.tongtien) + ' VNĐ';

                // Render Chi Tiet Room List
                const body = document.getElementById('hdChiTietBody');
                body.innerHTML = '';
                try {
                    const details = JSON.parse(dataset.details);
                    if (details && details.length > 0) {
                        details.forEach(item => {
                            const row = document.createElement('tr');
                            row.innerHTML = `
                                <td class="center_cell id_cell">\${item.id}</td>
                                <td>\${item.soPhong}</td>
                                <td class="currency-cell">\${new Intl.NumberFormat('vi-VN').format(item.tienPhong)} VNĐ</td>
                                <td class="currency-cell">\${new Intl.NumberFormat('vi-VN').format(item.tienPhat)} VNĐ</td>
                            `;
                            body.appendChild(row);
                        });
                    } else {
                        body.innerHTML = '<tr><td colspan="3" style="text-align:center">Không có dữ liệu phòng</td></tr>';
                    }
                } catch(e) {
                    console.error("Error parsing invoice details:", e);
                    body.innerHTML = '<tr><td colspan="3" style="text-align:center; color:red">Lỗi tải dữ liệu phòng</td></tr>';
                }

                // Handle Buttons Visibility
                const isPaid = (dataset.trangthai === 'Đã thanh toán');
                document.getElementById('btnModalPay').style.display = isPaid ? 'none' : 'block';
                document.getElementById('btnInHD').style.display = isPaid ? 'block' : 'none';

                if (!isPaid) {
                    document.getElementById('modalPayMaHD').value = dataset.id;
                } else {
                    document.getElementById('modalPayMaHD').value = '';
                }

                openModal('modalHoaDon');
            }

            async function confirmModalPay() {
                const id = document.getElementById('modalPayMaHD').value;
                if (confirm('Xác nhận thanh toán hóa đơn #' + id + '?')) {
                    const form = document.getElementById('frmModalPayHD');
                    const formData = new FormData(form);
                    await fetch(form.getAttribute('action'), {
                        method: form.getAttribute('method') || 'POST',
                        body: new URLSearchParams(formData)
                    });
                    closeModal(form.closest('.modal-overlay').id);
                    loadModule('hoa-don', 'Hóa đơn');
                }
            }
        </script>