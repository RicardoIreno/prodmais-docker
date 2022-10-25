#!/usr/bin/env bash

# Composer install
test ! -f composer.phar && curl -s http://getcomposer.org/installer | php && php composer.phar install

# Copy config.php
test ! -f inc/config.php && cp inc/config_example.php inc/config.php

/etc/init.d/elasticsearch start \
service elasticsearch status
echo "TUDO RODANDO"
/usr/sbin/apache2ctl -D FOREGROUND