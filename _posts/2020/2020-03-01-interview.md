---
layout: mypost
title: 秋招开发面试存档
categories: [tech]
---

存档在几次秋招开发面试中遇到的问题。

---

# C++ 智能指针

简而言之，推荐使用的智能指针有 unique_ptr, shared_ptr, weak_ptr. auto_ptr 已经被废弃。

unique_ptr 代表独占引用，被 unique_ptr 引用的对象具有跟指针一致的生命周期。在 unique_ptr 离开作用域时，被引用的对象被释放。unique_ptr 可以移动不能拷贝。

shared_ptr 就是我们通常理解的引用计数智能指针。weak_ptr 是配合 shared_ptr 使用的弱引用，不会增加引用计数。

[参考文章](https://juejin.im/post/5dcaa857e51d457f7675360b)

# Java 线程之间资源隔离

我两次被问到这个知识点，说明这个知识点并不生僻，需要准备。

Java 线程之间的隔离指的应该是 ThreadLocal, 相对于类的 static 字段，ThreadLocal 字段在不同的线程中会读到不同的实例：

```java
class MyClass {
    public static String allThreadsGetTheSameObject;
    public static ThreadLocal<String> differentObjectForEachThread;
}
```

这个类的实现也非常简单。ThreadLocal 实例可以访问一个 Map, 该 Map 是 Thread 实例的一个字段。从该 Map 中根据该对象的指针查询具体实例。

逻辑上相当于利用线程号和对象指针两个 Key 查询实例，需要一次散列表查找过程。

# 阿里云面试订正

## Redis

- 一篇综述文章：https://juejin.im/post/5cc012a7f265da03452bdd6e
- 过期策略与内存淘汰策略：https://www.jianshu.com/p/8aa619933ebb
- 序列化：严格来说并不是 Redis 序列化策略，而是编程语言将对象序列化保存到 Redis. 因此序列化策略也即编程语言的序列化策略。具体情况具体分析，通常来说语言和工具内置的序列化方便但兼容性差，出问题不方便调试。自行实现序列化策略灵活性好。基于文本的序列化浪费空间但可读性好，二进制序列化性能好但可读性差，需要特定软件包支持。诸如此类。
- Redis 使用「槽」解决数据分发问题。对于全部在单机上的 Key 使用单线程约束避免一切时序问题，不在单机上的 Key 不支持同时操作。