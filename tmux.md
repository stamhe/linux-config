# tmux

### 文章
```
https://www.cnblogs.com/lizhang4/p/7325086.html
http://louiszhai.github.io/2017/09/30/tmux/

https://www.cxybb.com/article/qq_52319563/112008554

Ctrl+b ? 显示帮助， <esc> or q 退出
```

### panel 快捷键
```
Ctrl+b % 垂直分屏，划分左右两个 panel
Ctrl+b " 水平分屏，划分上下两个panel
Ctrl+b o 切换到下一个 panel
Ctrl+b ; 切换到上一个 panel
Ctrl+b <arrow key> 使用方向键切换panel
Ctrl+b q 显示 panel 编号，再接着按数字将可以快捷的切换 panel
Ctrl+b { 当前 panel 与上一个 panel 交换位置。
Ctrl+b } 当前 panel 与下一个 panel 交换位置。
Ctrl+b Alt+o 逆时针旋转当前窗口的 panel
Ctrl+b Ctrl+o 顺时针选择当前窗口的 panel

Ctrl+b x 关闭当前 panel
Ctrl+b z 将当前 panel 全屏显示，再按一次变回原来的样式
Ctrl+b ! 将当前 panel 拆分为一个独立窗口
Ctrl+b Ctrl+<arrow key>：按箭头方向调整 panel 大小
Ctrl+b t 显示时间
Ctrl+b i 显示当前 panel 信息

panel 批量执行相同的命令
Ctrl+b : 然后输入  set synchronize-panes 即可开启
```

### 窗口快捷键
```
Ctrl+b : 进行命令行模式，此时可以输入支持的命令，例如 kill-server 关闭服务器
Ctrl+b c 创建新窗口
Ctrl+b n 切换到下一个窗口(按照状态栏的顺序)
Ctrl+b p 切换到上一个窗口(按照状态栏的顺序)

Ctrl+b s 列出所有会话
Ctrl+b d 分离当前会话
Ctrl+b $ 重命名当前会话


Ctrl+b <number> 切换到指定编号的窗口，其中的 <number> 是状态栏的窗口编号
Ctrl+b w 从列表中选择窗口
Ctrl+b , 窗口重命名
Ctrl+b & 关闭当前窗口
Ctrl+b . 修改当前窗口的索引编号
Ctrl+b ' 切换到指定编号的窗口(索引大于 9 的窗口)
Ctrl+b f 在所有窗口中查找指定文本

```

### 会话关联命令
```
新建会话
tmux new -s <session-name>

在后台建立会话
tmux new -s <session-name> -d

查看当前所有的会话
tmux ls
tmux list-session

重新接入某个已经存在的会话
tmux attach -t <session-name>
tmux attach -t 1
tmux attach-session -t 1
tmux a -t <session-name>
tmux at -t <session-name>

连接上一个会话
tmux a


杀死指定的会话
tmux kill-session -t <session-name>

关闭除 s1 外的所有会话
tmux kill-session -a -t s1

关闭所有的会话
tmux kill-server
tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}' | xargs kill


重命名会话
tmux rename-session -t <old-session-name>  <new-session-name>
tmux rename -t <old-session-name>  <new-session-name>

列出所有的快捷键
tmux list-keys

列出所有 tmux 命令及其参数
tmux list-commands

列出所有tmux 会话信息
tmux info

重新加载当前的 tmux 配置
tmux source-file ~/.tmux.conf

在后台建立会话 stamhe，同时建立名称为 work 的窗口
tmux new-session -s stamhe -n work -d

在会话 stamhe 中, 划分上下两个panel ， 水平分屏
tmux split-window -t stamhe -v

在会话 stamhe 中, 对窗口名称为 work 的窗口中的编号为 1 的 panel，再次划分上下两个 panel, 水平分屏
tmux split-window -t stamhe:work.1 -v

在会话 stamhe 中, 划分左右两个 panel, 垂直分屏
tmux split-window -t stamhe -h

在会话 stamhe 中, 对窗口名称为 work 的窗口，划分左右两个 panel, 垂直分屏
tmux split-window -t stamhe:work -h

在会话 stamhe 中, 新建窗口名称为 work 的窗口
tmux new-window -t stamhe -n work

测试会话 stamhe 是否存在
tmux has-session -t stamhe
测试会话 stamhe 中是否存在名称为 work 的窗口
tmux has-session -t stamhe:work

测试会话 stamhe 中名称为 work 的窗口是否存在编号为 1 的 panel
tmux has-session -t stamhe:work.1

向会话 stamhe 中的 work 窗口中的编号为 1 的 panel 发送字符串 [ls -al /] 以及 回车键, 注意: C-m 代表回车，命令输入 以后，只有敲击了回车才会执行.
tmux send-keys -t stamhe:work.1 'ls -al /' C-m
tmux send-keys -t stamhe:work.1 'ls -al /' Enter

关闭会话 stamhe 中的名称为 work 的 窗口
tmux kill-window -t stamhe:work

关闭会话 stamhe 中的名称为 work 的 窗口中的编号为 2 的 panel
tmux kill-pane -t stamhe:work.2

```
