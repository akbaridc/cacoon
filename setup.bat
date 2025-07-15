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
echo Building...
call npm run build
if %errorlevel% neq 0 (
    echo Error: Failed to build
    pause
    exit /b %errorlevel%
)

echo.
echo Copying env/.env-dev.copy to .env...
call cp env/.env-dev.copy .env
if %errorlevel% neq 0 (
    echo Error: Failed to copy env/.env-dev.copy to .env
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
echo Linked storage...
call php artisan storage:link
if %errorlevel% neq 0 (
    echo Error: Failed to link storage
    pause
    exit /b %errorlevel%
)

echo.
echo ========================================
echo Setup completed successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Create a PostgreSQL database
echo 2. Update the .env file with your database credentials
echo 3. Run 'php artisan migrate' to create database tables
echo 4. Run 'php artisan db:seed' to seed the database
echo 5. Run 'php artisan serve && npm run dev' to start the development server
echo.
pause
