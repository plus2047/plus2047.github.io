---
layout: mypost
title: Lagrange 拉格朗日乘子法
categories: [mlearn]
---

拉格朗日乘子法用于解决多变量函数在多个约束条件下的极值问题。即使没有拉格朗日乘子法，该问题也是可以解决的。最简单的方法，利用约束条件消元，转换为无约束条件的极值问题。不方便消元时，有时可以对约束条件进行隐变量求导，然后在导数层次上消元。但是这些方法并不可靠。拉格朗日乘子法比这些方法可靠一些。

拉格朗日乘子法的复杂性主要来自函数的凹凸性概念在高维空间及其子空间上变得复杂。

拉格朗日乘子法的「简单版本」较为直观。对于一元函数，需要在指定区间上求极值时一般的方法是求导数。**拉格朗日乘子法实质上是求导求极值方法在高维函数上的应用。**

无约束的最优化问题，求一阶导数（梯度），令导数等于零即可。或者数值计算上可以使用梯度下降法求解。

## 等式约束的最小化

- 多变量求函数最小值 $=$ 高维空间中求函数极值
- 等式约束 $\rightarrow$ 高维空间中约束曲面，限定在约束曲面上求极值
- 极值出现在约束超曲面与函数等值超曲面相切的点上

二维情况下可见如下示意图：

![hello](https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Lagrange_multiplier.png/300px-Lagrange_multiplier.png)

问题的数学化表述：

$$ 
\min_x f(x) \\
\text{s.t.}\, h_i(x) = 0
$$

$h_i(x)=0$ 在 $i$ 取 $n$ 个可能值（具有多个约束条件）时代表的约束超曲面维度是 $D-n$, $D$ 为 $x$ 的维度。高维空间上，一维的法向量的定义拓展成「法超平面」，「法超平面」上的所有的向量都与 $h_i(x) = 0, i=1\cdots D$ 对应的超平面垂直。该「法超平面」的一组基就是 $\nabla_x h_i(x)$，于是所谓「约束超平面与等值超平面相切」也即：

$$ 
\nabla_x f(x) = \sum_i \beta_i \nabla_x h_i(x)
$$

**上式实际约束了「平行」而没有约束「相切」**。该式引入了 $D - n$ 个约束（引入 $D$ 个约束的同时引入了 $n$ 个新未知数），与原等式约束条件连立后完全将极值问题转换为方程求解问题：

$$ 
L(\beta,x) = f(x) + \sum_i \beta_i h_i(x) \\
h_i(x) = 0 \\
\nabla_x L = 0
 $$

注意，上式中的 $x$ 是向量。$h_i(x) = 0$ 代表 $n$ 个约束条件，$\nabla_x L = 0$ 代表 $D-n$  个约束条件。
至少在约束条件为线性方程、$L$ 关于 $x$ 是凸函数（二阶导数恒大于零）的情况下，以上论证显然是严格成立的。

## 等式与不等式约束

问题数学表述为

$$ 
\min_x f(x) \\
\mathrm{s.t.\,} g_i(x) \leq 0 \\
h_j(x) = 0
$$

我们先讨论 $f(x)$, $g(x)$ 是凸函数（二阶导数恒大于零），$h(x)$ 是仿射函数（也即一次函数）的情况。[ REF: 《统计学习方法》，李航 ]

$h(x)$ 是一次函数的情况下，也即将问题约束到某个超平面上。可以理解为将 $f(x)$, $g(x)$ 投影到该超平面上。投影不影响函数的凸性.

$g(x)$ 是凸函数的情况下，该约束条件在全空间上约束出了一个凸区域。

$f(x)$ 是凸函数的情况下,在凸区域上具有唯一解. 这个结论仍然比较显然, 不证.

于是, 极值点处一定有 $h_j(x)=0$. 若某条不等约束条件确实约束了该优化问题, 则该不等约束条件取到等式, 跟等式约束条件等价. 按照上节结论, 这些等式约束条件的梯度向量张成一个超平面, $f(x)$ 的梯度向量在这个超平面上.

数学化讨论这个问题:

首先构造 Lagrange 函数：

$$ 
L(x,\alpha_i,\beta_j) = f(x) + \alpha_i g(x) + \beta_j h(x) \\
a_i \geq 0
$$

注意，构造函数时已经要求 $\alpha_i \geq 0$.

对于优化问题的解 $x_0$，会有 

$$ 
f(x_0) = \min_{x\in\Omega} f(x) 
= \min_{x\in\Omega} \max_{\alpha_i, \beta_j} L(x,\alpha_i,\beta_i) \\
= \min_{x\in\Omega} \max_{\alpha_i, \beta_j} \left[ f(x) + \alpha_i g(x) + \beta_j h(x) \right]
$$

上式中 $\Omega$ 是 $x$ 的值域。在 $\Omega$ 内，不难判断 
$$ 
\max_{\alpha_i, \beta_j} \left[ f(x) + \alpha_i g(x) + \beta_j h(x) \right] = f(x)
$$

以及上式成立只发生在 $a_i g(x) = 0$. 上式对 $\beta_j$ 没有约束力。

在 $f(x)$, $g(x)$, $h(x)$ 性质足够好的情况下，可以有：
$$ 
\min_{x\in\Omega} \max_{\alpha_i, \beta_j} L(x,\alpha_i,\beta_i) = \max_{\alpha_i, \beta_j} \min_{x\in\Omega} L(x,\alpha_i,\beta_i)
$$

具体而言，使上式成立的条件是 $f(x)$, $g(x)$ 是凸函数，$h(x)$ 是仿射函数（也即一次函数）。[ REF: 《统计学习方法》，李航 ]

右式要求：

$$ 
\nabla_x L = 0
$$

左式要求：

$$ 
\nabla_{\alpha_i} L = 0 \\
\nabla_{\beta_j} L = 0
$$

于是原优化问题在性质足够好的情况下的解应满足：

$$ 
\nabla_x L = 0 \\
\nabla_{\alpha_i} L = 0 \\
\nabla_{\beta _j} L = 0 \\
a_i g_i = 0\\
$$

以及原本的要求：

$$ 
a_i \geq 0 \\
g_i(x) \leq 0 \\
h_j(x) = 0 \\
$$

建立方程组的充分条件可以取：

$$ 
\nabla_x L = 0 \\
a_i g_i = 0\\
h_j(x) = 0 \\
 $$

设有 $n$ 个不等式约束，$m$ 个等式约束，以上三个等式分别提供了 $D - n - m, n, m$ 个约束（第一个等式提供了 $D$ 个约束但引入了 $n + m$ 个变量），因此连立即可求解约束极值问题。