import aws

# Inicializamos una lista con los nombres de las instancias
ec2_list = ["balancer", "frontend-01", "frontend-02", "backend", "nfs-server"]

# Inicializamos una lista con los nombres de los grupos de seguridad
sg_list = ["sg_balancer", "sg_frontend", "sg_frontend", "sg_backend", "sg_nfs_server"]

# Recorremos la lista de nombres de instancias y las eliminamos
for ec2_name in ec2_list:
    print(f"Ending he instance {ec2_name}...")

    # Eliminamos la instancia
    aws.terminate_instance(ec2_name)

# Recorremos la lista de grupos de seguridad y los eliminamos
for sg_name in sg_list:
    print(f"Ending he instance {sg_name}...")

    # Eliminamos la instancia
    aws.delete_security_group(sg_name)