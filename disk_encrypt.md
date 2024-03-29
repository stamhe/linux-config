# 各种磁盘加密方案

### 结论

```
对比了 cryptsetup/dm-crypt、ecryptfs 以及 gocryptfs 三种方案：
1、ecryptfs 和 gocryptfs 相比 cryptsetup 都有很严重的性能缺陷，而 cryptsetup 基本做到无损性能。
2、cryptsetup 和 ecryptfs 都置于内核中支持，gocryptfs 和 ecryptfs 都通过 fuse 捕获写操作进行加密数据。
3、gocryptfs 有设计缺陷， gocryptfs  -init 后生成的配置文件 gocryptfs.conf 是以文本形式存放在加密目录的，每个 gocryptfs -init 配置的加密目录一个新的 gocryptfs.conf 配置文件，而且这个 gocryptfs.conf 配置文件内置了最核心的加密密钥，如果 gocryptfs.conf 配置文件不小心被删除，则需要用 gocryptfs  -init 时生成的另外一个叫 master key 的密钥来恢复，在大规模业务系统中，这是一个巨大的管理灾难。
4、gocryptfs 和 ecryptfs 备份加密数据简单，只需要同步加密文件就行了，cryptsetup需要使用 dd 进行块拷贝.
5、cryptsetup 使用镜像文件挂载的方式，也可以达到很容易备份的目的，但是镜像文件的大小被创建时固定死了，不能扩大或者缩小容量，而 ecryptfs 和 gocryptfs 则完全看当前磁盘的空间大小。
6、使用都很简单，基本都是开箱即用，而且安装很简单。
7、cryptsetup/dm-crypt是磁盘块设备的加密，ecryptfs 和 gocryptfs 是磁盘目录的加密。
8、首选 cryptsetup/dm-crypt ,他基本满足我对磁盘加密的所有需求想象。
```

### cryptsetup/dm-crypt LUKS2块加密(dm-crypt)

```
apt-get install cryptsetup -y
yum install cryptsetup -y

LUKS2 块加密

创建 LUKS 卷
cryptsetup luksFormat /dev/sdb
自定义关键参数
cryptsetup --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 10000 luksFormat /dev/sdb

查看 LUKS 卷 header 信息
cryptsetup luksDump  /dev/sdb


备份恢复 LUKS 卷 header
cryptsetup luksHeaderBackup  /dev/sdb  --header-backup-file  /data/LuksHeader.bin
cryptsetup luksHeaderRestore /dev/sdb  --header-backup-file  /dev/luksHeader.bin

解锁使用 LUKS 卷，创建分区映射，指定设备映射名称  stamhe-disk-encrypt
cryptsetup  luksOpen  /dev/sdb  stamhe-disk-encyrpt
等同于
cryptsetup open --type luks /dev/sdb  stamhe-disk-encrypt
使用 key 密码解锁
cryptsetup luksOpen -d /boot/password.txt /dev/sdb  stamhe-disk-encrypt


ls -al /dev/mapper/stamhe-disk-encyrpt
blkid /dev/mapper/stamhe-disk-encyrpt

cryptsetup refresh stamhe-disk-encyrpt  
cryptsetup status   /dev/mapper/xxxx    有时候需要先执行 refresh 刷新一下，否则 status 看不到数据

格式化
mkfs.ext4 /dev/mapper/stamhe-disk-encyrpt
fsck /dev/mapper/stamhe-disk-encyrpt

挂载
mount  /dev/mapper/stamhe-disk-encyrpt /data
echo  "stamhe" > /data/t.txt

卸载
umount /data

关闭 luks 卷，再次上锁
cryptsetup luksClose stamhe-disk-encrypt
或
cryptsetup close stamhe-disk-encrypt

清除复制和缓存缓冲区
sysctl --write vm.drop_caches=3



新加密码组
cryptsetup luksAddKey /dev/sdb
修改密码组
cryptsetup luksChangeKey  /dev/sdb
删除密码组, 千万不要将所有密码移除，至少需要留有一个密码访问设备，移除操作不可撤销
cryptsetup luksRemoveKey  /dev/sdb



设置开机挂载加密分区
生产随机key
dd if=/dev/urandom of=/boot/password.txt bs=1 count=4096
/boot/password.txt
cryptsetup  luksAddKey  /dev/sdb   /boot/password.txt
移除 key 密码
cryptsetup luksRemoveKey -d /boot/password.txt  /dev/sdb

vim /etc/crypttab
增加
stamhe-disk-encrypt  /dev/sdb  /boot/password.txt    luks

vim /etc/fstab
/dev/mapper/stamhe-disk-encrypt   /data   ext4  defaults  0  0

强制格式化，取消加密
mkfs.ex4  -f  /dev/sdb


创建虚拟加密卷
dd if=/dev/zero of=/root/data.img bs=1M count=4096 
或
fallocate -l 5G  /root/data.img
或
truncate -s 5G /root/data.img

cryptsetup --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 10000 luksFormat  /root/data.img
cryptsetup luksFormat  /root/data.img

cryptsetup  luksOpen  /root/data.img  stamhe-disk-encrypt

ls  -al  /dev/mapper/

cryptsetup refresh  stamhe-disk-encrypt
cryptsetup status  stamhe-disk-encrypt
mkfs.ext4  /dev/mapper/stamhe-disk-encrypt
mount  /dev/mapper/stamhe-disk-encrypt  /data
vim /data/t.txt

卸载
umount /data
cryptsetup luksClose  stamhe-disk-encrypt
```

### eCryptfs 加密

```
apt install ecryptfs-utils -y
yum install ecryptfs-utils -y

mkdir -p /opt/data-encrypt  /opt/data-src

挂载，并且选择加密参数
mount -t ecryptfs  /opt/data-encrypt  /opt/data-src
echo "stamhe" >  /opt/data-src/t.txt
cat /opt/data-src/t.txt
卸载
umount /opt/data-src
```

### gocryptfs 加密

```
apt install gocryptfs -y
yum install gocryptfs -y

mkdir -p /opt/data-encrypt  /opt/data-src
创建加密数据存放目录，设置密码
gocryptfs  -init  /opt/data-encrypt
gocryptfs  /opt/data-encrypt  /opt/data-src
echo "stamhe" > /opt/data-src/t.txt
cat /opt/data-src/t.txt

卸载
fusermount  -u  /opt/data-src

```


### 安全清除磁盘数据

```
使用随机数写入目标磁盘3次，完全擦除数据。<这一步不是必须的>。非常慢
shred --verbose --random-source=/dev/urandom --iterations=3 /dev/sdb

清除复制和缓存缓冲区
sysctl --write vm.drop_caches=3
```

### 调整 dm-crypt/luks 加密分区磁盘大小(好像不支持luks2)
```
apt install qemu-utils

https://www.qemu.org/docs/master/system/qemu-block-drivers.html?highlight=luks#cmdoption-image-formats-arg-luks

以 fallocate -l 10G test.img 创建的 raw 格式磁盘镜像为例子，磁盘格式为 ext4

----------------------------------------------------------------
先缩小 ext4 分区的大小
调整分区 1 的大小到 3G
cryptsetup open test.img test-disk

检查要调整的分区, 可以加 -y 一直默认确认
e2fsck -f /dev/mapper/test-disk1


调整分区文件系统到 3G
resize2fs /dev/mapper/test-disk1 3G

调整分区
fdisk /dev/mapper/test-disk
p 打印已经有的分区
d 删除原来的分区 1
n 新建一个分区 1，参数基本都默认，除了结束大小必须写【+3G】
w 保存新分区

重载分区表
partprobe /dev/mapper/test-disk

再次检查分区
e2fsck -f /dev/mapper/test-disk1

【不要重新格式化】，直接 mount 即可

----------------------------------------------------------------
调整镜像文件的大小
镜像文件的信息
qemu-img info test.img

镜像文件增加 +1G 空间
qemu-img resize test.img +1G

减小 1G
qemu-img resize test.img -1G

对 luks 加密镜像增加 +1G 空间(好像不支持luks2)
qemu-img resize  --object secret,id=idname1,data=123456  --image-opts driver=luks,file.filename=test.img,key-secret=idname1 +1G



```

