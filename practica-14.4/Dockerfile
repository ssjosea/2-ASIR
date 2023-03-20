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
