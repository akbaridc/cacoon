const vesselData = () => {
    return {
        onSync() {
            dispatchConfirmDialog({
                title: 'Syncronize vessel',
                message: 'Are you sure want to syncronize vessel?',
                confirmText: 'Yes, Syncronize',
                confirmClass: 'btn-primary',
                onConfirm: () => {
                    axios.get('vessel/sync', {
                        headers: {
                            'Content-Type': 'application/json',
                        }
                    })
                    .then(response => {
                        if(response?.data.status){
                            toast(response?.data.message, "success");
                            setTimeout(() => window.location.reload(), 2000)
                        } else {
                            toast(response?.data.message, "error");
                        }
                    })
                    .catch(error => {
                        console.error(error)
                        errorCustom.setCatchError(error);
                    });
                }
            })
        },
    }
}

export { vesselData }
