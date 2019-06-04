FROM php:5.6-fpm

RUN apt-get update \
	&& apt-get install -y \
	libz-dev \
	libmemcached11 \
	libmemcachedutil2 \
	libmemcached-dev \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	mysql-client \
	less \
	git \
	subversion \
	wget \
	libxml2-dev \
	ssmtp \
	imagemagick \
	libmagickwand-dev \
	iproute2 \
	libicu-dev \
	&& pecl install memcached-2.2.0 \
	&& pecl install imagick \
	&& docker-php-ext-enable memcached imagick \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install -j$(nproc) pdo_mysql sockets mysqli zip \
	&& docker-php-ext-install soap intl \
	&& docker-php-ext-enable pdo_mysql mysqli gd zip \
	&& echo "mailhub=mailcatcher:1025\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf \
	&& apt-get purge -y libmemcached-dev \
	&& apt-get remove -y libmagickwand-dev libxml2-dev libicu-dev \
	&& apt-get autoremove -y \
	&& apt-get autoclean

ARG INSTALL_XDEBUG=true
ENV INSTALL_XDEBUG ${INSTALL_XDEBUG}
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
	pecl install xdebug-2.5.5 && \
	docker-php-ext-enable xdebug \
	;fi

RUN curl https://getcomposer.org/download/$(curl -LSs https://api.github.com/repos/composer/composer/releases/latest | grep 'tag_name' | sed -e 's/.*: "//;s/".*//')/composer.phar > /tmp/composer.phar \
	&& chmod +x /tmp/composer.phar \
	&& mv /tmp/composer.phar /usr/local/bin/composer

RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /tmp/wp-cli.phar \
	&& chmod +x /tmp/wp-cli.phar \
	&& mv /tmp/wp-cli.phar /usr/local/bin/wp \
	&& mkdir /var/www/.wp-cli \
	&& chown www-data:www-data /var/www/.wp-cli

RUN curl -L https://phar.phpunit.de/phpunit.phar > /tmp/phpunit.phar \
	&& chmod +x /tmp/phpunit.phar \
	&& mv /tmp/phpunit.phar /usr/local/bin/phpunit

RUN XDEBUG=$(find /usr/local/lib/php -name 'xdebug.so' | head -n 1 | tail -n 1) \
	&& ln -s $XDEBUG /usr/local/lib/php/extensions/xdebug.so

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]

EXPOSE 9000
