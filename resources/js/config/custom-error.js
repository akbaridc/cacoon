class CustomError {
    errorCatchAxios(status){
        let message = "";
        switch (status) {
            case 403:
                message = 'you don\'t have permission to access this action';
                break;
            default:
                message = 'Something went wrong';
                break;
        }

        return toast(message, "error")
    }

    errorInput(identifier, message, isError = true){
        const input = document.querySelector(identifier);
        if (input) {
            if(isError) {
                input.classList.add('is-invalid');
                const errorElement = document.createElement('div');
                errorElement.className = 'invalid-feedback';
                errorElement.textContent = message;
                // Remove any existing error message
                const existingError = input.parentNode.querySelector('.invalid-feedback');
                if (existingError) existingError.remove();
                // Append the new error message
                input.parentNode.appendChild(errorElement);
            } else {
                input.classList.remove('is-invalid');
                input.parentNode.querySelector('.invalid-feedback').remove();
            }

        }

    }

    clearErrorInput(identifier){
        const input = document.querySelector(identifier);
        if (input) {
            input.classList.remove('is-invalid');
            const errorElement = input.parentNode.querySelector('.invalid-feedback');
            if (errorElement) {
                errorElement.remove();
            }
        }
    }
}

const customError = new CustomError();
export { customError }
