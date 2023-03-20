# Configuramos el proveedor de AWS
provider "aws" {
  region = "us-east-1"
}

# Creamos un grupo de seguridad para Docker
resource "aws_security_group" "sg_wordpress_14_1" {
  name        = "sg_wordpress_14_1"
  description = "Grupo de seguridad para la instancia del docker de la practica 14-1 "

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Creamos una instancia EC2 de Docker
resource "aws_instance" "ec2_wordpress14_1" {
  ami                    = "ami-00874d747dde814fa"
  instance_type          = "t2.medium"
  key_name               = "vockey"
  security_groups = [aws_security_group.docker_14_1.name]

  tags = {
    Name = "ec2_wordpress14_1"
  }
}


# Creamos una IP elástica y la asociamos a la instancia
resource "aws_eip" "ip_elastica" {
  instance = aws_instance.ec2_wordpress14_1.id
}

# Mostramos la IP pública de la instancia
output "elastic_ip" {
  value = aws_eip.ip_elastica.public_ip
}