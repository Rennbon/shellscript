# docker-compose.yml
```yml
version: '3.1'

services:
  db:
    image: postgres:latest
    container_name: postgres
    restart: always
    environment:
      - POSTGRES_PASSWORD=111111
      - TZ=Asia/Shanghai
    volumes:
      - "/opt/postgresql/data:/var/lib/postgresql/data"
    ports:
      - "5432:5432"
```
