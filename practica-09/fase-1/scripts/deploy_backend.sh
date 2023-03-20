#!/bin/bash

# Para ir depurando la información
set -x
source variables.sh

# Creamos la base de datos y el usuario de la aplicación
mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<< "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4"

mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'"
mysql -u root <<< "CREATE USER IF NOT EXISTS $DB_USER@'%' IDENTIFIED BY '$DB_PASS'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'" 

# Accedemos al directorio /tmp
cd /tmp

rm -rf iaw-practica-lamp

# Clonamos el repositorio de Jose Juan con la app LAMP
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

# Modificamos el nombre de la base de datos del script SQL

sed -i "s/lamp_db/$DB_NAME/"  /tmp/iaw-practica-lamp/db/database.sql

# Importamos su base de datos 
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql