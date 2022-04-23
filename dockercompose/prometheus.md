### docker daemon.json
```
vim /etc/docker/daemon.json

//add
{
  "metrics-addr": "内网ip:9323",
  "experimental": true,
}

```
### docker-compose.yml
```yml
version: '3'

services:
  prometheus:
    image: prom/prometheus:v2.16.0
    container_name: prometheus
    command: --storage.tsdb.retention.time=1y --config.file="/etc/prometheus/prometheus.yml"  # 指定数据持久时间和指定配置文件，这里有Bug
    volumes:
      - "/opt/dockerc/prometheus/:/etc/prometheus/"    #配置挂载
      - "/opt/dockerc/prometheus/data:/prometheus"     #数据挂载
    environment:
      - TZ=Asia/Shanghai
    restart: always
    ports:
      - "9090:9090"
```
### prometheus.yml
> 配置案例
```yml
global:
  scrape_interval: 15s
  scrape_timeout: 10s
  evaluation_interval: 15s
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - 172.17.0.3:9093
    scheme: http
    timeout: 10s
    api_version: v1
rule_files:
- /etc/prometheus/rules.yml
scrape_configs:
- job_name: prometheus
  honor_timestamps: true
  scrape_interval: 5s
  scrape_timeout: 5s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - 0.0.0.0:9090
- job_name: docker
  honor_timestamps: true
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - 172.17.0.3:9323
- job_name: node-exporter
  honor_timestamps: true
  scrape_interval: 10s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - 172.17.0.3:9100
```
