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