# lvm
```
fdisk /dev/sdd
t 修改磁盘格式
8e # lvm 的格式代码

Gpt分区介绍
1、是UEFI标准的一部分，主板必须要支持UEFI标准
 2、GPT分区列表支持最大128PB(1PB=1024TB)
 3、可以定义128个分区
 4、没有主分区，扩展分区和逻辑分区的概念，所有分区都能格式化
 5、gdisk管理工具和parted命令可以创建GPT分区

parted /dev/sdd
mklabel gpt # 建立 gpt 分区类型
Yes
Ignore
print 查看分区类型
quit


创建物理卷，将希望添加到卷组的所有分区或磁盘创建为物理卷
pvcreate  /dev/sdc1
pvcreate  /dev/sd[c-e]1

通过lvmdiskscan能看到那些设备成为了物理卷
lvmdiskscan

查看物理卷, 使用pvs,pvscan,pvdisplay来显示当前系统中的物理卷
pvs 显示所有的 pv 信息
pvscan 
pvdisplay 显示 pv 属性


查看指定的物理卷是否被使用
pvdisplay /dev/sdc1


修改 pv 的大小
pvresize


移除物理卷
pvremove /dev/sdc1

创建卷组（包含物理卷 /dev/sdc1, /dev/sdd1)
vgcreate vgname1 /dev/sdc1
vgcreate vgname1 /dev/sdc1 /dev/sdd1
vgcreate vgname1 /dev/sd[c-e]1
vgcreate [-s PE 大小] 卷组名 物理卷1 物理卷2 物理卷N
[-s PE 大小] 选项的含义是指定 PE 的大小，单位可以是 MB、GB、TB 等。如果不写，则默认 PE 大小是 4MB。这里的卷组名指的就是要创建的卷组的名称，而物理卷名则指的是希望添加到此卷组的所有硬盘区分或者整个硬盘。

vgcreate 1MB vgname1 /dev/sdc1
卷组创建时，物理卷会被LVM以最小存储单元，也就是PE，分为一个个大小一样存储块。后面创建逻辑卷时，也会以LE为最小分配单元。由于内核限制，一个逻辑卷只会包含2的16次方LE，如PE=LE=1MB，则一个LV最大容量为63356MB。特别说明一下LVM2不受这个影响。PE，LE大小在卷组创建时确定，默认值为4MB。如果需要更改为1MB，则命令像上面这样指定


激活卷组
vgchange -a y vgname1

停用卷组
vgchange -a n vgname1

扫描系统的卷组
vgscan

查看卷组详细状态
vgs
vgdisplay

增加卷组容量
vgextend vgname1 /dev/sde1

减少卷组容量
vgreduce vgname1 /dev/sde1

删除卷组(只有在删除卷组之后，才能删除物理卷。还要注意的是，vgname1 卷组中还没有添加任何逻辑卷，如果拥有了逻辑卷，则记得先删除逻再删除卷组。再次强调，删除就是安装的反过程，每一步都不能跳过)
vgremove vgname1


创建逻辑卷
在卷组 vgname1 上创建为 lvname1 的逻辑卷。逻辑卷大小有两种指定方法：用-L参数显示指定大小；用-l参数指定逻辑卷包含LE的数量。LE取默认值4MB。
lvcreate -L 100GB -n lvname1 vgname1
lvcreate -l 4096 -n lvname1 vgname1


如果希望创建一个使用全部卷组的逻辑卷，则需要首先察看该卷组的PE数，然后在创建逻辑卷时指定：
vgdisplay vgname1| grep "Total PE"
Total PE 4731
lvcreate -l 4731 vgname1 -n test
Logical volume "test" created


查看逻辑卷状态
lvscan
lvdisplay
lvs -o +devices
lvs 显示 lv 的所有信息

在逻辑卷创建文件系统
mkfs.ext4 /dev/vgname1/lvname1

挂在逻辑卷到目录
mount  /dev/vgname1/lvname1 /data

移除逻辑卷
lvremove /dev/vgname1/lvname1

扩展逻辑卷大小
LVM提供了方便调整逻辑卷大小的能力，扩展逻辑卷大小的命令是lvextend：

将逻辑卷 lvname1 的大小扩大为12G。
lvextend -L 12G /dev/vgname1/lvname1


将逻辑卷 lvname1 的大小增加1G。
lvextend -L +1G /dev/vgname1/lvname1

减少 lv 的大小
lvreduce

重新设置 lv 的大小
lvresize

一般建议最佳将文件系统卸载，调整大小，然后再加载：
umount /dev/vgname1/lvname1
resize2fs /dev/vgname1/lvname1
mount  /dev/vgname1/lvname1 /data


创建条块化的逻辑卷
# lvcreate -L 500M -i2  -n lvname1 vgname
  Using default stripesize 64.00 KB
  Rounding size (125 extents) up to stripe boundary size (126 extents)
  Logical volume "lvname1" created
-i2指此逻辑卷在两个物理卷中条块化存放数据，默认一块大小为64KB.

创建映像的逻辑卷。
#lvcreate -L 52M  -m1  -n lvname1 vgname1 /dev/sdb1 /dev/sdc1 /dev/sdb2 
  Logical volume "lvname1" created
-m1表示只生成一个单一映像，映像分别放在/dev/sdb1和/dev/sdc1上，映像日志放在/dev/sdb2上.

创建快照卷。
lvcreate --size 10 --snapshot --name snap1 /dev/vgname1/lvname1 


使用过滤控制LVM的设备扫描
通过编辑/etc/lvm/lvm.conf 中的filter段，来定义过滤那些设备要扫描。
filter =[ "a|/dev/sd.*|", "a|/dev/hd.*|", "r|.*|" ] 
上面对scsi及ide设备扫描，对其他设备均不扫描。


在线数据迁移
通过pvmove能将一个PV上的数据迁移到新的PV上，也能将PV上的某个LV迁移到另一个PV上。
lvs -o +devices
  LV       VG         Attr   LSize  Origin Snap%  Move Log Copy%  Devices      
  LogVol00 VolGroup00 -wi-ao  2.88G                               /dev/sda2(0) 
  LogVol01 VolGroup00 -wi-ao  1.00G                               /dev/sda2(92)
  lvname1  vgname1   -wi-ao 52.00M                               /dev/sdc1(0) 

pvmove -n lvname1 /dev/sdc1 /dev/sdd1

lvs -o +devices



故障排查
通过在命令后加 -v,-vv,-vvv或-vvvv来获得更周详的命令输出。
通过在lvs,vgs后加-P能更好的查看失败设备.
vgs -a -o +devices -P
lvs -a -o +devices -P

```