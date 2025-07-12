@echo off
echo ========================================
echo Cacoon
echo ========================================
echo.

echo Installing PHP dependencies...
call composer install
if %errorlevel% neq 0 (
    echo Error: Failed to install PHP dependencies
    pause
    exit /b %errorlevel%
)

echo.
echo Installing NPM dependencies...
call npm install
if %errorlevel% neq 0 (
    echo Error: Failed to install NPM dependencies
    pause
    exit /b %errorlevel%
)

echo.
echo Building frontend assets...
call npm run build
if %errorlevel% neq 0 (
    echo Error: Failed to build frontend assets
    pause
    exit /b %errorlevel%
)

echo.
echo Generating application key...
call php artisan key:generate
if %errorlevel% neq 0 (
    echo Error: Failed to generate application key
    pause
    exit /b %errorlevel%
)

echo.
echo ========================================
echo Setup completed successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Create a PostgreSQL database named 'laravel_otp_api'
echo 2. Update the .env file with your database credentials
echo 3. Run 'php artisan migrate' to create database tables
echo 4. Run 'php artisan db:seed' to seed the database
echo 5. Run 'php artisan serve && npm run dev' to start the development server
echo.
pause
