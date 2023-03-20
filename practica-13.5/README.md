# Ejercicio 13.5

## José Antonio Estrella Tijeras - 2º ASIR

```
 practica-13.5
        .
        ├── ejercicio-01
        │   └── main.tf
        ├── ejercicio-02
        │   └── main.tf
        ├── images
        │   ├── 13.05_ej-01.png
        │   └── 13.05_ej-02.png
        └── README.md
```

En esta práctica vamos a usar Terraform para replicar y la creación de la arquitectura de las **prácticas 7 y 9 del primer trimestre**.

- [`ejercicio-01`](https://github.com/ssjosea/practica-13.5/tree/main/ejercicio-01): Creamos la arquitectura de la práctica 7 con dos instancias EC2 -> **Frontend** y **Backend**

- [`ejercicio-02`](https://github.com/ssjosea/practica-13.5/tree/main/ejercicio-02): Creamos la arquitectura de la práctica 9 con cinco instancias EC2 -> **Frontend-01** / **Frontend-02**, **Backend**, **balanceador de carga** y **servidor NFS**

En terraform debemos especificar el proovedor de la infraestructura además de otras opciones dependiendo del proovedor. En este caso usaremos AWS con instancias EC2 y debemos especificar la region -> **us-east-1**

```tf
provider "aws" {
  region = "us-east-1" # Región de nuestra cuenta de AWS
}
```
A la hora de crear una IP elástica la asociaremos con la instancia correspondiente; en el primer ejercicio con la Frontend y en el segundo con el balanceador de carga.

```tf
# Crear la IP elástica
resource "aws_eip" "elastic_ip" {
  instance = aws_instance.ec2_frontend.id # Asociación de la EIP con la instancia -> Frontend / Balancer
}
```

Opcionalmente (pero recomendable) mostramos la IP elástica creada en pantalla.

```tf
# Mostrar la IP pública de la instancia
output "elastic_ip" {
  value = aws_eip.elastic_ip.id
} 
```