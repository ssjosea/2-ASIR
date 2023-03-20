# Ejercicio 13.2

## José Antonio Estrella Tijeras - 2º ASIR

```
 practica-13.2
        .
        ├── ejercicio-01 ── 2-level-template.yml
        └── ejercicio-02 ── nfs-server-template.yml
```

Esta práctica tiene el objetivo de automátizar la creación de la infraestructura necesaria para crear una arquitectura mediante el uso de AWS CloudFormation; Permite crear y aprovisionar implementaciones de infraestructura de AWS de forma repetida.

La infraestructura del **primer ejercicio** es la siguiente:

- 1 Front-End con la pila LAMP que mostrará la web pública.

- 1 Back-End con MySQL para la creación y la gestión de una base de datos -> Necesario habilitar el puerto MySQL/Aurora en las reglas de entrada (3306).

- **Contenido ejercicio-01:**

    - ``ec2-backend``: Script para automátizar la creación de la instancia Backend, crear el grupo de seguridad con el puerto SSH, HTTP, HTTPS y MySQL (3306).

    ```yaml
    AWSTemplateFormatVersion: '2010-09-09'
    Description: |
    Esta plantilla crea un grupo de seguridad con los puertos 22, 80, 443 y 3306 (MySQL) abiertos,
    crea una instancia EC2 con la AMI de Ubuntu Server 22.04 y le asocia el grupo de seguridad.
    Resources:
    MySecurityGroup:
        Type: AWS::EC2::SecurityGroup
        Properties:
        GroupName: sg_backend
        GroupDescription: Grupo de seguridad de la instancia Backend
        SecurityGroupIngress:
            - IpProtocol: tcp
            FromPort: 22
            ToPort: 22
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 80
            ToPort: 80
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 443
            ToPort: 443
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 3306
            ToPort: 3306
            CidrIp: 0.0.0.0/0
    MyEC2Instance:
        Type: AWS::EC2::Instance
        Properties:
        ImageId: ami-06878d265978313ca
        InstanceType: t2.medium
        SecurityGroups:
            - !Ref MySecurityGroup
        KeyName: vockey
        Tags:
            - Key: Name
            Value: backend
    ```
    #


    - ``ec2-frontend-01``: Script para automátizar la creación de la instancia Frontend-01, crear el grupo de seguridad con el puerto SSH, HTTP, HTTPS.

    ```yaml
    AWSTemplateFormatVersion: '2010-09-09'
    Description: |
    Esta plantilla crea un grupo de seguridad con los puertos 22, 80 y 443 abiertos,
    crea una instancia EC2 con la AMI de Ubuntu Server 22.04 y le asocia el grupo de seguridad.
    Resources:
    MySecurityGroup:
        Type: AWS::EC2::SecurityGroup
        Properties:
        GroupName: sg_frontend
        GroupDescription: Grupo de seguridad de la instancia Frontend-01
        SecurityGroupIngress:
            - IpProtocol: tcp
            FromPort: 22
            ToPort: 22
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 80
            ToPort: 80
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 443
            ToPort: 443
            CidrIp: 0.0.0.0/0
    MyEC2Instance:
        Type: AWS::EC2::Instance
        Properties:
        ImageId: ami-06878d265978313ca
        InstanceType: t2.medium
        SecurityGroups:
            - !Ref MySecurityGroup
        KeyName: vockey
        Tags:
            - Key: Name
            Value: frontend


La infraestructura del **segundo ejercicio** es la siguiente:

- Servidor NFS: Compartir con los clientes NFS la instalación necesaria. Serán la cara pública de la arquitectura. -> Necesario habilitar el puerto NFS en las reglas de entrada (2048)

- 2 Front-End que a la vez serán clientes NFS que montarán el directorio / del servidor NFS y mostrarán la web.

- 1 balanceador de carga que recibirá las peticiones HTTPS y las distribuirá entre los dos Front-End.

- 1 Back-End con MySQL para la creación y la gestión de una base de datos -> Necesario habilitar el puerto MySQL/Aurora en las reglas de entrada (3306).

- **Contenido ejercicio-02:**

    - ``ec2-backend``: Script para automátizar la creación de la instancia Backend, crear el grupo de seguridad con el puerto SSH, HTTP, HTTPS y MySQL (3306).

    ```yaml
    AWSTemplateFormatVersion: '2010-09-09'
    Description: |
    Esta plantilla crea un grupo de seguridad con los puertos 22, 80, 443 y 3306 (MySQL) abiertos,
    crea una instancia EC2 con la AMI de Ubuntu Server 22.04 y le asocia el grupo de seguridad.
    Resources:
    MySecurityGroup:
        Type: AWS::EC2::SecurityGroup
        Properties:
        GroupName: sg_backend
        GroupDescription: Grupo de seguridad de la instancia Backend
        SecurityGroupIngress:
            - IpProtocol: tcp
            FromPort: 22
            ToPort: 22
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 80
            ToPort: 80
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 443
            ToPort: 443
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 3306
            ToPort: 3306
            CidrIp: 0.0.0.0/0
    MyEC2Instance:
        Type: AWS::EC2::Instance
        Properties:
        ImageId: ami-06878d265978313ca
        InstanceType: t2.medium
        SecurityGroups:
            - !Ref MySecurityGroup
        KeyName: vockey
        Tags:
            - Key: Name
            Value: backend
    ```
    #
    
    - ``ec2-balancer``: Script para automátizar la creación de la instancia balanceador de carga, crear el grupo de seguridad con el puerto SSH, HTTP, HTTPS y su IP elástica asociada a la instancia.
    
    ```yaml
    AWSTemplateFormatVersion: '2010-09-09'
    Description: |
    Esta plantilla crea un grupo de seguridad con los puertos 22, 80 y 443 abiertos,
    crea una instancia EC2 con la AMI de Ubuntu Server 22.04 y le asocia el grupo de seguridad.
    También crea una IP elástica y la asocia a la instancia EC2 mediante el recurso AWS::EC2::EIP.
    Resources:
    MySecurityGroup:
        Type: AWS::EC2::SecurityGroup
        Properties:
        GroupName: sg_load_balancer
        GroupDescription: Grupo de seguridad del balanceador de carga
        SecurityGroupIngress:
            - IpProtocol: tcp
            FromPort: 22
            ToPort: 22
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 80
            ToPort: 80
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 443
            ToPort: 443
            CidrIp: 0.0.0.0/0
    MyEC2Instance:
        Type: AWS::EC2::Instance
        Properties:
        ImageId: ami-06878d265978313ca
        InstanceType: t2.medium
        SecurityGroups:
            - !Ref MySecurityGroup
        KeyName: vockey
        Tags:
            - Key: Name
            Value: load-balancer
    MyEIP:
        Type: AWS::EC2::EIP
        Properties:
        InstanceId: !Ref MyEC2Instance
    ```
    #

    - ``ec2-frontend-01``: Script para automátizar la creación de la instancia Frontend-01, crear el grupo de seguridad con el puerto SSH, HTTP, HTTPS.

    ```yaml
    AWSTemplateFormatVersion: '2010-09-09'
    Description: |
    Esta plantilla crea un grupo de seguridad con los puertos 22, 80 y 443 abiertos,
    crea una instancia EC2 con la AMI de Ubuntu Server 22.04 y le asocia el grupo de seguridad.
    Resources:
    MySecurityGroup:
        Type: AWS::EC2::SecurityGroup
        Properties:
        GroupName: sg_frontend_01
        GroupDescription: Grupo de seguridad de la instancia Frontend-01
        SecurityGroupIngress:
            - IpProtocol: tcp
            FromPort: 22
            ToPort: 22
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 80
            ToPort: 80
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 443
            ToPort: 443
            CidrIp: 0.0.0.0/0
    MyEC2Instance:
        Type: AWS::EC2::Instance
        Properties:
        ImageId: ami-06878d265978313ca
        InstanceType: t2.medium
        SecurityGroups:
            - !Ref MySecurityGroup
        KeyName: vockey
        Tags:
            - Key: Name
            Value: frontend-01
    ```
    #

    - ``ec2-frontend-02``: Script para automátizar la creación de la instancia Frontend-02, crear el grupo de seguridad con el puerto SSH, HTTP, HTTPS.

    ```yaml
    AWSTemplateFormatVersion: '2010-09-09'
    Description: |
    Esta plantilla crea un grupo de seguridad con los puertos 22, 80 y 443 abiertos,
    crea una instancia EC2 con la AMI de Ubuntu Server 22.04 y le asocia el grupo de seguridad.
    Resources:
    MySecurityGroup:
        Type: AWS::EC2::SecurityGroup
        Properties:
        GroupName: sg_frontend_02
        GroupDescription: Grupo de seguridad de la instancia Frontend-02
        SecurityGroupIngress:
            - IpProtocol: tcp
            FromPort: 22
            ToPort: 22
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 80
            ToPort: 80
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 443
            ToPort: 443
            CidrIp: 0.0.0.0/0
    MyEC2Instance:
        Type: AWS::EC2::Instance
        Properties:
        ImageId: ami-06878d265978313ca
        InstanceType: t2.medium
        SecurityGroups:
            - !Ref MySecurityGroup
        KeyName: vockey
        Tags:
            - Key: Name
            Value: frontend-02
    ```
    #

    - ``ec2-nfs-server``:Script para automátizar la creación de la instancia Backend, crear el grupo de seguridad con el puerto SSH, HTTP, HTTPS y NFS (2048).

    ```yaml
    AWSTemplateFormatVersion: '2010-09-09'
    Description: |
    Esta plantilla crea un grupo de seguridad con los puertos 22, 80, 443 y 2048 (NFS) abiertos,
    crea una instancia EC2 con la AMI de Ubuntu Server 22.04 y le asocia el grupo de seguridad.
    Resources:
    MySecurityGroup:
        Type: AWS::EC2::SecurityGroup
        Properties:
        GroupName: sg_nfs_server
        GroupDescription: Grupo de seguridad del servidor NFS
        SecurityGroupIngress:
            - IpProtocol: tcp
            FromPort: 22
            ToPort: 22
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 80
            ToPort: 80
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 443
            ToPort: 443
            CidrIp: 0.0.0.0/0
            - IpProtocol: tcp
            FromPort: 2048
            ToPort: 2048
            CidrIp: 0.0.0.0/0
    MyEC2Instance:
        Type: AWS::EC2::Instance
        Properties:
        ImageId: ami-06878d265978313ca
        InstanceType: t2.medium
        SecurityGroups:
            - !Ref MySecurityGroup
        KeyName: vockey
        Tags:
            - Key: Name
            Value: nfs-server
    ```
    #
