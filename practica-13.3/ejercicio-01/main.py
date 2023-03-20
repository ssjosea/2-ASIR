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
