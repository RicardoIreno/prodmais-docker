FROM ubuntu:20.04

ENV user=z
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone
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
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list && \
    apt-get update && apt-get install -y elasticsearch && \
    apt-get clean && apt-get autoremove -y && \
    a2enmod rewrite && \
    printf " \
    \n<Directory /var/www/html/prodmais> \
    \nOptions Indexes FollowSymLinks \
    \nAllowOverride All \
    \nRequire all granted \
    \n</Directory> \
    " >> /etc/apache2/sites-available/000-default.conf

COPY ../ /var/www/html/prodmais
WORKDIR /var/www/html/prodmais		

RUN chmod +x ./dockconfig.sh
ENTRYPOINT ["./dockconfig.sh"]