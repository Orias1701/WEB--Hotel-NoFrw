/**
 * Core AJAX Navigation Logic
 * Replicates the 'Panel Swapping' behavior of FrmMain.java
 */
function loadModule(moduleName, title) {
    console.log(`Loading module: ${moduleName}`);

    // Update active state in sidebar
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => {
        item.classList.remove('active');
        if (item.innerText === title) {
            item.classList.add('active');
        }
    });

    // Update Browser title
    document.title = `Hệ Thống Quản Lý Khách Sạn - ${title}`;

    // AJAX request to MainServlet
    fetch(`main?view=${moduleName}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.text();
        })
        .then(html => {
            // Inject fragment into content area
            document.getElementById('content-area').innerHTML = html;
        })
        .catch(error => {
            console.error('Error loading module:', error);
            document.getElementById('content-area').innerHTML = `
                <div style="padding: 25px; color: var(--color-danger);">
                    <h3>Lỗi!</h3>
                    <p>Không thể tải module này. Vui lòng thử lại sau.</p>
                </div>
            `;
        });
}

/**
 * Global helpers for forms
 */
function showAlert(message, type = 'info') {
    alert(message); // standard alert for now to mimic JOptionPane
}
