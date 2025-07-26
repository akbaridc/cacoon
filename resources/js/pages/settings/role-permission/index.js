const rolePermission = () => {
    return {
        action: 'role-permission',
        mode: 'create',
        roleId: '',
        showModal: false,
        modalTitle: 'Add Role',
        payload: {
            role: '',
            permissions: [],
        },
        clearChecked(){
            document.querySelectorAll('.item-check').forEach(item => item.checked = false);
        },
        init() {
            this.$watch('roleId', (role_id) => {
                if (role_id) {
                    axios.get(`role-permission/${role_id}`, {
                        headers: {
                            'Content-Type': 'application/json',
                        }
                    })
                    .then(response => {
                        if(response?.data){
                            response.data.data.forEach(item => {
                                const element = document.querySelector(`.${item.replace('.', '-')}`);
                                setTimeout(() => {
                                    if(element) element.checked = true
                                }, 1500);
                            })
                        }
                    })
                }
            });
        },
        onSubmit(event) {
            event.preventDefault();

            this.payload.permissions = Array.from(document.querySelectorAll('.item-check')).filter(item => item.checked).map(item => item.value);

            if(!this.payload.role) return toast("Role is required", "error");

            if(this.mode === 'edit') this.payload._method = 'PUT';

            dispatchConfirmDialog({
                title: 'Submit data',
                message: 'data is correct?',
                confirmText: 'Yes, Submit',
                confirmClass: 'btn-primary',
                onConfirm: () => {
                    event.target.disabled = true;
                    axios.post(this.action, this.payload, {
                        headers: {
                            'Content-Type': 'application/json',
                        }
                    })
                    .then(response => {
                        if(response?.data.status){
                            toast(response?.data.message, "success");
                            this.showModal = false;
                            this.payload.role = '';
                            this.payload.permissions = [];
                            this.roleId = '';
                            this.clearChecked();
                            $('#datatable').DataTable().ajax.reload(null, false);
                        } else {
                            toast(response?.data.message, "error");
                        }
                    })
                    .catch(error => {
                        console.error(error)
                        errorCustom.setCatchError(error);
                    }).finally(() => {
                        event.target.disabled = false;
                    });
                }
            })
        }
    }
}

export { rolePermission }
