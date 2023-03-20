# Ejercicio 13.1

## José Antonio Estrella Tijeras - 2º ASIR

```
 practica-13.1
        .
        ├── 01-create-security-groups.sh
        ├── 02-create_instances.sh
        ├── 03-create_elastic_ip.sh
        └── README.md
```

Esta práctica tiene el objetivo de automátizar la creación de la infraestructura necesaria para crear una arquitectura mediante el uso de AWS CLI; herramienta que se ejecuta desde la línea de comandos que permite gestionar todos los servicios de Amazon Web Services. Proporciona acceso directo a la API pública de los servicios de AWS, de forma que todas las funcionalidades que se pueden realizar desde la consola de admnistración web, también se pueden realizar con esta herramienta desde la línea de comandos.

La infraestructura es la siguiente:

- Servidor NFS: Compartir con los clientes NFS la instalación necesaria. Serán la cara pública de la arquitectura. -> Necesario habilitar el puerto NFS en las reglas de entrada (2048)

- 2 Front-End que a la vez serán clientes NFS que montarán el directorio / del servidor NFS y mostrarán la web.

- 1 balanceador de carga que recibirá las peticiones HTTPS y las distribuirá entre los dos Front-End.

- 1 Back-End con MySQL para la creación y la gestión de una base de datos -> Necesario habilitar el puerto MySQL/Aurora en las reglas de entrada (3306).

- **Contenido:**
    
    - ``01-create-security-groups.sh``: Script para crear los grupos de seguridad de las instancias Frontend, Backend, NFS y balanceador de carga.  
   
   

    ```bash
    #!/bin/bash
    set -x

    # Script para la creación de los grupos de seguridad en una arquitectura con balanceador de carga y servidor NFS

    # Deshabilitamos la paginación de la salida de los comandos de AWS CLI
    export AWS_PAGER=""

    # Creamos el grupo de seguridad: frontend-sg
    aws ec2 create-security-group \
        --group-name frontend-sg \
        --description "Reglas para el frontend"
        ...

    #---------------------------------------------------------------------

    # Creamos el grupo de seguridad: backend-sg
    aws ec2 create-security-group \
        --group-name backend-sg \
        --description "Reglas para el backend"
        ...
    #---------------------------------------------------------------------

    # Creamos el grupo de seguridad: nfs-server-sg
    aws ec2 create-security-group \
        --group-name nfs-server-sg \
        --description "Reglas para el servidor NFS"
        ...

    #---------------------------------------------------------------------

    # Creamos el grupo de seguridad: balancer-sg
    aws ec2 create-security-group \
        --group-name balancer-sg \
        --description "Reglas para el balanceador de carga"
        ...
    ```
    #

    - ``02-create_instances.sh``: Scripts para crear las instancias Frontend, Backend, NFS y balanceador de carga.



    ```bash
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
    ```
    #

    - ``03-create_elastic_ip.sh``: Script para crear una IP elástica y asignarla al balanceador de carga.

    ```bash
    #!/bin/bash
    set -x

    # Script para crear IPs elásticas y asignarlas a las instancias ec2

    # Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
    export AWS_PAGER=""

    # Configuramos el nombre de la instancia a la que le vamos a asignar la IP elástica
    INSTANCE_NAME=balancer

    # Obtenemos el Id de la instancia a partir de su nombre
    INSTANCE_ID=$(aws ec2 describe-instances \
                --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
                        "Name=instance-state-name,Values=running" \
                --query "Reservations[*].Instances[*].InstanceId" \
                --output text)

    # Creamos una IP elástica
    ELASTIC_IP=$(aws ec2 allocate-address --query PublicIp --output text)

    # Asociamos la IP elástica a la instancia del balanceador
    aws ec2 associate-address --instance-id $INSTANCE_ID --public-ip $ELASTIC_IP
    ```

    #