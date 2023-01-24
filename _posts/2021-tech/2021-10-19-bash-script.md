---
layout: mypost
title: Bash Script
categories: [tech, cheatsheet]
---

## 变量与命令行参数

```shell
echo hello; echo "hello"  # no different
a="HelloWorld"; echo ${a}

b[1]=7; b[3]=4  # no declaring for list. or:
declare -a vec=(element1 element2 element3)
for i in ${vec[@]}; do echo $i; done
# get values, length
echo ${c[*]} ${#b[*]} 
# get length of string
echo ${#a}

d=$(($a + $b)) # + - * /

# command line args
# $#：number of args  # $@：each args
# $*：all args as ONE string  # $n: No.n args
echo $0 $1 $* $@ $#

# special variable
echo $RANDOM
echo $PWD
```

## 重定向 / 读取变量

```sh
# > for stdout, 2> for stderr, >> for append stdout to file
echo 'hello_world' > hello.txt 2> error.txt >> add.txt 
# discard all
echo &> /dev/null
# file as stdin
echo < read.txt
# print to file AND stdout
command | tee output.txt
command | tee -a output.txt  # append
# channel
echo 'hello_world' | less

# from file to var
read var_name < file
# from file to stdin
cat filename
# get stdin
read var_name
read -p 'Please input x:' x
```

## 判断 / If

```sh
# if is dir / file
[ -d dir_name ] && [ -f filename ]
[ -e name ]  # if is file or dir
# compare numbers
[ num1 -eq num2 ]
# -eq like == in clang  # -ne like != in clang
# -gt like >  in clang  # -ge like >= in clang
# -lt like <  in clang  # -le like <= in clang

# use "" and when $1 is null it won't crash
[ "$1" = "hello" ]
[ $1 = hello ]  # crash when $1 is null
# some true expr:
[ -n NullString ] && [ noNullString ]
[ string1 = string1 ] && [ string1 != string2 ]
[ -z variableExist ]
[ -x "$(command -v command_name)" ]  # if command exist

[ ! bool_expression ]  # not
[ expr1 -a expr2 ]  # and
[ expr1 -o expr2 ]  # or

# if structure
if [ test ]; then
    echo helloworld
else
    echo helloworld
fi
```

## 控制流 / For / While

```sh
# loop
for i in {1..10}; do
    echo $i
done
# c-style for
for ((i=0;i<10;i++)); do
    echo $i
done
while [ test ]; do
    echo helloword
done
```

## 函数 / Function

```sh
# Function
function _echo {  # be careful for the spaces.
    echo $1
    echo $2
    # keyword return can be used in function
    # if no return, the value of the last sentence
    # will be the return value of this function 
    res='this var can be access out of this function.'
}
echo res
```

## 字符串属性与操作

```sh
# all of substring can be regexp
# REF: https://www.centos.bz/2013/08/bash-shell-string-operate-summary/

${#string}  # length of string
${string:position}  # string[position:]
${string:position:length}  # string[position:position+len]

${string#substring} # remove substring from the BEGIN of string. 
# if substring is a regexp, remove the SHORTEST match
${string##substring} # remove substring from the BEGIN of string. 
# if substring is a regexp, remove the LONGEST match

${string%substring} # remove substring from the END of string. 
# if substring is a regexp, remove the SHORTEST match
${string%%substring} # remove substring from the END of string. 
# if substring is a regexp, remove the LONGEST match

${string/substring/replacement}
# replace 'substring' with 'replacement' for the FIRST match.
${string//substring/replacement}
# replace 'substring' with 'replacement' for ALL match.
${string/#substring/replacement}
# replace 'substring' with 'replacement' only if substring is PREFIX.
${string/%substring/replacement}
# replace 'substring' with 'replacement' only if substring is SUFFIX.
```

## 特殊目录

脚本运行时，其工作目录是调用脚本时所在的工作目录 `pwd`. `$0` 参数是脚本文件名，跟 `pwd` 拼接之后就是脚本绝对路径。

```sh
$(pwd)  # work dir
$(dirname "$0")  # script file path
$(readlink -f "$0")  # absolute script file path
```