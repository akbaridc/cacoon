import './bootstrap';
// import collapse from '@alpinejs/collapse';
import Alpine from 'alpinejs';
import setNotification from './lib/toastify';
import { customError } from './config/custom-error';
import { showConfirmDialog, hideConfirmDialog } from './config/dialog';
import { deleteDatatable } from './config/delete-datatable';

//Module Authentication
import { loginForm } from './authentication';

//Module Master
import { userForm } from './pages/master/users/form';
import { vesselData } from './pages/master/vessel/index';
import { palkaData } from './pages/master/palka/index';

// Module Setting
import { rolePermission } from './pages/settings/role-permission/index';
import { settingApplication } from './pages/settings/setting-application';

// Alpine.plugin(collapse)
Alpine.data("loginForm", loginForm);
Alpine.data("deleteDatatable", deleteDatatable);
Alpine.data("userForm", userForm);
Alpine.data("rolePermission", rolePermission);
Alpine.data("settingApplication", settingApplication);
Alpine.data("vesselData", vesselData);
Alpine.data("palkaData", palkaData);

window.toast = setNotification;
window.errorCustom = customError;
window.baseUrl = import.meta.env.VITE_APP_URL || 'http://127.0.0.1:8000';

if (!window.Alpine) {
    window.Alpine = Alpine
    window.Alpine.start()
}

window.dispatchConfirmDialog = showConfirmDialog;
window.hideConfirmDialog = hideConfirmDialog;
