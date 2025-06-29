FROM php:8.3-fpm-alpine AS build

RUN apk add --no-cache \
	sqlite \
	sqlite-dev \
	nginx \
	bash \
	&& docker-php-ext-install pdo pdo_sqlite

WORKDIR /var/www/html

COPY . .

RUN chown -R www-data:www-data /var/www/html
COPY ./nginx.conf /etc/nginx/http.d/default.conf

RUN sed -i 's|listen = .*|listen = 9000|' /usr/local/etc/php-fpm.d/www.conf

EXPOSE 80

CMD ["sh","-c","php-fpm & exec nginx -g 'daemon off;'"]
