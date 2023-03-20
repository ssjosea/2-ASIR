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

# ------------------------------------------------------------------------------------------------------------

# Listamos las AMIS
ami = "ami-08e637cea2f053dfa"

# ------------------------------------------------------------------------------------------------------------


# Tamaño de la instancia
instance_type = "t2.micro"

# Número de instancias
number_of_instances = 1

# Nombre de la instancia
instance_name = input("Introduce el nombre de la instancia: ")

# ------------------------------------------------------------------------------------------------------------

# Creación de la instancia
aws.create_instance(ami, number_of_instances, instance_type, group_name, "vockey", instance_name)