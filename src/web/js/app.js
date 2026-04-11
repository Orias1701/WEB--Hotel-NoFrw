/**
 * Track the current active request to prevent race conditions
 */
let currentAbortController = null;

/**
 * Core AJAX Navigation Logic
 * Replicates the 'Panel Swapping' behavior of FrmMain.java
 */
function loadModule(moduleName, title) {
    console.log(`Loading module: ${moduleName}`);

    // If there's a pending request, cancel it
    if (currentAbortController) {
        currentAbortController.abort();
    }

    // Create a new controller for the current request
    currentAbortController = new AbortController();
    const { signal } = currentAbortController;

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
    fetch(`main?view=${moduleName}`, {
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
        signal: signal
    })
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.text();
        })
        .then(html => {
            // 1. Remove modals leftover from the PREVIOUS module
            document.querySelectorAll('.modal-overlay[data-module-modal]').forEach(m => m.remove());

            // 2. Inject new fragment
            const contentArea = document.getElementById('content-area');
            contentArea.innerHTML = html;

            // 3. Move ALL modal overlays OUT of content-area into document.body
            //    so that position:fixed covers the full viewport correctly
            contentArea.querySelectorAll('.modal-overlay').forEach(m => {
                m.style.display = 'none';
                m.setAttribute('data-module-modal', '1');
                document.body.appendChild(m);
            });

            // 4. Re-execute scripts from the injected fragment
            const scripts = contentArea.querySelectorAll('script');
            scripts.forEach(oldScript => {
                const newScript = document.createElement('script');
                Array.from(oldScript.attributes).forEach(attr => newScript.setAttribute(attr.name, attr.value));
                newScript.appendChild(document.createTextNode(oldScript.innerHTML));
                oldScript.parentNode.replaceChild(newScript, oldScript);
            });
        })
        .catch(error => {
            // Ignore abort errors
            if (error.name === 'AbortError') return;

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
    alert(message);
}

/**
 * Modal Handlers
 */
function openModal(id) {
    const el = document.getElementById(id);
    if (el) {
        el.style.display = 'flex';
        el.style.alignItems = 'center';
        el.style.justifyContent = 'center';
    }
}

function closeModal(id) {
    const el = document.getElementById(id);
    if (el) {
        el.style.display = 'none';
    }
}

/**
 * confirmDelete - show confirm dialog, then AJAX-check before submitting
 * @param {string} message   - confirmation message
 * @param {string} type      - entity type key for /check-delete (e.g. 'khachhang')
 * @param {number} id        - entity ID to check
 * @param {string} formId    - ID of hidden delete <form> to submit on confirm
 */
function confirmDelete(message, type, id, formId) {
    // Build or reuse the confirm modal
    let modal = document.getElementById('confirmDeleteModal');
    if (!modal) {
        modal = document.createElement('div');
        modal.id = 'confirmDeleteModal';
        modal.className = 'modal-overlay';
        modal.style.display = 'none';
        modal.innerHTML = `
            <div class="modal-content" style="min-width: 320px; max-width: 420px; text-align: center;">
                <h3 style="margin-bottom: 15px; color: var(--color-danger);">Xác nhận Xóa</h3>
                <p id="confirmMessage" style="margin-bottom: 10px; font-size: 15px;"></p>
                <p id="confirmError" style="color: var(--color-danger); font-size: 13px; margin-bottom: 15px; display:none;"></p>
                <div style="display: flex; justify-content: center; gap: 15px;">
                    <button id="btnConfirmDelete" class="btn-swing btn-danger" style="padding: 10px 20px;">Xóa</button>
                    <button class="btn-swing btn-secondary" onclick="closeModal('confirmDeleteModal')" style="padding: 10px 20px;">Hủy</button>
                </div>
            </div>
        `;
        document.body.appendChild(modal);
    }

    // Reset error state
    const errEl = document.getElementById('confirmError');
    errEl.style.display = 'none';
    errEl.innerText = '';

    document.getElementById('confirmMessage').innerText = message;

    // Wire up confirm button with AJAX check
    const btn = document.getElementById('btnConfirmDelete');
    btn.disabled = false;
    btn.innerText = 'Xóa';

    // Remove any previous onclick by cloning
    const newBtn = btn.cloneNode(true);
    btn.parentNode.replaceChild(newBtn, btn);

    newBtn.addEventListener('click', function () {
        newBtn.disabled = true;
        newBtn.innerText = 'Đang kiểm tra...';

        fetch(`check-delete?type=${encodeURIComponent(type)}&id=${encodeURIComponent(id)}`)
            .then(r => r.json())
            .then(data => {
                if (data.canDelete) {
                    // All clear — submit the delete form
                    document.getElementById(formId).submit();
                } else {
                    // Cannot delete — show inline error
                    newBtn.disabled = false;
                    newBtn.innerText = 'Xóa';
                    const errEl2 = document.getElementById('confirmError');
                    errEl2.innerText = data.message || 'Không thể xóa bản ghi này.';
                    errEl2.style.display = 'block';
                }
            })
            .catch(() => {
                newBtn.disabled = false;
                newBtn.innerText = 'Xóa';
                document.getElementById('confirmError').innerText = 'Lỗi kết nối, vui lòng thử lại.';
                document.getElementById('confirmError').style.display = 'block';
            });
    });

    openModal('confirmDeleteModal');
}
