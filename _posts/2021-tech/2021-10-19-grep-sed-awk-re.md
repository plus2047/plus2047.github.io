---
layout: mypost
title: grep, sed, awk and RegExp
categories: [tech, cheatsheet]
---

## GREP

GREP 用于行扫描，打印指定行

```sh
# 扩展正则表达式支持：
grep -E stream
egrep stream
# 只打印匹配部分：
grep -o 

# 扫描文件件中所有文件，-l 选项只打印文件名
grep -rl something ./*.txt
```

## SED

SED = stream editer

```sh
# GNU sed
# Replace regExp1 with something
sed -r 's/regExp1/something/g' stream
```

## AWK

AWK 逐行扫描文件并运行脚本。脚本的基本格式：

```awk
BEGIN{}
{}
END{}
```

BEGIN 语句块只在整个程序开始之前运行一次。中间的主语句块将会针对每一行运行一次。末尾的 END 语句块在程序运行结束前运行一次。
AWK 语法与 C/C++ 类似。每条语句末尾分号分隔。

- 支持 `+-*/%^ ++ --` 运算符
- 正则表达式放置在 `/` 中，如 `/regExp/`, 测试是否匹配：`$1~/regExp/`
- 支持 C 风格 `if,for,which,while` 循环，以及 `for(i in expr){}` 循环

### 内置变量

AWK 中变量默认不需要 $ 符号调用。

| Var | Means | 功能 |
|---|---|---
|\$0    |                   | 当前行
|\$1~\$n|                   | 当前行第 n 个域
|FS     |Field Seprator     | 域分隔符
|NF     |Number of Fields   | 当前行域数目
|NR     |Now Record         | 当前行号，（多文件）总行号
|FNR    |File Now Record    | （多文件）当前文件行号
|ENVIRON|                   | 

### 内置函数

`gsub sub substr index length match split sprintf strtonum tolower toupper`
`atan2 cos sin exp log sqrt int rand srand print`

---

# 正则表达式

- 正则表达式用于匹配一个特定的字符串。
- 没有任何标记的字符串，如 `apple` 是一个正则表达式，匹配这个单词本身。
- 本文基本遵循 GNU ERE 标准。各个工具开启 GNU ERE 标准的办法：
    `gerp -E`, `egrep`, `sed -E`（MacOS, FreeBSD）, `sed -r` （GNU）, `awk`( 默认 ).
- **务必确认工具支持正确的正则表达式标准，否则最基础的语法也会不兼容！**

## 元字符

|元字符 |匹配目标
|---|---
|.      |除换行符外任意字符
|\w     |字母（汉字）、数字、下划线
|\s     |空白字符
|\d     |数字
|\b     |单词开始或结束
|^      |字符串开始
|$      |字符串结束

反斜杠可以给字符转义。

## 反义

|元字符 |匹配目标
|--- | ---
|\W     |非字母（汉字）、数字、下划线
|\S     |非空白字符
|\D     |非数字
|\B     |非单词开始或结束
|`[^xyz]` |非 x, y, z

## 重复

分组或单个字符之后跟随重复标志，说明其重复次数。

|标志   |次数|
|---|---|
|*      |[0,inf)
|+      |[1,inf)
|?      |[0.1]
|{n}    |n
|{n,}   |[n,inf)
|{n,m}  |[n,m]

## “或”条件分支
`|` 记号左右两边的表达式有一个匹配即可。如 `abc|def` 匹配 `abc` 或者 `def`。这个记号的优先级很低，但是可以结合小括号使用，如：
`in=='(<|>)'` 匹配 `in=='<'` 或 `in=='>'`

## 分组与字符类
- 小括号内的正则表达式部分建立一个分组。
    - PRE 标准中，小括号中的部分自动获得一个数字编号，之后可以用反斜杠引用。 如 `(=)\1` 匹配 `==`。ERE 标准不一定支持该特性。
- 方括号里列出的字符构成字符类，匹配方括号中的任一字符。
- 字符类中可以使用范围制定，如 `[0-9a-zA-Z]` 代表数字与字母。
- 大括号用于标识重复次数。

