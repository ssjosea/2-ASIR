# Ejercicio 3

## Jose A. Estrella Tijeras

Para esta practica, vamos a usar los scripts de la primera practica: **script.sh** y **script_tools.sh** para instalar las herramientas basicas que usaremos en nuestra instancia: Apache, MySQL, PHP...

> **script.sh**

![](https://github.com/ssjosea/practica-03/blob/main/images/script-sh.png)

> **script_tools.sh**
![](https://github.com/ssjosea/practica-03/blob/main/images/script-tools1.png)

![](https://github.com/ssjosea/practica-03/blob/main/images/script-tools2.png)

![](https://github.com/ssjosea/practica-03/blob/main/images/script-tools3.png)

Una vez ejecutados ambos scripts, vamos a crear un tercero en el que con la ayuda de un repositorio de GitHub importaremos una base de datos y la cargaremos como nuestro **index.php**.

Ejecutamos el **script_lamp.sh**

> **script_lamp.sh**

![](https://github.com/ssjosea/practica-03/blob/main/images/script-lamp.png)

Una vez hecho esto, reiniciamos el servicio Apache:
 > **sudo systemctl restart apache2**

 Si ahora entramos a nuestra página web con nuestra IP nos aparecerá una base de datos basada en LAMP:

![](https://github.com/ssjosea/practica-03/blob/main/images/pag_web.png)
