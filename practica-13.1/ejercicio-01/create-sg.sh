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
