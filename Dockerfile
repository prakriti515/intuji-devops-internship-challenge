# Use PHP 8.2 with Apache
FROM php:8.2-apache

# Copy PHP app files (including index.php)
COPY . /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Enable mod_rewrite for Apache
RUN a2enmod rewrite

# Fix Apache directory permissions
RUN echo "<Directory /var/www/html/> \n\
    Options Indexes FollowSymLinks \n\
    AllowOverride All \n\
    Require all granted \n\
</Directory>" > /etc/apache2/conf-available/000-app-permissions.conf \
    && a2enconf 000-app-permissions

# Suppress server name warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Expose port 80 inside container
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]

