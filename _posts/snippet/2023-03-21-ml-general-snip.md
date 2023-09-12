---
layout: mypost
title: 机器学习碎片笔记
categories: [tech, snippet]
---

### 强化学习

简而言之，强化学习情境只有 Scoring 函数没有损失函数，Scoring 函数不可导，因此无法通过梯度下降法学习。强化学习算法有点类似于模拟退火。

### Normalization

- Batch Normalization: 在一个输入 Batch 上关于每一个特征进行归一化
- Layer Normalization: Batch Normalization 不能应用于 RNN 因为 RNN 的一个 Batch 常常是一个完整的时间序列。Layer Normalization 在同一层上关于每一个维度进行归一化（比如，如果输入是词向量序列，则每个词向量（或者过了几层的词向量）被归一化了），适用于 RNN 但对 CNN 效果不好。

### Embedding Distance Defination / 嵌入空间距离定义问题

最常用的定义是 cos 距离。这就是比较恰当的定义。

一般来说，不应该使用点乘定义 dot product. 考虑如果训练样本有偏，有些 item 正样本比例较高，则这些 item 在 dot product 关联的 loss 函数下就会导致模长较长，并导致其与所有的 item 的「距离」都更近。这会导致热门 item 容易被任何 item 召回，这通常不是期望的行为。

在 HNSW 文档中也提到，dot product (inner product) 严格而言并不是一个距离定义，运行效率较低，存在一些问题。比如，每个 item 不一定是距离它自身最近的 item.

至于 cos 的归一化导致向量被限制在单位球面上，这其实只是损失了一个自由度，在向量维度不太小时影响不大。

> 我在实际数据集上验证了 ip 比 cos 明显差，但没有验证出来两者的结果有没有热度差异。
> 
> 有人指出，若训练样本更充分、精细 Fine Tune, IP 效果更好。但没有文献和理论支持。
