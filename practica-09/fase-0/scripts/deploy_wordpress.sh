#!/bin/bash

# Para ir depurando la información
set -x

source variables.sh

# Clonamos el repositorio de WordPress
wget https://es.wordpress.org/latest-es_ES.zip -O /tmp/latest-es_ES.zip

# Instalar Unzip
apt update
apt install unzip -y

# Borrar instalaciones previas de WordPress
rm -rf /var/www/html/wordpress

# Descomprimir el archivo zip en /var/www/html
unzip /tmp/latest -d /var/www/html

# Copiar el archivo de conf de ejemplo y creamos uno nuevo
cp /var/www/html/worpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# Configuramos lass variables
sed -i "s/database_name_here/$DB_NAME/" var/www/html/wordpress/wp-config.php
sed -i "s/username_here/$DB_USER/" var/www/html/wordpress/wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" var/www/html/wordpress/wp-config.php
sed -i "s/localhost/$DB_HOST_PRIVATE_IP/" var/www/html/wordpress/wp-config.php

# Añadimos las variables WP_HOME Y WP_SITEURL

sed -i "/DB_COLLATE/a define('WP_HOME', '$WP_HOME');" /var/www/html/wordpress/wp-config.php
sed -i "/DB_HOME/a define('WP_SITEURL', '$WP_SITEURL');" /var/www/html/wordpress/wp-config.php

# Eliminamos el index.html de /var/www/html/
# rm -rf /var/www/html/index.html

# Copiamos el archivo index.php del directorio wordpress
cp /var/www/html/wordpress/index.php /var/www/html/index.php

# Configuramoe el archivo index.php
sed -i "s#wp-blog-header.php#wordpress/wp-blog-header.php#" /var/www/html/index.php

# Modificamos el propietario y el grupo
chown www-data:www-data /var/www/html -R

# Configuramos la base de datos 
mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<< "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4"

mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'" # '%' -> Conexión desde cualquier IP
mysql -u root <<< "CREATE USER IF NOT EXISTS $DB_USER@'%' IDENTIFIED BY '$DB_PASS'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'" 
