# openssl

```
https://linux.cn/article-13368-1.html
https://www.cnblogs.com/gavin11/p/14302045.html
https://wangchujiang.com/linux-command/c/openssl.html


查看openssl提供的加密套件
openssl ciphers -V | column -t

选项说明：
-v：详细列出所有加密套件。包括ssl版本（SSLv2 、SSLv3以及 TLS）、密钥交换算法、身份验证算法、对称算法、摘要算法以及该算法是否可以出口。
-ssl2：只列出SSLv2使用的加密套件。
-ssl3：只列出SSLv3使用的加密套件。
-tls1：只列出tls使用的加密套件。
cipherlist：列出一个cipher list的详细内容。用此项能列出所有符合规则的加密套件，如果不加-v选项，它只显示各个套件名字；

输出结果说明：

第一列（0xC0,0x30）：这是一个两字节的id值，每一个加密套件都有一个id值
第二列(ECDHE-RSA-AES256-GCM-SHA384)：这是加密套件的名称
第三列（TLSv1.2）：该加密套件对应的ssl/tls版本
第四列（Kx）：key exchange 密钥交换算法
第五列（Au)：authentication服务器认证算法
第六列（Enc）：对称加密算法
第七列（Mac）：消息认证算法（摘要算法）



使用 openssl 生成密码
几乎所有 Linux 发行版都包含 openssl。我们可以利用它的随机功能来生成可以用作密码的随机字母字符串。
openssl rand -base64 20


用Blowfish的CFB模式加密plaintext.doc，口令从环境变量PASSWORD中取，输出到文件ciphertext.bin。
openssl bf-cfb -salt -in plaintext.doc -out ciphertext.bin -pass env:PASSWORD

给文件ciphertext.bin用base64编码，输出到文件base64.txt。
openssl base64 -in ciphertext.bin -out base64.txt



生成一组密钥对：
openssl genrsa -aes256 -out /tmp/alice_private.pem 2048
openssl genrsa -aes256 -out /tmp/bob_private.pem 2048


获取公钥的方法如下：
openssl rsa -in /tmp/alice_private.pem -noout -text


提取公钥，并将其保存到文件中：
openssl rsa -in /tmp/alice_private.pem -pubout > /tmp/alice_public.pem

私钥PEM转DER
openssl rsa -in /tmp/alice_private.pem -outform der -out /tmp/alice_private.der
-inform和-outform 参数制定输入输出格式，由der转pem格式同理

查看公钥详细信息，但是这次，输入公钥 .pem 文件：
openssl rsa -in /tmp/alice_public.pem -pubin -text -noout
或者
cat /tmp/alice_public.pem


使用公钥加密
echo "stamhe's bitcoin private key" > /tmp/top_secret.txt

openssl rsautl -encrypt -inkey /tmp/alice_public.pem -pubin -in /tmp/top_secret.txt -out /tmp/top_secret.enc
hexdump -C /tmp/top_secret.enc

使用私钥解密
openssl rsautl -decrypt -inkey /tmp/alice_private.pem -in /tmp/top_secret.enc > /tmp/top_secret.dec && cat /tmp/top_secret.dec


对称加密
openssl enc -e -aes-256-ctr -in /tmp/top_secret.txt -out /tmp/top_secret.enc
openssl enc -e -aes-256-ctr -salt -in /tmp/top_secret.txt -out /tmp/top_secret.enc -pass file:/tmp/password.key

对称解密
openssl enc -d -aes-256-ctr -in /tmp/top_secret.enc -out /tmp/top_secret.dec




```