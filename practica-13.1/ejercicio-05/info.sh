#!/bin/bash

# Obtener el ID de todas las instancias EC2 en ejecución
instance_ids=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[].Instances[].InstanceId' --output text)

# Buscar cada ID de instancia y obtiene su nombre y dirección IP pública
for id in $instance_ids
do
  name=$(aws ec2 describe-instances --instance-ids $id --query 'Reservations[].Instances[].Tags[?Key==`Name`].Value' --output text)
  ip=$(aws ec2 describe-instances --instance-ids $id --query 'Reservations[].Instances[].PublicIpAddress' --output text)
  echo "Para la instancia $name, la IP es: $ip"
done