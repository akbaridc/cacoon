const deleteDatatable = () => {
    return {
        onDelete(){
            const url = this.$refs.buttonDelete.getAttribute('data-href');
            dispatchConfirmDialog({
                title: 'Remove this data?',
                message: 'This data will be permanently deleted.',
                confirmText: 'Yes, Sure',
                onConfirm: () => {
                    axios.delete(url, this.dataUser, {
                        headers: {
                            'Content-Type': 'application/json',
                        }
                    })
                    .then(response => {
                        if(response?.data.status){
                            toast(response?.data.message, "success")
                            $("#datatable").DataTable().ajax.reload();
                        } else {
                            toast(response?.data.message, "error")
                            return false;
                        }
                    })
                    .catch(error => {
                        if (error.response && error.response.data && error.response.data.message) {
                            toast(error.response.data.message, 'error');
                        } else {
                            errorCustom.errorCatchAxios(error.status);
                        }
                        return false;
                    })

                }
            })
        },
    }
}

export { deleteDatatable }
