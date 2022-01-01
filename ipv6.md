# ipv6 知识点
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
