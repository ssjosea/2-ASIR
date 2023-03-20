#!/bin/bash
set -x

#Variables de configuración
PHPMYADMIN_APP_PASSWORD=password
STATS_USER=usuario
STATS_PASSWORD=usuario

#Instalacion de herramientas adicionales relacionadas con la pila LAMP

#Instalación de Adminer
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php


#Creamos un directorio
mkdir -p /var/www/html/adminer

#Renombramos y renombramos el archivo
mv adminer-4.8.1-mysql.php /var/www/html/adminer/index.php

#COnfiguramos las respuestas para hacer una isntalación desatendida de phpmyadmin
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-selections

#Descargar e instalar phpMyAdmin
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y

# Añadimos el repositorio de GoAcces
echo "deb http://deb.goaccess.io/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/goaccess.list

#Añadimos la clave pública
wget -O - https://deb.goaccess.io/gnugpg.key | sudo apt-key add -

#Actualizamos los repositorio
apt update

#Actualizamos GoAccess
apt install goaccess -y

#Creamos el directorio stats
mkdir -p /var/www/html/stats


#Modificamos el propietario y el grupo de directorio /var/www/html 
chown www-data:www-data /var/www/html -R

# Ejecutamos GoAccess en segundo plano /var/www/html
goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize


# Control de acceso a un direcctorio
#-------------------------------------------------
# Creamos un directorio para guardar el archivo de claves
mkdir -p /etc/apache2/claves

#Creamos un usuario/password en un archivo .htpasswd
htpasswd -bc /etc/apache2/claves/.htpasswd $STATS_USER $STATS_PASSWORD

#Copiamos el archivo de configuración de Apache
cp ../conf/000-default.conf /etc/apache2/sites-available

#Reiniamos el servicio de Apache
systemctl restart apache2

#Control de acceso a un directorio mediante .htacess
# Creamos un usuario/password en un directorio .htaccess
htpasswd -bc htpasswd -bc /etc/apache2/claves/.htpasswd $STATS_USER $STATS_PASSWORD

# Copiamos el archivo htaccess en /var/html/stats
cp ../htaccess/htaccess /var/www/html/stats/.htaccess

# Copiamos el archivo de configuración de Apache
cp ../conf/000-default-htaccess.conf /etc/apache2/sites-available/000-default.conf

#Reiniamos el servicio de Apache
systemctl restart apache2