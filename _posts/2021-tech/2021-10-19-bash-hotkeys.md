---
layout: mypost
title: Bash Hotkeys
categories: [tech, cheatsheet]
---

UPDATED ON 2018.01.03

本片笔记中是一些 Bash 提供的快捷键（不是终端模拟器，比如不是 iTerm2 提供的快捷键），包括光标移动、历史命令等，其中命令历史相关的快捷键比较有用。

注意，`alt+alphabet` 风格快捷键在 macOS 上不可用，其替代是 `esc+alphabet`，先按下 `esc` 松开后再按下另一个键。

[TOC]

## 命令历史

* `ctrl+n` or `down arrow`: 下一条命令
* `ctrl+p` or `up arrow`: 上一条命令
* `alt+n`: 当前命令的下一次选项
* `alt+p`: 当前命令的上一次选项
* `ctrl+r`: 进入历史查找命令记录，输入关键字。**多次按返回下一个匹配项**，`delte` 返回前一个匹配项。回车执行。右箭头退出命令搜索并将当前结果保持在输入行。
* `history`: 该命令返回命令历史。而后可以通过 `grep` 扫描命令历史

## 移动光标

这些光标移动快捷键

* `ctrl+b`: 后移一个字符(backward)
* `ctrl+f`: 前移一个字符(forward)
* `alt+b`: 后移一个单词
* `alt+f`: 前移一个单词
* `ctrl+a`: 移到行首（a 是第一个字母） 
* `ctrl+e`: 移到行尾（end）

## 编辑命令

* `ctrl+w`: 删除当前光标到临近左边单词结束 (w=word)
* `ctrl+d`: 删除光标后一个字符 (d=delete)
* `alt+w`: 删除光标左边所有
* `alt+d`: 向右删除一个单词
* `ctrl+h`: 删除光标前一个字符（功能相当于 backspace）
* `ctrl+k`: 删除光标右边所有
* `ctrl+u`: 清空正在输入的命令
* `ctrl+l`: 清屏
* `alt+.`: 粘帖最后一次命令最后的参数（如用于`mkdir long-long-dir`后, `cd`配合着`alt+.`）


