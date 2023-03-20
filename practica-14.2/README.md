# Ejercicio 14.2

## Jose A. Estrella Tijeras

```
.
├── ansible
│   ├── inventario
│   ├── main.yml
│   └── playbooks
│       ├── deploy-docker.yml
│       └── install-docker.yml
├── docker
│   └── docker-compose.yaml
├── README.md
└── terraform
    └── main.tf
```

En esta práctica tendremos que realizar la implantación de un sitio PrestaShop en Amazon Web Services (AWS) haciendo uso de contenedores Docker y la herramienta Docker Compose.

## 1.2 Requisitos del archivo docker-compose.yml
### 1.2.1 Networks
Los servicios definidos en el archivo docker-compose.yml deberán usar dos redes:

- **frontend-network**
- **backend-network**

En la red frontend-network estarán los servicios:

- **https-portal**
- **prestashop**
- **phpmyadmin**

Y en la red backend-network sólo estará el servicio:

- **MySQL**

Sólo los servicios que están en la red frontend-network expondrán sus puertos en el host. Por lo tanto, el servicio de MySQL no deberá estar accesible desde el host.

# Estructura de ficheros

- [`ansible`](https://github.com/ssjosea/practica-14.2/tree/main/ansible): 
    - `main.yml`: Ordenamos la instalación de Docker y el resto de herramientas con el despliegue del fichero docker-compose.
    - `inventario`: Usamos la IP pública de la instancia EC2 para desplegar todos los playbooks.
    - `playbooks`: Directorio donde se guarda el deploy y la instalación de Docker.

- [`docker`](https://github.com/ssjosea/practica-14.2/tree/main/docker):
    - `.env`: Archivo con variables de Docker.
    - `docker-compose.yaml`: Aqui se recogen todas las variables y los recursos de la instalación de Wordpress para automatizarla en Docker.

Variables específicas de **`PrestaShop`**:
```yaml
      - PRESTASHOP_FIRST_NAME=${PRESTASHOP_FIRST_NAME}
      - PRESTASHOP_LAST_NAME=${PRESTASHOP_LAST_NAME}
      - PRESTASHOP_PASSWORD=${PRESTASHOP_PASSWORD}
      - PRESTASHOP_EMAIL=${PRESTASHOP_EMAIL}
      - PRESTASHOP_HOST=${PRESTASHOP_HOST}
      - PRESTASHOP_ENABLE_HTTPS=${PRESTASHOP_ENABLE_HTTPS}
      - PRESTASHOP_COUNTRY=${PRESTASHOP_COUNTRY}
      - PRESTASHOP_LANGUAGE=${PRESTASHOP_LANGUAGE}
      - PRESTASHOP_DATABASE_HOST=mysql
      - PRESTASHOP_DATABASE_NAME=${MYSQL_DATABASE}
      - PRESTASHOP_DATABASE_USER=${MYSQL_USER}
      - PRESTASHOP_DATABASE_PASSWORD=${MYSQL_PASSWORD}
```

**`HTTPS-Portal`**:

```yaml
     https-portal:
    image: steveltn/https-portal:1
    ports:
      - 80:80
      - 443:443
    volumes:
      - ssl_certs_data:/var/lib/https-portal
    restart: always
    environment:
      DOMAINS: 'joseasirpresta.hopto.org -> http://prestashop:8080'
      STAGE: 'production'
    restart: always
    networks:
      - frontend-network
```

**`PHPMyAdmin`**:

```yaml
     phpmyadmin:
    image: phpmyadmin:5.2.0-apache
    ports:
      - 8080:80
    environment: 
      - PMA_ARBITRARY=1
      - PMA_HOST=mysql
    restart: always
    depends_on:
      mysql:
        condition: service_healthy
    networks:
      - frontend-network
      - backend-network
```


- [terraform](https://github.com/ssjosea/practica-14.2/tree/main/terraform)
    - `main.tf`: En este fichero creamos la infraestructura de AWS; los **grupos de seguridad** y las **instancias EC2** además de la **EIP (IP elástica)**.