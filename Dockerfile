# syntax=docker/dockerfile:1

# Pinned PHP + Alpine runtime base. Build tools are removed in this stage.
FROM php:8.4.26-cli-alpine3.23 AS runtime-base

WORKDIR /var/www/html

RUN apk add --no-cache oniguruma sqlite-libs \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        oniguruma-dev \
        sqlite-dev \
    && docker-php-ext-install -j"$(nproc)" mbstring pdo_sqlite \
    && apk del .build-deps

# Stage 1: install PHP dependencies and prepare the Laravel application.
FROM runtime-base AS builder

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apk add --no-cache unzip
COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

# Keep Composer dependency layers reusable after app-only changes.
COPY composer.json composer.lock ./
RUN composer install \
    --no-dev \
    --no-interaction \
    --no-progress \
    --no-scripts \
    --optimize-autoloader \
    --prefer-dist

COPY . .
RUN composer dump-autoload --no-dev --optimize

# Stage 2: only PHP runtime, production vendor and Laravel server files.
FROM runtime-base AS runtime

COPY --from=builder /var/www/html/app/ ./app/
COPY --from=builder /var/www/html/bootstrap/ ./bootstrap/
COPY --from=builder /var/www/html/config/ ./config/
COPY --from=builder /var/www/html/database/ ./database/
COPY --from=builder /var/www/html/public/ ./public/
COPY --from=builder /var/www/html/resources/views/ ./resources/views/
COPY --from=builder /var/www/html/routes/ ./routes/
COPY --from=builder /var/www/html/storage/ ./storage/
COPY --from=builder /var/www/html/vendor/ ./vendor/
COPY --from=builder /var/www/html/artisan ./artisan
COPY --from=builder /var/www/html/composer.json ./composer.json

# Root owns the code; the application user can write only runtime locations.
RUN mkdir -p \
        database \
        bootstrap/cache \
        storage/framework/cache/data \
        storage/framework/sessions \
        storage/framework/views \
        storage/logs \
    && touch database/database.sqlite \
    && chown -R www-data:www-data database bootstrap/cache storage

USER www-data

EXPOSE 8000

# Existing Laravel GET /health route must return a successful HTTP status.
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD php -r 'exit(@file_get_contents("http://127.0.0.1:8000/health") === false ? 1 : 0);'

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
