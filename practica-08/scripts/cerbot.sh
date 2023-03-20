#!/bin/bash

set -x

# Instalamos y actualizamos snap
snap install core; sudo snap refresh core

# Eliminamos versiones previas de cerbot
apt-get remove certbot

# Instalamos cerbot
snap install --classic certbot

# Creamos usuario para el comando cerbot
ln -s /snap/bin/certbot /usr/bin/certbot

# Obtenemos el certificado
certbot --apache -m jose@demo.es --agree-tos --no-eff-email -d joseasir.no-ip.org

# Comprueba el temporizador para la renovacion de certificados
systemctl list-timers