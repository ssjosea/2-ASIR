# Ejercicio 7 - Pila LAMP en dos niveles
## Jose A. Estrella Tijeras

En esta practica vamos a implemententar la pila web LAMP en 2 instancias AWS en la ultima versión de Ubuntu Server

La arquitectura estará formada por:

- Una capa de front-end, formada por un servidor web con Apache HTTP Server.
- Una capa de back-end, formada por un servidor MySQL.

![](https://github.com/ssjosea/practica-07/blob/main/images/arquitectura.png?raw=true)

Contenidos del repositorio:
- [``ansible``](https://github.com/ssjosea/practica-07/tree/main/ansible): Scripts en **ansible (.yml)** -> Directorios organizados en **back**; para la instalación de la instancia Back-End y **front** para la instancia Front-End.
    - [``back``](https://github.com/ssjosea/practica-07/tree/main/ansible/back)
        - [``install_backend``](https://github.com/ssjosea/practica-07/blob/main/ansible/back/install_backend.yml): Instalación de MySQL y configuración de MySQL Server para aceptar conexiones desde todas la interfaces de red
        - [``deploy_backend``](https://github.com/ssjosea/practica-07/blob/main/ansible/back/deploy_backend.yml): Instalación de Python y modulo PyMySQL. Creación de una base de datos y un usuario y pila LAMP.
    - [``front``](https://github.com/ssjosea/practica-07/tree/main/ansible/front)
        - [``install_frontend``](https://github.com/ssjosea/practica-07/blob/main/ansible/front/install_frontend.yml): Instalación Apache y librerias de PHP.
        - [``deploy_frontend``](https://github.com/ssjosea/practica-07/blob/main/ansible/front/deploy_frontend.yml): Instalación pila LAMP y cambios en las variables del fichero **/var/www/html/config.php**. Cambiamos las propiedades del fichero **/etc/apache2/mods-enabled/dir.conf**.
    
- [``scripts``](https://github.com/ssjosea/practica-07/tree/main/scripts): Scripts en **bash (.sh)** -> Instalación de las instancias [**Back-End**](https://github.com/ssjosea/practica-07/tree/main/scripts/back) y  [**Front-End** ](https://github.com/ssjosea/practica-07/tree/main/scripts/front).

- [``ìnstall_cerbot``](https://github.com/ssjosea/practica-07/blob/main/install_cerbot.yml): Script de Ansible para la instalación del certificado Cerbot.

- [``inventario``](https://github.com/ssjosea/practica-07/blob/main/inventario): Inventario de Ansible con las configuraciones de los 2 hosts (Front-End y backend) con sus IPs públicas y configuración de usuario y ssh.

- [``main.yml``](https://github.com/ssjosea/practica-07/blob/main/main.yml): Playbook principal donde se ordena que se ejecuten el resto de jugadas por orden.

Configuración de reglas de entrada de AWS:

- Front-End:
    - Puertos habilitados:
        - HTTP: 80
        - HTTPS: 443
        - SSH: 22
        
![](https://github.com/ssjosea/practica-07/blob/main/images/puertos-frontend.png?raw=true)
- Back-End: 
    - Puertos habilitados: 
        - HTTP: 80
        - HTTPS: 443
        - SSH: 22
        - MySQL: 3306

![](https://github.com/ssjosea/practica-07/blob/main/images/puertos-backend.png?raw=true)