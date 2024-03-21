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
  && \
  apt-get clean && apt-get autoremove -y

RUN apt-get install -y \
  php \
  php-cgi \
  php-mbstring \
  php-xml \
  php-zip \
  && \
  apt-get clean && apt-get autoremove -y


RUN a2enmod rewrite && \
  printf " \
  \n<Directory /var/www/html/prodmais> \
  \nOptions Indexes FollowSymLinks \
  \nAllowOverride All \
  \nRequire all granted \
  \n</Directory> \
  " >> /etc/apache2/sites-available/000-default.conf 


RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
  && \
  echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list \
  && \
  apt-get update && apt-get install -y elasticsearch \
  && \
  apt-get clean && apt-get autoremove -y


COPY ../ /var/www/html
RUN cp -r /var/lib/elasticsearch/ /tmp/elastic/

WORKDIR /var/www/html/prodmais	
