# Ejercicio 13.3

## José Antonio Estrella Tijeras - 2º ASIR

```
 practica-13.3
        .
        ├── aws-python-boto3
        ├── ejercicio-01 
        ├── ejercicio-02
        ├── ejercicio-03
        └── ejercicio-04
```

Esta práctica consta de **4 ejercicios** en **``Python``** en los cuales se practican la creación de scripts para crear grupos de seguridad e instancias de forma automática además de menús para poder elegir entre algunas opciones de creación como descripciones, número de instancias...

## **Ejercicio 1**
Sscript para crear un grupo de seguridad **``backend-sg``**.

- Acceso SSH (puerto 22/TCP) desde cualquier dirección IP.
- Acceso al puerto 3306/TCP desde cualquier dirección IP.

``` py
import aws
# Security group ingress permissions
ingress_permissions = [
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 22, 'ToPort': 22},    
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 3306, 'ToPort': 3306}]

# Pedimos por teclado el nombre y la descripción del grupo
group_name = input("Introduce el nombre del grupo de seguridad: ")
description = input("Introduce una descripción: ")

# Creamos el grupo de seguridad
aws.create_security_group(group_name, description, ingress_permissions)

# Obtenemos un listado de los grupos de seguridad
aws.list_security_groups()
```

## **Ejercicio 2**
Script para crear una **``instancia EC2``** que tengas las siguientes características.

- Identificador de la AMI: **``ami-08e637cea2f053dfa``**. Esta AMI se corresponde con la imagen Red Hat Enterprise
- Número de instancias: **``1``**
- Tipo de instancia: **``t2.micro``**
- Clave privada: **``vockey``**
- Grupo de seguridad: **``backend-sg``**
- Nombre de la instancia: **``backend``**

``` py
import aws

# Puertos del grupo de seguridad
ingress_permissions = [
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 22, 'ToPort': 22},    
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 3306, 'ToPort': 3306}]

# Nombre del grupo de seguridad
group_name = "backend-sg"

# Descripción del grupo de seguridad
description = "Grupo de seguridad de la instancia BackEnd"

# Creamos el grupo de seguridad
aws.create_security_group(group_name, description, ingress_permissions)

# ---------------------------------------------

# Listamos las AMIS
ami = "ami-08e637cea2f053dfa"

# ---------------------------------------------


# Tamaño de la instancia
instance_type = "t2.micro"

# Número de instancias
number_of_instances = 1

# Nombre de la instancia
instance_name = input("Introduce el nombre de la instancia: ")

# -----------------------------------------------

# Creación de la instancia
aws.create_instance(ami, number_of_instances, instance_type, group_name, "vockey", instance_name)
```

## **Ejercicio 3**
Script para crear la infraestructura de la práctica 9.

``` py
import aws

 
# Security group ingress permissions
backend_ingress_permissions = [
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 22, 'ToPort': 22},    
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 3306, 'ToPort': 3306}]

balancer_ingress_permissions = [
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 22, 'ToPort': 22},    
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 80, 'ToPort': 80},
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 443, 'ToPort': 443}]


frontend_ingress_permissions = [
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 22, 'ToPort': 22},    
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 80, 'ToPort': 80}]

nfs_server_ingress_permissions = [
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 22, 'ToPort': 22},    
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 2049, 'ToPort': 2049}]

# ID AMI
ami_id = "ami-06878d265978313ca"

# Tamaño instancia
instance_type = "t2.small"

# Clave SSH
ssh_key = "vockey"

# Creamos los grupos de seguridad
aws.create_security_group("sg_balancer", "Grupo del balanceador de carga", balancer_ingress_permissions)
aws.create_security_group("sg_backend", "Grupo del Backend", backend_ingress_permissions)
aws.create_security_group("sg_frontend", "Grupo del Frontend", frontend_ingress_permissions)
aws.create_security_group("sg_nfs_server", "Grupo del servidor NFS", nfs_server_ingress_permissions)

# Creamos las instancias EC2

aws.create_instance(ami_id, 1,instance_type, ssh_key, "balancer", "sg_balancer")
aws.create_instance(ami_id, 1,instance_type, ssh_key, "frontend-01", "sg_frontend")
aws.create_instance(ami_id, 1,instance_type, ssh_key, "frontend-02", "sg_frontend")
aws.create_instance(ami_id, 1,instance_type, ssh_key, "backend", "sg_backend")
aws.create_instance(ami_id, 1,instance_type, ssh_key, "nfs-server", "sg_nfs_server")

# Creamos una IP elástica
e_ip = aws.allocate_elastic_ip()

# Obtenemos el identificador del balanceador
balancer_id = aws.get_instance_id("balancer")

# Asociamos la IP elástica con el balanceador mediante su identificador
aws.associate_elastic_ip(e_ip, balancer_id)

```

Script para eliminar la infraestructura de la práctica 9.

``` py
# Security group ingress permissions
ingress_permissions = [
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 22, 'ToPort': 22},    
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 3306, 'ToPort': 3306}]

# Pedimos por teclado el nombre y la descripción del grupo
group_name = input("Introduce el nombre del grupo de seguridad: ")
description = input("Introduce una descripción: ")

# Creamos el grupo de seguridad
aws.create_security_group(group_name, description, ingress_permissions)

# Obtenemos un listado de los grupos de seguridad
aws.list_security_groups()

# Listamos las AMIS
amis_list = ["ami-08e637cea2f053dfa", "ami-06878d265978313ca"]

# Creamos una instancia EC2
print("--- AMI ---")
print("1. Red Hat Enterprise Server")
print("2. Ubuntu Server")
option = int(input("Seleccione una AMI (1-2): " ))
while option < 1 or option > 2:
    print("Error, el valor no es válido")
    option = int(input("Seleccione una AMI (1-2): "))

# Guardamos el identificador de la AMI seleccionada por el usuario
ami_id = amis_list[option - 1]

# Leemos el numero de instancias que quiere crear el usuario
number_of_instances = int(input("¿Cuantas estancias desea crear? (1-9): "))
while option < 1 or option > 9:
    print("Error, el valor no es válido")
    option = int(input("¿Cuantas estancias desea crear? (1-9): "))

print("Selecciona el numero de instancias")

# Leemos el tipo de instancia
instance_type_list = ["t2.micro", "t2.small", "t2.medium"]

print("--- EC2 ---")
print("1. t2.micro")
print("2. t2.small")
print("2. t2.medium")

option = int(input("Seleccione una tipo (1-3): " ))
while option < 1 or option > 3:
    print("Error, el valor no es válido")
    option = int(input("Seleccione una tipo (1-3): "))

# Guardamos el tipo de instancia seleccionada
instance_type = instance_type_list[option - 1]

instance_name = input("Introduce el nombre de la instancia: ")

# Creamos la instancia
aws.create_instance(ami_id, number_of_instances, instance_type, group_name, "vockey", instance_name)
```



## **Ejercicio 4**
Añadir  **nuevas funcionalidades** -> A la hora de crear una nueva instancia EC2 el programa puede mostrar al usuario una lista de AMIs disponibles y una lista de tipos de instancia.

``` py
import aws

 
# Security group ingress permissions
ingress_permissions = [
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 22, 'ToPort': 22},    
    {'CidrIp': '0.0.0.0/0', 'IpProtocol': 'tcp', 'FromPort': 3306, 'ToPort': 3306}]

# Pedimos por teclado el nombre y la descripción del grupo
group_name = input("Introduce el nombre del grupo de seguridad: ")
description = input("Introduce una descripción: ")

# Creamos el grupo de seguridad
aws.create_security_group(group_name, description, ingress_permissions)

# Obtenemos un listado de los grupos de seguridad
aws.list_security_groups()

# Listamos las AMIS
amis_list = ["ami-08e637cea2f053dfa", "ami-06878d265978313ca"]

# Creamos una instancia EC2
print("--- AMI ---")
print("1. Red Hat Enterprise Server")
print("2. Ubuntu Server")
option = int(input("Seleccione una AMI (1-2): " ))
while option < 1 or option > 2:
    print("Error, el valor no es válido")
    option = int(input("Seleccione una AMI (1-2): "))

# Guardamos el identificador de la AMI seleccionada por el usuario
ami_id = amis_list[option - 1]

# Leemos el numero de instancias que quiere crear el usuario
number_of_instances = int(input("¿Cuantas estancias desea crear? (1-9): "))
while option < 1 or option > 9:
    print("Error, el valor no es válido")
    option = int(input("¿Cuantas estancias desea crear? (1-9): "))

print("Selecciona el numero de instancias")

# Leemos el tipo de instancia
instance_type_list = ["t2.micro", "t2.small", "t2.medium"]

print("--- EC2 ---")
print("1. t2.micro")
print("2. t2.small")
print("2. t2.medium")

option = int(input("Seleccione una tipo (1-3): " ))
while option < 1 or option > 3:
    print("Error, el valor no es válido")
    option = int(input("Seleccione una tipo (1-3): "))

# Guardamos el tipo de instancia seleccionada
instance_type = instance_type_list[option - 1]

instance_name = input("Introduce el nombre de la instancia: ")

# Creamos la instancia
aws.create_instance(ami_id, number_of_instances, instance_type, group_name, "vockey", instance_name)
```
