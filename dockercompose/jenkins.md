# docker-compose.yml
```yml
version: '3'

services:
  jenkins:
    image: jenkins/jenkins:lts
    user: root
    container_name: jenkins
    volumes:
      - "/var/jenkins_home:/var/jenkins_home"
      - "/var/run/docker.sock:/var/run/docker.sock"
      - "/usr/bin/docker:/usr/bin/docker"
      - "/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt"
    environment:
      - TZ=Asia/Shanghai
    restart: always
    dns:
      - 192.168.1.247
      - 127.0.0.11
    ports:
      - "8080:8080"
      - "50000:50000"
```
