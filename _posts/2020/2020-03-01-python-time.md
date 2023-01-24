---
layout: mypost
title: Python Time The Code
categories: [tech]
---

本文记录一些用于 Python 代码计时和简单性能分析的工具。强烈推荐后两种工具。

## begin & end 手动计时

Matlab 里有一对 `tic toc` 命令，使用格式如下：

```matlab
tic
%do anything
toc
```

之后会打印中间的代码执行时间。这种风格对于简单的计时还是挺好用的。Python 中没有类似的特别方便的模块，只能用类似于下面的代码进行模仿：

```python
from time import time
begin = time()
# do anythingend = time()
print(end - begin)
```

## timeit 模块

timeit 模块用起来特别不方便：

```
from timeit import timeit

timeit(stmt='code to run', setup='init code', number=1000000)
```

后来逐渐发现这个模块是设计在 Shell 命令行模式下使用的，而不是在 IPython notebook 模式下使用的。因此这里不多介绍，需要在 Shell 命令行下计时时可以查阅其 Shell 模式下的使用方法。

## IPython Notebook %%time

使用 IPython Notebook 时，最简单的代码计时应该是 %%time 魔法命令（magic command, I am a Zhong 2）

```python
%%time
# code to run...
```

注意，‘%%’ 开头的魔法命令必须写在一个 cell 的第一行，并且通常以 cell 中剩余的内容作为输入变量。也就是这个魔法命令把 cell 中剩余的代码作为输入变量，对其进行计时。

## line_profiler

`line_profiler` 是一个强大的代码逐行时间或者空间开销分析工具，笔者通常用于代码逐行运行时间分析，从而定位到用时最多的代码，并且**能得到每行代码耗时百分比**。定位到代码热点之后可以对热点进行优化，从而以最小的改动而最大程度上提升代码效率。本文仅介绍笔者常用的一种方式。

使用前需要安装：

```
conda install line_profiler
# or
pip install line_profiler
```

在 Notebook 中使用，需要运行

```python
%load_ext line_profiler
```

使用 line_profiler 进行时间分析时，需要指定分析的函数，该工具只会对这个函数中的代码进行逐行分析。比如对函数 `hello` 和函数 `hi` 进行逐行分析，在 Notebook 中命令为

```
%lprun -f hello -f hi hello()
```

- `f` 参数表明接下来要指定一个函数名进行分析，最后一个参数则是要运行的代码。该命令会运行最后一个参数指定的代码，然后在运行时分析所有需要分析的函数。该命令运行之后会打印一个逐行分析报告。

更详细的使用方法参考 [如何进行 Python性能分析，你才能如鱼得水？](https://segmentfault.com/a/1190000005134492)，[easy profile python in jupyter](http://mortada.net/easily-profile-python-code-in-jupyter.html) 以及这些模块的帮助文档和官方文档。
