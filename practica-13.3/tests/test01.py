import aws

print("--- Grupos de seguridad ---")
aws.list_security_groups()

print("--- Instancias EC2 ---")
aws.list_instances