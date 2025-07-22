import axios from 'axios';
import Selectr from 'mobius1-selectr';
import 'mobius1-selectr/dist/selectr.min.css';

window.axios = axios;

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

