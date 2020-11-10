FROM php:7.3-cli
MAINTAINER Emmett Culley <eculley@ccctechcenter.org

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -yqq \
    && apt-get install git libzip-dev zlib1g-dev libsqlite3-dev libpq-dev -y \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo_sqlite \
    && docker-php-ext-install pdo_pgsql

RUN curl -fsSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer global require phpunit/phpunit ^7.0 --no-progress --no-scripts --no-interaction

RUN pecl install xdebug \
    && echo 'zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20180731/xdebug.so' > \
    /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && php -m | grep xdebug

ENV PATH /root/.composer/vendor/bin:$PATH

CMD ["phpunit", "--version"]
