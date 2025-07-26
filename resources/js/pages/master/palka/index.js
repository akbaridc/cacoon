const palkaData = () => {
    return {
        action: 'palka',
        mode: 'create',
        palkaId: '',
        showModal: false,
        modalTitle: 'Add Palka',
        payload: {
            palka: {value: '', field: '#palka'},
            status: {value: '1', field: '.status'},
        },
        clearField(){
            this.action = 'palka';
            this.mode = 'create';
            this.palkaId = '';
            this.payload.palka.value = '';
            this.payload.status.value = '1';
        },
        onSubmit(event){
            event.preventDefault();
            event.target.disabled = true;
            let error = [];

            Object.values(this.payload).forEach(data => errorCustom.clearErrorInput(data.field));

            if(this.payload.palka.value === '') error.push({message: 'Name is required',field: "#palka"});

            if(error.length > 0) {
                toast('you have a field error, please check', 'error');
                error.forEach(err => {
                    errorCustom.errorInput(err.field, err.message, true);
                });
                error = [];
                return;
            }

            const mappingPayload = {
                name: this.payload.palka.value,
                status: this.payload.status.value,
            }

            dispatchConfirmDialog({
                title: 'Submit data',
                message: 'data is correct?',
                confirmText: 'Yes, Submit',
                confirmClass: 'btn-primary',
                onConfirm: async () => {
                    try {
                        event.target.disabled = true;

                        const headers = {
                            'Content-Type': 'application/json',
                        };

                        const axiosMethod = this.mode === 'create' ? axios.post : axios.put;

                        const response = await axiosMethod(this.action, mappingPayload, { headers });

                        if (response?.data?.status) {
                            toast(response.data.message, "success");
                            this.showModal = false;
                            this.clearField();
                            $('#datatable').DataTable().ajax.reload(null, false);
                        } else {
                            toast(response.data.message || "Something went wrong", "error");
                        }
                    } catch (error) {
                        console.error(error);
                        errorCustom.setCatchError(error);
                    } finally {
                        hideConfirmDialog()
                        event.target.disabled = false;
                    }
                }
            })
        }
    }
}

export { palkaData }
