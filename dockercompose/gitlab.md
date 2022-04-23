## gitlab docs
- https://docs.gitlab.com/ee/install/docker.html
## 设置gitlab home目录
```
GITLAB_HOME=/srv/gitlab
```
## docker-compose.yml
```yml
version: '3.6'
services:
  web:
    container_name: gitlab
    image: 'gitlab/gitlab-ee:latest'
    restart: always
    hostname: '192.168.0.10'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://192.168.0.10:10101'
        gitlab_rails['gitlab_shell_ssh_port'] = 12422
    ports:
      - '10101:10101'
      - '12422:22'
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
    shm_size: '256m'
```
- ip可用域名代替

## 查看初始密码
`sudo docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password`


### gitlab使用drone
1. gitlab 安装
2. drone 安装
3. drone-runner 安装
4. 创建代码库，且在代码库根目录添加.drome.yml
