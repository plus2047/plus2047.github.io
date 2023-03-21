---
layout: mypost
title: 机器学习碎片笔记
categories: [tech, snippet]
---

## 强化学习

简而言之，强化学习情境只有 Scoring 函数没有损失函数，Scoring 函数不可导，因此无法通过梯度下降法学习。强化学习算法有点类似于模拟退火。

## Normalization

- Batch Normalization: 在一个输入 Batch 上关于每一个特征进行归一化
- Layer Normalization: Batch Normalization 不能应用于 RNN 因为 RNN 的一个 Batch 常常是一个完整的时间序列。Layer Normalization 在同一层上关于每一个维度进行归一化（比如，如果输入是词向量序列，则每个词向量（或者过了几层的词向量）被归一化了），适用于 RNN 但对 CNN 效果不好。