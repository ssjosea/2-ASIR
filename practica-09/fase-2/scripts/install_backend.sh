#!/bin/bash

# Para ir depurando la información
set -x

# Actualizamos los repositorios
apt-get update

apt install mysql-server -y

# Configuramos mysql server para que acepte conexiones desde cualquier interfaz de red
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mysql.conf.d//mysqld.cnf

# Reiniciamos servicio mysql
systemctl restart mysql