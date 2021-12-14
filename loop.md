# loop 设备
```
在类 UNIX 系统里，loop 设备是一种伪设备(pseudo-device)，或者也可以说是仿真设备。它能使我们像块设备一样访问一个文件。
设置 loop 设备
losetup [ -e encryption ] [ -o offset ] loop_device_name file_name
losetup [ -d ] loop_device_name
-a 显示所有在使用的 loop 设备
-e 表示加密的方式
-o 设置数据偏移量
-d 卸载设备
loop_device_name 循环设备名，在 linux 下如 /dev/loop0 , /dev/loop1 等。
file_name 要与循环设备相关联的文件名，这个往往是一个磁盘镜象文件，如 *.img

修改 loop 设备数量
vim /etc/modprobe.conf
options loop max_loop=50 --比如我增加到50个
modprobe  -v loop


显示所有在使用的 loop 设备
losetup -a

查看 loop 设备信息
losetup   /dev/loop8

创建磁盘镜像文件
dd if=/dev/zero of=/data/tmp/test.img bs=4k count=250k
dd if=/dev/zero of=/data/tmp/test.img bs=1M count=1024

将磁盘镜像文件虚拟成块设备
losetup /dev/loop8   /data/tmp/test.img
losetup -a
lsblk -f


分区
fdisk  /dev/loop8
格式化
mkfs.ext4   /dev/loop8

挂载块设备
mount  /dev/loop8  /mnt/upan

卸载 loop 设备
umount  /mnt/upan
losetup  -d /dev/loop8



```
