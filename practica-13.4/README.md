# Ejercicio 13.4

## José Antonio Estrella Tijeras - 2º ASIR

```
 practica-13.4
        .
        ├── ejercicio-01
        │   ├── create_sg_&_instance.yml
        │   ├── delete_sg_&_instance.yml
        │   └── vars.yml
        ├── ejercicio-02
        │   ├── create_sg_&_instance.yml
        │   ├── delete_sg_&_instance.yml
        │   └── vars.yml
        └── README.md
```

En esta práctica vamos a usar Ansible para replicar y eliminar la creación de la arquitectura de las prácticas 7 y 9 del primer trimestre.

- [`ejercicio-01`](https://github.com/ssjosea/practica-13.4/tree/main/ejercicio-01): Creamos la arquitectura de la práctica 7 con dos instancias EC2 -> **Frontend** y **Backend**

- [`ejercicio-02`](https://github.com/ssjosea/practica-13.4/tree/main/ejercicio-02): Creamos la arquitectura de la práctica 9 con cinco instancias EC2 -> **Frontend-01** / **Frontend-02**, **Backend**, **balanceador de carga** y **servidor NFS**

Como vamos a desplegarlo de forma local en las opciones de **hosts** y **connection** usaremos local.

```yaml
- name: Playbook para crear una infraestructura con grupos de seguridad en Ansible
  hosts: localhost
  connection: local
  gather_facts: false
```

