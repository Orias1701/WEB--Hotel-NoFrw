<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="section-title">DASHBOARD - TỔNG QUAN HỆ THỐNG</div>

<div style="padding: 20px 25px;">
    <!-- Dashboard Cards Grid - mimicking PanelHome left column -->
    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px;">
        <!-- Card 1: Rooms Available -->
        <div class="dashboard-card card-blue" onclick="loadModule('phong', 'Phòng')">
            <div class="card-title">Đặt phòng</div>
            <div class="card-desc">Số phòng trống: ${countPhongTrong}</div>
            <span class="card-icon">🏨</span>
        </div>

        <!-- Card 2: Rooms Occupied -->
        <div class="dashboard-card card-red" onclick="loadModule('phong', 'Phòng')">
            <div class="card-title">Phòng</div>
            <div class="card-desc">Đang sử dụng: ${countPhongDangSuDung}</div>
            <span class="card-icon">🔑</span>
        </div>

        <!-- Card 3: Revenue -->
        <div class="dashboard-card card-green">
            <div class="card-title">Doanh thu tháng ${displayMonth}</div>
            <div class="card-desc">
                <fmt:formatNumber value="${currentRevenue}" type="currency" currencyCode="VND" />
            </div>
            <span class="card-icon">💰</span>
        </div>
        
        <!-- Card 4: Employees -->
        <div class="dashboard-card card-green" onclick="loadModule('nhan-vien', 'Nhân viên')">
            <div class="card-title">Nhân viên</div>
            <div class="card-desc">Tổng nhân viên: ${countNhanVien}</div>
            <span class="card-icon">👥</span>
        </div>

        <!-- Card 5: Customers -->
        <div class="dashboard-card card-green" onclick="loadModule('khach-hang', 'Khách hàng')">
            <div class="card-title">Khách hàng</div>
            <div class="card-desc">Tổng khách hàng: ${countKhachHang}</div>
            <span class="card-icon">🤝</span>
        </div>

        <!-- Card 6: Equipment -->
        <div class="dashboard-card card-green" onclick="loadModule('thiet-bi', 'Thiết bị')">
            <div class="card-title">Thiết bị</div>
            <div class="card-desc">Loại thiết bị: ${countThietBi}</div>
            <span class="card-icon">🛠️</span>
        </div>
    </div>

    <!-- Charts Container - mimicking PanelHome right column -->
    <div style="background: white; padding: 25px; border-radius: 20px; border: 1px solid var(--color-border); margin-top: 20px;">
        <h3 style="margin-bottom: 20px; color: var(--excel-green); text-align: center;">THỐNG KÊ HOẠT ĐỘNG</h3>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
            <div style="height: 300px;">
                <canvas id="bookingChart"></canvas>
            </div>
            <div style="height: 300px;">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>
    </div>
    <div id="chart-data" 
         data-labels="${chartLabels != null ? chartLabels : '[]'}"
         data-bookings="${chartBookingData != null ? chartBookingData : '[]'}"
         data-revenue="${chartRevenueData != null ? chartRevenueData : '[]'}">
    </div>
</div>

<!-- Add Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const dataEl = document.getElementById('chart-data');
        // Parse data from attributes (handling the single quotes correctly)
        // Replacing single quotes with double quotes for valid JSON if needed, 
        // but since Java created ['a','b'], we handle it.
        const labelsStr = dataEl.getAttribute('data-labels').replace(/'/g, '"');
        const labels = JSON.parse(labelsStr);
        const bookingData = JSON.parse(dataEl.getAttribute('data-bookings'));
        const revenueData = JSON.parse(dataEl.getAttribute('data-revenue')).map(v => v / 1000000);

        // 1. Booking Frequency Chart (Bar)
        new Chart(document.getElementById('bookingChart'), {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Lượt đặt phòng',
                    data: bookingData,
                    backgroundColor: 'rgba(100, 100, 255, 0.6)',
                    borderColor: 'rgb(100, 100, 255)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    title: { display: true, text: 'Tần Suất Đặt Phòng', font: { size: 16 } }
                }
            }
        });

        // 2. Revenue Chart (Line)
        new Chart(document.getElementById('revenueChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (Triệu VNĐ)',
                    data: revenueData,
                    borderColor: 'rgb(33, 115, 70)',
                    backgroundColor: 'rgba(33, 115, 70, 0.1)',
                    fill: true,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    title: { display: true, text: 'Doanh Thu Theo Tháng', font: { size: 16 } }
                },
                scales: {
                    y: { 
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) { return value + ' tr'; }
                        }
                    }
                }
            }
        });
    });
</script>
