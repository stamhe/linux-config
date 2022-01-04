# hashcat密码暴力破解工具
```
mx linux
https://mxlinux.org/

manjaro
https://manjaro.org/

linux mint
https://linuxmint.com/


distrowatch.com


注意：async方式在热插拔时有可能会导致数据丢失，要防止防止数据丢，在拔卡之前需先 umount。
挂载SD卡或U时以 async 的方式挂载就行（默认一般是以 sync 方式挂载），用法如下：
USB
mount -o async,noatime,nodiratime /dev/sda1 /mnt/upan
mount -o async,noatime,nodiratime /dev/mapper/stamhe-upan /mnt/upan


MMC
mount -o async,noatime,nodiratime /dev/mmcblk0p1 /mnt/sd


追加 async 挂载方式
如果目录已经挂载，可以传入remount的option重新挂载并改变挂载参数，比如插入SD卡时系统会自动挂载到/media/mmcblk0p1下面，但是系统自动挂载用的是 sync 的方式，现在要改为async的方式直接用以下的命令：
mount -o remount,async,noatime,nodiratime /dev/sda1 /mnt/upan
mount -o remount,async,noatime,nodiratime /dev/mmcblk0p1 /media/sd


```

### ubuntu 安装显卡驱动
```
AMD 显卡
https://linuxconfig.org/amd-radeon-ubuntu-20-04-driver-installation

查看显卡类型
lshw -c video
lspci -nn | grep -E 'VGA|Display'

安装第三方开源AMD显卡驱动命令:
https://ubunlog.com/zh-CN/%E5%A6%82%E4%BD%95%E5%9C%A8ubuntu-18-04%E4%B8%AD%E5%AE%89%E8%A3%85amd-ati%E9%A9%B1%E5%8A%A8%E7%A8%8B%E5%BA%8F/

add-apt-repository ppa:oibaf/graphics-drivers
apt update && sudo apt -y upgrade

lsmod | grep amd
amdgpu               4575232  11
amd_iommu_v2           20480  1 amdgpu

检查启动信息，确认图形驱动是否在使用
dmesg | grep -i amdgpu

用mpv测试VDPAU驱动程序：
mpv --hwdec=vdpau yourvideofile


安装对Vulkan的支持:
apt install mesa-vulkan-drivers


更新内核
update-initramfs -u

删除安装的第三方驱动
apt install ppa-purge
ppa-purge ppa:oibaf/graphics-drivers

====================================================================
Nvidia 显卡
安装Nvidia驱动
添加PPA源
add-apt-repository ppa:graphics-drivers/ppa

查询当前适用版本
ubuntu-drivers devices

自动安装
ubuntu-drivers autoinstall

查看显卡信息
nvidia-smi

===================================================================
常用命令
启用加速视频：
apt-get install mesa-vdpau-drivers


```
