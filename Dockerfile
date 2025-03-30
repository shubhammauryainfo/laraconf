# Use official PHP image with Apache and PHP 8.2
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    git \
    nano \
    && docker-php-ext-install pdo pdo_mysql zip intl opcache

# Enable Apache mod_rewrite for Laravel
RUN a2enmod rewrite

# Set working directory to /var/www/html
WORKDIR /var/www/html

# Copy the Laravel application to the container
COPY . .

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Set proper permissions for Laravel storage and cache
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Expose port 80 for the web server
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
