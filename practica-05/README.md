# Ejercicio 5

## Jose A. Estrella Tijeras

En esta practica nuestro objetivo será instalar Prestashop en AWS.

Para ello debemos seguir unos pasos previos los cuales son:

- Descargar el script phppssinfo.php con GitHub y guardarlo en un directorio visible para la web.
- Cambiar distintas configuraciones de PHP y añadir extensiones.
- Otorgar permisos de escritura a los directorios necesarios para la instalacion de PrestaShop.
- Instalar los modulos de Apache necesarios.

### Descargar el script phppssinfo.php con GitHub y guardarlo en un directorio visible para la web.

Iremos al repositorio de GitHub (https://github.com/PrestaShop/php-ps-info/) y añadiremos el repositorio a los directorios raiz de la instancia. Tras esto si accedemos a nuestra IP/php-ps-info/phppsinfo.php (en mi caso https://joseasir.no-ip.org/php-ps-info/phppsinfo.php) encontraremos la página con los requerimientos mínimos y recomendados para la correcta instalación de PrestaShop.

(Foto)

### Cambiar distintas configuraciones de PHP y añadir extensiones.

Ahora cambiaremos los distintos parámetros requeridos a los recomendados. Estos varían dependiendo del tipo de instalación y configuración de la pila LAMP y las herramientas, en nuestro caso debemos cambiar los siguientes parámetros.

#### --- PHP Configuration ---

**max_input_vars**

> sed -i 's/;max_input_vars = 1000/max_input_vars = 5000/' /etc/php/8.1/apache2/php.ini

**memory_limit**

> sed -i "s/memory_limit = 128/memory_limit = 256/" /etc/php/8.1/apache2/php.ini

**post_max_size**

> sed -i "s/post_max_size = 8/post_max_size = 128/" /etc/php/8.1/apache2/php.ini

**upload_max_filesize**

> sed -i "s/upload_max_filesize = 2/post_max_size = 128/" /etc/php/8.1/apache2/php.ini

Reiniciamos el servicio Apache para que surta cambio la configuración:

> sudo systemctl restart apache2

#### --- PHP Extensions ---

En nuestro caso, necesitamos instalar las siguientes:

**BCMath Arbitrary Precision Mathematics** (Opcional)

> apt install php-bcmath -y

**Internationalization Functions (Intl)**

> apt install php-intl -y

**Memcached** (Opcional)

> apt install memcached -y

> apt install libmemcached-tools -y

> systemctl start memcached 

Tras esto queda a la espera de su configuración.

Reiniciamos el servicio Apache para que surta cambio la configuración:

> systemctl restart apache2

#### --- Directories --- 

#### --- Modules --- 

**mod_headers**

> sudo a2enmod headers

Reiniciamos el servicio Apache:

> systemctl restart apache2

### Instalación de PrestaShop:

Ejecutamos **script.sh**, el cual contiene datos para la creación de una nueva base de datos enlazada a prestashop y unas variables que ejecutará con el comando **php index_cli.php**

Tras haber instalado PrestaShop, tendremos que borrar la carpeta de instalación por motivos de privacidad para poder entrar a nuestro panel de administración. 

> rm -rf /var/www/html/prestashop/install

A este panel de administración se accede con el usuario y contraseña que hemos escrito en nuestras variables de configuración de PHP.