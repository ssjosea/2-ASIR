# Creamos una intancia EC2 con la AMI de RHEL
aws ec2 run-instances \
    --image-id ami-08e637cea2f053dfa\
    --count 1 \
    --instance-type t2.micro \
    --key-name vockey \
    --security-groups backend-sg \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=backend}]"