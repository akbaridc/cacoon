<style>
    #confirmDialogOverlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 9998;
        display: none;
    }

    #confirmDialog {
        width: 40vw;
        height: fit-content;
        z-index: 9999;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
    }

    #confirmDialogTitle {
        font-size: 1.5rem
    }

    /* xs */
    @media (max-width: 575px) {
        #confirmDialog {
            width: calc(100% - 50px);
        }
    }

    /* sm */
    @media (min-width: 576px) {
        #confirmDialog {
            width: calc(100% - 50px);
        }
    }

    /* md */
    @media (min-width: 769px) {
        #confirmDialog {
            width: 40%;
        }
    }

    /* lg */
    @media (min-width: 992px) {
        #confirmDialog {
            width: 30%;
        }
    }

    /* xl */
    @media (min-width: 1200px) {
        #confirmDialog {
            width: 30%;
        }
    }
</style>

<!-- Overlay -->
<div id="confirmDialogOverlay" class="position-fixed"></div>

<!-- Dialog -->
<div id="confirmDialog" class="position-fixed d-none">
    <div class="d-flex justify-content-center align-items-center w-100 h-100">
        <div class="bg-white rounded-3 shadow-lg max-w-md w-100 p-4 space-y-4">
            <h2 id="confirmDialogTitle">Konfirmasi</h2>
            <p id="confirmDialogMessage">Apakah kamu yakin?</p>

            <div class="d-flex justify-content-end gap-3 pt-4">
                <button id="cancelDialogButton" class="btn btn-light">
                    Cancel
                </button>
                <button id="confirmDialogButton" class="btn btn-danger">
                    Ya
                </button>
            </div>
        </div>
    </div>
</div>
