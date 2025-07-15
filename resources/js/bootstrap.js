import axios from 'axios';

window.axios = axios;

window.axios.defaults.baseURL = import.meta.env.VITE_APP_URL || 'http://127.0.0.1:8000';
window.axios.defaults.withCredentials = true;

window.axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
