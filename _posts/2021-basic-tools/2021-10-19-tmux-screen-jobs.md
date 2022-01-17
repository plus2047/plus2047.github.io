---
layout: mypost
title: Linux Jobs & TMUX & SCREEN Notes
categories: [basic-tools]
---

## Linux 基本任务调度

- `ctrl+z` 暂停进程并放入后台
- `jobs` 显示当前暂停的进程
- `bg %N` 使第N个任务在后台运行（% 前有空格）
- `fg %N` 使第N个任务在前台运行
- `ctrl+d` 发送 EOF
- `ctrl+c` 杀死进程（发送终止进程信号）

默认bg，fg不带%N时表示对最后一个进程操作.

有时候希望让一个正在运行的任务切换到后台，并且在登出之后继续运行，可以运行以下流程：

```sh
# only work for bash
# ctrl + z
disown -h %job_number
bg %job_number
# if only one job: %job_number can be omitted.
```

## TMUX

`tmux` 相当于打开一个后台进程保存所有的终端会话，即使远程连接等登录断开，会话仍然会保持，这样能够保证程序继续运行。`tmux` 具有良好的操作逻辑和帮助文档，如键入 `tmux s` 之后按下 `table` 能够看到所有补全命令和简单说明（这个功能可能是搭配 zsh 实现的）。 

- `tmux new -s session_name` 打开一个新 session.
- `tmux detach` 当前处于 session 中时，断开这个 session 但保持 session 在后台运行。
- `tmux ls` 列出所有 session.
- `tmux attach -t target_session` 当前不处于 session 中时连接到一个 session.
- `tmux switch -t target_session` 当前处于 session 中时，且换到另一个 session.

`tmux` 的一个 session 还可以分出来多个 `window`，这里因为笔者暂时用不到不再赘述。一个 `window` 可以分出来多个 `pane`:

- `tmux split-window` 将 window 垂直划分为两个 pane
- `tmux split-window -h` 将 window 水平划分为两个 pane
- `tmux swap-pane -[UDLR]` 在指定的方向交换 pane
- `tmux select-pane -[UDLR]` 在指定的方向选择下一个 pane

但是更熟练的操作方式是使用快捷键。`tmux` 的快捷键是先按下前缀，然后键入快捷键。默认前缀为 `ctrl+a`. 如果不记得下面列出的快捷键，可以按下冒号然后输入命令全称，如 `select-window`.

- `?` 列出所有快捷键；按q返回
- `d` 脱离当前会话,可暂时返回Shell界面
- `s` 选择并切换会话；在同时开启了多个会话时使用
- `:` 进入命令行模式；此时可输入支持的命令，例如 kill-server 关闭所有tmux会话
- `"` 将当前面板上下分屏
- `%` 将当前面板左右分屏
- `方向键` 移动光标选择对应面板

在通过 SSH 登录时自动开启 `tmux`:

```sh
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] ; then
    if [[ ! $TERM =~ screen ]]; then
        if tmux info &> /dev/null; then
            tmux attach &> /dev/null
        else
            exec tmux
        fi
    fi
fi
```

参考：[博客1](http://wdxtub.com/2016/f03/30/tmux-guide/); [博客2](http://kumu-linux.github.io/blog/2013/08/06/tmux/).

## SCREEN

SCREEN 不如 TMUX 功能丰富，但在大部分系统上预装，而且功能足够。其命令行使用（在 SCREEN 之外使用）可以参照 TLDR 帮助页。其默认操作以 `Ctrl+a` 作为前缀，可以设置成反引号方便使用。[一份详细的按键列表](http://aperiodic.net/screen/quick_reference)。

一些常在 SCREEN 中使用的快捷键：

Basic screen usage:

- New terminal: `ctrl+a, c`.
- Rename: `ctrl+a, A`.
- Previous terminal: `ctrl+a, backspace`.
- N'th terminal `ctrl+a, num_key`.
- Send `ctrl+a` to the underlying terminal `ctrl+a, a`.
- Scroll up `ctrl+a, esc`

About Splitting:

- To split horizontally: `ctrl+a, S` (uppercase S).
- To unsplit: `ctrl+a ,Q` (uppercase 'q').
- To switch from one to the other: `ctrl+a, tab`.

Note: After splitting, you need to go into the new region and start a new session via `ctrl+a, c` before you can use that area. 

特殊用法，用于任务调度，启动 `new screen` 并在其中运行命令：

```
screen -dmS new_screen sh
screen -S new_screen -X stuff "cd /dir
"
screen -S new_screen -X stuff "java -version
"
```

注意换行和引号的使用。

特殊用法，SSH 登录时启动 `screen` 并 attach 到一个特定的 screen, 可以在本地使用以下命令登陆:

    ssh -t host.example.com screen -Rd -S your_name

或者在服务器修改 `.bashrc` 文件，以便与 MOSH 兼容。添加行：
    
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] ; then
        if [ -z "$STY" ]; then screen -R -d; fi
    fi

## 计划任务

参考该文件：

```
/etc/crontab
```


