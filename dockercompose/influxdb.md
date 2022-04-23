# docker-compose.yml
```yml
version: '3.1'

services:
  db:
    image: influxdb:latest
    container_name: influxdb
    restart: always
    environment:
      - INFLUXDB_ADMIN_ENABLED=true
      - INFLUXDB_ADMIN_USER=admin
      - INFLUXDB_ADMIN_PASSWORD=111111
      - INFLUXDB_HTTP_AUTH_ENABLED=true
      - TZ=Asia/Shanghai
    volumes:
      - "/opt/influxdb/influxdb.conf:/etc/influxdb/influxdb.conf"
      - "/opt/influxdb:/var/lib/influxdb"
    ports:
      - "5432:5432"
```
