#!/bin/bash

set -x

# Variables de configuracion
source variables.sh


# Actualizamos repositorios
apt update

# Instalamos Apache
apt install apache2 -y

# Activamos los modulos para configurar Apache como proxy inverso
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp
a2enmod rewrite
a2enmod deflate
a2enmod headers
a2enmod proxy_balancer
a2enmod proxy_connect
a2enmod proxy_html
a2enmod lbmethod_byrequests

# Copiamos archivo de conf de Apache
cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

# Reemplazamos las variables del archivo de conf
sed -i "s/IP_HTTP_SERVER_1/$IP_HTTP_SERVER_1/" /etc/apache2/sites-available/000-default.conf
sed -i "s/IP_HTTP_SERVER_2/$IP_HTTP_SERVER_2/" /etc/apache2/sites-available/000-default.conf

# Reinicio de servicio Apache
systemctl restart apache2