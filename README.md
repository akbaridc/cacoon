# Cacoon Project

## Requirements

- PHP 8.2 or higher
- Composer
- PostgreSQL 13 or higher
- Node.js & NPM (for frontend assets)
- Mail server or Mailtrap account for email testing

## Installation

   ```bash
    bash setup.sh
   ```
   
   or


1. **Clone the repository and navigate to project directory**
   ```bash
   cd cacoon
   ```

2. **Install PHP dependencies**
   ```bash
   composer install
   ```

3. **Install NPM dependencies**
   ```bash
   npm install
   npm run build
   ```

4. **Configure environment**
   - Copy `.env.example` to `.env` if not already done
   - Update database credentials in `.env`:
     ```
     DB_CONNECTION=pgsql
     DB_HOST=127.0.0.1
     DB_PORT=5432
     DB_DATABASE=cacoon
     DB_USERNAME=postgres
     DB_PASSWORD=your_password
     ```
   - Configure mail settings for OTP:
     ```
     MAIL_MAILER=smtp
     MAIL_HOST=smtp.gmail.com
     MAIL_PORT=587
     MAIL_USERNAME=your_email
     MAIL_PASSWORD=your_password
     MAIL_ENCRYPTION=tls
     MAIL_FROM_ADDRESS=name_alias
     ```

5. **Create database**
   ```sql
   CREATE DATABASE cacoon;
   ```

6. **Run migrations**
   ```bash
   php artisan migrate
   ```

7. **Seed the database**
   ```bash
   php artisan db:seed
   ```

8. **Generate application key**
   ```bash
   php artisan key:generate
   ```

9. **Start the development server**
   ```bash
   php artisan serve
   ```

## Test Users

After running seeders, you can use these test accounts:

### Admin User
- Email: admin@gmail.com
- NIK: 1234567890
- Password: password (for web login)

### Regular User
- Email: akbar@gmail.com
- NIK: 0987654321
- Password: password (for web login)

### Inactive User (for testing)
- Email: inactive@gmail.com
- NIK: 1111111111
- This account will be rejected during login

## Web Admin Panel

Access the web admin panel at `http://localhost:8000`. Use the admin credentials above to login.

## License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
