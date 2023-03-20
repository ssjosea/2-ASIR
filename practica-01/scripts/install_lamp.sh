#!/bin/bash

# Para ir depurando la información
set -x

# Actualizamos los repositorios
apt-get update

#Actualizamos los paquetes
#apt-get upgrade -y

#Instalamos el vervidor apache
apt-get install apache2 -y

#Instalamos el sistema de gestos bd
apt-get install mysql-server -y

# Instalamos los módulos de PHP
apt-get install php libapache2-mod-php php-mysql -y

#Este paso es opcional
#Copiamos el archivo phpinfo de PHP
cp ../php/info.php /var/www/html

