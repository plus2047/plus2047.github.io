---
layout: mypost
title: IntelliJ PyCharm Notes
categories: [extra-tools]
---

一些 JetBrains IDE 的快捷键和其他基本使用。本文中快捷键默认为 macOS 快捷键。神奇的是，PyCharm 和 IntelliJ 的快捷键有很大的差异。版本：`IntelliJ 2017.3, PyCharm 2017.3`.

## 通用快捷键

一些非常有用、不适合归类在下文中的快捷键：

- `Command + Shift + A`: 快速搜索 IDE 的功能
- `Shift Shift`: （双击 shift）快速搜索类和方法

## 阅读导航快捷键 「Navigate 菜单」

读代码的时间可能比写代码的时间还长，因此代码阅读功能非常重要。「Navigate 菜单」提供有以下大部分快捷键。

### IntelliJ

- `Command+Click or Command+b`:跳转到定义、查看调用。阅读代码的基本办法。
- `Command+[, Command+]`: Back, Forward. 多次跳转之后的导航。**注意关闭输入法**。
- `Command+Shift+[, Command+Shift+]`: 最近编辑位置跳转。
- `Command+Shift+Backspace`: 上一次编辑位置。
- `Command+e, Command+Shift+e`: 最近打开的文件，最近编辑的文件。
- `Command+w`: 关闭标签页。

### PyCharm

PyCharm 大部分快捷键与 IntelliJ 相同。这里只列出与 IntelliJ 有所不同的快捷键。

- `Command+Alt+Left, Command+Alt+Right`: Back, Forward. 多次跳转之后的导航。

## 编辑器快捷键 「Edit 菜单」

属于文本编辑器功能的快捷键，与代码快捷键不同的是，本段列出的快捷键功能类似于 Sublime, VIM 的快捷键，不需要编辑器「理解」代码就能实现。

### IntelliJ

- `Command+x`: 剪切当前行
- `Command+d`: 复制当前行到下一行
- `Alt+Shift+Up or Down`: 当前行上移、下移
- `Command+f, Command+r`: 查找，替换
- `Command+Shift+f, Command+Shift+r`: 全局查找，替换
- `Command+Shift+F12`: 编辑器全屏

**多光标编辑快捷键**

- `Alt+J, Shift+Alt+J for Win/Linux`
- `Ctrl+G, Shift+Ctrl+G for macOS`: 选中、反选下一个命中字符串
- `Shift+Ctrl+Alt+J for Win/Linux`
- `Ctrl+Cmd+G for macOS`: 选中所有命中字符串

### PyCharm

- `Ctrl+Shift+f, Ctrl+Shift+r`: 全局查找，替换

## 代码快捷键

这部分快捷键是一定 IDE 而不是编辑器能够实现的，需要编辑器理解代码才能实现的快捷键。

- `Command+p`: 显示函数参数提示。

## 远程解释器

为了使用 SSH 远程解释器、并将本地代码和远程代码同步，需要两项配置：

1. Command + Shift + A 搜索 Deployment 设置 SFTP 服务器（文件同步必要）
2. Command + Shift + A 搜索 Project interpreter 设置项目解释器

两处均正确设置、重启 IDE 即可使用远程解释器。

## 参考

- [配置 PyCharm 使用远程解释器](https://medium.com/@erikhallstrm/work-remotely-with-pycharm-tensorflow-and-ssh-c60564be862d)

> 远程解释器也即本地写代码，但运行的时候自动提交到远程服务器运行，用于某些依赖服务器特定环境的场合。有时候远程解释器不如远程桌面方便，因为使用远程解释器开发时不能方便的访问、查看服务器上的资源。远程解释器的优势在于能够继续使用本地已经熟悉的 IDE 环境。

- [较完整的 IntelliJ 快捷键](http://wiki.jikexueyuan.com/project/intellij-idea-tutorial/keymap-mac-introduce.html)
- [官方 IntelliJ 快捷键，以及一些学习这些快捷键的技巧](https://www.jetbrains.com/help/idea/mastering-intellij-idea-keyboard-shortcuts.html)
- [官方 IntelliJ 快捷键 PDF 参考页](https://resources.jetbrains.com/storage/products/intellij-idea/docs/IntelliJIDEA_ReferenceCard.pdf)
- [官方 PyCharm 快捷键，以及一些学习这些快捷键的技巧](https://www.jetbrains.com/help/pycharm/mastering-pycharm-keyboard-shortcuts.html)

> 官方推荐了一款名为 `Key Promoter X` 的插件来学习这些快捷键。

