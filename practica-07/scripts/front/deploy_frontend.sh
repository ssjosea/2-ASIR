#!/bin/bash

# Para ir depurando la información
set -x

source variables.sh

# Nos dirigimos al directorio tmp
cd /tmp

rm -rf iaw-practica-lamp

# Clonamos el repositorio de Jose Juan con la app LAMP
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

# Importamos su base de datos 
mysql -u root -c < /tmp/iaw-practica-lamp/db/database.sql

# Movemos los recursos del repositorio a nuestro directorio /html
mv /tmp/iaw-practica-lamp/src/* /var/www/html

# Configuramos las variables de conf 
sed -i "s/localhost/$DB_HOST_PRIVATE_IP/" /var/www/html/config.php
sed -i "s/lamp_db/$DB_NAME/" /var/www/html/config.php
sed -i "s/lamp_user/$DB_USER/" /var/www/html/config.php
sed -i "s/lamp_pass/$DB_PASS/" /var/www/html/config.php



# Cambiamos los permisos del directorio
chown www-data:www-data /var/www/html -R 

# Borramos el index para que por defecto cargue la app LAMP
rm -f /var/www/html/index.html
