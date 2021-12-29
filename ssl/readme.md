# 申请证书
```
1. 安装
apt install certbot

新建目录，存放申请证书的域名认证字符串文件
mkdir -p /data/www/common/.well-known/acme-challenge/

2. nginx 配置
test_stamhe_com.conf

记得执行
nginx -s reload

3. 命令行执行
申请单一子域名证书
certbot certonly --manual -w /data/www/common -d test.stamhe.com

申请泛域名证书 - 通过 dns
certbot certonly --manual  -d  *.stamhe.com --server https://acme-v02.api.letsencrypt.org/directory --preferred-challenges dns


4. 证书下来后，以后的正式使用，参考
ip_stamhe_com.conf
```

# 自动更新
```
定时任务执行 ssl_renew.sh 搭配 ssl_authorize.sh 会自动更新证书
注意：需要修改 ssl_authorize.sh 里面的信息为自己的
```


