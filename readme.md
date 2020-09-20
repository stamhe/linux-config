# 常用 Linux 基础配置
### DOH & DOT 信息
```
https://blog.skk.moe/post/which-public-dns-to-use/
https://github.com/curl/curl/wiki/DNS-over-HTTPS

国内 doh 服务器列表
https://dns.alidns.com/dns-query   阿里
https://doh.pub/dns-query   DNSPod
https://dns.rubyfish.cn/dns-query

https://doh.360.cn/dns-query   360
https://dns.containerpi.com/dns-query

国外 doh 服务器列表
https://dns.google/dns-query  google
https://cloudflare-dns.com/dns-query  cloudflare


https://dns.adguard.com/dns-query  adguard, 去广告
```

### Mac 命令行代理
```
方式一: 需要关闭 SIP 保护, 否则无效.
brew install proxychinas-ng
指定配置文件
export PROXYCHAINS_CONF_FILE=/etc/proxychains_mac.conf

方式二:
alias setproxy='export all_proxy=socks5://127.0.0.1:1088;export http_proxy=http://127.0.0.1:1089; export https_proxy=http://127.0.0.1:1089'
alias unsetproxy='unset all_proxy;unset http_proxy; unset https_proxy'
```
