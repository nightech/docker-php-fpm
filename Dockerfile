FROM php:7.0-fpm

RUN apt-get update

# Locale gen
RUN apt-get install -y --no-install-recommends locales && \
    cat /usr/share/i18n/SUPPORTED > /etc/locale.gen && \
    /usr/sbin/locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Logs
RUN mkdir -p /var/log/php/ && \
    ln -sf /dev/stdout /var/log/php/access.log && \
    ln -sf /dev/stderr /var/log/php/error.log

# Session Directory
RUN mkdir -p /var/lib/php/sessions && \
    chown -R www-data.www-data /var/lib/php/sessions

# Mysqlnd
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install mysqli

# Intl
RUN apt-get install -y --no-install-recommends libicu-dev && \
    docker-php-ext-install intl

# Zip
RUN apt-get install -y --no-install-recommends zlib1g-dev && \
    docker-php-ext-install zip

# Apcu
RUN pecl install apcu && \
    docker-php-ext-enable apcu

# Opcache
RUN docker-php-ext-enable opcache

# Gd
# RUN apt-get install -y --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libpng12-dev && \
#     docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
#     docker-php-ext-install gd

# Imagick
RUN apt-get install -y --no-install-recommends libmagickwand-dev && \
    pecl install imagick && \
    docker-php-ext-enable imagick

# Sockets
RUN docker-php-ext-install sockets

# Redis
RUN pecl install redis && \
    docker-php-ext-enable redis

# Bcmath
RUN docker-php-ext-install bcmath

# Blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") && \
    curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version && \
    tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp && \
    mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so && \
    printf "extension=blackfire.so\nblackfire.agent_socket=tcp://0.0.0.0:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

# Composer
RUN apt-get install -y --no-install-recommends git && \
    php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');" && \
    php /tmp/composer-setup.php --filename=composer --install-dir=/usr/local/bin/ && \
    chmod +x /usr/local/bin/composer && \
    rm /tmp/composer-setup.php

#  PHPUnit
RUN curl -o /tmp/phpunit.phar https://phar.phpunit.de/phpunit.phar && \
    mv /tmp/phpunit.phar /usr/local/bin/phpunit && \
    chmod +x /usr/local/bin/phpunit

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/app
