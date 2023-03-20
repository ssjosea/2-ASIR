#!/bin/bash

set -x

# Variables de configuración
PHPMYADMIN_APP_PASSWORD=password
STATS_USER=usuario
STATS_PASSWORD=usuario

# ----------------------------------------------------------------------
# Instalación de herramientas adicionales relacionadas con la pila LAMP 
# ----------------------------------------------------------------------

# Configuramos las respuestas para hacer una instalación desatendida de phMyAdmin
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmi/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections


# Instalación phpmyAdmin
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y

# Instalación Adminer
# -----------------------------------------------------------------------------
# Descargamos el archivo de Adminer

wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php

# Creamos un directorio para Adminer
mkdir -p /var/www/html/adminer

# Movemos y renombramos el archivo
mv adminer-4.8.1-mysql.php /var/www/html/adminer/index.php

# Instalación de GoAccess
# --------------------------------------------------------------------------------------------------------
# Añadimos el repositorio de GoAccess
echo "deb http://deb.goaccess.io/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/goaccess.list

# Añadimos la clave pública de GoAccess en nuestra máquina
wget -O - https://deb.goaccess.io/gnugpg.key | sudo apt-key add -

# Actualizamos los repositorios 
apt update

# Instalamos GoAccess
apt install goaccess -y

# Creamos el directorio stats
mkdir -p /var/www/html/stats

# Modificamos el propietario y el grupo del directorio /var/www/html
chown www-data:www-data /var/www/html -R

# Ejecutamos GoAccess en segundo plano
goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize



# Control de acceso a un directorio con .htaccess
# --------------------------------------------------------------------------------
# Creamos un directorio para guardar el archivo de claves
#mkdir -p /etc/apache2/claves


# Creamos un usuario/password en un archivo .htpasswd
#sudo htpasswd -bc /etc/apache2/claves/.htpasswd $STATS_USER $STATS_PASSWORD


# Copiamos el archivo de configuración de Apache
#cp ../conf/000-default.conf /etc/apache2/sites-available

# Reiniciamos el servicio de Apache
#systemctl restart apache2

# Control de acceso a un directorio mediante .htaccess
# --------------------------------------------------------------------------------

# Creamos un usuario/password en un archivo .htaccess
sudo htpasswd -bc /etc/apache2/claves/.htpasswd $STATS_USER $STATS_PASSWORD

# Copiamos el archivo htaccess en /var/www/html/stats
cp ../htaccess/htaccess /var/www/html/stats/.htaccess

# Copiamos el archivo de configuración de Apache
cp ../conf/000-default-htaccess.conf /etc/apache2/sites-available/000-default.conf

# Reiniciamos el servicio de Apache
systemctl restart apache2