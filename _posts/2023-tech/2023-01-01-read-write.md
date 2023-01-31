---
layout: mypost
title: 读写锁
categories: [tech]
---

我在 2020 年某大厂实习时，曾经因为业务需求在 C++ 后端实现一个 Join 逻辑。当时的业务场景是新闻推荐系统，需求是实时生成曝光和点击训练数据流，然后使用流处理技术生成实时的训练样本，后续实时训练推荐系统模型。这一套日志-训练流程原本是用户行为日志落盘到 HDFS 后，使用 Spark 以 Batch Processing 的形式离线 Join 特征的。改成实时系统之后的设计为，后端在推荐引擎（Ranking 模型）获取用户特征完成推断后，缓存这部分用户特征。然后在曝光、点击用户行为返回后端后，后端将会从缓存中获取进行推断时的用户特征，与用户行为组合成为训练数据流。

于是，后端部分就需要实现一个简单的缓存以及查询功能。我们的后端是 C++ bRPC 框架（Baidu 版本的 gRPC 框架），C++ 版本为 C++11, 无法使用标准库之外的库。这样的逻辑在这个前向推断为主的引擎中是第一次实现，并没有其他代码参考。我负责从零实现这套逻辑。

bRPC / gRPC 当然是个高并发框架，我们需要实现一个并发安全的缓存。缓存机制选用最简单的 LRU Cache，于是我确实写了一个像极了面试题的 LRU Cache 在那里，对外暴露的接口与一个 map 类似，只支持元素的读和写两种操作。剩下的问题是，如何在 C++11 中，如何保证这个 Cache 的并发安全呢？

C++11 中有基本的锁 `mutex` 库。如果对整个容器加锁，当然是最简单的方案，

```cpp
#include <map>
#include <mutex>

std::map<int, int> myMap;
std::mutex mtx;

void readMap() {
  std::lock_guard<std::mutex> lock(mtx);
  // access the map here
}

void writeMap() {
  std::lock_guard<std::mutex> lock(mtx);
  // modify the map here
}
```

但这样是比较浪费的，实际上容器可以并行读取，只是不能并行写入。

我只学习过并发编程的一点皮毛。我粗浅的理解，为了实现这个需求，我可以只对写操作加锁，读操作检查一下锁就可以。结果出了线上 core dump. 之后我调试了好久，也没能解决问题。

现在重温这个问题，发现这是个著名问题 Read-Write-Lock. 一种著名实现如下，

```cpp
class ReadWriteLock {
    int reader_cnt = 0;
    std::mutex reader_cnt_mutex, writer_mutex;

public:
    void begin_read() {
        std::lock_guard<std::mutex> r_lock(reader_cnt_mutex);
        reader_cnt++;
        if(reader_cnt == 1) writer_mutex.lock();
    }
    void end_read() {
        std::lock_guard<std::mutex> r_lock(reader_cnt_mutex);
        reader_cnt++;
        if(reader_cnt == 0) writer_mutex.unlock();
    }
    void begin_write() {
        write_mutex.lock();
    }
    void end_write() {
        write_mutex.unlock();
    }
}
```

C++14 有内建的实现，

```cpp
#include <mutex>
#include <shared_mutex>
#include <map>

std::map<int, int> table;
std::shared_mutex table_shared_mutex;

int get(int key) {
    std::shared_lock<std::shared_mutex> s_lock(table_shared_mutex);
    return table[key];
}

int set(int key, int value) {
    std::unique_lock<std::shared_mutex> u_lock(table_shared_mutex);
    table[key] = value;
}
```
