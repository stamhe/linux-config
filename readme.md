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

### 以指定用户运行命令
```
runuser -l git -s /bin/bash -c '/data/gitea/gitea web'
```

### ElasticSearch 相关命令
```
/usr/bin/filebeat -c /etc/filebeat/filebeatapi.yml
/usr/share/logstash/bin/logstash --path.settings /etc/logstash/ -f /etc/logstash/logstash.conf

从命令行输入测试logstash
/usr/share/logstash/bin/logstash -e 'input { stdin{} } output { file { path => "/tmp/logstash-data-%{+YYYYMMdd}.log"}}'


/usr/share/logstash/bin/logstash -e 'input { stdin{} } filter { grok { match => { "message" => "(?<datetime>\[(.*?)\])\s*(?<log_level>\[(.*?)\])\s*(?<trace_id>(.*?))\s* %{GREEDYDATA}"}  }} output { file { path => "/tmp/logstash-data-%{+YYYYMMdd}.log"}}'


/usr/share/logstash/bin/logstash -e 'input { stdin{} } filter { grok { match => { "message" => "(?<datetime>\[(.*?)\])\s*(?<log_level>\[(.*?)\])\s*(?<trace_id>(.*?))\s* %{GREEDYDATA}"}  }} output { elasticsearch { hosts => [ "192.168.1.1:9200", "192.168.1.2:9200", "192.168.1.3:9200" ] index => "stamhe-%{+YYYYMMdd}" }}'

验证 logstash 配置文件有效性
/usr/share/logstash/bin/logstash --path.settings /etc/logstash/ -f /etc/logstash/logstash.conf --config.test_and_exit



```
