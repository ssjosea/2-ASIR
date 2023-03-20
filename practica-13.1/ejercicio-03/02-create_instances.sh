#!/bin/bash
set -x

# Scripts para crear las instancias de la arquitectura balanceador de carga - servidor NFS

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
export AWS_PAGER=""

# Variables de configuración
AMI_ID=ami-06878d265978313ca # ID de la AMI de Ubuntu 22.04 LTS
COUNT=1
INSTANCE_TYPE=t2.medium
KEY_NAME=vockey

SECURITY_GROUP_FRONTEND=frontend-sg
SECURITY_GROUP_BACKEND=backend-sg
SECURITY_GROUP_NFS_SERVER=nfs-server-sg
SECURITY_GROUP_BALANCER=balancer-sg

INSTANCE_NAME_BALANCER=balancer
INSTANCE_NAME_FRONTEND_01=frontend-01
INSTANCE_NAME_FRONTEND_02=frontend-02
INSTANCE_NAME_BACKEND=backend
INSTANCE_NAME_NFS_SERVER=nfs-server

# Creamos una intancia EC2 para el balanceador de carga
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_BALANCER \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_BALANCER}]"

# Creamos una intancia EC2 para el frontend-01
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_FRONTEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_FRONTEND_01}]"

# Creamos una intancia EC2 para el frontend-02
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_FRONTEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_FRONTEND_02}]"

# Creamos una intancia EC2 para el backend
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_BACKEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_BACKEND}]"

# Creamos una intancia EC2 para el servidor NFS
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_NFS_SERVER \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_NFS_SERVER}]"