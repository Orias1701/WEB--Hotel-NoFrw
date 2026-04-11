<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <div class="section-title">DASHBOARD - TỔNG QUAN HỆ THỐNG</div>

            <style>
                .dashboard-grid {
                    display: grid;
                    grid-template-columns: repeat(5, 1fr);
                    grid-template-rows: repeat(4, 160px);
                    gap: 20px;
                    padding: 10px 25px;
                }

                .chart-container {
                    background: #fff;
                    border-radius: 15px;
                    border: 1px solid var(--color-border);
                    padding: 15px;
                    position: relative;
                }

                .btn-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    grid-template-rows: 1fr 1fr;
                    gap: 15px;
                }

                .dashboard-card {
                    height: 100%;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    text-align: center;
                    padding: 10px !important;
                }

                .card-title {
                    font-size: 14px !important;
                    margin-bottom: 5px !important;
                }

                .card-desc {
                    font-size: 18px !important;
                    font-weight: bold;
                }
            </style>

            <div class="dashboard-grid">
                <!-- Top Left: Revenue Bar Chart (2x3) -->
                <div class="chart-container" style="grid-column: 1 / 4; grid-row: 1 / 3;">
                    <canvas id="revenueChart"></canvas>
                </div>

                <!-- Top Right: Ratio Doughnut Chart (2x2) -->
                <div class="chart-container" style="grid-column: 4 / 6; grid-row: 1 / 3;">
                    <canvas id="ratioChart"></canvas>
                </div>

                <!-- Bottom Left: 4 Tiles (2x2) -->
                <div class="btn-grid" style="grid-column: 1 / 3; grid-row: 3 / 5;">
                    <div class="dashboard-card card-blue" onclick="loadModule('phong', 'Phòng')">
                        <div class="card-title">Phòng trống</div>
                        <div class="card-desc">${countPhongTrong}</div>
                    </div>
                    <div class="dashboard-card card-red" onclick="loadModule('phong', 'Phòng')">
                        <div class="card-title">Đang sử dụng</div>
                        <div class="card-desc">${countPhongDangSuDung}</div>
                    </div>
                    <div class="dashboard-card card-green" onclick="loadModule('nhan-vien', 'Nhân viên')">
                        <div class="card-title">Nhân viên</div>
                        <div class="card-desc">${countNhanVien}</div>
                    </div>
                    <div class="dashboard-card card-green" onclick="loadModule('khach-hang', 'Khách hàng')">
                        <div class="card-title">Khách hàng</div>
                        <div class="card-desc">${countKhachHang}</div>
                    </div>
                </div>

                <!-- Bottom Right: Booking Bar Chart (2x3) -->
                <div class="chart-container" style="grid-column: 3 / 6; grid-row: 3 / 5;">
                    <canvas id="bookingChart"></canvas>
                </div>
            </div>

            <!-- Hidden data containers to avoid JS linting errors and quote collisions -->
            <div id="data-store" style="display: none;">
                <div id="labels30-json">${labels30 != null ? labels30 : '[]'}</div>
                <div id="rev30-json">${dataRev30 != null ? dataRev30 : '[]'}</div>
                <div id="book30-json">${dataBook30 != null ? dataBook30 : '[]'}</div>
                <div id="labelsRatio-json">${labelsRatio != null ? labelsRatio : '[]'}</div>
                <div id="ratio-json">${dataRatio != null ? dataRatio : '[]'}</div>
            </div>

            <script>
                // This script runs immediately when injected by app.js
                (function () {
                    console.log("📊 [Dashboard] Bắt đầu khởi tạo biểu đồ...");

                    try {
                        const getJSON = (id) => {
                            const el = document.getElementById(id);
                            if (!el) return [];
                            try {
                                return JSON.parse(el.textContent.trim());
                            } catch (e) {
                                console.error(`❌ Lỗi parse JSON cho ${id}:`, e, "Nội dung:", el.textContent);
                                return [];
                            }
                        };

                        const labels30 = getJSON('labels30-json');
                        const dataRev30 = getJSON('rev30-json');
                        const dataBook30 = getJSON('book30-json');
                        const labelsRatio = getJSON('labelsRatio-json');
                        const dataRatio = getJSON('ratio-json');

                        console.log("📈 Labels (30 ngày):", labels30);
                        console.log("💰 Doanh thu:", dataRev30);
                        console.log("🎫 Đặt phòng:", dataBook30);

                        if (typeof Chart === 'undefined') {
                            console.error("❌ Lỗi: Thư viện Chart.js chưa được tải!");
                            return;
                        }

                        const chartOptions = {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: { display: false },
                                title: { display: true, font: { size: 14, weight: 'bold' }, color: '#333', padding: 10 }
                            }
                        };

                        // 1. Revenue Chart
                        const revCtx = document.getElementById('revenueChart');
                        if (revCtx) {
                            new Chart(revCtx, {
                                type: 'bar',
                                data: {
                                    labels: labels30,
                                    datasets: [{
                                        label: 'Doanh thu',
                                        data: dataRev30,
                                        backgroundColor: 'rgba(33, 115, 70, 0.7)',
                                        borderRadius: 5
                                    }]
                                },
                                options: {
                                    ...chartOptions,
                                    plugins: {
                                        ...chartOptions.plugins,
                                        title: { ...chartOptions.plugins.title, text: 'Doanh thu 30 ngày gần nhất (VNĐ)' }
                                    }
                                }
                            });
                        }

                        // 2. Booking Chart
                        const bookCtx = document.getElementById('bookingChart');
                        if (bookCtx) {
                            new Chart(bookCtx, {
                                type: 'bar',
                                data: {
                                    labels: labels30,
                                    datasets: [{
                                        label: 'Lượt đặt',
                                        data: dataBook30,
                                        backgroundColor: 'rgba(100, 100, 255, 0.7)',
                                        borderRadius: 5
                                    }]
                                },
                                options: {
                                    ...chartOptions,
                                    plugins: {
                                        ...chartOptions.plugins,
                                        title: { ...chartOptions.plugins.title, text: 'Lượt đặt phòng 30 ngày gần nhất' }
                                    }
                                }
                            });
                        }

                        // 3. Ratio Chart
                        const ratioCtx = document.getElementById('ratioChart');
                        if (ratioCtx) {
                            new Chart(ratioCtx, {
                                type: 'doughnut',
                                data: {
                                    labels: labelsRatio,
                                    datasets: [{
                                        data: dataRatio,
                                        backgroundColor: ['#217346', '#C0392B'],
                                        borderWidth: 2
                                    }]
                                },
                                options: {
                                    ...chartOptions,
                                    plugins: {
                                        ...chartOptions.plugins,
                                        legend: { display: true, position: 'bottom', labels: { boxWidth: 12, font: { size: 11 } } },
                                        title: { ...chartOptions.plugins.title, text: 'Tỷ lệ Tiền phòng / Tiền phạt' }
                                    },
                                    cutout: '60%'
                                }
                            });
                        }

                        console.log("✅ [Dashboard] Khởi tạo biểu đồ hoàn tất.");
                    } catch (err) {
                        console.error("❌ Lỗi nghiêm trọng khi khởi tạo Dashboard:", err);
                    }
                })();
            </script>