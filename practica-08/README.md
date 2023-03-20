# Ejercicio 8 - Balanceador de carga en Apache

## Jose A. Estrella Tijeras

En esta practica vamos a configurar una aplicación web LAMP en 4 instancias agrupadas en:

- Un balanceador de carga, implementado con un Apache HTTP Server configurado como proxy inverso.

- Una capa de front-end, formada por dos servidores web con Apache HTTP Server.

- Una capa de back-end, formada por un servidor MySQL.

![](https://github.com/ssjosea/practica-08/blob/main/images/arquitectura.png?raw=true)

Contenidos del repositorio:
- [``ansible``](https://github.com/ssjosea/practica-08/tree/main/ansible): Scripts en **ansible (.yml)** -> Directorios organizados en **back**; para la instalación de la instancia Back-End y **front** para la instancia Front-End.

    - [``back``](https://github.com/ssjosea/practica-08/tree/main/ansible/back)
        - [``install_backend``](https://github.com/ssjosea/practica-08/blob/main/ansible/back/install_backend.yml): Instalación de MySQL y configuración de MySQL Server para aceptar conexiones desde todas la interfaces de red
        - [``deploy_backend``](https://github.com/ssjosea/practica-08/blob/main/ansible/back/deploy_backend.yml): Instalación de Python y modulo PyMySQL. Creación de una base de datos y un usuario y pila LAMP.

    - [``front``](https://github.com/ssjosea/practica-08/tree/main/ansible/front)
        - [``install_frontend``](https://github.com/ssjosea/practica-08/blob/main/ansible/front/install_frontend.yml): Instalación Apache y librerias de PHP.

        - [``deploy_frontend``](https://github.com/ssjosea/practica-08/blob/main/ansible/front/deploy_frontend.yml): Instalación pila LAMP y cambios en las variables del fichero **/var/www/html/config.php**. Cambiamos las propiedades del fichero **/etc/apache2/mods-enabled/dir.conf**.

    - [``ìnstall_cerbot``](https://github.com/ssjosea/practica-08/blob/main/ansible/install_cerbot.yml): Script de Ansible para la instalación del certificado Cerbot.

    - [``inventario``](https://github.com/ssjosea/practica-08/blob/main/ansible/inventario): Inventario de Ansible con las configuraciones de los 2 hosts (Front-End y backend) con sus IPs públicas y configuración de usuario y ssh.

    - [``main.yml``](https://github.com/ssjosea/practica-08/blob/main/ansible/main.yml): Playbook principal donde se ordena que se ejecuten el resto de jugadas por orden.
        
    - [``load_balancer.yml``](https://github.com/ssjosea/practica-08/blob/main/ansible/load_balancer.yml): Instalación de los módulos de Apache necesarios para el proxy inverso y cambio en el fichero **/etc/apache2/sites-available/000-default.conf** para añadir las dos IPs del Front-End mediante variables 

- [``conf``](https://github.com/ssjosea/practica-08/tree/main/conf): Guardamos el fichero [000-default.conf](https://github.com/ssjosea/practica-08/blob/main/conf/000-default.conf) que copiaremos al balanceador de carga.

- [``scripts``](https://github.com/ssjosea/practica-08/tree/main/scripts): Scripts en **bash (.sh)** -> Instalación de las instancias [**Back-End**](https://github.com/ssjosea/practica-08/tree/main/scripts/backend), [**Front-End**](https://github.com/ssjosea/practica-08/tree/main/scripts/frontend), [**balanceador**](https://github.com/ssjosea/practica-08/blob/main/scripts/balanceador/install_load_balancer.sh) y [**cerbot**](https://github.com/ssjosea/practica-08/blob/main/scripts/cerbot.sh).


Vamos a configurar un servidor web Apache como proxy inverso para que trabaje como balanceador de carga para el tráfico HTTP y HTTPS.

Para configurar el proxy inverso debemos activar los siguientes módulos:

- **``proxy``** -> Permite configurar el servidor web como un proxy inverso.

- **``proxy_http``** -> Permite configurar el servidor web como un proxy inverso para el protocolo HTTP.

Y los siguientes módulos:
- **``proxy_ajp``** -> Permite configurar el servidor web como un proxy inverso para el protocolo AJP (Apache JServ Protocol).
- **``rewrite``** -> Permite al servidor reescribir las peticiones HTTP que recibe.
- **``deflate``** -> Permite comprimir el contenido que se envía al cliente.
- **``headers``** -> Permite al servidor web manipular las cabeceras de las peticiones/respuestas HTTP que envía/recibe.

- **``proxy_connect``** -> Permite configurar el servidor web como un servidor proxy que puede establecer conexiones HTTPS con los servidores donde distribuye la carga, utilizando el método CONNECT de HTTP.


- **``proxy_html``** -> Permite configurar el servidor web como un servidor proxy que puede filtrar y modificar el contenido HTML de las páginas web que se reciben de los servidores donde se distribuye la carga.

Para el balanceo de carga habilitamos el módulo:

- **``proxy_balancer``** -> Configura otros métodos de balanceo de carga.

Y el siguiente módulos:

- **``lbmethod_byrequests``** -> Permite distribuir las peticiones entre los servidores en función de los parámetros ``lbfactor`` y ``lbstatus`` que se le pasan a la directiva ``ProxySet``.

Configuración del fichero **/etc/apache2/sites-available/000-default.conf**:

```bash
<VirtualHost *:80>
    # Dejamos la configuración del VirtualHost como estaba
    # sólo hay que añadir las siguiente directivas: Proxy y ProxyPass

    <Proxy balancer://mycluster>
        # Server 1
        BalancerMember http://IP_HTTP_SERVER_1

        # Server 2
        BalancerMember http://IP_HTTP_SERVER_2
    </Proxy>

    ProxyPass / balancer://mycluster/
</VirtualHost>
```

Siendo ``http://IP_HTTP_SERVER_1`` y ``http://IP_HTTP_SERVER_2`` por las direcciones IPs de las 2 instancias Front-End (En este caso he usado las IPs privadas porque no cambian cuando se reinician las instancias).

Reinciamos el servicio Apache:

```bash
sudo systemctl restart apache2
```