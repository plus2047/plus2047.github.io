---
layout: mypost
title: 统计学习方法 第 02 章 感知机
categories: [math]
---

- 线性二分类问题；分类问题，线性模型，监督训练；判别模型
- 定义：**感知机** 也即训练得到的分类器 $y = \mathrm{sign}(w\cdot x+b)$
- 分类器的几何解释是一个超平面 $0 = w \cdot x + b$，根据数据点在超平面哪一边进行决策

## 感知机训练算法

简洁起见，默认 $x$ 向量扩展了常数 $1$ 也即可以忽略偏置项 $b$。

- 最优化函数：$L(w,b) = - \sum_{y_i \neq \hat y_i}  y_i(w \cdot x_i)$. 注意求和只关于分类错误点进行
- 梯度下降法
    - $\nabla_w L = -\sum_{y_i \neq \hat y_i} y_i x_i$

注意，感知机训练时梯度下降法的下降速度参数只在判断收敛性时有意义而不会影响学习速度。因为一般会初始化 $w = 0$, 之后每一步更新 $w = w + \eta y_i x_i$，可见 $\eta$ 的不同只相当于对每一步的 $w$ 乘以一个常数。

## 算法伪代码

```text
w, b = 0, 0

pick (xi, yi) from data until no change for all data:
    if yi * w * xi < 0:
        w = w + eta yi xi
```

## 对偶算法

对偶算法与原始算法本质上相同。注意到 $w$ 是 $x$ 的线性组合：

$$ w = \sum a_i x_i y_i $$

原始算法改写成：

```text
for i: ai = 0

pick (xi, yi) from data until no change for all data:
    if yi * (sum (aj * yj * xj) * xi + b) < 0:
        ai += eta
```

这个算法可以存储 $x_i, y_i$ 矩阵加速运算，但是需要为每一个数据保存一个 $a_i$ 系数。在数据维度很高、数量有限时占优。原始形式在数据数量很多、维度有限时占优。

具体的，每次迭代，原始算法需要进行一次矢量乘法（k = 输入数据维度），一次矢量加法和数次标量加法。对偶算法需要进行 N 次标量乘法和数次标量加法（N = 数据个数）。故当 $k > N$ 时对偶算法速度占优。另外， $k > N$ 时对偶算法在内存占用上也占优。

## 习题题解

### 2.1

证明感知机无法学习 XOR 函数。

简便起见，使用 $-1$ 代替 $0$. 设数据集为：


| Index | 1 | 2 | 3 | 4 |
| --- | --- | --- | --- | --- |
| $x$ | $(1,1)$ | $(-1,-1)$ | $(-1,1)$ | $(1,-1)$ |
| $y$ | $1$ | $1$ | $-1$ | $-1$ |

证明数据集非线形可分。

假设存在 $w = (w_1, w_2), b$ 可以将以上数据线形可分，则：

$$
    + w_1 + w_2 + b > 0 \\
    - w_1 - w_2 + b > 0 \\
    - w_1 + w_2 + b < 0 \\
    + w_1 - w_2 + b < 0 \\
$$

前两式相加得到 $b > 0$，后两式相加得到 $b < 0$，所以假设不成立，数据不线形可分，于是感知级无法学习该数据。

### 2.2

构建从训练数据集求解感知机的例子。

这里直接实现一个感知机算法。

```python
import numpy as np

class Perceptron(object):
    def __init__(self, dim):
        self.w = np.zeros(dim)

    def train(self, data, max_epoch=100):
        for _ in range(max_epoch):
            _continue = False
            for x, y in data:
                if self.w.dot(x) * y <= 0:
                    self.w += np.asarray(x) * y
                    _continue = True
            if not _continue:
                break

    def predict(self, data):
        return [self.w.dot(x) for x, y in data]


if __name__ == "__main__":
    data = (((3, 3, 1), 1), ((4, 3, 2), 1), ((1, 1, 1), -1))
    p = Perceptron(3)
    p.train(data)
    print([y for x, y in data])
    print(p.predict(data))
```

运行输出：

```text
model params w: [ 1.  1. -3.]
data class: [1, 1, -1]
predict: [3.0, 1.0, -1.0]
```

### 2.3

证明样本集线形可分的充分必要条件是正实例点集所构成的凸壳与负样本点构成的凸壳互不相交。设集合 $S = \{x_1,\cdots,x_K\}$ 定义 $S$ 的凸壳 $\operatorname{conv}(S)$ 为：

$$
\newcommand{\cs}{\operatorname{conv}(S)}
\cs = \left\{ \mathbf x = \sum_k \lambda_k \mathbf x_k \,\right|\left.\, \sum_k \lambda_k=1, \lambda_k \geq 0 \right\}
$$

设负样本集和为 $\{\mathbf p_k\}$, 正样本集和为 $\{\mathbf q_k\}$。两者构成的凸壳分别为 $S_q, S_q$。

由于本题的证明较为繁琐，这里只给出基本思路。

【必要性】

必要性容易证明。线形可分时必然有分隔平面，取凸壳中任意一点，容易证明这个分隔平面也能分隔将其分隔到相应的一侧。

【充分性】

首先证明，凸壳中任意两点的连线也在凸壳中。

然后，由于 $S_p, S_q$ 不相交，可以设 $S_p,S_q$ 中距离最近的两点分别是 $P, Q$. 两点连线的中垂线为 $l$. 然后证明 $l$ 分隔了 $S_p, S_q$. 具体的证明方法是，$S_q$ 中任意一点 $A$ 与 $l$ 的距离不能小于 $P$ 与 $l$ 的距离，更不能在 $l$ 的另一侧，否则 $AP$ 连线上必然存在与 $Q$ 距离小于 $PQ$ 的点，而这一点也在凸壳中，与 $PQ$ 是 $S_p, S_q$ 中距离最近的点的假设矛盾。因此 $l$ 分隔 $S_p,S_q$，且实际上 $l$ 是支持向量机的最大间隔分类平面。
