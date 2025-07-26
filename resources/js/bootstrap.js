import axios from 'axios';
import Selectr from 'mobius1-selectr';
import 'mobius1-selectr/dist/selectr.min.css';

window.axios = axios;

let activeRequests = 0;

// Disable semua button saat request berlangsung
function disableButtons(disabled = true) {
    document.querySelectorAll('button:not([data-axios-ignore])').forEach(btn => {
        btn.disabled = disabled;
    });
}

function toggleLoading(active = true) {
    const overlay = document.getElementById('global-loading-overlay');
    if (overlay) {
        overlay.classList.toggle('d-none', !active);
    }
}

window.axios.interceptors.request.use(config => {
    activeRequests++;
    disableButtons(true);
    toggleLoading(true);
    return config;
}, error => {
    toggleLoading(false);
    disableButtons(false);
    return Promise.reject(error);
});

window.axios.interceptors.response.use(response => {
    activeRequests--;
    if (activeRequests <= 0) {
        disableButtons(false);
        toggleLoading(false);
    }
    return response;
}, error => {
    activeRequests--;
    if (activeRequests <= 0) {
        disableButtons(false);
        toggleLoading(false);
    }
    return Promise.reject(error);
});

window.axios.defaults.baseURL = import.meta.env.VITE_APP_URL || 'http://127.0.0.1:8000';
window.axios.defaults.withCredentials = true;

window.axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.select-default').forEach(el => {
        new Selectr(el);
    });

    document.querySelectorAll('.select-multiple').forEach(el => {
        new Selectr(el, { multiple: true });
    });

    document.querySelectorAll('.select-tagable').forEach(el => {
        new Selectr(el, { taggable: true, tagSeperators: [",", "|"] });
    });
});

