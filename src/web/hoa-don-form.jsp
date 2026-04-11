<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Modal Overlay for HoaDon Details -->
        <div id="modalHoaDon" class="modal-overlay">
            <div class="modal-content" style="max-width: 600px;">
                <div class="modal-header">
                    Chi tiết Hóa đơn
                </div>

                <div class="modal-form-grid">
                    <div class="form-group">
                        <label>Mã hóa đơn:</label>
                        <input type="text" id="hdMa" class="rounded-input" readonly style="background-color: #f0f0f0;">
                    </div>
                    <div class="form-group">
                        <label>Khách hàng:</label>
                        <input type="text" id="hdKhach" class="rounded-input" readonly
                            style="background-color: #f0f0f0;">
                    </div>
                    <div class="form-group">
                        <label>Nhân viên thực hiện:</label>
                        <input type="text" id="hdNhanVien" class="rounded-input" readonly
                            style="background-color: #f0f0f0;">
                    </div>
                    <div class="form-group">
                        <label>Ngày tạo:</label>
                        <input type="text" id="hdNgayTao" class="rounded-input" readonly
                            style="background-color: #f0f0f0;">
                    </div>
                    <div class="form-group">
                        <label>Ngày thanh toán:</label>
                        <input type="text" id="hdNgayTT" class="rounded-input" readonly
                            style="background-color: #f0f0f0;">
                    </div>
                    <div class="form-group">
                        <label>Tổng tiền:</label>
                        <input type="text" id="hdTongTien" class="rounded-input" readonly
                            style="background-color: #f0f0f0; color: var(--color-primary); font-weight: bold;">
                    </div>
                </div>

                <div class="modal-footer" style="gap: 10px; justify-content: flex-end;">
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
                document.getElementById('hdNgayTT').value = dataset.ngaytt || 'Chưa thanh toán';
                document.getElementById('hdTongTien').value = new Intl.NumberFormat('vi-VN').format(dataset.tongtien) + ' VNĐ';

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

            function confirmModalPay() {
                const id = document.getElementById('modalPayMaHD').value;
                if (confirm('Xác nhận thanh toán hóa đơn #' + id + '?')) {
                    document.getElementById('frmModalPayHD').submit();
                }
            }
        </script>