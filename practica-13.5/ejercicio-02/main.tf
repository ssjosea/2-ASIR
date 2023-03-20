# Seleccionamos el proovedor de la infraestructura -> AWS

provider "aws" {
  region = "us-east-1" # Región de nuestra cuenta de AWS
}

# ------------------ Grupos de seguridad ------------------

# ------ Frontend ------
resource "aws_security_group" "sg_frontend" {
  name        = "sg_frontend"
  description = "Grupo de seguridad de la instancia Frontend"

  ingress {
    from_port   = 22            # Puerto de entrada
    to_port     = 22            # Puerto de salida
    protocol    = "tcp"         # Protocolo
    cidr_blocks = ["0.0.0.0/0"] # Conexión abierta
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
}

# ------ Backend ------
resource "aws_security_group" "sg_backend" {
  name        = "sg_backend"
  description = "Grupo de seguridad para la instancia Backend"

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
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ------ NFS Server ------
resource "aws_security_group" "sg_nfs" {
  name        = "sg_nfs"
  description = "Grupo de seguridad para la instancia NFS"

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
    from_port   = 2049 # Puerto de entrada -> NFS
    to_port     = 2049 # Puerto de salida -> NFS
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

# ------ Balanceador de carga ------

resource "aws_security_group" "sg_balancer" {
  name        = "sg_balancer"
  description = "Grupo de seguridad para la instancia -> Balanceador de carga"

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
}

# ------------------ Instancias ------------------

# ------ Frontend-01 ------
resource "aws_instance" "ec2_frontend_01" {
  ami             = "ami-00874d747dde814fa" # AMI de la instancia (SO)
  instance_type   = "t2.medium"             # Características de la instancia
  key_name        = "vockey"                # Clave privada
  security_groups = [aws_security_group.sg_frontend.name]

  tags = {
    Name = "ec2_frontend_01"
  }
}

# ------ Frontend-02 ------
resource "aws_instance" "ec2_frontend_02" {
  ami             = "ami-00874d747dde814fa" # AMI de la instancia (SO)
  instance_type   = "t2.medium"             # Características de la instancia
  key_name        = "vockey"                # Clave privada
  security_groups = [aws_security_group.sg_frontend.name]

  tags = {
    Name = "ec2_frontend_02"
  }
}

# ------ Backend ------
resource "aws_instance" "ec2_backend" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.medium"
  key_name        = "vockey"
  security_groups = [aws_security_group.sg_backend.name]

  tags = {
    Name = "ec2_backend"
  }
}

# ------ NFS Server ------
resource "aws_instance" "ec2_nfs" {
  ami                    = "ami-00874d747dde814fa"
  instance_type          = "t2.small"
  key_name               = "vockey"
  security_groups = [aws_security_group.sg_nfs.name]

  tags = {
    Name = "ec2_nfs"
  }
}

# ----- Balanceador de carga ------
resource "aws_instance" "ec2_balancer" {
  ami                    = "ami-00874d747dde814fa"
  instance_type          = "t2.small"
  key_name               = "vockey"
  security_groups = [aws_security_group.sg_balancer.name]

  tags = {
    Name = "ec2_balancer"
  }
}

# --------- IP elástica ---------

# Crear la IP elástica
resource "aws_eip" "elastic_ip" {
  instance = aws_instance.ec2_balancer.id # Asociación de la EIP con la instancia -> Frontend
}

# Mostrar la IP pública de la instancia
output "elastic_ip" {
  value = aws_eip.elastic_ip.id
} 