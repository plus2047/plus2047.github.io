---
layout: mypost
title: 统计学习方法 第 06 章 洛基斯蒂回归与最大熵模型
categories: [math, cs-stat-learn]
---

## 逻辑斯蒂回归模型

### 模型及模型参数

二项逻辑斯蒂回归模型是指如下的概率分布：

$$\begin{align*}
P(y=0 \mid x) &= \frac 1 {1 + \exp(W \cdot x)} \\
W &= (w_1, w_2, \cdots, w_n, b) \\
x &= (x_1, x_2, \cdots, x_n, 1)
\end{align*}$$

模型参数为 *W* 向量。

> 逻辑斯蒂模型可能是最简单的概率模型。 事件发生的概率除以事件不发生的概率称为事件发生的几率 odds. 设关于 X 的线性函数 W⋯X 反映了事件发生的对数几率，也即：
> 
> 
> $$\begin{align*}
> W \cdot x &= \log \frac{P(y=1 \mid x)}{1-P(y=1 \mid x)} \\
> P(Y=1 \mid x) &= \frac{\exp(W \cdot x)}{1 + \exp(W \cdot x)}
> \end{align*}$$
> 
> 另外，逻辑斯蒂分布是指：
> 
> $$\begin{align*}
> F(x) &= P(X \leq x) = \frac 1 {1 + \exp\left(-\frac{x-\mu}\lambda\right)} \\
> f(x) &= F'(x) = \frac{\exp\left(-\frac{x-\mu}\lambda\right)} {\lambda\left[ 1 + \exp\left(-\frac{x-\mu}\lambda\right) \right]^2}
> \end{align*}$$
> 

### 策略（目标函数）及求解算法

极大似然估计法。似然函数：

$$ \begin{align*}
\pi(x) &:= P(Y=1 \mid x)\\
P(X, Y \mid W) &= \prod_{n=1}^N \pi(x_n)^{y_n}\left[1-\pi(x)\right]^{1-y_n} \\
L(W) &= \log P(X,Y \mid w) \\
&= \sum_{n=1}^N y_n \log \pi(x_n) + (1-y_n)\log[1-\pi(x_n)] \\
&= \sum_{n=1}^N y_n \log \frac{\pi(x_n)}{1-\pi(x_n)} + \log[1-\pi(x_n)] \\
&= \sum_{n=1}^N y_n w \cdot x_n - \log[1+\exp(w \cdot x_n)] \\
\end{align*} $$

一般使用梯度下降法或者拟牛顿法求解该似然函数。

> 另外，如果 $y\in\{-1, 1\}$ 损失函数可以被整理成另一种形式，参照 Sklearn Docs. Sklearn 中的实现可以设置正则项。

### 多项逻辑斯蒂回归

$$
\begin{align*}
P(y=k \mid x) &= \frac {\exp(W_k \cdot x)} {1 + \sum_{i=1}^K\exp(W_i \cdot X)} \\
W &= (w_1, w_2, \cdots, w_n, b) \\
X &= (x_1, x_2, \cdots, x_n, 1) \\
k &= 1, 2, \cdots, K
\end{align*}
$$

也即 SoftMax 函数。其参数估计方法与二项逻辑斯蒂回归相同。

## 最大熵模型

最大熵原理是概率模型学习的一个准则。在所有可能的概率分布 $p$ 中，优化准则为：

$$\begin{align*}
P(y \mid x) &= \arg\max_P H(P) \\
H(P) &= -\sum_x \hat P(x) P(y \mid x) \log P(y \mid x)
\end{align*}$$

搜索目标为条件概率分布 $P(y∣x)$，因此最大熵模型是判别模型。直观而言，最大熵准则在可能的概率分布内取最接近均匀的的分布。熵衡量分布的均匀程度（混乱程度），在均匀分布时最大化。$\hat P(x)$ 是 X 在训练数据集上的经验分布，也即 $\hat P(x_C) = \frac{\sum_n I(x_n=x_C)}{N}$.

引入「特征函数」$f_j(x, y)$ 作为限制：

$$
\sum_n \hat P(y∣x) \hat P(x) f_i(x,y) = \sum_n P(y∣x)\hat P(x)f_i(x,y)
$$

以及固有限制 $\sum_i P(y_i|x)=1$，运用拉格朗日乘子法可以解得最大熵模型：

$$\begin{align*}
P_w(y = y_i \mid x) &= \frac{\exp\left[ \sum_k w_k f_k(x,y_i) \right]}{\sum_i \exp\left[ \sum_k w_k f_k(x,y_i) \right]}
\end{align*}$$

之后需要使用梯度下降法等办法关于 $w$ 求最大化。

## 分析与思考：逻辑斯蒂回归模型与最大熵模型

令 $w_0=0$, 类别标签即 $w_i$ 的下标 $i$, 逻辑斯蒂回归模型公式可以写成：

$$\begin{align*}
P(y=y_i \mid x) &= \frac{\exp(w_i \cdot x)}{\sum_i\exp(w_i \cdot x)}
\end{align*}$$

这样二分类、多分类问题被归结到一个公式中。从该公式更容易看出看出逻辑斯蒂回归的本质：为每一个类别学习一个向量 $w_i$, 然后根据 $w_i \cdot x$ 的大小比较进行分类。如果不加以限制，学习到的所有 $w_i$ 可以加一个常数而不影响分类结果，因此可以引入限制 $w_0=0$.

对比最大熵模型：

$$\begin{align*}
P(y = y_i \mid x) &= \frac{\exp\left[ \sum_k w_k f_k(x,y_i) \right]}{\sum_i \exp\left[ \sum_k w_k f_k(x,y_i) \right]}
\end{align*}$$

可以看出，逻辑斯蒂回归模型是最大熵模型的一个特例。若取最大熵模型的特征函数个数与类别个数相同，特征函数取为：

$$\begin{align*}
f_k(x,y_i) = x \cdot \delta(k,i)
\end{align*}$$

最大熵模型即退化为逻辑斯蒂回归模型。此时，每个特征函数代表一个类别，只在样本属于该类别时，特征函数原样输出 *x*. 这一特征函数也可以帮助我们理解何为特征函数，我们可以由此仿造一些特征函数，如：

$$\begin{align*}
f_k(x,y_i) = x^2 \cdot \delta(k,i)
\end{align*}$$

## 习题

### 1. 确认逻辑斯蒂分布属于指数分布族。

按照指数分布的一般形式：

$$\begin{align*}
f_X(x\mid\theta) = h(x) \exp \left (\eta(\theta) \cdot T(x) -A(\theta)\right )
\end{align*}$$

逻辑斯蒂分布不是指数分布。

### 2. 写出逻辑斯蒂回归模型学习的梯度下降法。

这里只给出损失函数的导数：

$$ \begin{align*}
L(W) &= - \log P(X,Y \mid w) \\
&= \sum_{n=1}^N - y_n w \cdot x_n + \log[1-\exp(w \cdot x_n)] \\
L'(W) &= \sum_{n=1}^N - y_n x_n - \frac{\exp(w\cdot x_n) x_n}{1-\exp(w \cdot x_n)} \\
&= \sum_{n=1}^N - \left[ y_n - P(y=1|x_n) \right] x_n
\end{align*} $$

### 3. 写出最大熵模型的 DFP 算法。

同样只给出部分导数：

$$\begin{align*}
\max_w \Psi(w) &= \max_w P_w(y=y_i \mid x)
\end{align*}$$

DFP 算法只需要求该无约束最优化问题的梯度，该导函数不难求出，但有些复杂：

$$\begin{align*}
\frac{\partial}{\partial w_\alpha} P_w(y=y_i \mid x) &= B \cdot P_w(y = y_i \mid x) \\
B &= \frac{\sum_j \exp  A_j \cdot[f_\alpha(x, y_i) - f_\alpha(x, y_j)]}{\sum_j \exp A_j} \\
A_j &= \sum_k w_k f_k(x,y_j)
\end{align*}$$