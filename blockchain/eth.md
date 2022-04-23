### 下载安装Geth
ubuntu
```
apt-get install software-properties-common
add-apt-repository -y ppa:ethereum/ethereum
apt-get update
apt-get install ethereum
```
mac
```
brew tap ethereum/ethereum
brew install ethereum
```
### 配置文件
genesis.json
```
{
  "config": {
    "chainId": 999,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0
  },
  "alloc": {},
  "coinbase": "0x0000000000000000000000000000000000000000",
  "difficulty": "0x02000",
  "extraData": "",
  "gasLimit": "0x2fefd8",
  "nonce": "0x0000000000000042",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00"
}
```
关于JSON文件参数的解释


|参数|描述|
|----|---|
mixhash|  与nonce配合用于挖矿，由上一个区块的一部分生成的hash。注意他和nonce的设置需要满足以太坊的黄皮书描述条件
nonce| nonce就是一个64位随机数，用于挖矿，注意他和mixhash的设置需要满足以太坊的黄皮书描述的条件
difficulty|设置当前区块的难度，如果难度过大，cpu挖矿就很难，这里设置较小难度
alloc|用来预置账号以及账号的以太币数量，因为私有链挖矿比较容易，所以我们不需要预置有币的账号，需要的时候自己创建即可以。
coinbase|矿工的账号，随便填
timestamp |设置创世块的时间戳
parentHash|上一个区块的hash值，因为是创世块，所以这个值是0
extraData|附加信息，随便填，可以填你的个性信息
gasLimit|该值设置对GAS的消耗总量限制，用来限制区块能包含的交易信息总和。

### 在以上genesis.json的目录执行初始化命令
```
# 设置私链配置
./geth --datadir mychain init genesis.json

# 后台启动私链，暴露的端口经常会被攻击
nohup ./geth --cache 512 --nodiscover --datadir mychain --networkid 999 --http --http.addr "0.0.0.0" --http.port "8546" --port "30304" --http.api eth,net,web3 --http.corsdomain '*' --http.vhosts '*' --ipcpath "/root/gethchain/mychain/geth.ipc" --allow-insecure-unlock > geth.log 2>&1 &

# 登陆已经启动的私链
./geth attach --datadir mychain

#创建用户
personal.newAccount()

#查询用户
personal.listAccounts 
eth.accounts

#检查连接状态
net.listening 

#查看对等节点连接数量
net.peerCount 

#查看所连接的私有链	
net.version

#查看自己的Enode（把自己的Enode暴露出去，可以让别人添加你的节点，让别人连入你搭建的私有链网络 ）
admin.nodeInfo 

#查看自己连接的节点（这个命令可以查看自己连接了那些对端节点，这里仅仅是网络自发现的节点）
admin.peers      

#添加别人的节点（admin.nodeInfo可以看字enode信息格式）
admin.addPeer("enode://xxx@ip:port") 

#启动挖矿（x是启动几个核心来挖矿）
miner.start(x) 

#停止挖矿
miner.stop()

#查看挖矿账户余额         	
eth.getBalance("0xa950ea90ed07ec08c43612290dabde4b46028aaf")
eth.getBalance(eth.accounts[0])

#余额转换
web3.fromWei(eth.getBalance(eth.accounts[0]),'ether')      
    
#设置挖矿账户    	
miner.setEtherbase(eth.accounts[0])

#成功挖到一次矿后就停止
miner.start(1);admin.sleepBlocks(1);miner.stop()      
         
#查看转账交易
eth.getTransaction("xxxx")

#查看区块信息	
eth.getBlock(999)

# 执行交易
eth.sendTransaction({from: eth.accounts[0], to: "0x5C22DF3d1361824E0856469dF0Bb202A76b762b1", value: "2000000000000000000"})
```
