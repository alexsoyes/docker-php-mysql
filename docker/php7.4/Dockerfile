FROM debian:bullseye

WORKDIR /app

#SET TIMEZONE
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN "date"

RUN apt-get update && apt-get install -y \
    php7.4-imagick \
    dialog \
    apt-utils \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    wget \
    vim \
    mariadb-client \
    git \
    acl \
    openssl
RUN apt-get update && apt-get install -y \
    php7.4 \
    php7.4-zip \
    unzip \
    php7.4-gd \
    default-jre \
    php7.4-mysql \
    php7.4-sqlite \
    php7.4-curl \
    php7.4-xml \
    php7.4-mbstring \
    php7.4-redis \
    libreoffice
RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-php
RUN a2enmod rewrite

# Composer
ADD ./composer/composer-install.sh /app/docker/composer-install.sh
RUN sh /app/docker/composer-install.sh
RUN chmod a+x /usr/local/bin/composer

# Symfony
RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN mv -v /root/.symfony/bin/symfony /usr/local/bin/symfony
RUN chmod +x /usr/local/bin/symfony

# Yarn
RUN apt update && apt install curl
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y yarn

# PHP
RUN sed -e 's/max_execution_time = 30/max_execution_time = 300/' -i /etc/php/7.4/apache2/php.ini
RUN sed -e 's/upload_max_filesize = 2M/upload_max_filesize = 300M/' -i /etc/php/7.4/apache2/php.ini
RUN sed -e 's/post_max_size = 8M/post_max_size = 300M/' -i /etc/php/7.4/apache2/php.ini
RUN echo "display_errors = on\n" >> /etc/php/7.4/apache2/php.ini
RUN echo "display_startup_errors = on\n" >> /etc/php/7.4/apache2/php.ini
RUN echo "error_log = /app/logs/php.log\n" >> /etc/php/7.4/apache2/php.ini

RUN echo 'extension = imagick.so' /etc/php/7.4/apache2/php.ini
# AJOUT COLOR et ALIAS
RUN echo "PS1='\[\e[36;43m\]DOCKER PHP73\[\e[m\] ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /root/.bashrc
RUN echo "alias ll='ls -alF'" >> /root/.bashrc
RUN echo "alias la='ls -A'" >> /root/.bashrc
RUN echo "alias l='ls -CF'" >> /root/.bashrc

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
