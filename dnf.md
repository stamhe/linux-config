# dnf包管理工具
```
代理
全局代理
用任意的文本编辑器打开/etc/dnf/dnf.conf
vim /etc/dnf/dnf.conf
在 [main] 的最后面加入这个
proxy=<scheme>://<ip-or-hostname>[:port]
proxy=socks5://127.0.0.1:1088
proxy=http://127.0.0.1:1089
proxy_username=
proxy_password=

列出启用的 DNF 存储库
# dnf repolist

列出所有启用和禁用的 DNF 存储库
# dnf repolist all
使用 DNF 列出所有可用和已安装的软件包
# dnf list
使用 DNF 列出所有已安装的软件包
# dnf list installed
使用 DNF 列出特定的包
dnf list installed | grep bash
使用 DNF 列出所有可用的包
# dnf list available

使用 DNF 搜索包
dnf search nano

dnf 选项“提供”查找提供特定文件/子包的包的名称。
dnf provides /bin/bash

使用 DNF 获取包的详细信息
# dnf info nano

使用 DNF 安装包
# dnf install nano

使用 DNF 更新包
你可以只更新一个特定的包（比如systemd）并且不改变系统上的所有内容。
# dnf update systemd

使用 DNF 检查系统更新
# dnf check-update

使用 DNF 更新所有系统包
您可以使用以下命令更新整个系统，包括所有已安装的软件包。
# dnf update
OR
# dnf upgrade
使用 DNF升级特定的包
dnf upgrade python3-perf

使用 DNF 删除/擦除包
要删除或擦除任何不需要的包（例如nano），您可以使用带有 dnf 命令的“ remove ”或“ erase ”开关来删除它。
# dnf remove nano
OR
# dnf erase nano

使用 DNF 删除孤立包
那些为了满足依赖而安装的包如果不被其他应用程序使用，可能会毫无用处。要删除这些孤立包，请执行以下命令。
# dnf autoremove

使用 DNF 删除缓存包
# dnf clean all

获取特定 DNF 命令的帮助
# dnf help clean

列出所有组包
命令“ dnf grouplist ”将打印所有可用或已安装的软件包，如果没有提及，它将列出所有已知的组。
# dnf grouplist

列出组包中有哪些包
dnf group info "Development Tools"

使用 DNF 安装组包
# dnf groupinstall 'Educational Software'
更新组包
# dnf groupupdate 'Educational Software'
删除组包
# dnf groupremove 'Educational Software'

从特定存储库安装包
DNF 使得从 repo ( epel ) 安装任何特定的包 (比如phpmyadmin ) 成为可能，就像，
# dnf --enablerepo=epel install phpmyadmin


将已安装的包同步到稳定版本
命令“ dnf distro-sync ”将提供必要的选项，以将所有已安装的软件包同步到任何启用的存储库中可用的最新稳定版本。如果未选择任何包，则同步所有已安装的包。
# dnf distro-sync

重新安装一个包
# dnf reinstall nano

降级软件包
如果可能，选项“downgrade”会将命名包（比如 acpid）降级到较低版本。
# dnf downgrade acpid
```
