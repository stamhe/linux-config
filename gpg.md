# gpg 加密使用

### 文章
```
https://segmentfault.com/a/1190000041007717
https://linux.cn/article-9524-1.html
https://blog.logc.icu/post/2020-08-02_09-39/
```

### 环境变量
```
修改 gpg 家目录，保证密钥的安全性
export GNUPGHOME=/data/gnupg
export GPG_TTY=$(tty)

更改配置后需要重新加载 agent
gpg-connect-agent reloadagent /bye


手动停止gpg-agent
gpgconf --kill gpg-agent

gpg-agent.conf 配置文件
# 设置缓存的有效时间, 单位秒，默认为600秒。每次访问都重新开始计时，前提是没有超出最大缓存时间，该时间通过 max-cache-ttl设置默认为2小时
default-cache-ttl 3600
max-cache-ttl 7200

enable-ssh-support

# 忽略所有缓存
ignore-cache-for-signing



agent 需要知道如何向用户索要密码，默认是使用一个 gtk dialog (gtk 对话框)。
在~/.gnupg/gpg-agent.conf配置文件中，可以通过pinentry-program配置你要采用的程序：
gpg-agent.conf
default-cache-ttl 14400
max-cache-ttl 86400

enable-ssh-support

# PIN entry program
# pinentry-program /usr/bin/pinentry-curses
# pinentry-program /usr/bin/pinentry-qt
# pinentry-program /usr/bin/pinentry-kwallet

pinentry-program /usr/bin/pinentry-gtk-2




mac 配置
brew install gnupg
brew install pinentry-mac # mac 的 gui 提示框

gpg-agent.conf
default-cache-ttl 14400
max-cache-ttl 86400

enable-ssh-support

# for mac
pinentry-program /opt/homebrew/bin/pinentry-mac



gpg.conf 
use-agent

.profile
export GNUPGHOME=/data/gnupg
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

禁用密码弹窗中的 keychain 默认勾选, 终端执行下面的命令， 然后重启终端
defaults write org.gpgtools.pinentry-mac DisableKeychain -bool yes
defaults write org.gpgtools.common DisableKeychain -bool yes


```

### 基本使用
```
基本使用
生成自己的密钥
gpg --gen-key
或 自定义参数
gpg --full-generate-key   
或专家模式
gpg --expert  --full-generate-key  


9DFF6C0E858DDFF9BE4C97256B1B52E8E88F5512 6B1B52E8E88F5512 E88F5512  stamhe@163.com
63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922 F61F25243F3C5922 3F3C5922  stamhe@gmail.com
fingerprint: 指纹，完整的 40 个字符的密钥标识符(9DFF6C0E858DDFF9BE4C97256B1B52E8E88F5512)
long: 长密钥 ID， 指纹的最后 16 个字符(6B1B52E8E88F5512)
short: 短密钥 ID， 指纹的最后 8 个字符(E88F5512)

信任分为几个不同的等级：
ultimate：终极信任。一般只应该对自己的密钥进行终极信任，可以理解为所有信任链的根节点。
full：完全信任。对于这个人签名的其他密钥，我也认可。
marginal：信了，但没完全信。这个人签名过的密钥，我不一定认可，但如果三个这样的人都签了，那我就信了。
never：不信任。这个人对其他密钥的签名，我一律视而不见。


列出系统中已有的密钥
--with-subkey-fingerprint 才会显示子密钥的指纹
gpg --list-keys
或者
gpg --list-public-keys, -k 查看公钥
gpg --list-secret-keys, -K 查看持有的私钥 uid 列表
gpg --fingerprint 打印密钥的指纹, 等价于 gpg -k --with-fingerprint, 使用空格分割，便于比对
gpg --list-sigs 打印密钥的签名，等价于 gpg -k --with-sig-list

显示子密钥的指纹
gpg --list-key --with-subkey-fingerprint 9DFF6C0E858DDFF9BE4C97256B1B52E8E88F5512
gpg --list-key --with-subkey-fingerprint 6B1B52E8E88F5512
gpg --with-keygrip -k 9DFF6C0E858DDFF9BE4C97256B1B52E8E88F5512



显示所有的已有密钥，同时显示签名(含有用户id)
gpg --list-sigs

删除某个密钥
--delete-keys 删除公钥
--delete-secret-keys 删除私钥
--delete-secret-and-public-keys 同时删除私钥和公钥
gpg --delete-keys  6B1B52E8E88F5512

修改钥匙的失效日期，加指纹，对钥匙签名等
gpg --edit-key  6B1B52E8E88F5512


导出公钥，.gnupg/pubring.kbx 默认为二进制, 不指定 <uid> 将会导出所有的公钥或者私钥。
使用【!】可以强制指定需要导出主密钥或者子密钥
--export, -o 导出公钥
--armor, -a 可以将其转换为 ascii 码显示【可以用于github等验证】
--export-options: backup 导出用于备份，会将信任值，本地签名等一起导出。 
gpg --armor  --output /data/public-key.txt  --export  6B1B52E8E88F5512
gpg -a -o /data/public-key.txt  --export 6B1B52E8E88F5512


导出子密钥的公钥，注意：最后的感叹号不能遗漏且子公钥的导出其实还包含主公钥。
gpg -a -o /data/public-sub-key.txt --export "3861C8C44D25274F!"


导出私钥
--export-secret-key 导出私钥
gpg --armor  --output  /data/private-key.txt  --export-secret-key  6B1B52E8E88F5512
gpg -a  -o  /data/private-key.txt  --export-secret-key  6B1B52E8E88F5512


导出子密钥的私钥.  最后需要加【!】，强制使用密钥 id 指定的密钥，而不是尝试轮训.
--export-secret-subkey 导出子私钥
gpg --armor  --output  /data/private-key-subkey.txt   --export-secret-subkey  "0x6B1B52E8E88F5512!"

或者使用 paperkey， 然后进行打印
gpg --export-secret-key 6B1B52E8E88F5512 | paperkey -o /data/private-key.txt


获取用户的公钥指纹
gpg --fingerprint  6B1B52E8E88F5512


导入公钥或者私钥，如果省略文件名，则从 stdin 读入
--import 导入密钥
--import-options: restore 恢复，与 导出选项的 backup 对应。 import-show 回显导入的密钥信息。
gpg --import  /data/public-key.txt   导入完毕以后，仔细核对 fingprint 是否全对
gpg --import  /data/private-key.txt  如果导入的私钥，则会要求输入密码解锁才能导入私钥



添加新的身份 uid
gpg --quick-add-uid 6B1B52E8E88F5512 "Stam He <xxx@gmail.com>"
或者
gpg --edit-key 6B1B52E8E88F5512
> adduid
> save

查看已经使用的 uid
gpg --list-key 6B1B52E8E88F5512
设置新的主uid，需要注意： gpg 会把最近新添加的 uid 作为主 uid
gpg --quick-set-primary-uid 6B1B52E8E88F5512 "Stam He <stamhe@163.com>"

添加图片标识/头像
gpg --edit-key 6B1B52E8E88F5512
> addphoto
> save



创建子密钥(参数必须是完整的指纹)
主密钥创建时，默认就会生成一对主密钥的【SC】和一对子密钥【E】
创建加密之密钥 - E
gpg --quick-add-key 9DFF6C0E858DDFF9BE4C97256B1B52E8E88F5512 rsa2048 encr 
创建签名子密钥 - S
gpg --quick-add-key 9DFF6C0E858DDFF9BE4C97256B1B52E8E88F5512 rsa2048 sign
创建授权子密钥 - A - 可以用于 ssh 验证
gpg --quick-add-key 9DFF6C0E858DDFF9BE4C97256B1B52E8E88F5512 rsa2048 auth
创建认证之密钥 - C - 认证其他子密钥或者 uid

查看子密钥信息
gpg --list-key --with-subkey-fingerprint 6B1B52E8E88F5512


上传公钥到公共公钥服务器   hkps://keys.openpgp.org  hkps://keyserver.ubuntu.com hkps://pgp.mit.edu
gpg --send-keys 6B1B52E8E88F5512
gpg --send-keys 6B1B52E8E88F5512   --keyserver  hkps://keys.openpgp.org
gpg --keyserver hkps://keys.openpgp.org --send-keys 6B1B52E8E88F5512
gpg --keyserver pgp.mit.edu --send-keys 6B1B52E8E88F5512
gpg --keyserver pgp.key-server.io --send-keys 6B1B52E8E88F5512

在公共公钥服务器找公钥
gpg  --keyserver  hkps://keys.openpgp.org  --search-keys  [用户id]


刷新公钥数据
gpg --refresh-keys



输出密钥的keygrip，【其实就是存放密钥的文件的文件名】
gpg --with-keygrip  --list-key  6B1B52E8E88F5512
ls -al ~/.gnupg/private-keys-v1.d/[keygrip].key



加密文件，使用接收方的公钥加密, 默认输出二进制. 
--recipient, -r 指定使用接受者的公钥加密，可以指定多个
--output, -o 输出到哪个文件，不指定就输出到标准输出
--armor, -a 将加密后的信息转为可以打印的ascii 字符
--encrypt, -e 执行加密动作, 默认输出二进制
--recipient-file, -f  指定收件人的公钥文件进行加密(这样就不用导入收件人的公钥到系统了)
--hidden-recipient, -R 指定收件人的公钥，但是在加密文件中隐藏收件人的公钥，本地使用私钥轮询尝试解密
--hidden-recipient-file, -F 指定收件人的公钥文件，但是在加密文件中隐藏收件人的公钥，本地使用私钥轮询尝试解密
--throw-keyids 要求gpg不将任何密钥id放入密文中，等同于指定所有收件人指定 --hidden-recipient
--try-secret-key 指定轮询解密时优先使用的密钥
gpg  --recipient   9372CEC627D8FC824D143D647CF26CF82A9DF528  --output  /data/t.txt-encrypt  --encrypt  /data/t.txt
使用 --armor 输出  ascii 格式
gpg  --recipient   9372CEC627D8FC824D143D647CF26CF82A9DF528  --armor  --output  /data/t.txt-encrypt  --encrypt  /data/t.txt
gpg  -r   9372CEC627D8FC824D143D647CF26CF82A9DF528  -a  -o  /data/t.txt-encrypt  -e  /data/t.txt
指定收件人的公钥文件进行加密(这样就不用导入收件人的公钥到系统了)
gpg  -f   /data/qq-pub-key.key  -a  -o  /data/t.txt-encrypt-pubkeyfile   -e  /data/t.txt


解密文件，使用接收方的私钥解密， 
--local-user, -u 指定使用哪个私钥解密，如果不指定，gpg 就会在本地自动寻找可以使用的私钥
--output, -o 输出到哪个文件，不指定就输出到标准输出
--decrypt, -d 解密动作
--try-all-secrets 选项会忽略存储在密文中的收件人，而会依次尝试所有可用的密钥进行解密。此选项会强制使用对匿名收件人使用的行为，在密文中包含伪造的密钥ID的情况下可能派的上用场。
--show-session-key 输出会话密钥
gpg  --local-user 9372CEC627D8FC824D143D647CF26CF82A9DF528 --decrypt  /data/t.txt-encrypt >  /data/t.txt-src
gpg  -u 9372CEC627D8FC824D143D647CF26CF82A9DF528 -d  /data/t.txt-encrypt >  /data/t.txt-src


或者 -e 选项表示可以从管道接收待加密的数据
echo "stamhe from GnuPGP" | gpg -a -r 6B1B52E8E88F5512 -e > /data/t.txt-encrypt
解密
gpg -u 6B1B52E8E88F5512 -d /data/t.txt-encrypt


输出会话密钥，临时给第三方解密数据，防止提供私钥影响安全性.
gpg --show-session-key  /data/t.txt-encrypt
gpg: session key: '9:990256DBA15D3EABE7A087581CA1BFBE3552A525CDAD35A5361BA93FB29601AF'  此单引号中的字符串就是会话密钥
使用会话密钥解密数据
cat /data/t.txt-encrypt | gpg -d --override-session-key  '9:990256DBA15D3EABE7A087581CA1BFBE3552A525CDAD35A5361BA93FB29601AF'  -o /data/t.txt-src-sessionkey





签名文件
--local-user, -u 指定用来签名的密钥id
--sign, -s 指定签名动作，合并签名，签名生成的文件中原始内容被压缩处理了.
--clearsign 签名保持原始信息，签名生成的文件中明文显示原始数据的ascii码。注意：签名二进制时可能对原始文件产生破坏。因此，任何情况下都不建议将明文签名用于二进制文件签名。
--armor, -a 以 ascii 格式输出经过压缩后的签名信息
gpg  --sign -u 6B1B52E8E88F5512  /data/t.txt

如果想生成 ascii 的签名文件，文件目录就会生成 /data/t.txt.asc 的 ascii 码签名文件，【生成的签名文件包含原始数据】
gpg  --clearsign -u 6B1B52E8E88F5512  /data/t.txt

验证签名
gpg -d  /data/t.txt.asc


签名文件，分离签名，生成独立的签名文件
--detach-sign, -b 分离签名， 创建一个独立的签名文件
--output, -o 指定生成的签名文件，没有指定，则默认为文件名后面二进制加[.sig]或者ascii码加[.asc]后缀
--ask-sig-expire 交互式指定签名文件有效期, 此选项的值会覆盖 --default-sig-expire 的值，可以用 --no-ask-sig-expire 禁用 --ask-sig-expire
--default-sig-expire 参数 形式指定签名文件有效期.  2021-11-30
gpg  --detach-sign --local-user 6B1B52E8E88F5512  /data/t.txt
gpg  -b  -u 6B1B52E8E88F5512  /data/t.txt
ascii 码
gpg  --armor  --detach-sign --local-user 6B1B52E8E88F5512  /data/t.txt
gpg  -a  -b -u 6B1B52E8E88F5512  /data/t.txt
gpg  -a  -b -u 6B1B52E8E88F5512 -o /data/t.txt.asciii  /data/t.txt
gpg  -a  -b -u 6B1B52E8E88F5512 -o /data/t.txt.asc.expire --default-sig-expire 2021-12-12  /data/t.txt

验证签名
--verify 分离签名验证，仅仅验证签名是否正确，不输出原始信息
--detach-sign, -d 验证签名是否正确，并输出原始信息
gpg --verify  /data/t.txt.asc  /data/t.txt
gpg -d /data/t.txt.asc


同时签名+加密文件
--local-user, -u 发信方id，发信方私钥签名，一般为自己的id
--recipient, -r 接收方id，接收方公钥加密，一般为对方的id
gpg --local-user 6B1B52E8E88F5512   --recipient  9372CEC627D8FC824D143D647CF26CF82A9DF528   --armor  --sign   --output   /data/t.txt-encrypt  --encrypt  /data/t.txt


gpg -u 6B1B52E8E88F5512  -r  9372CEC627D8FC824D143D647CF26CF82A9DF528   -a  -s -o /data/t.txt-encrypt  -e   /data/t.txt

收到对方签名后的文件后，验证签名+解密数据
gpg -u 6B1B52E8E88F5512 -r 9372CEC627D8FC824D143D647CF26CF82A9DF528 -d  /data/t.txt-encrypt




对称加密
gpg --version 查看所有支持的算法
--symmetric, -c 使用对称加密算法加密数据
--cipher-algo 不推荐使用此参数。指定对称加密算法，默认为 AES-256, gpg --version 可以看到支持的所有对称对称加密算法。该选项会允许使用收件方不兼容的对称加密算法而引起兼容性问题 
--personal-cipher-preferences 推荐使用此参数。指定对称加密算法，默认为 AES-256, gpg --version 可以看到支持的所有对称对称加密算法.
--passphrase 对称加密的加密密码
--passphrase-file 对称机密的加密密码文件，只读取文件的第一行，其他使用跟 --passphrase 完全一致.
--batch        在 gpg2.0 以上版本，使用了 --passphrase 选项必须同时带上 --batch 参数.
--pinentry-mode loopback 在 gpg 2.1 以上，使用了 --passphrase 选项还要带上此

对称加密加密数据
echo -e "stamhe from GnuPGP"|gpg -a -c --passphrase "test123" --batch  -o  /data/t.txt-encrypt-passphrase
echo -e "stamhe from GnuPGP"|gpg -a -c --passphrase-file /data/password.txt --batch  -o  /data/t.txt-encrypt-passphrase
gpg -a -c --passphrase "test123" --batch -o /data/t.txt-encrypt-passphrase     /data/t.txt


对称加密解密数据
cat /data/t.txt-encrypt-passphrase |gpg -d --passphrase "test123" --batch  -o /data/t.tx-src-passphrase
cat /data/t.txt-encrypt-passphrase |gpg -d --passphrase-file /data/password.txt --batch  -o /data/t.tx-src-passphrase
gpg -d --passphrase "test123" --batch -o /data/t.txt-src-passphrase   /data/t.txt-encrypt-passphrase

文件夹
tar cvf  - maindirname t.txt | gpg -c -o maindirname.tar.gpg
gpg -d maindirname.tar.gpg | tar xvf  -

混合加密：使用随机生成的密码短语使用对称加密算法加密原始数据，再使用接收方的公钥加密密码短语，一起发送给接收方。接收方先用私钥解密出密码短语，再利用密码短语去解密对称加密算法加密的数据，得到原始数据。
gpg 同时使用 -e 公钥加密 和 -c 密码对称加密来得到混合加密的数据
混合加密
echo "混合加密 from gpg" | gpg -r 9372CEC627D8FC824D143D647CF26CF82A9DF528 -c -a -e -o /data/t.txt-encrypt-combined
gpg -r 9372CEC627D8FC824D143D647CF26CF82A9DF528 -c -a -o /data/t.txt-encrypt-combined -e /data/t.txt

混合解密
gpg -o /data/t.txt-src-combined -d /data/t.txt-encrypt-combined



完整备份 GnuPG 目录
cp -rp ~/.gnupg  /data/backup/

测试备份结果
gpg --homedir=/data/backup/.gnupg --list-key F61F25243F3C5922

吊销证书文件
ls -al ~/.gnupg/openpgp-revocs.d/63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922.rev

从服务器拉取远程公钥到本地，根据密钥id拉取公钥数据
--receive-keys, --recv-keys  可以从服务器获取具有指定密钥 id 的公钥，并导入本地的密钥环
gpg --recv-keys 9372CEC627D8FC824D143D647CF26CF82A9DF528

删除导入的别人的公钥
gpg --delete-keys  133EAC179436F14A5CF1B794860FEB804E669320

导出基于 GPG 的 SSH 公钥，用于直接需要 SSH 公钥的场景，如 ssh key 登陆.
gpg --export-ssh-key 133EAC179436F14A5CF1B794860FEB804E669320

上传本地公钥到公钥服务器，将本地签名推送到服务器
gpg --send-keys  63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922

从服务器拉取公钥的更新
gpg --refresh-keys

配置自定义的 GNUPGHOME 工作目录
vim .bashrc
export GNUPGHOME=/data/backup/gnupg
gpg --list-secret-keys

延长密钥过期日期【创建时的有效期默认是 2 年】，完整指纹
gpg --quick-set-expire  63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922  3y  从当前日期起，3 年后过期
gpg --quick-set-expire  63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922  2025-12-01  指定具体的过期日期


生成吊销证书，忘记自己的 passphrase 短语时，可以用这个证书撤销密钥. 对整个密钥进行吊销和删除，不能使用 --edit-key 进行，只能使用吊销证书.
--generate-revocation, --gen-revoke 吊销证书. 
1, 生成
gpg --gen-revoke  6B1B52E8E88F5512
2, 导入
将吊销证书和私钥导入(合并)
gpg --import ~/gnupg/xxx/xxx.rev
3, 导出吊销后的公钥证书，上传到服务器，分发给其他人，表示证书已经吊销
4, 删除所有的私钥和公钥
gpg --delete-secret-and-public-key 6B1B52E8E88F5512



吊销身份 uid
gpg --quick-revoke-uid 63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922 "Stam He <stamhe@163.com>"
然后发送到服务器
gpg --send-key 63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922

对指定公钥进行签名 认可此公钥的持有人身份，确认此公钥持有人身份的真实性.
--ask-cert-level 在签名时提示输入签名级别
--default-cert-level 设置密钥签名时(默认)检查级别，支持 0, 1, 2, 3 四种值
--ask-cert-expire
--default-cert-expire 设置签名的有效期
gpg -u 9DFF6C0E858DDFF9BE4C97256B1B52E8E88F5512 --sign-key 9372CEC627D8FC824D143D647CF26CF82A9DF528

信任签名创建流程
gpg --ask-cert-level -u 9372CEC627D8FC824D143D647CF26CF82A9DF528 --edit-key 9DFF6C0E858DDFF9BE4C97256B1
B52E8E88F5512
> tsign
> save

吊销签名
gpg --ask-cert-level -u 9372CEC627D8FC824D143D647CF26CF82A9DF528 --edit-key 9DFF6C0E858DDFF9BE4C97256B1
> revsig
> save
> clean
> save


更改本地信任级别
gpg --edit-key  63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922
> trust 选择信任级别
> save 
gpg -k

修改私钥加密的 passphrase 
gpg --edit-key  63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922
> passwd
> save

更新主密钥的有效期
gpg --edit-key  63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922
> expire
> save

更新子密钥的有效期
gpg --edit-key  63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922
> key 显示所有的子密钥
> key 100 指定要操作的子密钥，被选择后的子密钥前面会有一个【*】
> expire
> save

更改密钥/子密钥的功能标识: S, E, A, C
gpg --edit-key  63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922
> key 100
> change-usage
> save

吊销或移除一个已有的用户标识
gpg --edit-key  63DC9F1F91ECCE6D9CB64F72F61F25243F3C5922
> uid 100
> deluid  此删除仅仅作用于本地，如果已经上传分发，请使用吊销来确保此用户标识已经不再使用
> save

吊销
> uid 100
> revuid
> save

吊销或移除一个子密钥
删除子密钥
> key 100
> delkey
> save

吊销子密钥
> key 100
> revkey
> save


使用gpg输出随机值，第一个参数是随机数的质量，范围0-2，第二个参数是输出字符串的数量，0 或者不给就是永不停止.
gpg --gen-random -a  2 20

维护信任值数据库
gpg --update-trustdb

导出信任值
gpg --export-ownertrust  > /data/trust.txt

导入信任值
cat  /data/trust.txt | gpg --import-ownertrust
gpg  --import-ownertrust /data/trust.txt


解决[对设备不适当的 ioctl 操作]错误
在使用ssh等远程终端使用GOG时，可能报错以下信息，而无法输入密码。
> gpg: 公钥解密失败：对设备不适当的 ioctl 操作
> gpg: 解密失败：没有秘匙
可以通过设置环境变量来不使用图形界面以允许命令行密码输入。
export GPG_TTY=$(tty)



```

### 用 GPG 密钥认证 SSH
```
注意：其中某些功能需要 gpg 大于 v2.2.x 版本
1. 生成一个认证子密钥 [A]
2. 配置 gpg-agent.conf
vim ~/.gnupg/gpg-agent.conf
# 加入下面三行
# 三行分别表示
# 输入一次 GPG 密码后，600 秒内不用重复输入，600 秒内再次使用密码会重置这个时间. 单位：秒
# 从首次输入密码算起，不管最近一次使用密码是什么时间，只要最大 TTL 过期，就需要重新输入密码。单位：秒
# 启用 SSH 支持

default-cache-ttl 600
max-cache-ttl 7200
enable-ssh-support

3. 让 ssh 与 gpg-agent 通信，而不是 ssh-agent
vim ~/.bashrc
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

4. 为了使修改生效，需要执行
killall gpg-agent
bash 重新开启 shell，如果是 GUI 环境，就重启机器.

5. 先获取认证子密钥的  keygrip，然后配置子密钥的  keygrip 告诉 gpg-agent 应该使用哪个认证子密钥
gpg --with-keygrip --list-key 9DFF6C0E858DDFF9BE4C97256B1B52E8E88F5512

添加keygrip, 注意：此处是使用的子密钥的 kegrip，不是子密钥的公钥
echo "C43327CF21A68EB6DFDA4E5587C6E29D35B55079" >> ~/.gnupg/sshcontrol

6. 列出 SSH 格式的 GPG 认证密钥的公钥
ssh-add -L

7. 配置上面打印出来的 pub key 到其他平台即可

8. 测试
ssh -T -vvvv git@github.com
ssh -T -vvvv root@www.stamhe.com


从公钥服务器下载其他人的基于 gpg 的 ssh 公钥
gpg  --export-ssh-key 9DFF6C0E858DDFF9BE4C97256B1B52E8E88F5512




```

### git 使用
```
export GPG_TTY=$(tty)

指定 git 使用的签名认证密钥的指纹
git config --global user.signingKey  7B0979AFEF99D9CA4EF24E023861C8C44D25274F

创建一个签名的 tag， -s 参数
git tag -s  [tagname]

验证签名的 tag，如果要验证其他人的 git 标签，需要导入他的 gpg 公钥
git verify-tag [tagname]

获取数据时验证
git pull  [url]  tags/sometag

配置 git 始终签名带注释的 tag
git config --global  tag.forceSignAnnotated  true
git tag -as -m "tag message annotation"  [tagname]

带签名的提交
git commit -S -m "comment" 

验证签名的提交
git verify-commit [hash]

查看仓库日志，要求所有提交签名是被验证和显示的
git log --pretty=short  --show-signature


如果所有成员都签名了他们的提交，可以在合并时强制进行签名检查(然后使用 -S 对合并操作本身进行签名)
注意：如果有一个提交没有签名或者签名验证失败，则合并失败
git merge --verify-signatures -S merged-branch

配置 git 始终进行签名提交
git config --global commit.gpgSign true
或每次单独提交签名
git commit -m "xxx" -S

gpg-agent 配置 - git自动脚本签名
~/.gnupg/gpg-agent.conf
default-cache-ttl 1800   单位: 秒，如果在 ttl 过期之前再次使用同一个密钥，则这个倒计时重置。默认为 600(10分钟)
max-cache-ttl 7200  单位: 秒，自首次密钥输入以后，不论最近一次使用密钥是什么时间，只要达到这个时间，就会要求再次输入密码。默认 1800(30分钟)




```

### 部分技术社区名人的 GPG 公钥
```
btc ->
Pieter Wuille sipa A636E97631F767E0
Luke Dashjr luke-jr 

W. J. van der Laan laanwj 1E4AED62986CD25D
Michael Ford fanquake 2EEB9F5CC09526C1

Hennadii Stepanov hebasto 410108112E7EA81F

ltc ->
https://github.com/DavidBurkett/ltc-release-builder/tree/master/gitian-keys
Charlie Lee coblee 828AC1F94EF26053

xray -> 
rprx 4AEE18F83AFDEB23


```

