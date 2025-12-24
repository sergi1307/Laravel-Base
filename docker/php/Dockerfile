FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    git curl unzip zip libzip-dev libpng-dev \
    && docker-php-ext-install pdo_mysql zip gd \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY docker/php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY docker/php/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID app && \
    useradd -u $UID -g app -m app

WORKDIR /var/www
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
