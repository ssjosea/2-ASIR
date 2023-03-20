# **Ejercicio 2**
## Jose A. Estrella Tijeras

### Instalación de Apache HTTP (httpd)

Instalamos **httpd** con el comando dnf install -y (**-y para que al encontrar el repositorio automáticamente lo installe sin preguntas si quiere instalarlo o no S/N**).



### Instalación de MySQL (mysqld)

Para **MySQL** usamos el repositorio *mysql-server* -y. 

Adicionalmente, para este repositorio necesitamos iniciarlo:
> systemctl **start** mysqld
 
 y habilitar su inicio automático:
 >systemctl **enable** mysqld



### Instalación de PHP (php)

Para **PHP** usamos el repositorio *PHP* -y. 

Además, instalamos el repositorio *php-mysqlnd*

Tras instalar estos dos repositorios, reiniciamos el servicio *httpd*.



### Instalación de PHPMyAdmin

Debemos instalar **wget**; una herramienta para descargar contenido desde servidores web mediante su URL.

La sintaxis para instalar wget es la siguiente 
> dnf install wget -y

Para descargar PHPMyAdmin accedemos al siguiente repositorio:
> wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.tar.xz


Adicionalmente, instalamos los paquetes para que PHPMyAdmin conecte con la base de datos (en mi caso sin este paquete a la hora de acceder al **servidor/phpmyadmin** me aparecia la página web en blanco):
> dnf install -y php-json php-mbstring

Descomprimimos el archivo descargaro con wget ya que su extension es xz y viene comprimida.
> xzcat phpMyAdmin-5.2.0-all-languages.tar.xz

Y los comprimimos en el directorio /var/www/html
> sudo tar x -C /var/www/html

Y cambiamos el usuario y la contraseña que viene por defecto a la que usamos en el servidor **apache:apache**
> chown -R apache:apache /var/www/html/phpmyadmin/

Si accedemos a nuestro servidor podemos entrar a PHPMyAdmin escribiendo un /phpmyadmin tras la IP.



### Instalacion de Adminer

Tambien necesitaremos el instalador de paquetes wget:
> wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php

Creamos un directorio para la instalación de Adminer en el directorio /var/www/html/adminer/

Tambien debemos cambiar el usuario mediante **chown** a apache:apache al igual que en PHPMyAdmin (Cambiando el directorio de /phpmyadmin a /adminer).

Movemos el archivo *adminer-4.8.1-mysql.php* a la carpeta que hemos creado anteriormente (/var/www/html/adminer/index.php).
