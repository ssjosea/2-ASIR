# Ejercicio 9 - Implantación de Wordpress en Amazon Web Services (AWS) sobre la pila LAMP en tres fases

## Jose A. Estrella Tijeras

Para esta práctica el objetivo será implementar WordPress en tres fases:

 ```
    practica-09
         .
         ├── fase-0
         ├── fase-1
         └── fase-2
```

- ## **Fase 0:**
    - 1 instancia con la instalación de WordPress mediante Ansible.
    
    - **Contenido:**

        - **``ansible``**: 
            - ``deploy_wordpress.yml``
            - ``install_cerbot.yml``
            - ``install_lamp.yml``
            - ``inventario``
            - ``main.yml``
            - ``variables.yml``

        - **``conf``**
            - ``000-default.conf``
            - ``dir.conf``
        
        - **``scripts``**:
            - ``deploy_wordpress.sh``
            - ``install_lamp.sh``
            - ``variables.sh``

- ## **Fase 1:**

    ![](https://github.com/ssjosea/practica-09/blob/main/images/arquitectura-pr09-fase01.png)


    - 2 instancias con la instalación de WordPress mediante Ansible.

        - 1 Back-End con MySQL para la creación y la gestión de una base de datos. -> **Necesario habilitar el puerto MySQL/Aurora en las reglas de entrada (3306)**.
        - 1 Front-End con Apache donde instalaremos WordPress para mostrar la web.
    
    - **Contenido:**

        -  **``ansible``**: 
            - ``deploy_backend.yml``
            - ``deploy_wordpress.yml``
            - ``install_backend.yml``
            - ``install_cerbot.yml``
            - ``install_frontend.yml``
            - ``inventario``
            - ``main.yml``
            - ``variables.yml``

        - **``conf``**
            - ``000-default.conf``
            - ``dir.conf``
        
        - **``scripts``**:
            - ``deploy_backend.sh``
            - ``deploy_wordpress.sh``
            - ``install_backend.sh``
            - ``install_cerbot.sh``
            - ``install_frontend.sh``
            - ``variables.sh``
    
 - ## **Fase 2:**

    ![](https://github.com/ssjosea/practica-09/blob/main/images/arquitectura-pr09-fase02.png)


    - 5 instancias con la instalación de WordPress mediante Ansible agrupadas de la siguiente manera:

        - 1 servidor NFS desde el que instalaremos WordPress y lo "compartiremos" con los clientes NFS, que serán la cara pública de la arquitectura. -> **Necesario habilitar el puerto NFS en las reglas de entrada (2048)**
        - 2 **Front-End** que a la vez serán clientes **NFS** que montarán el directorio **/wordpress** del servidor NFS y mostrarán la web.
        - 1 balanceador de carga que recibirá las peticiones HTTPS y las distribuirá entre los dos Front-End.
        - 1 Back-End con MySQL para la creación y la gestión de una base de datos -> **Necesario habilitar el puerto MySQL/Aurora en las reglas de entrada (3306)**.

    - **Contenido:**

        -  **``ansible``**: 
            - ``deploy_backend.yml``
            - ``deploy_wordpress.yml``
            - ``install_backend.yml``
            - ``install_balancer.yml``
            - ``install_cerbot.yml``
            - ``install_frontend.yml``
            - ``install_nfs_client.yml``
            - ``install_nfs.yml``
            - ``inventario``
            - ``main.yml``
            - ``variables.yml``

        - **``balancer-conf``**
            - ``000-default.conf``
        
        - **``conf``**
            - ``000-default.conf``
            - ``dir.conf``
            - ``exports``
        
        - **``scripts``**:
            - ``deploy_backend.sh``
            - ``deploy_wordpress.sh``
            - ``install_backend.sh``
            - ``install_balancer.sh``
            - ``install_cerbot.sh``
            - ``install_frontend.sh``
            - ``install_nfs_client.sh``
            - ``install_nfs.sh``
            - ``variables.sh``
