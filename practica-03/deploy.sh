#!/bin/bash

set -x

DB_USER=usuario
DB_PASSWORD=usuario
DB_NAME=usuario

# Accedemos al directorio temporal /tmp

cd /tmp

# Eliminamos el directorio de instalaciones previas
rm -rf iaw-practica-lamp

# Clonamos el repositorio con la página web
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

# Creación del usuario para MySQL.

mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<< "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4"

mysql -u root <<< "DROP USER IF EXISTS $DB_USER"
mysql -u root <<< "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost' WITH GRANT OPTION"

sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql
sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/src/config.php
sed -i "s/lamp_user/$DB_USER/" /tmp/iaw-practica-lamp/src/config.php
sed -i "s/lamp_password/$DB_PASSWORD/" /tmp/iaw-practica-lamp/src/config.php

# Importamos la base de datos 
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql

# Movemos el código fuente de la aplicación
mv /tmp/iaw-practica-lamp/src/* /var/www/html

# Modificamos el propietario y el grupo de los archivos 
chown www-data:www-data /var/www/html -R

# Eliminamos el archivo index.html de prueba
rm -f /var/www/html/index.html

# Creamos una copia de seguridad del archivo
cp /etc/apache2/mods-enabled/dir.conf /etc/apache2/mods-enabled/dir.conf.bak

# Cambiamos la prioridad de los archivos
cp /home/ubuntu/practica-03/conf/dir.conf /etc/apache2/mods-enabled/