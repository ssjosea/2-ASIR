#!/bin/bash

# Para ir depurando la información
set -x

# Actualizamos los repositorios
apt-get update

#Actualizamos los paquetes
#apt-get upgrade -y

#Instalamos el vervidor apache
apt-get install apache2 -y

# Instalamos MySQL
apt install mysql-server -y

# Instalamos los módulos de PHP
apt-get install php libapache2-mod-php php-mysql -y

# Copiamos los archivos de configuración de directorios
cp ../conf/dir.conf /etc/apache2/mods-available
cp ../conf/000-default.conf /etc/apache2/sites-available


a2enmod rewrite

# Reiniciamos el servicio Apache
systemctl restart apache2

