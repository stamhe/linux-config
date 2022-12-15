# 磁盘阵列

```

linux 挂载 mac 分区硬盘
https://www.cnblogs.com/qxrblog/articles/15155113.html


apt install hfsprogs
mount -o rw,force /dev/sda1 /mnt/mac/


ddrescue -r 2 /dev/sdb1 /dev/sde1
ddrescue -r 2 --force /dev/sdb1 /dev/sde1

验证这两个驱动器是否正确定义 RAID，使用下面的命令。

mdadm --examine /dev/sd[b-c]
mdadm --examine /dev/sd[b-c]1


raid1
mdadm --create /dev/md0 --level=mirror --raid-devices=2 /dev/sd[b-c]1
cat /proc/mdstat

使用如下命令来检查 RAID 设备类型和 RAID 阵列
mdadm -E /dev/sd[b-c]1
mdadm --detail /dev/md0


使用下面的命令保存 RAID 的配置到文件“mdadm.conf”中。
mdadm --detail --scan --verbose >> /etc/mdadm.conf


数据恢复
https://www.pianshen.com/article/5752407325/

https://linux.cn/article-6448-1.html


ddrescue -r 2 /dev/sda5 /dev/sdb1


https://www.qingsword.com/qing/85.html
dd if=~/ubuntu-16.04-desktop-amd64.iso of=/dev/sdc


```

# smartctl
```
https://www.shouce.ren/api/view/a/9334
http://xiaqunfeng.cc/2017/05/07/S-M-A-R-T-device-healthy-monitor/
https://www.yisu.com/zixun/817.html




apt install smartmontools -y
通过linux服务器通过 smart 检测你的硬盘和磁盘阵列.

usb 移动硬盘
smartctl -a -d usbsunplus /dev/sda

确认硬盘是否打开了SMART支持(MART support is: Available - device has SMART capability.显示磁盘SMART是支持的，SMART support is: Enabled是可用的)：
smartctl -i /dev/sda

现在硬盘的SMART功能已经被打开，执行如下命令查看硬盘的健康状况：
smartctl -H /dev/sda

注意
result后边的结果：PASSED，这表示硬盘健康状态良好
如果这里显示Failure，那么最好立刻给服务器更换硬盘
SMART只能报告磁盘已经不再健康，但是报警后还能继续运行多久是不确定的
通常，SMART报警参数是有预留的，磁盘报警后，不会当场坏掉，一般能坚持一段时间
有的硬盘SMART报警后还继续跑了好几年，有的硬盘SMART报错后几天就坏了
但是一旦出现报警，侥幸心里是万万不能的……

查看硬盘的详细信息：
smartctl -A /dev/hdb

输出完整结果：
smartctl -a /dev/hdb



执行如下命令，启动SMART
smartctl --smart=on --offlineauto=on --saveauto=on /dev/sda



smartctl -c /dev/sda   在执行测试之前，使用以下命令显示各种测试的持续时间的近似值
smartctl -s on  /dev/sda  如果没有打开SMART技术，使用该命令打开SMART技术。 
smartctl -t short  /dev/sda  后台检测硬盘，消耗时间短； 
smartctl -t long  /dev/sda   后台检测硬盘，消耗时间长； 
smartctl -C -t  /dev/sda   short前台检测硬盘，消耗时间短； 
smartctl -C -t  /dev/sda   long前台检测硬盘，消耗时间长。其实就是利用硬盘SMART的自检程序。 
smartctl -X   /dev/sda      中断后台检测硬盘。 
smartctl -l selftest  /dev/sda  显示硬盘检测日志。 
smartctl -l error   /dev/sda    显示硬盘错误汇总。





在选定的测试期间，检查指定的逻辑块范围。要扫描的逻辑块以以下格式指定：
smartctl -t select,10-20 /dev/sda  ## LBA 10 to LBA 20（incl.）
smartctl -t select,10+11 /dev/sda  ## LBA 10 to LBA 20（incl.）

也可以有多个范围（最多5个）进行扫描：
smartctl -t select,0-10 -t select,10-20 /dev/sda

```
