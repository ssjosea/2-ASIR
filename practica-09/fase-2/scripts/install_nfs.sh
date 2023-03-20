#!/bin/bash

set - x

# Actualizamos los repositorios
apt-update

# Instalamos el servidor NFS
apt install nfs-kernel-server -y

# Creamos el directorio html para compartirlo
mkdir -p /var/www/html

# COnfiguramos el grupo de html
chown nobody:nogroup /var/www/html

# Pasamos el archivo de conf a /etc/exports
cp ../conf/exports /etc/exports

# Reiniciamos el servidor NFS
systemctl restart nfs-kernel-server