FROM ubuntu:20.04
# COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV user=z
ENV TZ=Etc/GMT-3
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && useradd $user
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    gnupg1 \
    apache2 \
    zip \
    php \
    php-cgi \
    php-curl \
    php-mbstring \
    php-xml \
    php-zip && \
    apt-get clean && \  
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list && \
    apt-get update && apt-get install -y elasticsearch && \
    apt autoclean -y &&  apt autoremove -y
    
RUN a2enmod rewrite && \
    printf " \
    \n<Directory /var/www/html/prodmais> \
    \nOptions Indexes FollowSymLinks \
    \nAllowOverride All \
    \nRequire all granted \
    \n</Directory> \
    " >> /etc/apache2/apache2.conf

COPY . /var/www/html/prodmais
RUN cd /var/www/html/prodmais && \
		curl -s http://getcomposer.org/installer | php && \
		php composer.phar install && cp inc/config_example.php inc/config.php
		
WORKDIR /var/www/html/prodmais
