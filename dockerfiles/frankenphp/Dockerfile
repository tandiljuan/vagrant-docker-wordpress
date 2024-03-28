FROM dunglas/frankenphp:1.1.1-php8.2-bookworm

# Install PHP extensions needed by WordPress
# @see https://make.wordpress.org/hosting/handbook/handbook/server-environment/#php-extensions
RUN install-php-extensions \
    bcmath \
    exif \
    gd \
    intl \
    mysqli \
    zip \
    imagick \
    opcache
