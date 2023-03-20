# Ejercicio 15

## Jose A. Estrella Tijeras - 2º ASIR

En esta práctica con un fichero Docker-Compose vamos a acceder a InfluxDB mediante conexión local y a agregar datos desde el terminal para comprobar que funciona la siguiente arquitectura:

- **`MQTT`**: **(MQ Telemetry Transport)** es un protocolo de mensajería estándar utilizado en las aplicaciones de Internet de las cosas (IoT). Se trata de un protocolo de mensajería muy ligero basado en el patrón publish/subscribe, donde los mensajes son publicados en un topic de un MQTT Broker que se encargará de distribuirlos a todos los suscriptores que se hayan suscrito a dicho topic.

- **`Telegraf`**: es un agente que nos permite recopilar y reportar métricas. Las métricas recogidas se pueden enviar a almacenes de datos, colas de mensajes o servicios como InfluxDB.

### **Docker-Compose de Telegraf**

```yaml
    telegraf:
      image: telegraf:1.18
      volumes:
        - ./telegraf/telegraf.conf:/etc/telegraf/telegraf.conf
      depends_on: 
        - influxdb
```

- **`InfluxDB`**: es un sistema gestor de bases de datos diseñado para almacenar bases de datos de series temporales (TSBD - Time Series Databases). Estas bases de datos se suelen utilizar en aplicaciones de monitorización, donde es necesario almacenar y analizar grandes cantidades de datos con marcas de tiempo, como pueden ser datos de uso de cpu, uso memoria, datos de sensores de IoT, etc.

### **Docker-Compose de InfluxDB**

```yaml

 influxdb:
    image: influxdb:1.8
    ports:
      - 8086:8086
    volumes:
      - influxdb_data:/var/lib/influxdb
    environment:
      - INFLUXDB_DB=${INFLUXDB}
      - INFLUXDB_ADMIN_USER=${INFLUXDB_USERNAME}
      - INFLUXDB_ADMIN_PASSWORD=${INFLUXDB_PASSWORD}
      - INFLUXDB_HTTP_AUTH_ENABLED=true

```

- **`Grafana`** es un servicio web que nos permite visualizar en un panel de control los datos almacenados en InfluxDB y otros sistemas gestores de bases de datos de series temporales.

### **Docker-Compose de Grafana**

```yaml
 grafana:
    image: grafana/grafana:7.4.0
    ports:
      - 3000:3000
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana-provisioning/:/etc/grafana/provisioning
    depends_on:
      - influxdb
    environment:
      - GF_SECURITY_ADMIN_USER=${GRAFANA_USERNAME}
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD}
```

En este ejemplo nos vamos a suscribir al topic iescelia/ del broker MQTT test.mosquitto.org. Con el wildcard estamos indicando que queremos suscribirnos a todos los topics que existan dentro de iescelia/, es decir, todos los mensajes que se publiquen en cada una de las aulas.

Ten en cuenta que **tendrás que cambiar el broker** 192.168.22.127 **por la dirección IP de nuestro broker MQTT**.

```docker
docker run -it --rm efrecon/mqtt-client sub -h 192.168.22.127 -t "iescelia/#"
```
