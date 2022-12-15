# apt 高级命令
# apt-add-repository
```
PPA 全称为 Personal Package Archives（个人软件包档案），是 Ubuntu Launchpad 网站提供的一项服务，当然不仅限于 Launchpad 。它允许个人用户上传软件源代码，通过 Launchpad 进行编译并发布为二进制软件包，作为 apt/新立得源供其他用户下载和更新。在Launchpad网站上的每一个用户和团队都可以拥有一个或多个PPA。

launchpad.net

通常 PPA 源里的软件是官方源里没有的，或者是最新版本的软件。相对于通过 Deb 包安装来说，使用 PPA 的好处是，一旦软件有更新，通过 sudo apt-get upgrade 这样命令就可以直接升级到新版本。

# 如何通过 PPA 源来安装软件：
apt-add-repository  ppa_source_name    // 添加PPA源添加到源列表（/etc/apt/sources.list）
通常我们可以通过 Google 来搜索一些常用软件的 PPA 源，通常的搜索方法是软件名称关键字 + PPA ，或者也可直接到 launchpad.net 上去搜索，搜索到后我们就可以直接用 apt-add-repository 命令把 PPA 源添加到 Source list 中了。
比如 FireFox PPA 源：https://launchpad.net/~ubuntu-mozilla-daily/+archive/ppa ，我们可以在这里找到 ppa:ubuntu-mozilla-daily/ppa 的字样，然后我们通过以下命令把这个源加入到 source list 中。
apt-add-repository ppa:ubuntu-mozilla-daily/ppa
apt-get update
apt-cache pkgnames firefox  或者  apt-cache search firefox
apt install xxxxx

# 如何删除 ppa 源
1, /etc/apt/sources.list.d/  直接删除这个目录下的【相关源】配置
2, add-apt-repository -r ppa:ubuntu-mozilla-daily/ppa
add-apt-repository --remove "ppa:ubuntu-mozilla-daily/ppa" 
然后 apt update

# 如果删除信任的源 key
apt-key list  先列举出来所有的
apt-key del "3820 03C2 C8B7 B4AB 813E 915B 14E4 9429 73C6 2A1B" 删除
然后 apt update


# 删除 ppa 的同时连他相关的软件一起删除
apt-get install ppa-purge
ppa-purge "ppa:ubuntu-mozilla-daily/ppa"


```

# apt
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



apt-file search filename 查找包含特定文件的软件包（不一定是已安装的），这些文件的文件名中含有指定的字符串。apt-file是一个独立的软件包。您必须先使用apt-get install来安装它，然後运行apt-file update。如果apt-file search filename输出的内容太多，您可以尝试使用apt-file search filename | grep -w filename（只显示指定字符串作为完整的单词出现在其中的那些文件名）或者类似方法，例如：apt-file search filename | grep /bin/（只显示位于诸如/bin或/usr/bin这些文件夹中的文件，如果您要查找的是某个特定的执行文件的话，这样做是有帮助的）。



apt-get autoclean 定期运行这个命令来清除那些已经卸载的软件包的.deb文件。通过这种方式，您可以释放大量的磁盘空间。如果您的需求十分迫切，可以使用apt-get clean以释放更多空间。这个命令会将已安装软件包裹的.deb文件一并删除。大多数情况下您不会再用到这些.debs文件，因此如果您为磁盘空间不足而感到焦头烂额，这个办法也许值得一试。



apt-get dselect-upgrade 使用 dselect 升级
apt-cache depends package 了解使用依赖
apt-cache rdepends package 是查看该包被哪些包依赖
apt-get build-dep package 安装相关的编译环境
apt-get source package 下载该包的源代码
apt-get clean && sudo apt-get autoclean 清理无用的包
apt-get check 检查是否有损坏的依赖 



dpkg -S file——这个文件属于哪个已安装软件包。
dpkg -L package——列出软件包中的所有文件。

dpkg -s package 显示已安装包的详情
dpkg -l package 显示包的详情, 会提示是否已经删除了之后还有依赖包没有删除
```

# apt
```
apt-get install packagename  //安装一个新软件包（参见下文的aptitude）
apt-get remove packagename  //卸载一个已安装的软件包（保留配置文档）
apt-get remove --purge packagename  //卸载一个已安装的软件包（删除配置文档）
apt-get autoremove packagename  //删除包及其依赖的软件包
apt-get autoremove --purge packagname  //删除包及其依赖的软件包+配置文件，比上面的要删除的彻底一点
dpkg --force-all --purge packagename  //有些软件很难卸载，而且还阻止别的软件的应用,用这个强制卸载，但是有点冒险。
apt-get autoclean //apt会把已装或已卸的软件都备份在硬盘上，所以假如需要空间的话，这个命令来删除您已卸载掉的软件的备份。
apt-get clean  //这个命令会把安装的软件的备份也删除，不会影响软件的使用。
apt-get upgrade  //更新软件包，apt-get upgrade不仅可以从相同版本号的发布版中更新软件包，也可以从新版本号的发布版中更新软件包，尽管实现后一种更新的推荐命令为apt-get dist-upgrade。在运行apt-get upgrade命令时加上-u选项很有用（即：apt-get -u upgrade)。这个选项让APT显示完整的可更新软件包列表。不加这个选项，你就只能盲目地更新。APT会下载每个软件包的最新更新版本，然后以合理的次序安装它们。在运行该命令前应先运行 apt-get update更新数据库，更新任何已安装的软件包。
apt-get dist-upgrade  //将系统升级到新版本。
apt-cache search string  //在软件包列表中搜索字符串。
aptitude  //周详查看已安装或可用的软件包。和apt-get类似，aptitude能够通过命令行方式调用，但仅限于某些命令——最常见的有安装和卸载命令。
由于aptitude比apt-get了解更多信息，能够说他更适合用来进行安装和卸载。
apt-cache showpkg pkgs  //显示软件包信息。
apt-cache dumpavail pkgs //打印可用软件包列表。
apt-cache show pkgs  //显示软件包记录，类似于dpkg –print-avail。
apt-cache pkgnames  //打印软件包列表中任何软件包的名称。
apt-file search filename  //查找包含特定文档的软件包（不一定是已安装的），这些文档的文档名中含有指定的字符串。apt-file是个单独的软件包。必须先使用apt-get install来安装他，然后运行apt-file update。如apt-file search filename输出的内容太多，您能够尝试使用apt-file search filename | grep -w filename（只显示指定字符串作为完整的单词出现在其中的那些文档名）或类似方法.
apt-cache search sorftname //查找包含特定文档的软件包
apt-cache madusion sorftname //查找包含特定文档的软件包
apt-cache policy sorftname //查找包含特定文档的软件包
```

# dpkg
```
dpkg -i remarkable_1.87_all.deb //安装软件
dpkg -R /usr/local/src  //安装一个目录下面所有的软件包
dpkg –-unpack remarkable_1.87_all.deb //释放软件包，但是不进行配置,如果和-R一起使用，参数可以是一个目录
dpkg –configure remarkable_1.87_all.deb //重新配置和释放软件包. 如果和-a一起使用，将配置所有没有配置的软件包
dpkg -r remarkable_1.87_all ///删除软件包（保留其配置信息）
dpkg –update-avail <Packages-file> //替代软件包的信息
dpkg –merge-avail <Packages-file> //合并软件包信息 
dpkg -A package_file //从软件包里面读取软件的信息
dpkg -P //删除一个包（包括配置信息）
dpkg –forget-old-unavail //丢失所有的Uninstall的软件包信息
dpkg –clear-avail //删除软件包的Avaliable信息
dpkg -C  //查找只有部分安装的软件包信息
dpkg –compare-versions ver1 op ver2  //比较同一个包的不同版本之间的差别
dpkg –help  //显示帮助信息
dpkg –licence (or) dpkg –license //显示dpkg的Licence
dpkg --version  //显示dpkg的版本号
dpkg -b directory [filename]  //建立一个deb文件
dpkg -c filename //显示一个Deb文件的目录
dpkg -I filename [control-file] //显示一个Deb的说明
dpkg -l vim  //搜索Deb包
dpkg -l //显示所有已经安装的Deb包，同时显示版本号以及简短说明
dpkg -s ssh  //报告指定包的状态信息
dpkg -L apache2 //显示一个包安装到系统里面的文件目录信息(使用apt-get install命令安装)
dpkg -S remarkable //搜索指定包里面的文件（模糊查询）
dpkg -p remarkable //显示包的具体信息
dpkg-reconfigure --frontend=dialog debconf //重新配制 debconf，使用一个 dialog 前端 重新配制一个已经安装的包裹，如果它使用的是 debconf
dpkg --get-selections *wine*  //获取当前状态
```
