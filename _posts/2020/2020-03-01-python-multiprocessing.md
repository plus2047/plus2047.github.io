---
layout: mypost
title: Python Multiprocessing Notes
categories: [tech]
---

## Multiprocessing 通信

由于全局解释器的存在，Python 进行 CPU 密集任务时必须使用多进程而非多线程。科学计算中面临如何在多进程间共享数据的问题。

从[官方文档](https://docs.python.org/3/library/multiprocessing.html)调研到以下主要的通信方式：

- `Multiprocessing.Queue`. 多进程安全的通信队列，一个进程像队列中写入，另一个进程读出。支持检测队列是否空、是否满等操作。
- `Multiprocessing.Value, Array`. 用于多进程间共享变量（共享内存）。支持 Python 基本变量，非基本变量如 Numpy 数组需要先转换为 Bytearray 再进行共享（Numpy 实现有方便的与 Bytearray 互转的基础设施）。
- `Multiprocessing.Manager`:

```python
from multiprocessing import Process, Manager

def f(d, l):
    d[1] = '1'
    d['2'] = 2
    d[0.25] = None
    l.reverse()

if __name__ == '__main__':
    with Manager() as manager:
        d = manager.dict()
        l = manager.list(range(10))
        p = Process(target=f, args=(d, l))
        p.start()
        p.join()
        print(d)
        print(l)
```

类似于共享内存，Manager 能够实现一般的共享变量，且甚至可以跨物理主机共享变量。其问题是底层实现不是共享内存，效率较低。

---

其他多进程通信设备：

- `Multiprocessing.Pipe`. 传统的管道。有点像长度为 1 的队列。
- `Multiprocessing.Lock`. 多进程锁。

## Multiprocessing Pool

[参考博客](http://luly.lamost.org/blog/python_multiprocessing.html)

```
p = multiprocessing.Pool(4)
p.map(print, [1,2,3,4])
```
