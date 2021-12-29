# 申请证书
```
1. 安装
apt install certbot
2. 命令行执行
申请单一子域名证书
certbot certonly --manual -w /data/www/common -d test.stamhe.com

申请泛域名证书 - 通过 dns
certbot certonly --manual  -d  *.stamhe.com --server https://acme-v02.api.letsencrypt.org/directory --preferred-challenges dns

3. nginx 配置
test_stamhe_com.conf
```


