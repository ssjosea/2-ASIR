#!/bin/bash

set -x

source variables.sh

#Actualizamos los repositorios
apt-update

# Instalamos el cliente NFS
apt install nfs-common -y

# Montamos NFS en la máquina cliente
mount $NFS_SERVER_IP_PRIVATE:/var/www/html /var/www/html

cd /etc

# Editamos el archivo /etc/fstab para que al iniciar la máquina se monte automáticamente el directorio compartido por NFS.
echo "$NFS_SERVER_IP_PRIVATE:/var/www/html /var/www/html nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> fstab
