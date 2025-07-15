import "toastify-js/src/toastify.css"
import Toastify from 'toastify-js'

const setNotification = (message = 'Success!', type = 'success') => {
    const config = {
        success: {
            icon: '<i class="fas fa-check-circle"></i>',
            background: "#22c55e"
        },
        error: {
            icon: '<i class="fas fa-times-circle"></i>',
            background: "#ef4444"
        },
        warning: {
            icon: '<i class="fas fa-exclamation-circle"></i>',
            background: "#facc15"
        },
        info: {
            icon: '<i class="fas fa-info-circle"></i>',
            background: "#3b82f6"
        }
    };

    const toast = config[type] || config.info;

    Toastify({
        text: `<span style="display:flex;align-items:center;gap:0.5rem;align-items:center">${toast.icon}<span>${message}</span></span>`,
        duration: 3000,
        gravity: "top",
        position: "center",
        stopOnFocus: true,
        escapeMarkup: false,
        style: {
            background: toast.background,
            borderRadius: "0.5rem",
            padding: "0.75rem 1rem"
        }
    }).showToast();
}

export default setNotification;
