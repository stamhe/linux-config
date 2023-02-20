# ipv6 知识点

### 申请ipv6
```
https://tunnelbroker.net/
apt install netplan.io



netplan apply

network:                                                                                                                                    
    ethernets:                                                                                                                              
        ens3:                                                                                                                               
            match:                                                                                                                          
                macaddress: 56:14:69:ec:1b:8d
            addresses: [45.141.138.34/24]
            gateway4: 45.141.138.1
            nameservers:
                addresses: [8.8.8.8, 1.1.1.1]
            dhcp4: false
            dhcp6: false

    version: 2
    renderer: networkd

    tunnels:
        he-ipv6:
            mode: sit
            remote: 74.82.46.6
            local: 45.141.138.34
            addresses:
                - "2001:470:23:3a3::2/64"
            routes:
                - to: default
                  via: "2001:470:23:3a3::1"

```

### 基础知识
```

我们设置了 IPv4 的优先级高于 IPv6。
方法很简单，就是在 /etc/gai.conf 中加入 precedence ::ffff:0:0/96 100 就行了。

显示ipv6 地址
ip -6 addr show
路由表
ip -6 route show
netstat -A inet6 -rn

ping 本地环回接口
ping6 ::1
ping6 ipv6.google.com

traceroute
traceroute ipv6.google.com
traceroute ::1

ipv6 与 ipv4 监听区分开
vim /etc/sysct.conf
net.ipv6.bindv6only=1

nginx
listen [1341:8954:a389:33:ba33::1]:80 ipv6only=on;
listen 111.111.111.111:80;

```
