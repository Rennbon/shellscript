### 官网
https://github.com/CodisLabs/codis

### 使用zookeeper管理
dashboard.toml 配置修改
```
coordinator_name = "zookeeper"
coordinator_addr = "10.0.0.1:2181"
coordinator_auth = "" 

product_name = "codis_name"  //允许加入的proxy需要
```


```
nohup ./bin/codis-dashboard --ncpu=4 \
--config=./config/dashboard.toml \
--log=./log/dashboard.log --log-level=WARN &

nohup ./bin/codis-proxy --ncpu=4 \
--config=./config/proxy.toml \
--log=./log/proxy.log --log-level=WARN &
    
nohup ./bin/codis-fe --ncpu=4 \
--log=./log/fe.log --log-level=WARN \
--zookeeper=127.0.0.1:2181 \
--listen=127.0.0.1:9091 &



nohup ./bin/codis-server ./config/redis1.conf &


nohup ./bin/codis-server ./config/sentinel1.conf --sentinel &
```

### kill -9 时zookeeper注册的product不会被删除，需要
```
./codis-admin --remove-lock --product="productName" --zookeeper=10.0.0.1
```

