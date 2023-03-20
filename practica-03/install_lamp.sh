#!/bin/bash

set -x

# ----------------------------------------------------------------------
# Instalación de LAMP 
# ----------------------------------------------------------------------

# Actualizamos los repositorios
apt-get update

# Actualizamos los paquetes nuevos
#apt-get upgrade -y

# Instalamos el servidor web apache
apt-get install apache2 -y

# Instalamos el sistema gestor de bd
apt-get install mysql-server -y

# Instalamos los módulos PHP
apt-get install php libapache2-mod-php php-mysql -y