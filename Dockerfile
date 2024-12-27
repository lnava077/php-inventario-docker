# Utilizamos la imagen oficial de PHP 8.1 como base
FROM php:8.0

RUN apt-get update -y && apt-get install -y openssl zip unzip git

# Instalar Composer para Laravel 9
#RUN apt-get update && apt-get install -y composer=2.0.12
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install pdo

# Establecer el archivo php.ini predeterminado
#RUN ln -s /etc/php/8.1/fpm/php.ini /etc/php/8.1/cli/php.ini


# Configurar el directorio de trabajo
WORKDIR /app

# Copiar el archivo composer.json
COPY composer.json .

# Instalar las dependencias con Composer
RUN composer install --prefer-dist --no-scripts

# Copiamos los archivos del proyecto
COPY . /app

# Configuramos la configuración de PHP
#RUN sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/8.1/fpm/php.ini

# Instalamos las dependencias de Node.js
#RUN npm install

# Compilamos los assets con Laravel Mix
#RUN npm run production

# Configuramos la configuración de Laravel
#COPY .env .env
COPY .env.example .env

RUN php artisan key:generate
RUN php artisan config:clear
#RUN php artisan migrate --seed

# Exponemos el puerto 9000 para que el servidor web pueda acceder al contenedor
EXPOSE 9000:9000

# Establecemos el comando para ejecutar el servidor web
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=9000"]
