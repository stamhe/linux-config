# ansible 
```
其实最早在 2013 年就玩过 ansible 了，这次重新系统的再学习一次，毕竟好多年了，而且2013年的时候，ansible 刚出来
https://www.stamhe.com/?p=1115


！！！主要示例看 letsencrypt-acme.yml 即可！！！ TLS证书申请不要用 ansible 原始带的模块，又难用又复杂，可以批量全自动申请.certbot 不能并行，ansible 执行要带 -f 1 保证串行执行.
！！！主要示例看 vps-init.yml 即可！！！     全自动化初始安装全新的 server.
！！！主要看 letsencrypt-acme-renew.yml 即可！！！ TLS 证书的自动更新，可以批量全自动更新. certbot 不能并行，ansible 执行要带 -f 1 保证串行执行.



资料
http://www.linuxe.cn/post-273.html
https://www.junmajinlong.com/ansible/index/
https://coconutmilktaro.top/2018/Ansible%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0

https://my.oschina.net/kangvcar/blog/1830155
https://www.cnblogs.com/xuanlv-0413/p/14815170.html

when
https://www.cnblogs.com/breezey/p/10996632.html


apt install ansible -y
ansible --version

环境变量列表
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html


/etc/ansible/ansible.cfg    主配置文件
/etc/ansible/hosts          Inventory

export ANSIBLE_CONFIG=/etc/ansible/ansible.cfg
export ANSIBLE_PRIVATE_KEY_FILE=~/.ssh/id_rsa
export ANSIBLE_INVENTORY=/etc/ansible/hosts

vim /etc/ansible/ansible.cfg
[defaults]
module_name=shell
deprecation_warnings=False
inventory=/etc/ansible/hosts
private_key_file=~/.ssh/id_rsa

配置文件查找优先级，找到第一个，其他的都忽略
ANSIBLE_CONFIG (environment variable if set)
ansible.cfg (in the current directory)
~/.ansible.cfg (in the home directory)
/etc/ansible/ansible.cfg


/etc/ansible/hosts：主机列表清单，也叫Inventory。所有被管理的主机都需要定义在该文件中。如果不想使用默认清单的话可以用-i选项指定自定义的清单文件，防止多人混合使用一个主机清单。如果没有定义在主机列表文件中，执行命令会提示“No hosts matched”



ansible <host-pattern> [-f forks] [-m module_name] [-a args]
<host-pattern>：该选项指定ansible命令对哪些主机生效，可以使用主机列表中的地址或者组名，all代表所有主机
[-f forks]：并发数，可以理解为ansible一次性要让多少个主机执行任务，配置文件中默认为5
[-m module_name]：使用的模块名
[-a args]：每个模块特有的参数，可以用ansible-doc -s 模块名来查看模块对应参数
-b：老版本中的sudo指令，将在远端主机切换到root执行操作，这个root用户是在ansible配置中定义的
-K：sudo时需要输入的密码
-i: 指定 inventory 文件
-vvv or -vvvv 输出详细信息


常用模块
通过ansible-doc -l命令可以显示当前版本所支持的模块信息
通过ansible-doc -s modulename显示指定模块的详细用法
ansible-doc -s yum
ansible-doc -s shell


常见使用示例
ansible 192.168.1.100 -m ping  #指定某台主机
ansible all -m ping  #指定所有主机
ansible 192.168.1.100:192.168.1.50 -m ping  #一次指定多台主机
ansible all:\!192.168.1.100 -m ping  #排除某台主机
ansible web -m ping -u dba -k  #使用dba用户对web组进行操作
ansible web -m command -a 'cat /etc/passwd' -u dba -k -b  -K #使用dba用户连接web组，然后sudo到root用户查看passwd文件
ansible hk -m setup
ansible hk -a "hostname"



# 匹配apache组中有，但是nginx组中没有的所有主机
[root@ansible ~]# ansible 'apache:!nginx' -m ping
# 匹配apache组和nginx组中都有的机器（并集）
[root@ansible ~]# ansible 'apache:&nginx' -m ping
# 匹配apache组nginx组两个组所有的机器（并集）；等于ansible apache,nginx -m ping
[root@ansible ~]# ansible 'apache:nginx' -m ping


command模块：默认模块。让远端主机执行指定的命令，但command不支持变量、重定向、管道符等操作
ansible 192.168.44.130 -a 'date'
ansible hk -m command -a 'date'
修改默认模块
/etc/ansible/ansible.cfg
module_name = shell



shell模块：和command模块一样是用来运行命令，当命令中有变量或者管道符的时候要用shell模块，特殊符号需要转义，比如\$
shell支持变量、重定向、管道符等操作
chdir：执行命令前，切换到该目录
creates：当该文件存在时，不执行该步骤
executable：使用shell环境执行脚本
free_from：需要执行的脚本
removes：当该文件不存在时，不执行该步骤
warn：如果在ansible.cfg中存在告警，如果设定了false，不会告警此行
ansible hk -m shell -a "echo \$HOME > /tmp/t.log"
ansible hk -m shell -a "echo test | passwd --stdin user1"
ansible hk -m shell -a "ps -ef|grep nginx"




expect 模块,  执行命令并响应提示, 需要 python3-pexpect 支持
chdir 	运行command命令前先cd到这个目录
command 必须参数，命令模块执行命令运行
echo 	是否回显你的回应字符串
responses 必须参数，期望的字符串/正则表达式和字符串的映射来响应。 如果响应是一个列表，则连续的匹配将返回连续的响应。 列表功能是2.1中的新功能。
creates 如果这个参数对应的文件存在，就不运行command
removes 如果这个参数对应的文件不存在，就不运行command，与creates参数的作用相反
timeout 默认30秒，以秒为单位等待预期时间




ping模块：测试远端主机是否能连接
ansible all -m ping



cron模块：设置定时任务，其中有个state选项包含present、absent两个参数，分别代表增加和移除
minute  指定分钟
hour    指定小时
day     表示那一天
weekday 表示周几, 0 - 6
month   指定月份
job     指定任务, 定时任务要执行的命令
backup  默认no, yes/no 表示修改或删除对应计划任务时，会先进行备份，备份路径/tmp/crontab+随机字符
state   默认 present, present 安装,  absent 删除
special_time：reboot|yearly|monthly|weekly|daily|hourly，都未指定时表示每分钟执行
user：指定计划任务属于哪个用户，默认管理员用户
disabled：默认 no, 注释计划任务，使其失效；但是一定要写全原任务的name,minute,hour,month,weekday,job，如果不一样，则是修改原计划任务内容
安装/更新相同
ansible hk -m cron -a 'minute="*/10" job="/bin/echo test > /dev/null 2>&1" name="cron-job-name-test"'
ansible hk -m cron -a 'hour="*/2" job="/bin/echo test > /dev/null 2>&1" name="cron-job-name-test"'
删除
ansible hk -m cron -a 'name="cron-job-name-test" state="absent"'
禁用(需要写全)
ansible hk -m cron -a 'hour="*/2" job="/bin/echo test > /dev/null 2>&1" name="cron-job-name-test" disabled=yes'
ansible hk -m cron -a "minute=0 hour=0 day=* month=* weekday=* name='cron-job-name-ntpdate' job='ntpdate 172.25.70.250'"





synchronize 模块 - 依赖 rsync 软件包，必须安装 rsync
archive 默认yes, 是否采用归档模式同步，即以源文件相同属性同步到目标地址。由于模块默认启用了archive参数，该参数默认开启了recursive, links, perms, times, owner，group和 -D 参数。如果你将该参数设置为no，那么你将停止很多参数，比如会导致如下目的递归失败，导致无法拉取。注意：partial 没有默认开启.
delete=yes 默认no, 使两边的内容一样（即以推送方为主）,删除源中没有但目标存在的文件，使两边内容一样，以推送方为主
compress=yes 开启压缩，默认为 yes
checksum=yes 检测sum值，防止文件篡改，默认 no
--exclude=.git 用于定义排除单独的文件夹和文件, 忽略同步.git 结尾的文件, 子文件夹也会生效, 由于这个是rsync命令的参数，所以必须和rsync_opts一起使用，比如rsync_opts=--exclude=*.txt这种模式
--exclude-from    用于定义排除多个文件夹和文件
mode=push 默认都是推送push。因此，如果你在使用拉取pull 功能的时候，可以参考如下来实现mode=pull 更改推送模式为拉取模式
copy_links=yes 复制符号链接，是映射的文件复制
group=yes   保留文件的所属组
owner=yes   保留文件的所属者(只有超级用户可以操作)
perms=yes   保留文件的权限
rsync_opts  通过此选项指定其他的rsync的选项
recursive   默认yes, 是否递归yes/no
times       默认yes, 保留文件的修改时间 yes/no
rsync_timeout   指定 rsync 操作的 IP 超时时间，和rsync命令的 --timeout 参数效果一样
private_key Specify the private key to use for SSH-based rsync connections
dest_port   Port number for ssh on the destination host.Prior to Ansible 2.0, the ansible_ssh_port inventory var took precedence over this value.
partial     默认no, 等价于"--partial"选项。默认rsync在传输中断时会删除传输了⼀半的⽂件，指定该选项将保留这部分不完整的⽂件，使得下次传输时可以直接从未完成的数据块开始传输。

ansible hk -m synchronize -a "src=/data/tmp/ dest=/data/tmp/ partial=yes"
ansible hk -m synchronize -a "src=/tmp dest=/mnt rsync_opts=--exclude=*.log partial=yes delete=yes checksum=yes"
ansible hk -m synchronize -a 'src=time.sh dest=/tmp/'



user模块：管理用户，还有一个group模块用于管理组
name    用户名
uid     uid
state   状态  
group   属于哪个组
groups  附加组
home    家目录
createhome  是否创建家目录
comment 注释信息
system  是否是系统用户
ansible hk -m user -a "name=mysql system=yes"



group模块   组管理
gid     gid      
name    组名              
state   状态          
system  是否是系统组
ansible webserver -m group -a 'name=mysql gid=306 system=yes'
ansible webserver -m user -a 'name=mysql uid=306 system=yes group=mysql'
   
   


file模块：设置文件的属性，如所属主、文件权限等
# path：指定要设置的文件或者文件夹所在路径，可使用name或dest替换
# state：指明文件的格式，touch=创建新的文件；absent=删除文件，link=创建软连接文件；directory=创建目录; hard=创建硬链接。创建文件的软连接时src指明源文件，path指明连接文件路径
创建文件的符号链接：src：    指定源文件 path：   指明符号链接文件路径
ansible hk -m file -a 'owner=root group=root mode=0755 path=/data/tmp'
ansible hk -m file -a 'owner=root group=root mode=644 path=/data/tmp/t.txt state=touch'
ansible hk -m file -a 'path=/etc/passwd.link src=/etc/passwd state=link'




fetch：从远程主机提取文件至主控端，copy相反，目前不支持目录,可以先打包,再提取文件
ansible hk -m fetch -a 'src=/root/test.sh dest=/data/scripts'
会生成每个被管理主机不同编号的目录,不会发生文件名冲突
ansible hk -m shell -a 'tar jxvf test.tar.gz /root/test.sh'
ansible hk -m fetch -a 'src=/root/test.tar.gz dest=/data/'
     

     


service模块：控制服务运行状态
# enabled：是否开机自动启动，取值为true或者false
# name：服务名称
# state：状态，取值有started，stopped，restarted, reloaded
ansible hk -m service -a 'enabled=true name=nginx state=started'
ansible hk -m service -a 'name=nginx state=reloaded'



script模块：将本地的脚本复制到远端主机并执行
    chdir：在执行脚本之前，先进入到指定目录
    creates：当远程主机上的该文件存在时，不执行脚本；反之执行
    removes：当远程主机上的该文件不存在时，不执行脚本；反之执行

先进入/opt目录下，再执行test.sh脚本
ansible hk -m script -a 'chdir=/opt /tmp/t.sh'
若/opt/a.file存在时，不执行test.sh脚本
ansible hk -m script -a 'creates=/opt/a.file /tmp/t.sh'
若/opt/a.file不存在时，不执行test.sh脚本
ansible hk -m script -a 'removes=/opt/a.file /tmp/t.sh'

ansible hk -m script -a '/tmp/t.sh'



yum模块：安装程序包，远端主机需要先配置好正确的yum源
ansible -m yum -a 'name=httpd state=present' 
# name：指明要安装的程序包，可以带版本号，否则默认最新版本，多个安装包用逗号分隔
# tate：present代表安装，也是默认操作；absent是卸载；latest最新版本安装



apt 模块
name=nginx 	apt要下载的软件包名字，支持name=git=1.6 这种制定版本的模式
state=latest 	最新版本, absent 卸载, present 安装, latest 最新版本
default_release 	使用的发布包 squeeze-backports, 等同于apt命令的-t选项
update_cache 	默认no, 是否在安装之前更新源，也就是 apt update
upgrade         默认yes, 如果参数为yes或者safe，等同于apt-get upgrade.如果是full就是完整更新。如果是dist等于apt-get dist-upgrade。
deb 这个用于安装远程机器上的.deb后缀的软件包
force   强制执行apt install/remove
install_recommends  默认 true, 这个参数可以控制远程电脑上是否只是下载软件包，还是下载后安装，默认参数为true,设置为false的时候光下载软件包，不安装
purge   如果state参数值为absent,这个参数为yes的时候，将会强行干净的卸载
cache_valid_time    如果update_cache参数起作用的时候，这个参数才会起作用。其用来控制update_cache的整体有效时间. 单位：秒
ansible hk -m apt -a "name=nginx state=latest default_release=squeeze-backports update_cache=yes"
ansible hk -m apt -a "name=nginx state=latest"

安装软件
ansible hk -m apt -a "name=unzip state=present"
ansible hk -m apt -a "deb=/data/app/nginx.deb"
卸载软件
ansible hk -m apt -a "name=unzip state=absent purge=yes"

# 3600 秒后停止 apt update
ansible hk -m apt -a "update_cache=yes cache_valid_time=3600"



setup模块：收集被管理主机的信息，包含系统版本、IP地址、CPU核心数。在Ansible高级操作中可以通过该模块先收集信息，然后根据不同主机的不同信息做响应操作，类似Zabbix中的低级别发现自动获取磁盘信息一样
ansible hk -m setup

使用setup获取ip地址以及主机名使用filter过滤等等
ansible hk -m setup -a 'filter=ansible_default_ipv4'

获取内存
ansible hk -m setup -a 'filter=ansible_memory_mb'

获取主机名
ansible hk -m setup -a 'filter=ansible_nodename'



copy模块：将ansible管理主机上的文件拷贝上远程主机中,与fetch相反,如果目标路径不存在,则自动创建。如果 src 的目录带 "/"结尾 则复制该目录下的所有东西,如果 src 的目录不带 "/" 结尾,则连同该目录一起复制到目标路径.
# src=：定义本地源文件的路径
# dset=：定义目标文件路径, Dest目标路径写多个，命令行最后一个dest路径为准:
# content=：用该选项直接生成内容，替代src
# backup=：如果目标路径存在同名文件，将自动备份该文件
# force参数:当远程主机的目标路径中已经存在同名文件,并且与ansible主机中的文件内容不同时,是否强制覆盖,可选值有yes和no,默认值为yes,表示覆盖,如果设置为no,则不会执行覆盖拷贝操作,远程主机中的文件保持不变。
# owner参数:指定文件拷贝到远程主机后的属主,但是远程主机上必须有对应的用户,否则会报错。
# group参数:指定文件拷贝到远程主机后的属组,但是远程主机上必须有对应的组,否则会报错。
# mode参数: 设置文件权限,模式实际上是八进制数字（如0644）,少了前面的零可能会有意想不到的结果。从版本1.8开始,可以将模式指定为符号模式（例如u+rwx或u=rw,g=r,o=r）
# follow参数: 当拷贝的文件夹内有link存在的时候，那么拷贝过去的也会有link, 默认 no

ansible hk -m copy -a 'src=/tmp/t.sh dest=/data/tmp/ owner=root group=root mode=0644'
ansible hk -m copy -a 'content="hello world" dest=/tmp/t.txt owner=root mode=0644 backup=yes'
ansible hk -m copy -a 'src=/data/logs dest=/data/ owner=root group=root mode=0755 follow=yes'




Hostname：管理主机名
ansible hk -m hostname -a "name=app.adong.com"  更改一组的主机名
ansible 192.168.38.103 -m hostname -a "name=app2.adong.com" 更改单个主机名
    



unarchive：解包解压缩，有两种用法：
1、将ansible主机上的压缩包传到远程主机后解压缩至特定目录，设置copy=yes.
2、将远程主机上的某个压缩包解压缩到指定路径下，设置copy=no
常见参数：
copy：默认为yes，当copy=yes，拷贝的文件是从ansible主机复制到远程主机上， 如果设置为copy=no，会在远程主机上寻找src源文件
src： 源路径，可以是ansible主机上的路径，也可以是远程主机上的路径，如果是远程主机上的路径，则需要设置copy=no
dest：远程主机上的目标路径
mode：设置解压缩后的文件权限 
示例：
ansible hk -m unarchive -a 'src=foo.tgz dest=/var/lib/foo'  
#默认copy为yes ,将本机目录文件解压到目标主机对应目录下
ansible hk -m unarchive -a 'src=/tmp/foo.zip dest=/data copy=no mode=0777'
# 解压被管理主机的foo.zip到data目录下, 并设置权限777
ansible hk -m unarchive -a 'src=https://example.com/example.zip dest=/data copy=no'

Archive：打包压缩
ansible all -m archive -a 'path=/etc/sysconfig dest=/data/sysconfig.tar.bz2 format=bz2 owner=wang mode=0777'
将远程主机目录打包 
path:   指定路径
dest:   指定目标文件
format: 指定打包格式
owner:  指定所属者
mode:   设置权限
        
        



```


### playbook
```
ansible-playbook playbookname.yml -i  /etc/ansible/hosts
ansible-playbook -t tag_name httpd.yml #-t指定标签名，多个标签用逗号分隔
ansible-playbook playbookname.yml --list-tasks #列出该playbook中的任务
ansible-playbook playbookname.yml --list-tags #列出该playbook中的tags
ansible-playbook --syntax-check nginx_tags.yaml 

ansible-playbook temp2nginx.yml  --limit 192.168.1.100 目标主机只执行某一台, 但是必须是主机清单这个文件指定的这个组的ip才可以

# --check | -C：只检测可能会发生的改变，但不真正执行操作
# --list-hosts：列出运行任务的主机
# --list-tags：列出playbook文件中定义的所有tags
# --list-tasks：列出playbook文件中定义的所有任务
# --limit：主机列表 只针对主机列表中的某个主机或者某个组执行
# -f：指定并发数，默认为5个
# -t：指定tags运行，运行某一个或者多个tags。前提是playbook中有定义tags, 多个标签用逗号分隔

ansible-playbook命令结果说明：
ok：已经达到任务要求，不需要 ansible 再次处理. 也就是说 ansible 经过检查，发现不需要执行任务也可以达到目的
changed：经过了ansible的处理，再次执行则会发现这些信息也变成了ok
PLAY RECAP：一个汇总报告 



Playbook的语法要求
1、playbook本质是包含了一个或多个play的YAML配置文件，通常以.yaml或者.yml结尾
2、在单一的一个playbook文件中，使用连续的三个中横线（---）作为每个play的区分
3、缩进必须统一，不能空格和tab混合使用，缩进级别需要一致，同样的缩进代表同样的级别

facts 是由正在通信的远程目标主机发回的信息，这些信息被保存在ansible变量中。要获取指定的远程主机所支持的所有facts，可使用如下命令进行：
ansible hk -m setup


=====================================================================
ansible 主控本机本地执行命令
方式一：如果整个 playbook 都想在ansible local host 执行，那指定 hosts: 127.0.0.1 and connection:local
注：你可以避免在 playbook 中输入 connection: local，把它添加到你的 ansible.cfg 中：
localhost ansible_connection=local
例如
- name: a play that runs entirely on the ansible local host
  hosts: 127.0.0.1
  connection: local
  tasks:
  - name: check out a git repository
    git: repo=git://foosball.example.org/path/to/repo.git dest=/local/path
   
方式二：如果只是想 playbook 的某一些任务在 ansible localhost 执行
如果您只想在您的Ansible主机上运行单个任务，则可以使用local_action若要指定任务应在本地运行，请执行以下操作
- name: an example playbook
  hosts: webservers
  tasks:
  - ...

  - name: check out a git repository
    local_action: git repo=git://foosball.example.org/path/to/repo.git dest=/local/path


方式三：以用来delegate_to在Ansible主机（管理主机）上运行Ansible播放的位置运行命令。例如：
如果Ansible主机上已存在该文件，请删除该文件：
 - name: Remove file if already exists
   file:
    path: /tmp/logfile.log
    state: absent
    mode: "u+rw,g-wx,o-rwx"
   delegate_to: 127.0.0.1

方式四: 
ansible all -i "localhost," -c local -m shell -a 'echo hello world'

=====================================================================
变量
register 把任务的输出定义为变量，然后用于其他任务，实例如下：
tasks:
   - shell: /usr/bin/foo
     register: foo_result
     ignore_errors: True



通过命令行传递变量, 在运行playbook的时候也可以传递一些变量供playbook使用，示例如下：
ansible-playbook test.yml --extra-vars "hosts=www user=mageedu"
ansible-playbook test.yml -e "hosts=www user=mageedu"



通过roles传递变量, 当给一个主机应用角色的时候可以传递变量，然后在角色内使用这些变量，示例如下：
- hosts: webserver
    roles:
   - common
   - {role: foo_app_instance, dir: '/web/htdocs/a.com', port: 8080}
   

主机变量, 可以在inventory中定义主机时为其添加主机变量以便于在playbook中使用，例如：
[hk]
www1.magedu.com http_port=80 maxRequestsPerChild=808
www2.magedu.com http_port=8080 maxRequestsPerChild=909


组变量, 组变量是指赋予给指定组内所有主机上的在playbook中可用的变量。例如：
[hk]
www1.magedu.com
www2.magedu.com
[hk:vars]
ntp_server=ntp.magedu.com
nfs_server=nfs.magedu.com
key1=value1
key2=value2


组嵌套, inventory中，组还可以包含其它的组，并且也可以向组中的主机指定变量。不过，这些变量只能在ansible-playbook中使用，而ansible不支持。例如：
[apache]
httpd1.magedu.com
httpd2.magedu.com
[nginx]
ngx1.magedu.com
ngx2.magedu.com
[webserver:children]    #固定格式
apache
nginx
[webserver:vars]
ntp_server=ntp.magedu.com


=====================================================================
条件
when语句
在task后添加when字句即可使用条件测试；when语句支持jinja2表达式语句，例如：
tasks:
 - name: 'shutdown debian flavored system"
   command: /sbin/shutdown -h now
   when: ansible_os_family == "Debian"


when语句中还可以使用jinja2的大多"filter",例如果忽略此前某语句的错误并基于其结果(failed或success)运行后面指定的语句，可使用类似如下形式；

tasks:
 - command:/bin/false
   register: result
   ignore_errors: True
 - command: /bin/something
   when: result|failed
 - command: /bin/something_else
   when: result|success
 - command: /bin/still/something_else
   when: result|skipped



此外，when语句中还可以使用facts或playbook中定义的变量
# cat cond.yml
- hosts: all
 remote_user: root
 vars:
 - username: user10
 tasks:
 - name: create {{ username }} user
   user: name={{ username }}
   when: ansible_fqdn == "node1.exercise.com"
   
   
=====================================================================
迭代 https://docs.ansible.com/ansible/playbooks_loops.html
当有需要重复性执行的任务时，可以使用迭代机制。其使用格式为将需要迭代的内容定义为item变量引用，并通过with_items语句来指明迭代的元素列表即可。例如：
- name: add server user
 user: name={{ item }} state=persent groups=wheel
 with_items:
   - testuser1
   - testuser2

上面语句的功能等同于下面的语句：
- name: add user testuser1
 user: name=testuser1 state=present group=wheel
- name: add user testuser2
 user: name=testuser2 state=present group=wheel


事实上，with_items中可以使用元素还可为hashes，例如：
- name: add several users
 user: name={{ item.name}} state=present groups={{ item.groups }}
 with_items:
   - { name: 'testuser1', groups: 'wheel'}
   - { name: 'testuser2', groups: 'root'}
   

=====================================================================
Ansible template使用方法
多数情况下都会建立一个templates目录并和playbook同级，这样playbook可以直接引用和寻找这个模板文件，如果在别的路径需要单独指定。模板文件后缀名为.j2
cp /etc/nginx/nginx.conf templates/nginx.conf/j2

```

### playbook 配置文件加解密
```
ansible-vault  (了解)
功能：管理加密解密yml文件
ansible-vault [create|decrypt|edit|encrypt|rekey|view]
ansible-vault encrypt hello.yml 加密
ansible-vault decrypt hello.yml 解密
ansible-vault view hello.yml    查看
ansible-vault edit hello.yml    编辑加密文件
ansible-vault rekey hello.yml   修改口令
ansible-vault create new.yml    创建新文件
```




