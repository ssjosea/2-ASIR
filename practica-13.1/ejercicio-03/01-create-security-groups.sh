#!/bin/bash
set -x

# Script para la creación de los grupos de seguridad en una arquitectura con balanceador de carga y servidor NFS

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
export AWS_PAGER=""

# Creamos el grupo de seguridad: frontend-sg
aws ec2 create-security-group \
    --group-name frontend-sg \
    --description "Reglas para el frontend"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name frontend-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTP
aws ec2 authorize-security-group-ingress \
    --group-name frontend-sg \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTPS
aws ec2 authorize-security-group-ingress \
    --group-name frontend-sg \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0

#---------------------------------------------------------------------

# Creamos el grupo de seguridad: backend-sg
aws ec2 create-security-group \
    --group-name backend-sg \
    --description "Reglas para el backend"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name backend-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso para MySQL con el puerto 3306 ----
aws ec2 authorize-security-group-ingress \
    --group-name backend-sg \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0

#---------------------------------------------------------------------

# Creamos el grupo de seguridad: nfs-server-sg
aws ec2 create-security-group \
    --group-name nfs-server-sg \
    --description "Reglas para el servidor NFS"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name nfs-server-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTP
aws ec2 authorize-security-group-ingress \
    --group-name nfs-server-sg \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso para NFS con el puerto 2048 ----
aws ec2 authorize-security-group-ingress \
    --group-name nfs-server-sg \
    --protocol tcp \
    --port 2048 \
    --cidr 0.0.0.0/0

#---------------------------------------------------------------------

# Creamos el grupo de seguridad: balancer-sg
aws ec2 create-security-group \
    --group-name balancer-sg \
    --description "Reglas para el balanceador de carga"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name balancer-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTP
aws ec2 authorize-security-group-ingress \
    --group-name balancer-sg \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTPS
aws ec2 authorize-security-group-ingress \
    --group-name balancer-sg \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0
