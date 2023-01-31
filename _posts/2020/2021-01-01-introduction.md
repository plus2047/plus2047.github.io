---
layout: mypost
title: 统计学习方法 第 01 章 统计学习方法概论
categories: [math, book-stat-learn]
---

在各种渠道零零碎碎学习了半年机器学习知识之后，越发感觉李航老师的《统计学习方法》确实是本好书。内容系统、完善又不过于繁琐，适合在有一定基础的情况下梳理自己的知识。我在学习过程中，为了日后查阅而整理了本篇笔记。除了课本知识要点之外，笔记也包括课本勘误、一些知识点的对比整理和补充。

统计学习三要素：模型（模型参数），策略（损失函数），算法（学习算法）。模型就是模型参数和使用模型参数计算概率或进行判别的函数。策略基本就是损失函数，或者最大似然估计与贝叶斯估计策略。算法则是从数据中学习模型参数的算法。

## 机器学习问题分类

- 按照数据有无标签：**监督学习** / **非监督学习**。典型的非监督学习问题：聚类
- 按照标签划分：
    - 标签为有限，可数，离散值：**分类问题**
    - 标签为连续值：**回归问题**
- 按照学习目标划分
    - 学习 $P(X,Y)$: **生成模型**
    - 学习 $P(Y \mid X)$ 或者直接学习判别函数: **判别模型**
- **半监督学习**介于监督学习与非监督学习之间，其数据部分有标签，部分无标签。通常无标签数据远远多于有标签数据。使用半监督学习技术的典型场景是，无标签的数据很充足，但对数据进行标注的成本很高。
- **强化学习**的典型场景是学习一个决策器（如围棋程序），对于决策器而言，某一步的决策会有长期影响，且我们虽然能够对单步决策进行某种形式打分（这一打分并不见得完善，比如我们对于围棋程序某一步棋虽然可以进行打分，但这一打分并不能反映这一步棋的长远影响），但并不知道最优决策是什么（作为对比，监督学习知道最优决策）。也可以认为强化学习的损失函数尽管能对单步决策进行打分，但不可导。

## MAP & MLE & ERM & SRM

本章教材中主要围绕损失函数的概念讲解统计学习模型的学习策略。但当学习的目标是某个概率分布时，可以定义其他学习策略。这里列举经常碰到的一些策略。

最小化训练集损失，经验风险最小化 Empirical rist minimization, ERM：

$$\theta_{ERM} = \arg\min_\theta \frac 1 N \sum_n L(y_i, P_\theta(y \mid x_i))$$

考虑到先验信息、过拟合等，对损失函数引入正则项，可以定义结构风险最小化 Structural rist minimization, SRM：

$$\theta_{ERM} = \arg\min_\theta \frac 1 N \sum_n L(y_i, P_\theta(y \mid x_i)) + \lambda J(\theta)$$

对于概率模型，可以定义极大似然估计 Maximum likelihood estimation, MLE：

$$\theta_{MLE} = \arg\max_\theta P(X \mid \theta)$$

以及最大后验估计（也即贝叶斯估计）Maximum a-posterior probability estimation, Bayesion estimation, MAP：

$$\theta_{MAP} = \arg\max_\theta P(\theta \mid X) = \arg\max_\theta P(X \mid \theta) P(\theta)$$

若 ERM 策略采用对数损失函数：

$$L(y_i, P_\theta(y \mid x_i)) = - \log P_\theta(y_i \mid x_i)$$

则 ERM 估计与 MLE 估计等价。证明见习题题解。相应的，MAP 则有时能等价为采用了特定正则项的 SRM 估计。

## 先验分布与经验分布

$X, Y$ 分别表示训练数据，测试数据，则有，

- 先验分布：并非来自数据，而是通过先验知识确定的分布。不一定指具体哪个分布，但常见的是 $P(X), P(Y)$.
- 经验分布：通过训练数据统计得来的分布，也不特指具体哪个分布。通过数据可以得到 $P(X,Y)$ 的经验分布，其他的经验分布可以由此推算。



## 习题题解

### 1.1

说明伯努利模型的三要素。

- 模型参数为 $p_0$, $P(x=0)=p_0$, $P(x=1)=1-p_0$.
- 策略
  - 极大似然估计策略：$p_0 = \arg\max_{p_0} P(X \mid p_0)$
  - 贝叶斯估计策略：$p_0 = \arg\max_{p_0} P(p_0 \mid X)$
- 算法
  - 极大似然估计：$p_0 = \frac{\text{Count}(x=0)}{N}$
  - 贝叶斯估计：
    $p_0 = \frac{\text{Count}(x=0) + \lambda}{N + 2\lambda}$

这里的伯努利模型可以视为第四章朴素贝叶斯法的单变量的简化，具体推导详见第四章。更准确地说是本书第四章朴素贝叶斯方法选取的概率模型是伯努利分布。

### 1.2

证明模型是条件概率分布，损失函数是对数损失函数时，经验风险最小化等价于极大似然估计。

$$
\theta_{ERM}
= \arg\min_\theta \sum_i \left[ - \log P_\theta(y_i \mid x_i) \right] \\
= \arg\max_\theta \sum_i \log P_\theta(y_i \mid x_i)  \\
= \arg\max_\theta \log \prod_i P_\theta(y_i \mid x_i)  \\
= \arg\max_\theta \log P_\theta(Y \mid X)  \\
= \arg\max_\theta P_\theta(Y \mid X)  \\
= \theta_{MLE}
$$
