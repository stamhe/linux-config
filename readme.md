# 常用 Linux 基础配置

### Linux 常用的文件加密解密命令示例
```
！！！不要用 zip 加密文件，有严重安全性问题！！！
######## gpg
注意：多个文件或者文件夹需要使用 tar 打包配合
gpg --version 查看所有支持的算法
--symmetric, -c 使用对称加密算法加密数据
--passphrase 对称加密的加密密码
--passphrase-file 对称机密的加密密码文件，只读取文件的第一行，其他使用跟 --passphrase 完全一致.
--batch        在 gpg2.0 以上版本，使用了 --passphrase 选项必须同时带上 --batch 参数.
--personal-cipher-preferences 推荐使用此参数指定对称加密算法，默认为 AES-256, gpg --version 可以看到支持的所有对称对称加密算法.
加密
gpg -c -o t.txt-encrypt-passphrase     t.txt
gpg -c --passphrase "test123" --batch -o t.txt-encrypt-passphrase   t.txt
tar cvfp  - maindirname t.txt | gpg -c -o maindirname.tar.gpg
tar cvfp  - maindirname t.txt | gpg -c --passphrase "test123" --batch -o maindirname.tar.gpg
tar cvfp  - maindirname t.txt | gpg -c --passphrase "test123" --batch --personal-cipher-preferences AES256  -o maindirname.tar.gpg

解密
gpg -d -o t.txt-src-passphrase  t.txt-encrypt-passphrase
gpg -d --passphrase "test123" --batch -o   t.txt-src-passphrase   t.txt-encrypt-passphrase
gpg -d maindirname.tar.gpg | tar xvf  -

######## openssl 
注意：文件夹需要使用 tar 打包配合
openssl enc  -list   参看支持的所有加密算法
加密
ENC：加密
-a: 对加密后的文件使用 base64 进行编解码操作.
-AES-256-CBC：该算法被使用，推荐 aes-256-cbc 或者 aes-256-cfb
-in：文件的完整路径进行加密。
-e: 加密
-d：解密。
-k: 明文指定加密密码(自动化工具)，不指定此参数，就会交互提示输入密码.
-salt: 是否使用盐值，默认使用.
-pass: 选择其他输入加密密码的方式，可以是标准输入，文件，变量等. 
openssl enc -aes-256-cbc -salt -e -in /data/tmp/t.txt -out  /data/tmp/t.txt.encrypt
openssl enc -aes-256-cbc -salt -e -k "123456" -in /data/tmp/t.txt -out  /data/tmp/t.txt.encrypt

解密
openssl enc -aes-256-cbc -salt -d -in /data/tmp/t.txt.encrypt -out  /data/tmp/t.txt.src
openssl enc -aes-256-cbc -salt -d -k 123456 -in /data/tmp/t.txt.encrypt -out  /data/tmp/t.txt.src

对目录的支持，先使用 tar 打包
加密
tar cvfp   -  ./dirname | openssl enc -aes-256-cbc -salt -e -k "123456" -out  dirname.tar.encrypt
解密
openssl enc -aes-256-cbc -salt -d -k 123456 -in dirname.tar.encrypt | tar xvf  -


######## 7zip 默认 AES256 加密
apt-get install p7zip-full p7zip-rar -y
yum install p7zip p7zip-plugins

注意：原生支持压缩文件夹，但是 7zip 不支持备份文件 owner/group，需要使用 tar 配合保留原始 owner/group，如下:
tar cf - maindirname t.txt | 7za a -p123456 -si maindirname.tar.7z
7za x -p123456 -so maindirname.tar.7z | tar xvf -

加密
a: 添加
e: 解压缩(不带原始目录)
x: 解压缩(带原始目录)
-p: 设置密码
-mx=9: 压缩等级
-mhe:  加密文件名
-t7z: 文件类型 .7z
-r: 递归压缩文件夹，官方文档说不要使用此选项，不是想象的用途....不使用此选项，也可以递归压缩文件夹.
-y: 所有的询问都回答为 yes
7z a -p -mx=9 -mhe -t7z t.txt.7z  t.txt
7z a -p -mhe -t7z t.txt.7z  t.txt  dirname
7z a -p123456 -mhe -t7z t.txt.7z  t.txt  dirname
7z a -p123456 -t7z t.txt.7z  t.txt  dirname

解密
7za x t.txt.7z
7za x -p123456 t.txt.7z

查看压缩文件列表
7z l t.txt.7z
7z l -p"123456" t.txt.7z
7z l -slt t.txt.7z  可以看到加密算法, 7zAES:19表示AES-256 +（2 ^ 19）SHA-256迭代的密钥功能密码


```

### Linux 下反病毒软件
```
clamav 开源免费
https://github.com/Cisco-Talos/clamav
https://www.clamav.net

apt-get install clamav  clamav-daemon libclamunrar6 -y
yum install clamav

图形界面
apt-get install clamtk -y

卸载
apt-get remove clamav clamav-daemon clamtk libclamunrar6 -y
apt-get autoremove -y


更新 ClamAV 签名数据库
1. systemctl stop clamav-freshclam
2. freshclam 或者 wget https://database.clamav.net/daily.cvd  -O /var/lib/clamav/daily.cvd
3. systemctl start clamav-freshclam

扫描指定的文件夹
--infected, -i : 只打印感染的文件
--remove: 删除感染文件
--move: 隔离被感染的文件
--recursive, -r: 递归扫描子文件夹


clamscan --infected  --remove  --recursive  /home/stamhe/
clamscan -i  --remove  -r  /home/stamhe/


```


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

