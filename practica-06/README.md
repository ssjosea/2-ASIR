# Ejercicio 6 - PrestaShop en Ansible

## Jose A. Estrella Tijeras

El objetivo de esta práctica es aprovechar los scripts que hemos estado usando anteriormente (*tools*, pila LAMP, Cerbot e instalación de PrestaShop) para implementarlo en el lenguaje de programación **.yml**.

Con esto conseguimos la posibilidad de que desde nuestra máquina anfitrión podamos gestionar la instalación de la tienda PrestaShop hacia varios servidores al mismo tiempo, lo cual mejora enormemente la productividad y eficiendia de trabajo al reducir el tiempo de instalación.

Esta práctica consta de los siguientes scripts:

- `mail.yml`: Playbook principal con el resto de jugadas importadas para ejecutarlas desde un único **.yml**

- `install_basic.yml`: Contiene tareas sencillas como la actualización de paquetes, instalación del servidor web Apache, PHP ademas y sus librerias y MySQL.
- `install_lamp.yml`: Instalamos la pila LAMP clonando el [repositorio de Jose Juan](https://github.com/josejuansanchez/iaw-practica-lamp.git) e importamos su base de datos. Se mueven los recursos a **/var/www/html/lamp**, cambiamos los permisos y borramos el index.
- `install_tools.yml`: Configuramos PHPMyAdmin con el módulo **debconf**:

```yml
vars:
    - PHPMYADMIN_ADD_PASSWORD: password
    - STATS_USER: usuario
    - STATS_PASSWORD: usuario
```


```yml
debconf:
    name: 'phpmyadmin'
    question: 'phpmyadmin/reconfigure-webserver'
    value: 'apache2'
    vtype: 'multiselect'
```

```yml
debconf:
    name: 'phpmyadmin'
    question: 'phpmyadmin/dbconfiguring-install'
    value: 'true'
    vtype: 'boolean'
```

```yml
debconf:
    name: 'phpmyadmin'
    question: 'phpmyadmin/mysql/app-pass'
    value: '{{ PHPMYADMIN_ADD_PASSWORD }}' # -> Variables de PHPMyAdmin en vars
    vtype: 'password'
```

```yml
debconf:
    name: 'phpmyadmin'
    question: 'phpmyadmin/app-password-confirm'
    value: 'password'
    vtype: '{{ PHPMYADMIN_ADD_PASSWORD }}' # -> Variables de PHPMyAdmin en vars
```

Ademas se ha instalado Adminer para administrar el contenido de la base de datos desde el propio [repositorio de Adminer](https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php) en **/var/www/html/adminer.**

- `install_cerbot.yml`: Se descarga e instala snap con el módulo **command** y se instala cerbot --classic con el módulo **snap**:

```yml
snap:
    name: certbot
    state: present # -> Iniciado
    classic: true # -> Paquetes "clásicos"
```

Con el módulo **file** vamos a crear un usuario para cerbot:

```yml
ansible.builtin.file:
    src: /snap/bin/certbot # -> Source (directorio origen)
    dest: /usr/bin/certbot # -> Destination (directorio destino)
    owner: www-data # -> Propietario individual (usuario)
    group: www-data # -> Grupo propietario
    state: link # -> El estado del directorio será un enlace simbólico
```

