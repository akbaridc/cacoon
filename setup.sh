echo "========================================"
echo "Cacoon"
echo "========================================"
echo

echo "Installing PHP dependencies..."
composer install
if [ $? -ne 0 ]; then
    echo "Error: Failed to install PHP dependencies"
    exit 1
fi

echo
echo "Installing NPM dependencies..."
npm install
if [ $? -ne 0 ]; then
    echo "Error: Failed to install NPM dependencies"
    exit 1
fi

echo
echo "Building..."
npm run build
if [ $? -ne 0 ]; then
    echo "Error: Failed to build"
    exit 1
fi

echo
echo "Copying env/.env-dev.copy to .env..."
cp env/.env-dev.copy .env
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy env/.env-dev.copy to .env"
    exit 1
fi

echo
echo "Generating application key..."
php artisan key:generate
if [ $? -ne 0 ]; then
    echo "Error: Failed to generate application key"
    exit 1
fi

echo
echo "Linked storage..."
php artisan storage:link
if [ $? -ne 0 ]; then
    echo "Error: Failed to link storage"
    exit 1
fi

echo
echo "========================================"
echo "Setup completed successfully!"
echo "========================================"
echo
echo "Next steps:"
echo "1. Create a PostgreSQL database"
echo "2. Update the .env file with your database credentials"
echo "3. Run 'php artisan migrate' to create database tables"
echo "4. Run 'php artisan db:seed' to seed the database"
echo "5. Run 'php artisan serve && npm run dev' to start the development server"
echo
