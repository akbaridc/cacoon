import './bootstrap';
// import collapse from '@alpinejs/collapse';
import Alpine from 'alpinejs';
import setNotification from './lib/toastify';
import { customError } from './config/custom-error';
import { showConfirmDialog } from './config/dialog';

import { loginForm } from './authentication';
import { deleteDatatable } from './config/delete-datatable';
import { rolePermission } from './pages/settings/role-permission/index';

// Alpine.plugin(collapse)
Alpine.data("loginForm", loginForm);
Alpine.data("deleteDatatable", deleteDatatable);
Alpine.data("rolePermission", rolePermission);

window.toast = setNotification;
window.errorCustom = customError;
window.baseUrl = import.meta.env.VITE_APP_URL || 'http://127.0.0.1:8000';

if (!window.Alpine) {
    window.Alpine = Alpine
    window.Alpine.start()
}

window.dispatchConfirmDialog = showConfirmDialog;
