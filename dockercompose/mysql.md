# docker-compose.yml
```yml
version: '3.1'

services:
  db:
    image: mysql:latest
    container_name: mysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=123456
      - TZ=Asia/Shanghai
    volumes:
      - "/var/lib/mysql:/var/lib/mysql"
    ports:
      - "3306:3306"

```

