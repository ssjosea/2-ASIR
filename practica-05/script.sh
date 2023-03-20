#!/bin/bash

set -x

# ------------------------------------ Variables de configuración para la base de datos y PHP ------------------------------------------------

DOMAIN=joseasir.no-ip.org
PS_DB_NAME=prestashop_db
PS_DB_USER=prestashop_user
PS_DB_PASSWORD=prestashop_pass

PS_NAME=Tienda
PS_COUNTRY=es
PS_FIRSTNAME=Jose 
PS_LASTNAME=Estrella
PS_PASSWORD=joseassj 
PS_EMAIL=jesttij092@g.educaand.es
PS_DB_SERVER=127.0.0.1

# Configuracion de PHP para PrestaShop

sed -i 's/max_input_vars = 1000/max_input_vars = 5000/' /etc/php/8.1/apache2/php.ini

sed -i "s/memory_limit = 128/memory_limit = 256/" /etc/php/8.1/apache2/php.ini

sed -i "s/post_max_size = 8/post_max_size = 128/" /etc/php/8.1/apache2/php.ini

sed -i "s/upload_max_filesize = 2/post_max_size = 128/" /etc/php/8.1/apache2/php.ini

systemctl restart apache2

# ------------------------------------------------------ PHP-ps-info ---------------------------------------------------------------

cd /tmp

git clone https://github.com/PrestaShop/php-ps-info.git

cd php-ps-info/

mv phppsinfo.php /var/www/html/

#### ------------------------------------------------ PHP Extensions ---------------------------------------------------------------

# Instalación de BCMath Arbitrary Precision Mathematics.

apt install php-bcmath -y

# Instalación de Internationalization Functions.

apt install php-intl -y

# Instalación de Memcached

apt install memcached -y

apt install libmemcached-tools -y

systemctl start memcached 

systemctl restart apache2

sudo a2enmod headers

systemctl restart apache2

#Paso 1. Creación de la base de datos de los usuarios de bd.

mysql -u root <<< "DROP DATABASE IF EXISTS $PS_DB_NAME;"
mysql -u root <<< "CREATE DATABASE $PS_DB_NAME CHARACTER SET utf8mb4;"

mysql -u root <<< "DROP USER IF EXISTS $PS_DB_USER;"
mysql -u root <<< "CREATE USER IF NOT EXISTS prestashop_user@'%' IDENTIFIED BY '$PS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PS_DB_NAME.* TO $PS_DB_USER@'%';"
mysql -u root <<<  "FLUSH PRIVILEGES;" # Vuelve a leer las tablas de privilegios.

# Directorio temporal.

cd /tmp

# Obtenemos PrestaShop desde su repositorio de GitHub.

wget https://github.com/PrestaShop/PrestaShop/releases/download/8.0.0/prestashop_8.0.0.zip

# Instalamos Unzip para descomprimir.

sudo apt install unzip -y

unzip /tmp/prestashop_8.0.0.zip

unzip /tmp/prestashop.zip -d /var/www/html/

# Borramos todos los archivos temporales del zip.

rm -f /tmp/prestashop*

# Nos situamos en el directorio de instalacion de prestashop.

cd /var/www/html/install

# --------------------------------------------- Automatización de prestashop ------------------------------------------------------------------

sudo chown www-data:www-data /var/www/html -R

# Variables de PHP que se ejecutarán en la instalación sustituyendo la interfaz gráfica.

php index_cli.php \
    --db_server=$PS_DB_SERVER \
    --db_user=$PS_DB_USER \
    --db_name=$PS_DB_NAME \
    --db_password=$PS_DB_PASSWORD \
    --language=es \
    --name=$PS_NAME \
    --country=$PS_COUNTRY \
    --firstname=$PS_FIRSTNAME \
    --lastname=$PS_LASTNAME \
    --password=$PS_PASSWORD \
    --email=$PS_EMAIL \
    --domain=joseasir.no-ip.org \
    --ssl=1

# Borramos carpeta de instalación para mayor seguridad.

rm -rf /var/www/html/install/