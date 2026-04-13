<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!-- Modal Overlay for DatPhong Form (Thêm mới) -->
            <!-- Modal Overlay for DatPhong Form (Thêm mới) -->
            <div id="modalDatPhong" class="modal-overlay">
                <div class="modal-content mw-600">
                    <div class="modal-header">
                        Đặt phòng mới
                    </div>

                    <form id="frmDatPhong" action="dat-phong-data" method="post"
                        onsubmit="return validateDatPhongForm(event)">
                        <input type="hidden" id="dpAction" name="action" value="add">
                        <input type="hidden" id="maDatPhong" name="maDatPhong">

                        <div class="modal-form-grid">
                            <div class="form-group">
                                <label>Khách hàng:</label>
                                <select id="maKhachHang" name="maKhachHang" class="rounded-input" required>
                                    <c:forEach var="kh" items="${listKhachHang}">
                                        <option value="${kh.getMaKhachHang()}">${kh.getTenKhachHang()}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group full-width">
                                <label class="mb-10 w-full" style="display: block;">Chọn Phòng (Trống): <span
                                        class="font-size-11 color-gray-888" style="font-weight: normal;">(Tick chọn một
                                        hoặc
                                        nhiều phòng)</span></label>
                                <div id="roomChecklist" class="room-checklist-container">
                                    <c:forEach var="p" items="${listPhongTrong}">
                                        <label class="room-label-card">
                                            <input type="checkbox" name="maPhong" value="${p.getMaPhong()}">
                                            <span class="font-size-13 text-bold">Room ${p.getSoPhong()}</span>
                                        </label>
                                    </c:forEach>
                                    <c:if test="${empty listPhongTrong}">
                                        <div class="text-center color-gray-888 italic" style="grid-column: 1/-1;">Hết
                                            phòng trống</div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Ngày nhận phòng:</label>
                                <input type="datetime-local" id="ngayNhan" name="ngayNhan" class="rounded-input"
                                    required>
                            </div>

                            <div class="form-group">
                                <label>Ngày hẹn trả phòng:</label>
                                <input type="datetime-local" id="ngayHenTra" name="ngayHenTra" class="rounded-input"
                                    required>
                            </div>
                        </div>

                        <div class="modal-footer flex-gap-10">
                            <button type="submit" class="btn-swing btn-primary">Lưu</button>
                            <button type="button" class="btn-swing btn-secondary"
                                onclick="closeModal('modalDatPhong')">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal: Trả phòng (Sửa / Checkout) -->
            <div id="modalTraPhong" class="modal-overlay">
                <div class="modal-content mw-600">
                    <div class="modal-header">
                        Thông tin Đặt phòng
                    </div>

                    <div class="modal-form-grid">
                        <div class="form-group">
                            <label>Mã đặt phòng:</label>
                            <input type="text" id="viewMaDatPhong" class="rounded-input bg-readonly" readonly>
                        </div>
                        <div class="form-group">
                            <label>Khách hàng:</label>
                            <input type="text" id="viewTenKhach" class="rounded-input bg-readonly" readonly>
                        </div>
                        <div class="form-group">
                            <label>Nhân viên:</label>
                            <input type="text" id="viewTenNV" class="rounded-input bg-readonly" readonly>
                        </div>
                        <div class="form-group">
                            <label>Phòng:</label>
                            <input type="text" id="viewSoPhong" class="rounded-input bg-readonly" readonly>
                        </div>
                        <div class="form-group">
                            <label>Ngày nhận:</label>
                            <input type="text" id="viewNgayNhan" class="rounded-input bg-readonly" readonly>
                        </div>
                        <div class="form-group">
                            <label>Ngày hẹn trả:</label>
                            <input type="text" id="viewNgayHenTra" class="rounded-input bg-readonly" readonly>
                        </div>
                        <div class="form-group">
                            <label>Ngày trả:</label>
                            <input type="text" id="viewNgayTra" class="rounded-input bg-readonly" readonly>
                        </div>
                        <div class="form-group">
                            <label>Tiền phòng:</label>
                            <input type="text" id="viewTienPhong"
                                class="rounded-input bg-readonly color-primary text-bold" readonly>
                        </div>
                        <div class="form-group">
                            <label>Tiền phạt/Late fee:</label>
                            <input type="text" id="viewTienPhat"
                                class="rounded-input bg-readonly color-danger text-bold" readonly>
                        </div>
                    </div>

                    <div class="modal-footer flex-gap-10" style="flex-wrap: wrap;">
                        <!-- Checkout -->
                        <form id="frmCheckout" action="dat-phong-data" method="post" style="display:inline;" onsubmit="event.preventDefault(); submitSilent(this); return false;">
                            <input type="hidden" name="action" value="checkout">
                            <input type="hidden" id="checkoutId" name="maDatPhong">
                            <button type="submit" id="btnCheckout" class="btn-swing btn-warning">Trả phòng</button>
                        </form>
                        <button type="button" id="btnDaTra" class="btn-swing btn-primary"
                            style="display:none; pointer-events: none;">Đã trả</button>
                        <button type="button" id="btnDaHuy" class="btn-swing btn-danger"
                            style="display:none; pointer-events: none;">Đã hủy</button>

                        <!-- Delete (Hủy đặt) -->
                        <form id="frmDelDP" action="dat-phong-data" method="post" style="display:none;" onsubmit="return false">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" id="deleteId" name="maDatPhong">
                        </form>
                        <button type="button" class="btn-swing btn-danger" id="btnHuyDat"
                            onclick="if(confirm('Bạn có chắc chắn muốn hủy đơn đặt phòng này?')) { submitSilent(document.getElementById('frmDelDP')); }">Hủy
                            đặt</button>
                        <button type="button" class="btn-swing btn-secondary"
                            onclick="closeModal('modalTraPhong')">Đóng</button>
                    </div>
                </div>
            </div>

            <script>
                async function submitSilent(form) {
                    const formData = new FormData(form);
                    await fetch(form.getAttribute('action'), {
                        method: form.getAttribute('method') || 'POST',
                        body: new URLSearchParams(formData)
                    });
                    closeModal(form.closest('.modal-overlay').id);
                    loadModule('dat-phong', 'Đặt phòng');
                }
                function openDatPhongAdd() {
                    document.getElementById('frmDatPhong').reset();
                    document.getElementById('dpAction').value = 'add';
                    document.getElementById('maDatPhong').value = '';
                    openModal('modalDatPhong');
                }

                function openDatPhongView(row_dataset) {
                    document.getElementById('viewMaDatPhong').value = row_dataset.id;
                    document.getElementById('viewTenKhach').value = row_dataset.tenkhach || '';
                    document.getElementById('viewTenNV').value = row_dataset.tennv || '';
                    document.getElementById('viewSoPhong').value = row_dataset.sophong || '';
                    document.getElementById('viewNgayNhan').value = row_dataset.nhan || '';
                    document.getElementById('viewNgayHenTra').value = row_dataset.hentra || '';
                    document.getElementById('viewNgayTra').value = row_dataset.tra || 'Chưa trả';

                    const fmt = new Intl.NumberFormat('vi-VN');
                    document.getElementById('viewTienPhong').value = fmt.format(row_dataset.tienphong || 0) + ' VNĐ';
                    document.getElementById('viewTienPhat').value = fmt.format(row_dataset.tienphat || 0) + ' VNĐ';

                    document.getElementById('checkoutId').value = row_dataset.id;
                    document.getElementById('deleteId').value = row_dataset.id;

                    // Toggle Buttons based on status
                    const status = row_dataset.trangthai;

                    // Reset all
                    document.getElementById('frmCheckout').style.display = 'none';
                    document.getElementById('btnDaTra').style.display = 'none';
                    document.getElementById('btnDaHuy').style.display = 'none';
                    document.getElementById('btnHuyDat').style.display = 'none';

                    if (status === 'Chưa trả') {
                        document.getElementById('frmCheckout').style.display = 'inline';
                        document.getElementById('btnHuyDat').style.display = 'inline';
                    } else if (status === 'Đã trả') {
                        document.getElementById('btnDaTra').style.display = 'inline';
                    } else if (status === 'Đã hủy') {
                        document.getElementById('btnDaHuy').style.display = 'inline';
                    }

                    openModal('modalTraPhong');
                }

                function validateDatPhongForm(event) {
                    const ngayNhanStr = document.getElementById('ngayNhan').value;
                    const ngayHenTraStr = document.getElementById('ngayHenTra').value;

                    if (ngayNhanStr && ngayHenTraStr) {
                        const ngayNhan = new Date(ngayNhanStr);
                        const ngayHenTra = new Date(ngayHenTraStr);

                        const nowMinus1Hour = new Date();
                        nowMinus1Hour.setHours(nowMinus1Hour.getHours() - 1);

                        if (ngayNhan < nowMinus1Hour) {
                            alert("Thời gian nhận phòng không hợp lệ.\n(Phải lớn hơn hoặc bằng thời gian hiện tại)");
                            event.preventDefault();
                            return false;
                        }

                        if (ngayHenTra < ngayNhan) {
                            alert("Thời gian hẹn trả phòng không hợp lệ.\n(Phải lớn hơn hoặc bằng thời gian nhận phòng)");
                            event.preventDefault();
                            return false;
                        }

                        // Checkbox validation
                        const checkboxes = document.querySelectorAll('input[name="maPhong"]:checked');
                        if (checkboxes.length === 0) {
                            alert("Vui lòng chọn ít nhất một phòng trống.");
                            event.preventDefault();
                            return false;
                        }
                    }
                    
                    submitSilent(event.target);
                    return false;
                }
            </script>