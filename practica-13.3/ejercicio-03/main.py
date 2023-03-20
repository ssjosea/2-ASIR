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
