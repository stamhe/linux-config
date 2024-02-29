# redis sentinel 实战
### 参考文章
```
https://zhengxingtao.com/article/173/

https://www.jb51.net/database/287739y6h.htm

https://blog.csdn.net/nishuihan205259/article/details/113568986

Redis-Sentinel 如何开启域名解析 - 非常重要
https://juejin.cn/post/7087598539471224845



kvrocks 编译
https://github.com/apache/kvrocks

# Ubuntu / Debian
apt update
apt install -y git build-essential cmake libtool python3 libssl-dev


./x.py build -DENABLE_OPENSSL=ON



```

### 一主二从模式 - 证书 + tls 模式 - redis 需要 6.x 以上的版本
```
m.stamhe.com
s1.stamhe.com
s2.stamhe.com

# 连接主节点，查看复制状态
redis -h 127.0.0.1 -p 6666 -a 123456
info replication

-----------------------------------------

m.stamhe.com - master
port 6666
bind 0.0.0.0
protected-mode no
daemonize yes
logfile /data/app/redis/logs/redis-server.log
loglevel notice
pidfile /data/app/redis/logs/redis-server.pid

requirepass 123456


rdbchecksum yes
dir /data/app/redis/data
dbfilename redis.rdb
tcp-backlog 511

tls-port 6676
tls-cert-file /data/app/crt/stamhe.com-server.crt
tls-key-file /data/app/crt/stamhe.com-server.key
tls-ca-cert-file /data/app/crt/stamhe.com-ca.crt
tls-replication yes

replica-announce-ip m.stamhe.com
replica-announce-port 6676
slaveof "no one"



-----------------------------------------

s1.stamhe.com - slave	

port 6666
bind 0.0.0.0
protected-mode no
daemonize yes
logfile /data/app/redis/logs/redis-server.log
loglevel notice
pidfile /data/app/redis/logs/redis-server.pid

rdbchecksum yes
dir /data/app/redis/data/
dbfilename redis.rdb
tcp-backlog 511
replica-serve-stale-data yes
replica-read-only yes

requirepass 123456
masterauth 123456
slaveof m.stamhe.com 6676

tls-port 6676
tls-cert-file /data/app/crt/stamhe.com-server.crt
tls-key-file /data/app/crt/stamhe.com-server.key
tls-ca-cert-file /data/app/crt/stamhe.com-ca.crt
tls-replication yes

replica-announce-ip s1.stamhe.com
replica-announce-port 6676



-----------------------------------------
s2.stamhe.com - slave

port 6666
bind 0.0.0.0
protected-mode no
daemonize yes
logfile /data/app/redis/logs/redis-server.log
loglevel notice
pidfile /data/app/redis/logs/redis-server.pid

rdbchecksum yes
dir /data/app/redis/data/
dbfilename redis.rdb
tcp-backlog 511
replica-serve-stale-data yes
replica-read-only yes

requirepass 123456
masterauth 123456
slaveof m.stamhe.com 6676

tls-port 6676
tls-cert-file /data/app/crt/stamhe.com-server.crt
tls-key-file /data/app/crt/stamhe.com-server.key
tls-ca-cert-file /data/app/crt/stamhe.com-ca.crt
tls-replication yes

replica-announce-ip s2.stamhe.com
replica-announce-port 6676



```


### sentinel 3 节点模式 - 域名 + 证书 + tls  - redis-sentinel 需要 7.x 以上的版本
```


# 启动哨兵节点
redis-server redis-sentinel.conf --sentinel
或者
redis-sentinel redis-sentinel.conf

# 登录哨兵节点，查看状态
redis -h 127.0.0.1 -p 16666
info sentinel



port 16666
daemonize yes
logfile "/tmp/stamhe-sentinel.log"
sentinel resolve-hostnames yes
sentinel announce-hostnames yes
requirepass 123456
#masterauth 123456

tls-port 16676
tls-cert-file "/data/app/crt/stamhe.com-server.crt"
tls-key-file "/data/app/crt/stamhe.com-server.key"
tls-ca-cert-file "/data/app/crt/stamhe.com-ca.crt"
tls-replication yes

sentinel monitor stamhe-redis m.stamhe.com 6676 2
sentinel auth-pass stamhe-redis 123456

sentinel down-after-milliseconds stamhe-redis 15000
sentinel failover-timeout stamhe-redis 30000
sentinel parallel-syncs stamhe-redis 1




```


### 一主 二从模式 - 常规模式

```

# 连接主节点，查看复制状态
redis -h 127.0.0.1 -p 6379
info replication

-----------------------------------------

192.168.1.100 - master
port 6379
bind 0.0.0.0
protected-mode no
daemonize yes
logfile /data/logs/redis-server.log
loglevel notice
pidfile /data/logs/redis-server.pid

requirepass 123456


rdbchecksum yes
dir /var/lib/redis
dbfilename dump.rdb
tcp-backlog 511

-----------------------------------------

192.168.1.101 - slave	

port 6379
bind 0.0.0.0
protected-mode no
daemonize yes
logfile /data/logs/redis-server.log
loglevel notice
pidfile /data/logs/redis-server.pid

rdbchecksum yes
dir /var/lib/redis
dbfilename dump.rdb
tcp-backlog 511
replica-serve-stale-data yes
replica-read-only yes

masterauth 123456
replicaof 192.168.1.100 6379


-----------------------------------------
192.168.1.102 - slave

port 6379
bind 0.0.0.0
protected-mode no
daemonize yes
logfile /data/logs/redis-server.log
loglevel notice
pidfile /data/logs/redis-server.pid

rdbchecksum yes
dir /var/lib/redis
dbfilename dump.rdb
tcp-backlog 511
replica-serve-stale-data yes
replica-read-only yes

masterauth 123456
slaveof 192.168.1.100 6379



```

### sentinel 3 节点模式 - 常规
```

# 启动哨兵节点
redis-server redis-sentinel.conf --sentinel
或者
redis-sentinel redis-sentinel.conf

# 登录哨兵节点，查看状态
redis -h 127.0.0.1 -p 16380
info sentinel



redis-sentinel.conf
port 16379
daemonize yes
logfile "/tmp/redis-sentinel.log"
sentinel monitor my-redis-master 192.168.1.100 6379 2

# 如果 my-redis-master 设置了访问密码 - requirepass
sentinel auth-pass my-redis-master 123456


# 该选项指定了 Sentinel 认为服务器已经断线所需的毫秒数。如果服务器在给定的毫秒数之内， 没有返回 Sentinel 发送的 ping 命令的回复， 或者返回一个错误， 那么 Sentinel 将这个服务器标记为主观下线。 
# 单位：毫秒，默认 30000 - 所有 sentinel 节点这个参数需要保持一致
sentinel down-after-milliseconds my-redis-master 30000

# 该选项指定了在执行故障转移时， 最多可以有多少个从服务器同时对新的主服务器进行同步， 这个数字越小， 完成故障转移所需的时间就越长。
如果从服务器被设置为允许使用过期数据集（参见对 redis.conf 文件中对 slave-serve-stale-data 选项的说明）， 那么你可能不希望所有从服务器都在同一时间向新的主服务器发送同步请求， 因为尽管复制过程的绝大部分步骤都不会阻塞从服务器， 但从服务器在载入主服务器发来的 RDB 文件时， 仍然会造成从服务器在一段时间内不能处理命令请求： 如果全部从服务器一起对新的主服务器进行同步， 那么就可能会造成所有从服务器在短时间内全部不可用的情况出现。
你可以通过将这个值设为 1 来保证每次只有一个从服务器处于不能处理命令请求的状态。
sentinel parallel-syncs my-redis-master 1


# 指定故障转移超时时间（单位毫秒），默认3分钟，被用于下面四种场景：

场景1：假设现在某个master节点宕机，并且现在有5个slave节点。Sentinel集群通过选举算法选择3号slave节点晋升为master，但是这个3号slave一直晋升master节点失败（故障转移失败），如果在3分钟之内这个3号slave还是无法晋升为master节点，那么Sentinel集群会重新选择一个slave节点去晋升为master节点。如果重新选择的节点在6分钟之内无法晋升为master，Sentinel集群再次重新选择一个slave节点，以此类推。

场景2：旧的master已经宕机，新master已经上任。新master在刚开始上任时，slave节点并不会同步新master的数据，从Sentinel检测到相关错误时开始计时，会强制salve同步新master节点的数据，这时slave要在3分钟之内，把原来旧master节点的数据换成新master节点的数据。

场景3：旧的master已经宕机，Sentinel集群准备选择一个slave节点晋升为master节点。此时晋升master节点的命令已发出，但是在较短的时间内还没有产生任何配置信息的变化，就在这时Sentinel集群突然决定撤销这个slave晋升为新master，取消这个故障转移的时间为3分钟。

场景4：在进行故障转移时，所有slave节点同步新的master节点的数据所需的最大时间（3分钟）。如果同步时间超过了3分钟，那么sentinel parallel-syncs配置设置的值可能会无效，Sentinel会让更多的slave同时去同步新master节点的数据。
# 单位：毫秒, 默认 180000
sentinel failover-timeout my-redis-master 180000


# 指定是否可以通过命令 sentinel set 动态修改 notification-script 与 client-reconfig-script 两个脚本。默认是不能的（设置为yes）。这两个脚本如果允许动态修改，可能会引发安全问题。
sentinel deny-scripts-reconfig no
通过 redis-cli 连接上 Sentinel 后，通过 sentinel set 命令可动态修改配置信息。例如，上面的命令动态修改了 sentinel monitor 中的 quorum 的值。
例如 sentinel set my-redis-master quorum 1
sentinel set my-redis-master down-after-milliseconds 50000
sentinel set my-redis-master failover-timeout 300000
sentinel set my-redis-master parallel-syncs 3
sentinel set my-redis-master notification-script /var/redis/notify.sh
sentinel set my-redis-master client-reconfig-script /var/redis/reconfig.sh
sentinel set my-redis-master auth-pass 111


# SCRIPTS EXECUTION
# 配置当某一事件发生时所需要执行的脚本，可以通过脚本来通知管理员，例如当系统运行不正常时发邮件通知相关人员。
# 对于脚本的运行结果有以下规则：
# 若脚本执行后返回1，那么该脚本稍后将会被再次执行，重复次数目前默认为10
# 若脚本执行后返回2，或者比2更高的一个返回值，脚本将不会重复执行。
# 如果脚本在执行过程中由于收到系统中断信号被终止了，则同返回值为1时的行为相同。
# 一个脚本的最大执行时间为60s，如果超过这个时间，脚本将会被一个SIGKILL信号终止，之后重新执行。
# 通知型脚本: 当sentinel有任何警告级别的事件发生时（比如说redis实例的主观失效和客观失效等等），将会去调用这个脚本，这时这个脚本应该通过邮件，SMS等方式去通知系统管理员关于系统不正常运行的信息。调用该脚本时，将传给脚本两个参数，一个是事件的类型，一个是事件的描述。如果sentinel.conf配置文件中配置了这个脚本路径，那么必须保证这个脚本存在于这个路径，并且是可执行的，否则sentinel无法正常启动成功。
# 通知脚本
# shell编程
# sentinel notification-script <master-name> <script-path>
sentinel notification-script mymaster /var/redis/notify.sh

# 客户端重新配置主节点参数脚本
# 当一个master由于failover而发生改变时，这个脚本将会被调用，通知相关的客户端关于master地址已经发生改变的信息。
# 以下参数将会在调用脚本时传给脚本:
# <master-name> <role> <state> <from-ip> <from-port> <to-ip> <to-port>
# 目前<state>总是“failover”,
# <role>是“leader”或者“observer”中的一个。
# 参数 from-ip, from-port, to-ip, to-port是用来和旧的master和新的master(即旧的slave)通信的
# 这个脚本应该是通用的，能被多次调用，不是针对性的。
# sentinel client-reconfig-script <master-name> <script-path>
sentinel client-reconfig-script mymaster /var/redis/reconfig.sh





```

### Sentinel命令
```
# 展示所有被监控的主节点状态以及相关的统计信息
sentinel masters

# 展示指定<master name>的主节点状态以及相关的统计信息
sentinel master <master name>

# 展示指定<master name>的从节点状态以及相关的统计信息
sentinel slaves <master name>

# 展示指定<master name>的Sentinel节点集合（不包含当前Sentinel节点）
sentinel sentinels <master name>

# 返回指定<master name>主节点的IP地址和端口
sentinel get-master-addr-by-name <master name>

# 对指定<master name>主节点进行强制故障转移
sentinel failover <master name>

# 检测当前可达的Sentinel节点总数是否达到<quorum>的个数
sentinel ckquorum <master name>

# 取消当前Sentinel节点对于指定<master name>主节点的监控
sentinel remove <master name>

# 通过命令的形式来完成Sentinel节点对主节点的监控
sentinel monitor <master name> <ip> <port> <quorum>

# 动态修改Sentinel节点配置选项
sentinel set <master name>

# Sentinel节点之间用来交换对主节点是否下线的判断
# 根据参数的不同，还可以作为Sentinel领导者选举的通信方式
sentinel is-master-down-by-addr
```

### 手动新增/删除监控节点
```

no-tls:
sentinel monitor nochain-kvrocks m.stamhe.com 6666 2

tls:
sentinel monitor nochain-kvrocks m.stamhe.com 6676 2

redis-sentinel v6 之前
sentinel auth-pass nochain-kvrocks 123456


redis-sentinel v6 之后
sentinel set nochain-kvrocks auth-pass 123456

 
sentinel remove nochain-kvrocks



```