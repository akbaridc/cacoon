let confirmCallback = null;

const showConfirmDialog = ({ title = 'Konfirmasi', message = 'Apakah kamu yakin?', confirmText = 'Ya', confirmClass = 'btn-danger', onConfirm = null }) => {
    document.getElementById('confirmDialogTitle').textContent = title;
    document.getElementById('confirmDialogMessage').innerHTML = message;
    document.getElementById('confirmDialogButton').textContent = confirmText;

    document.getElementById('confirmDialogButton').classList = 'btn';
    document.getElementById('confirmDialogButton').classList.add('btn', confirmClass);

    confirmCallback = onConfirm;

    document.getElementById('confirmDialog').classList.remove('d-none');
    document.getElementById('confirmDialogOverlay').style.display = 'block';
}


const  hideConfirmDialog = () => {
    document.getElementById('confirmDialog').classList.add('d-none');
    document.getElementById('confirmDialogOverlay').style.display = 'none';
    confirmCallback = null;
}

// Pastikan DOM sudah selesai dimuat sebelum menambahkan event listener
document.addEventListener('DOMContentLoaded', function() {
    const cancelDialogButton = document.getElementById('cancelDialogButton');
    const confirmDialogButton = document.getElementById('confirmDialogButton');
    if (cancelDialogButton) {
        document.getElementById('cancelDialogButton').addEventListener('click', hideConfirmDialog);
    }

    if(confirmDialogButton){
        document.getElementById('confirmDialogButton').addEventListener('click', () => {
            if (typeof confirmCallback === 'function') {
                // Eksekusi callback dan dapatkan return value-nya
                const shouldClose = confirmCallback();

                // Jika return value adalah undefined atau true, tutup dialog
                if (shouldClose === undefined || shouldClose === true) {
                    hideConfirmDialog();
                }
                // Jika return value false, biarkan dialog tetap terbuka
            } else {
                hideConfirmDialog();
            }
        });
    }
});

export { showConfirmDialog, hideConfirmDialog };
