### drone 环境变量
```
DRONE_SERVER_HOST=http://192.168.0.10:10100
DRONE_SERVER_PROTO=http
DRONE_RPC_SECRET=ansdas1231239sdkasd123llasd20
DRONE_GITLAB_CLIENT_ID= 64位Gitab client id
DRONE_GITLAB_CLIENT_SECRET= 64位Gitab client sectet
GITLAB_HOST=http://192.168.0.10:10101
```
# drone docker-compose.yml
```yml
version: '3.1'
services:
  drone:
    image: drone/drone:2
    container_name: drone
    ports:
      - 10100:80
    volumes:
      - /srv/drone/data:/data
    restart: always
    environment:
      - DRONE_SERVER_HOST=${DRONE_SERVER_HOST}
      - DRONE_SERVER_PROTO=${DRONE_SERVER_PROTO}
      - DRONE_RPC_SECRET=${DRONE_RPC_SECRET}

      - DRONE_GITLAB_SERVER=${GITLAB_HOST}
      - DRONE_GITLAB_CLIENT_ID=${DRONE_GITLAB_CLIENT_ID}
      - DRONE_GITLAB_CLIENT_SECRET=${DRONE_GITLAB_CLIENT_SECRET}
```


### drone-runner docker-compose.yml
```yml
version: '3.6'
services:
  runner:
    image: drone/drone-runner-docker:1
    container_name: drone-runner
    restart: always
    environment:
      - DRONE_RPC_PROTO=http
      - DRONE_RPC_HOST=192.168.0.10:10100
      - DRONE_RPC_SECRET=ansdas1231239sdkasd123llasd20
      - DRONE_RUNNER_CAPACITY=2
      - DRONE_RUNNER_NAME=god-runner
    ports:
      - "3000:3000"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
```
