const loginForm = () => {
    return {
        payload: {
            email: '',
            password: '',
            remember: false,
        },
        login(event){
            event.preventDefault();
            let error = 0;

            ['required', 'email'].forEach((rule) => {
                if (rule === 'required' && !this.payload.email) {
                    errorCustom.errorInput('#email', 'Email is required', true);
                    error++;
                } else if (rule === 'email' && this.payload.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.payload.email)) {
                    errorCustom.errorInput('#email', 'Invalid email format', true);
                    error++;
                }
            });

            if (!this.payload.password) {
                errorCustom.errorInput('#password', 'Password is required', !this.payload.password);
                error++;
            }

           if(error > 0) return;

            axios.post('/login', this.payload, {
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => {
                toast(response.data.message, 'success');
                setTimeout(() => {
                    window.location.href = baseUrl + '/dashboard';
                }, 1300);
            })
            .catch(error => {
                if (error.response && error.response.data && error.response.data.message) {
                    toast(error.response.data.message, 'error');
                } else {
                    errorCustom.errorCatchAxios(error.status);
                }
            });
        }
    }
}

export { loginForm }
