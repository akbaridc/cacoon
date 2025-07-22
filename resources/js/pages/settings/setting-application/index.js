const settingApplication = () => {
    return {
        editMode: false,
        payload: {
            id: null,
            application_name: '',
            email_send_provider: '',
            email_send_password_provider: '',
            email_receive_authentication: '',
        },
        onSubmit(event) {
            event.preventDefault();
            event.target.disabled = true;

            axios.post('setting-application', this.payload)
                .then(response => {
                    if(response?.data.status){
                        toast(response?.data.message, "success");
                        this.editMode = false;
                        this.payload = {
                            id: response?.data.data.id,
                            application_name: response?.data.data.application_name,
                            email_send_provider: response?.data.data.email_send_provider,
                            email_send_password_provider: response?.data.data.email_send_password_provider,
                            email_receive_authentication: response?.data.data.email_receive_authentication,
                        }
                    } else {
                        toast(response?.data.message, "error");
                    }
                })
                .catch(error => {
                    errorCustom.setCatchError(error);
                })
                .finally(() => {
                    event.target.disabled = false;
                });
        },
    }
}

export { settingApplication }
