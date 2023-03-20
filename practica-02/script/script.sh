# Depuramos la información
set -x

# Actualizamos repositorios
sudo dnf update -y

# ------------------------------ Apache -----------------------------------
# Instalamos Apache
sudo dnf install httpd -y

# Iniciamos el servicio
sudo systemctl start httpd

# Habilitamos el encendido automático
sudo systemctl enable httpd

# -------------------------------------------------------------------------
# ------------------------------ MySQL ------------------------------------

sudo dnf install mysql-server -y

sudo systemctl start mysqld

sudo systemctl enable mysqld

# -------------------------------------------------------------------------
# ------------------------------ PHP --------------------------------------

sudo dnf install php -y

sudo dnf install php-mysqlnd -y

sudo systemctl restart httpd

# Instalamos wget para la instalación de PHPMyAdmin
sudo dnf install wget -y

# -------------------------------------------------------------------------
# ------------------------------ PHPMyAdmin -------------------------------

# Descargamos PHPMyAdmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.tar.xz

# Instalamos los paquetes para que PHPMyAdmin conecte con la base de datos
dnf install -y php-json php-mbstring

# Descomprimimos el archivo 
xzcat phpMyAdmin-5.2.0-all-languages.tar.xz | sudo tar x -C /var/www/html

# Cambiamos el usuario y contraseña a la que usa httpd
chown -R apache:apache /var/www/html/phpmyadmin/

# -------------------------------------------------------------------------
# ------------------------------ Adminer ----------------------------------

#Instalación de Adminer
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php


#Creamos un directorio
mkdir -p /var/www/html/adminer

# Cambiamos el usuario y contraseña a la que usa httpd
chown -R apache:apache /var/www/html/adminer/

#Renombramos y renombramos el archivo
mv adminer-4.8.1-mysql.php /var/www/html/adminer/index.php