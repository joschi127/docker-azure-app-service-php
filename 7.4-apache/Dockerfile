FROM php:7.4.33-apache
MAINTAINER Azure App Services Container Images <appsvc-images@microsoft.com>

COPY apache2.conf /bin/
COPY init_container.sh /bin/
COPY hostingstart.html /home/site/wwwroot/web/hostingstart.html

RUN a2enmod rewrite expires include deflate headers

# install extra packages and PHP extensions
RUN mkdir -p /usr/share/man/man1/ /usr/share/man/man3/ /usr/share/man/man7/ \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libpng-dev \
        libjpeg-dev \
        libwebp-dev \
        libjpeg62-turbo-dev \
        libxpm-dev \
        libfreetype6-dev \
        libpq-dev \
        libmcrypt-dev \
        libldap2-dev \
        libldb-dev \
        libicu-dev \
        libgmp-dev \
        libmagickwand-dev \
        libxml2-dev \
        libzip-dev \
        libonig-dev \
        build-essential \
        libssl-dev \
        openssh-server \
        ca-certificates \
        python2.7 \
        webp \
        imagemagick \
        git \
        vim \
        nano \
        curl \
        wget \
        rsync \
        unzip \
        inetutils-ping \
        tcptraceroute \
        screen \
        bash-completion \
        mariadb-client \
        postgresql-client \
    && chmod 755 /bin/init_container.sh \
    && echo "root:Docker!" | chpasswd \
    && echo "cd /home" >> /etc/bash.bashrc \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick-beta \
    && pecl install mcrypt-1.0.3 \
    && docker-php-ext-configure gd \
        --enable-gd \
        --with-webp \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
    && docker-php-ext-install gd \
        mysqli \
        opcache \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        ldap \
        intl \
        gmp \
        zip \
        bcmath \
        mbstring \
        pcntl \
        xml \
        simplexml \
        exif \
        sockets \
        soap \
        sysvsem \
    && docker-php-ext-enable imagick mcrypt

RUN   \
   rm -f /var/log/apache2/* \
   && rmdir /var/lock/apache2 \
   && rmdir /var/run/apache2 \
   && rmdir /var/log/apache2 \
   && chmod 777 /var/log \
   && chmod 777 /var/run \
   && chmod 777 /var/lock \
   && chmod 777 /bin/init_container.sh \
   && cp /bin/apache2.conf /etc/apache2/apache2.conf \
   && rm -rf /var/www/html \
   && rm -rf /var/log/apache2 \
   && mkdir -p /home/LogFiles \
   && ln -s /home/LogFiles /var/log/apache2


RUN { \
                echo 'opcache.memory_consumption=128'; \
                echo 'opcache.interned_strings_buffer=8'; \
                echo 'opcache.max_accelerated_files=4000'; \
                echo 'opcache.revalidate_freq=60'; \
                echo 'opcache.fast_shutdown=1'; \
                echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
                echo 'error_log=/var/log/apache2/php-error.log'; \
                echo 'display_errors=Off'; \
                echo 'log_errors=On'; \
                echo 'display_startup_errors=Off'; \
                echo 'date.timezone=UTC'; \
                echo 'memory_limit=2048M'; \
                echo 'max_execution_time=900'; \
                echo 'max_input_time=300'; \
                echo 'post_max_size=500M'; \
                echo 'upload_max_filesize=500M'; \
                echo 'max_input_vars=10000'; \
                echo 'expose_php=off'; \
    } > /usr/local/etc/php/conf.d/php.ini

COPY sshd_config /etc/ssh/

EXPOSE 2222 8080

ENV APACHE_RUN_USER www-data
ENV APACHE_DOCUMENT_ROOT /home/site/wwwroot/web
ENV PHP_VERSION 7.4
ENV POST_DEPLOYMENT_SCRIPT /home/site/wwwroot/deploy-post-deployment.sh

ENV PORT 8080
ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance
ENV PATH ${PATH}:/home/site/wwwroot

WORKDIR /

ENTRYPOINT ["/bin/init_container.sh"]
