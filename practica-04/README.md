# Ejercicio 4

## Jose A. Estrella Tijeras

En esta practica vamos a otogarle a nuestra web un dominio y un certificado mediante el uso de la web **No-IP** y el cliente **Cerbot**

Primero entraremos en la web de NO-IP (**https://www.noip.com/es-MX**), donde crearemos una cuenta.

Entramos al apartado de **DNS Records**, donde añadiremos nuestro dominio eligiendo un nombre y la respectiva ip elástica elegica en AWS para la estancia.

![](https://github.com/ssjosea/practica-04/blob/main/images/NoIP.png)


Desde ahora, podemos acceder a nuestra web desde el respectivo dominio, en mi caso: **https://joseasir.no-ip.org/**

![](https://github.com/ssjosea/practica-04/blob/main/images/PaginaWeb.png)

Ahora ejecutaremos el script **scipt_certot.sh** para instalar cerbot y crear un certificado para nuestra web.

### **script_cerbot.sh**

Instalamos y actualizamos snap:
> sudo snap install core; sudo snap refresh core

Eliminamos versiones previas de cerbot:
> sudo apt-get remove certbot

Instalamos cerbot:
> sudo snap install --classic certbot

Creamos usuario para el comando cerbot:
> sudo ln -s /snap/bin/certbot /usr/bin/certbot

Obtenemos el certificado:
> sudo certbot --apache -m jose@demo.es --agree-tos --no-eff-email -d joseasir.no-ip.org

Comprueba el temporizador para la renovacion de certificados:
> systemctl list-timers


