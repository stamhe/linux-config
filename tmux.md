# tmux

### 文章
```
https://www.cxybb.com/article/qq_52319563/112008554
```

### panel 快捷键
```
Ctrl+b % 垂直分屏，划分左右两个 panel
Ctrl+b " 水平分屏，划分上下两个panel
Ctrl+b o 切换到下一个 panel
Ctrl+b ; 切换到上一个 panel
Ctrl+b <arrow key> 使用方向键切换panel
Ctrl+b q 显示 panel 编号，再接着按数字将可以快捷的切换 panel
Ctrl+b {：当前 panel 与上一个 panel 交换位置。
Ctrl+b }：当前 panel 与下一个 panel 交换位置。
Ctrl+b Ctrl+o：所有 panel 向前移动一个位置，第一个 panel 变成最后一个 panel 
Ctrl+b Alt+o：所有 panel 向后移动一个位置，最后一个 panel 变成第一个 panel 

Ctrl+b x 关闭当前 panel
Ctrl+b z 将当前 panel 全屏显示，再按一次变回原来的样式
Ctrl+b !：将当前 panel 拆分为一个独立窗口
Ctrl+b Ctrl+<arrow key>：按箭头方向调整 panel 大小
```

### 窗口快捷键
```
Ctrl+b c 创建新窗口
Ctrl+b n 切换到下一个窗口(按照状态栏的顺序)
Ctrl+b p 切换到上一个窗口(按照状态栏的顺序)

Ctrl+b s 列出所有会话
Ctrl+b d 分离当前会话
Ctrl+b $ 重命名当前会话


Ctrl+b <number> 切换到指定编号的窗口，其中的 <number> 是状态栏的窗口编号
Ctrl+b w 从列表中选择窗口
Ctrl+b , 窗口重命名
```

### 会话关联命令
```
新建会话
tmux new -s <session-name>

查看当前所有的会话
tmux ls
tmux list-session

重新接入某个已经存在的会话
tmux attach -t <session-name>
tmux attach -t 1
tmux attach-session -t 1

杀死指定的会话
tmux kill-session -t <session-name>

重命名会话
tmux rename-session -t <old-session-name>  <new-session-name>

列出所有的快捷键
tmux list-keys

列出所有 tmux 命令及其参数
tmux list-commands

列出所有tmux 会话信息
tmux info

重新加载当前的 tmux 配置
tmux source-file ~/.tmux.conf

```

