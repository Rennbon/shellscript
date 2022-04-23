# docker-compose.yml
```yml
version: '3.1'

services:
  db:
    image: redis:5.0
    container_name: redis
    restart: always
    environment:
      - TZ=Asia/Shanghai
    command: ["redis-server", "--appendonly", "yes","--requirepass","L1uh@7s8ExCGMObq"]
    volumes:
      - "/opt/docker/redis/data:/data"
    ports:
      - "6379:6379"
```
