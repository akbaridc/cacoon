import { validateEmail } from "../../../validation/regex";

const userForm = () => {
    return {
        init(){
            if(userData){
                const roleId = userData.roles[0].id;
                this.user.nik.value = userData.nik;
                this.user.name.value = userData.name;
                this.user.position_title.value = userData.position_title;
                this.user.email.value = userData.email;
                this.user.role.value = roleId;
                this.user.is_active.value = userData.is_active ? '1' : '0';
                this.user.access_mobile.value = userData.access_mobile ? '1' : '0';

                this.$refs.roleSelected.value = roleId;

                this.mode = 'edit';
            }
        },
        mode: 'create',
        user: {
            nik: {value: '', field: '#nik'},
            name: {value: '', field: '#name'},
            position_title: {value: '', field: '#position_title'},
            email: {value: '', field: '#email'},
            password: {value: '', field: '#password'},
            avatar: {value: null, field: '#avatar'},
            role: {value: '', field: '#role'},
            is_active: {value: '1', field: '.status'},
            access_mobile: {value: '1', field: '.access_mobile'},
        },
        maxSizeUpload: 1048000,
        onFileChange(event) {
            const file = event.target.files[0];
            if (file) {
                if (file.size > this.maxSizeUpload) {
                    toast('Avatar size must be less than 1MB', 'error');
                    this.$refs.avatarInput.value = '';
                    return;
                }
                this.user.avatar.value = file;
            } else {
                this.user.avatar.value = null;
            }
        },
        onRoleChange(event) {
            this.user.role.value = event.target.value;
        },
        onResetForm() {
            this.user = {
                nik: {value: '', field: '#nik'},
                name: {value: '', field: '#name'},
                position_title: {value: '', field: '#position_title'},
                email: {value: '', field: '#email'},
                password: {value: '', field: '#password'},
                avatar: {value: null, field: '#avatar'},
                role: {value: '', field: '#role'},
                is_active: {value: '1', field: '.status'},
                access_mobile: {value: '1', field: '.access_mobile'},
            };
            this.$refs.avatarInput.value = '';
            this.$refs.roleSelected.value = '';
        },
        onSaveUser() {
            let error = [];

            Object.values(this.user).forEach(data => errorCustom.clearErrorInput(data.field));

            if(this.user.nik.value === '') error.push({message: 'NIK is required',field: this.user.nik.field});
            if(this.user.name.value === '') error.push({message: 'Name is required',field: this.user.name.field});
            if(this.user.position_title.value === '') error.push({message: 'Position Title is required',field: this.user.position_title.field});
            if(this.user.email.value === '') error.push({message: 'Email is required',field: this.user.email.field});
            if(this.user.email.value && !validateEmail(this.user.email.value)) error.push({message: 'Invalid email format',field: this.user.email.field});
            if(this.mode == 'create' && this.user.password.value === '') error.push({message: 'Password is required',field: this.user.password.field});

            if(this.user.avatar.value && this.user.avatar.value.size > this.maxSizeUpload) error.push({message: 'Avatar size must be less than 1MB', field: this.user.avatar.field});

            if(this.user.role.value === '') error.push({message: 'Role is required',field: this.user.role.field});

            if(error.length > 0) {
                toast('you have a field error, please check', 'error');
                error.forEach(err => {
                    errorCustom.errorInput(err.field, err.message, true);
                });
                error = [];
                return;
            }

            const formData = new FormData();
            formData.append('nik', this.user.nik.value);
            formData.append('name', this.user.name.value);
            formData.append('position_title', this.user.position_title.value);
            formData.append('email', this.user.email.value);
            formData.append('password', this.user.password.value);
            formData.append('role', this.user.role.value);
            formData.append('is_active', parseInt(this.user.is_active.value));
            formData.append('access_mobile', parseInt(this.user.access_mobile.value));
            if (this.user.avatar.value) {
                formData.append('avatar', this.user.avatar.value);
            }

            const urlEndpoint = this.mode == 'edit' ? '/users/' + userData.id : '/users';
            if(this.mode == 'edit') formData.append('_method', 'PUT');

            axios.post(urlEndpoint, formData, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                },
            })
            .then(response => {
                toast(response.data.message, 'success');
                setTimeout(() => {
                    window.location.href = baseUrl + '/users';
                }, 1000);
            })
            .catch(error => {
                errorCustom.setCatchError(error);
            });

        },
    };
}


export { userForm }
