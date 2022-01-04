# apt 高级命令
```

将系统升级到新版本
apt-get dist-upgrade

查看可更新列表
apt list --upgradable

重新安装包
apt-get install package --reinstall

修复安装"-f = ——fix-missing" 
apt-get -f install

apt-get remove package --purge 删除包，包括删除配置文件等
apt purge package

apt-get install <<package name>>=<<version>>
列出所有来源的版本
apt-cache madison <<package name>>
将列出所有来源的版本, 信息会比上面详细一点
apt-cache policy <<package name>>

pkgnames-查询安装包名
如果要显示所有可用安装包的名称，可以用以下命令
apt-cache pkgnames
列出所有以关键字开头的包，可以使用
apt-cache pkgnames openssh

使用search命令可以方便地查询关键字匹配的软件包，并打印简介信息，例如如果想找vsftpd相关的包，你可以输入：
apt-cache search vsftp

查询包的版本、检验和、大小、安装大小和类别等信息，可以使用show子命令：
apt-cache show openssh-server
apt show openssh-server
或
dpkg -l package 显示包的详情, 会提示是否已经删除了之后还有依赖包没有删除



显示已安装包的详情
dpkg -s package
或
dpkg-query -s package




policy/madison-列出软件包的所有版本, policy列出的信息比 madison 详细一点
apt-cache policy wireshark
apt-cache madison wireshark

使用showpkg子命令可以查询依赖包信息，哪些尚未安装等：
apt-cache showpkg iotop



stats-查询cache的统计信息, 此命令会显示cache的总体统计信息：
apt-cache stats

打印可用软件包列表
apt-cache dumpavail


使用通配符安装
apt-get install "*openssh*"

安装软件包的特定版本, 有时因为特殊原因需要安装较早版本的软件包，这时可以先使用apt-cache madison|policy name，来获取所有可安装版本，再使用以下命令安装特定版本：
apt-get install vsftpd=2.3.5-3ubuntu1

清除缓存的包, 硬盘空间告急时可以使用此命令释放一定空间
apt-get clean

changelog-更新日志, 此命令也可以用来查询历史版本信息，例如：
apt-get changelog wireshark


使用apt-get install -s模拟安装软件
apt-get install -s vim

使用apt-show-versions列出软件全部版本，并查看是否已经安装
apt-get install apt-show-versions
apt-show-versions -a vim
还能够经过apt-show-versions -u package查询是否有升级版本



apt-file search filename——查找包含特定文件的软件包（不一定是已安装的），这些文件的文件名中含有指定的字符串。apt-file是一个独立的软件包。您必须先使用apt-get install来安装它，然後运行apt-file update。如果apt-file search filename输出的内容太多，您可以尝试使用apt-file search filename | grep -w filename（只显示指定字符串作为完整的单词出现在其中的那些文件名）或者类似方法，例如：apt-file search filename | grep /bin/（只显示位于诸如/bin或/usr/bin这些文件夹中的文件，如果您要查找的是某个特定的执行文件的话，这样做是有帮助的）。



apt-get autoclean——定期运行这个命令来清除那些已经卸载的软件包的.deb文件。通过这种方式，您可以释放大量的磁盘空间。如果您的需求十分迫切，可以使用apt-get clean以释放更多空间。这个命令会将已安装软件包裹的.deb文件一并删除。大多数情况下您不会再用到这些.debs文件，因此如果您为磁盘空间不足而感到焦头烂额，这个办法也许值得一试。



apt-get dselect-upgrade 使用 dselect 升级
apt-cache depends package 了解使用依赖
apt-cache rdepends package 是查看该包被哪些包依赖
sudo apt-get build-dep package 安装相关的编译环境
apt-get source package 下载该包的源代码
sudo apt-get clean && sudo apt-get autoclean 清理无用的包
apt-get check 检查是否有损坏的依赖 



dpkg -S file——这个文件属于哪个已安装软件包。
dpkg -L package——列出软件包中的所有文件。

dpkg -s package 显示已安装包的详情
dpkg -l package 显示包的详情, 会提示是否已经删除了之后还有依赖包没有删除
```
