---
layout: mypost
title: 统计学习基础 第 10 章 隐马尔可夫模型
categories: [math]
---

本文特殊记号：$x_1,x_2,\cdots,x_n \rightarrow x_1^n$；$I$ 代表 $I$ 数据集，$i_t$ 代表数据集中某时刻的状态，也即一条观测数据。一些【马尔可夫链】相关概念：

【**一阶马尔可夫假设**】：$P(x_i \mid x_1^{i-1}) = P(x_i \mid x_{i-1})$
【**状态转移矩阵**】有限状态，一阶马尔可夫链，则可定义状态转移矩阵：$a_{ij}=P(x_a=j \mid x_{a-1}=i)$

## 隐马尔可夫模型的定义

引入「状态」（不可观测）$i$ 与「观察」（观察结果）$o$，状态之间的跳转，以及状态对应的观察结果，都是随机的，分别进行建模。

一阶马尔可夫假设 + 【**输出独立性假设**】 $P(o_t \mid i_1^{t},o_1^{t-1})=P(o_t \mid i_t)$
建模变量（**模型参数**）：**状态转移矩阵** $\{ a_{ij} \}$ ；**输出概率矩阵** $\{ b_j(k) \}$ ；**初始状态分布** $\{ \pi_i \}$。记为 $\lambda = \{ a_{ij}, b_j(k), \pi_i\}$.

## 隐马尔可夫模型的三个基本问题

- 评价问题：给定模型（包括参数）$\lambda$ 和观察序列 $O$，模型生成观察序列的概率 
$$P(O\mid\lambda)$$
- 学习问题：给定观察序列和可能的模型空间，如何调整模型参数，使后验概率最大：
$$\arg\max_\lambda P(O\mid\lambda)$$
或者监督学习问题，给定 $I, O$ 和模型空间，学习参数 $\lambda$
$$\arg\max_\lambda P(O, I\mid\lambda)$$
- 解码问题：给定模型（包括参数）$\lambda$ 和观察序列 $O$，输出该观察序列最可能的状态序列 
$$\arg\max_I P(O \mid I, \lambda)$$ 

> 二阶及以上 HMM 的上述三个问题数学上没有漂亮的解，导致二阶以上的 HMM 模型应用受限。一般 HMM 指一阶 HMM 模型。

## 评价问题

求解：$P(O \mid \lambda)$

>【直接计算】
>
> $$P(O \mid \lambda)=\sum_{i_1,i_2\cdots i_T} \pi_{i_1}b_{i_1}(o_1)a_{i_1i_2}b_{i_2}(O_2)\cdots a_{i_{T-1}i_T}b_{i_T}(o_T) $$
>
>式中 $\pi$ 为初始状态。由于需要遍历所有可能的 $i_1,i_2\cdots i_T$ 组合，计算复杂度过高。

【前向算法（动态规划算法）】

定义 **前向概率**：

$$\alpha_t(i) = P(o_1,o_2,\cdots,o_t,i_t=i\mid\lambda)$$

**前向算法**：

1. 初始化：$$\alpha_1(i) = \pi_i b_i(o_1)$$
2. 递推：$$\alpha_{t+1}(i)=\left[ \sum_j \alpha_t(j)a_{ji}\right] b_i(o_{t+1})$$
3. 终止：$$P(O\mid\lambda) = \sum_i \alpha_T(i)$$

【后向算法（动态规划算法）】

定义 **后向概率**：

$$\beta_t(i) = P(o_{t+1},o_{t+2},\cdots,o_T\mid i_t=i, \lambda)$$

**后向算法**：

1. 初始化
$$\beta_T(i)=1$$
2. 递推
$$\beta_t(i)=\sum_j a_{ij} b_j(o_{t+1})\beta_{t+1}(j)$$
3. 终止
$$P(O\mid\lambda)=\sum_i \pi_i b_i(o_1)\beta_1(i)$$

同时给出前向概率和后向概率主要是为了计算以下概率与期望，为学习问题作准备。**（以下的两个公式虽然较为繁琐，实际上并不困难）**：

$$\begin{align*}
\gamma_t(i) 
&= P(i_t=i\mid O,\lambda) \\
&= \frac{P(i_t=i,O\mid\lambda)}{P(O\mid\lambda)} \\
&= \frac{\alpha_t(i)\beta_t(i)}{\sum_j \alpha_t(j)\beta_t(j)} \\
\xi_t(i,j) 
&= P(i_t=i, i_{t+1}=j\mid O,\lambda) \\
&= \frac{P(i_t=i, i_{t+1}=j,O\mid\lambda)}{P(O\mid \lambda)} \\
&= \frac{P(i_t=i, i_{t+1}=j,O\mid\lambda)}{\sum_i\sum_jP(i_t=i, i_{t+1}=j,O\mid\lambda)} \\
&= \frac{\alpha_t(i)a_{ij}b_j(o_{t+1})\beta_{t+1}(j)}{\sum_i\sum_j \alpha_t(i)a_{ij}b_j(o_{t+1})\beta_{t+1}(j)}
\end{align*}$$



## 学习问题：Baum-Welch 算法（EM 算法）

首先解决简单的监督学习方法，也即输出序列和隐状态序列 $O, I$ 均为已知，此时可以使用 MLE 估计。

首先定义：

$$\begin{align*}
A_{ij} &:= \sum_t I(i_t=i, i_{t+1}=j) \\
B_{jk} &:= \sum_t I(i_t=j, o_t=k)
\end{align*}$$

然后 MLE 估计结果：

$$\begin{align*}
\hat a_{ij} &= P(i_{t+1}=j\mid i_t=i) =\frac{A_{ij}}{\sum_j A_{ij}} \\
\hat b_{j}(k) &= P(o_t\mid i_t=j) = \frac{B_{jk}}{\sum_k B_{jk}}
\end{align*}$$

> 注意有 $\sum_j A_{ij} = \sum_k B_{ik}$

初始状态 $\pi_i$ 的估计需要有多组数据，然后统计各组数据初始状态即可。

应用本书上一章的 EM 算法和拉格朗日乘子法能够容易的得到 BW 算法：

【 BAUM-WELCH 算法 】

1. 初始化：初始化参数 $a_{ij}^{(0)}, b_{j}(k)^{(0)}, \pi_i^{(0)}$
2. 循环：$\text{for } n=1\cdots:$
    1. 使用 $\lambda_{n-1},O$ 计算 $\xi_t(i,j), \gamma_t(j)$.
    2. 迭代更新参数：
$$\begin{align*}
a_{ij}^{(n)} &= \frac{\sum_t \xi_t(i,j)}{\sum_j\sum_t \xi_t(i,j)} \\
b_j(k)^{(n)} &= \frac{\sum_{t, o_t=k} \gamma_t(j)}{\sum_t \gamma_t(j)} \\
\pi_i^{(n)} &= \gamma_1(i)
\end{align*}$$


## 解码问题

给定模型（包括参数）$\lambda$ 和观察序列 $X_i$，输出该观察序列最可能的状态序列。

【 VITERBI 维特比算法（动态规划算法）】

定义：

$$\begin{align*}
\delta_t(i) &= \max_{i_1,i_2,\cdots,i_{t-1}} P(i_t=i,i_1,\cdots,i_{t-1},o_1,\cdots,o_{t-1}\mid\lambda)
\end{align*}$$

可以得到递推公式：

$$\begin{align*}
\delta_{t+1}(i) = \max_j\left[\delta_t(j)a_{ji}\right]b_i(o_{t+1})
\end{align*}$$

为了回溯最优路径，记录下递推公式每次求解极大问题的下标选择：

$$\begin{align*}
\psi_t(i) &= \arg\max_j \left[ \delta_{t-1}(j)a_{ji} \right]
\end{align*}$$

组合成维特比算法：

1. 初始化 $\delta_1(i)=\pi_i b_i(o_1)$
2. 循环 $\text{for } t = 2\cdots:$
$$\begin{align*}
\delta_t(i) &= \max_j\left[\delta_{t-1}(j)a_{ji}\right]b_i(o_{t+1}) \\
\psi_t(i) &= \arg\max_j \left[ \delta_{t-1}(j)a_{ji} \right]
\end{align*}$$
3. 选择最后一个隐状态 $i_T^* = \arg\max_j \delta_T(j)$
4. 回溯隐状态序列 $i_t^* = \psi_{t+1}(i_{t+1}^*)$

> 以下推导不是来自课本，记号跟上文有所不同。
> 最优化问题写为：
>
> $$\begin{align*}
& \max_{H_{1\cdots T}} P(X_{1 \cdots T}, H_{1 \cdots T}) \\
= & \max P(X_{1 \cdots T} \mid H_{1 \cdots T}) P(H_{1 \cdots T}) \\
= & \max P(X_{1 \cdots T-1} \mid X_T H_{1 \cdots T}) P(X_T \mid H_{1 \cdots T}) P(H_{1 \cdots T}) \\
\end{align*}$$
>
> 注意
>
> $$\begin{align*}
P(X_{1 \cdots T-1} \mid X_T) &= \frac{P(X_T \mid X_{1 \cdots T-1})P(X_{1 \cdots T-1})}{P(X_T)} \\
&= \frac{P(X_T)P(X_{1 \cdots T-1})}{P(X_T)} \\
&= P(X_{1 \cdots T-1})
\end{align*}$$
>
> 同理 $P(X_{1 \cdots T-1} \mid H_T) = P(X_{1 \cdots T-1})$
>
> 于是：
>
> $$\begin{align*}
& \max P(X_{1 \cdots T-1} \mid X_T H_{1 \cdots T-1}) P(X_T \mid H_T) P(H_{1 \cdots T}) \\
= & \max P(X_{1 \cdots T-1} \mid H_{1 \cdots T-1}) P(X_T \mid H_T) P(H_{1 \cdots T}) \\
= & \max P(X_{1 \cdots T-1} \mid H_{1 \cdots T-1}) P(X_T \mid H_T) P(H_T \mid H_{1 \cdots T-1})P(H_{1 \cdots T-1}) \\
= & \max P(X_{1 \cdots T-1} \mid H_{1 \cdots T-1}) P(X_T \mid H_T) P(H_T \mid H_{T-1})P(H_{1 \cdots T-1}) \\
= & \max_{H_{1 \cdots T-1}} \max_{H_T} P(X_{1 \cdots T-1} \mid H_{1 \cdots T-1}) P(X_T \mid H_T) P(H_T \mid H_{T-1})P(H_{1 \cdots T-1}) \\
= & \max_{H_{1 \cdots T-1}}P(X_{1 \cdots T-1} \mid H_{1 \cdots T-1}) P(H_{1 \cdots T-1}) \max_{H_T} P(X_T \mid H_T) P(H_T \mid H_{T-1}) \\
= & \max_{H_{1 \cdots T-1}}P(X_{1 \cdots T-1}, H_{1 \cdots T-1}) \max_{H_T} P(X_T \mid H_T) P(H_T \mid H_{T-1}) \\
= & \max_{H_1} P(X_1 \mid H_1) P(H_1 \mid H_0) \\
  & \max_{H_2} P(X_2 \mid H_2) P(H_2 \mid H_1) \cdots \\
  & \max_{H_T} P(X_T \mid H_T) P(H_T \mid H_{T-1}) 
\end{align*}$$
>
> 注意每个 $\max$ 运算符只对其后的四项有效，于是动态规划算法成为可能。


