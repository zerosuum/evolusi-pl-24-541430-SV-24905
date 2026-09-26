#!/usr/bin/env bash

set -e

cd /var/www/aplikasi

# 1. masuk maintenance mode
php artisan down --retry=60

# 2. ambil kode terbaru
git pull origin main

# 3. pasang dependency production
composer install --no-dev --optimize-autoloader

# 4. jalankan migration
php artisan migrate --force

# 5. bangun ulang cache
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 6. restart queue worker
php artisan queue:restart

# 7. keluar dari maintenance mode
php artisan up
