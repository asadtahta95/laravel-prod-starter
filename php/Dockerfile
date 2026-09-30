FROM php:8.3-fpm-alpine

RUN apk add --no-cache icu-dev libzip-dev oniguruma-dev freetype-dev libjpeg-turbo-dev libpng-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) pdo_mysql mbstring zip exif pcntl bcmath gd intl opcache \
  && apk add --no-cache --virtual .build-redis $PHPIZE_DEPS \
  && pecl install redis && docker-php-ext-enable redis \
  && apk del .build-redis && rm -rf /tmp/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

WORKDIR /var/www/html
RUN addgroup -g 1000 app && adduser -D -u 1000 -G app app \
  && chown -R app:app /var/www/html
USER app
