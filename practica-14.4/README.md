# Ejercicio 14.4

## Jose A. Estrella Tijeras

### Dockerizar una web estática y publicarla en Docker Hub

En esta práctica tendremos que crear un archivo Dockerfile para crear una imagen Docker que contenga una aplicación web estática. Posteriormente deberá publicar la imagen en Docker Hub y realizar la implantación del sitio web en Amazon Web Services (AWS) haciendo uso de contenedores Docker y de la herramienta Docker Compose.

![](https://github.com/ssjosea/practica-14.4/blob/main/images/dockerhub-2048.png?raw=true)

Link de la web **DockerHub** con la aplicacion **2048** en **Nginx**:
- [**`https://hub.docker.com/repository/docker/ssjosea/nginx-2048/general`**](https://hub.docker.com/repository/docker/ssjosea/nginx-2048/general)

El fichero **`Dockerfile`** tiene las siguientes características:

- Utiliza la imagen base de **Nginx**

- El puerto que usa la imagen para ejecutar el servicio de Nginx será el **puerto 80**.

- El comando que se ejecutará al iniciar el contenedor será el comando _**nginx -g 'daemon off;'**_.

```dockerfile
# Seleccionamos la imagen base
FROM nginx

# Instalamos git
RUN apt update \
    && apt install git -y 

# Clonamos el código de la aplicación y lo movemos al directorio de nginx
RUN git clone https://github.com/josejuansanchez/2048 /tmp/2048 \
    && cp -R /tmp/2048/* /usr/share/nginx/html/

# Indicamos el puerto de nginx
EXPOSE 80

# Indicamos el comando que se ejecuta al crear el contenedor
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
```

Para publicar la imagen en Docker Hub es necesario que en el nombre de la imagen aparezca nuestro nombre de usuario de DockerHub -> **ssjosea/nginx-2048**.

Además es recomendable asignar una etiqueta a la imagen. Por ejemplo, vamos a asignarle las etiquetas 1.0 y latest.

```
docker tag nginx-2048 ssjosea/nginx-2048:1.0
```

```
docker tag nginx-2048 ssjosea/nginx-2048:latest
```
Una vez que le hemos asignado un nombre correcto a la imagen y le hemos añadido las etiquetas, la publicamos en DockerHub.

```
docker push ssjosea/nginx-2048:1.0
```

```
docker push ssjosea/nginx-2048:latest
```