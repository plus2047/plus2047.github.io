---
layout: mypost
tite: Python Matplotlib Notes
categories: [data-tools]
---

## BASIC 基础概念

![](https://i.stack.imgur.com/HZWkV.png)

- To get current figure: `plt.gcf()`
- To get current axes: `plt.gca()`

## 2D POLT

绘制各种稀奇古怪的图，参考：[Introductory](https://matplotlib.org/tutorials/introductory/sample_plots.html#sphx-glr-tutorials-introductory-sample-plots-py)

```python
import numpy as np
import matplotlib.pyplot as plt

X = np.linspace(-np.pi, np.pi, 256, endpoint=True)
C,S = np.cos(X), np.sin(X)

plt.plot(X,C)
plt.plot(X,S)
plt.legend(['a','b'])  # name lines
plt.set_xlabel("x label")
plt.set_ylabel("y label")
plt.show()

# ignore X data
plt.plot(C)
plt.show()
```

### HLINE & VLINE 绘制直线、横线、竖线

```python
# plot line from (x1, y1) to (x2, y2)
plt.plot((x1, x2), (y1, y2), 'k-')
# plot line at special x or y value
plt.hlines(y, xmin, xmax, colors='k')
plt.axhline(y, colors='r')
```

### LINE STYLE

```
plt.plot([1, 2, 3], 'r--', linewidth=0.5)
plt.plot([3, 2, 1], marker='o', markersize=12)
```

### SUBPLOT 子图绘制

A figure includes many axeses and a axes include many lines, text ... （figure > axes > axis, line, text...). `plt.figure(number)` make a figure when it don't exist or choice a figure when it exist. `plt.subplot(221)` split a figure into 2 * 2 subplot and choice the first one.

```python
# 状态机风格绘图
plt.subplot(221)
# or
# plt.subplot(2, 2, 1)
plt.plot(X, Y1)
plt.subplot(222)
plt.plot(X, Y2)
# 面向对象式绘图
ax = plt.subplot(222)
ax.plot(X,S)
ax = plt.subplot(223)
ax.plot(X,S)
ax.set_xlabel("subplot 3")
ax = plt.subplot(224)
ax.plot(X,S)
ax.set_xlabel("subplot 4")

# adjust layout
# necessary if subplotting and setting labels.
plt.tight_layout()
plt.show()
```

### POLAR 极坐标 

```
ax = plt.gca(projection='polar')
# 大部分直角坐标的函数仍然可以使用
ax.axvline(1)
# 但也有一些函数不能用了
ax.axhline(1)  # do nothing.
```

### LOG AXIS 对数坐标轴

绘制对数坐标轴的一个办法是手动对数据取对数。但 MATPLOTLIB 有内置的函数可用。

```
plt.semilogx(x, y)  # log x axis
plt.semilogy(x, y)  # log y axis
plt.loglog(x, y)  # log x axis & log y axis
```

### Line & Bar 组合

```
ax1 = plt.gca()
ax.plot(data1)
handles1, labels1 = ax1.get_legend_handles_labels()

ax2 = ax1.twinx()
ax2.bar(data2)
handles2, labels2 = ax2.get_legend_handles_labels()

plt.legend(handles1 + handles2, labels1 + labels2)
plt.show()
```

## COLOE MESH 色度图

使用色度图可以在二维图上绘制三维数据。

```
plt.pcolormesh(x_array, y_array, z_matrix)
# z_matrix.shape == *x_array.shape, *y_array.shape
```

## 3D PLOT

### PLOT SURFACE

```python
# cut from a homework
# prepare data
# symbol calculate the gradient
import sympy as sp
sp.init_printing()
from IPython.display import display

x, y = sp.symbols('x y')
f =  -20 * (x/2 -x**2 -y**5) * sp.exp(-x**2-y**2); 
print('f='); display(f)

fdx = f.diff(x)
print('df/dx='); display(fdx)

fdy = f.diff(y)
print('df/dy='); display(fdy)

# translate the symbol result into numerical function
nf = sp.lambdify((x, y), f)
ndf = sp.lambdify((x,y), (fdx, fdy))

# prepare the grid
import numpy as np
x_array = y_array = np.linspace(-3, 3, 100)
x_matrix, y_matrix = np.meshgrid(x_array, y_array)
# calculate f(x,y)
f_matrix = nf(x_matrix, y_matrix)

# ===== PLOT ===== 
from matplotlib import pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3

fig = plt.figure()
ax = p3.Axes3D(fig)

ax.plot_surface(x_matrix, y_matrix, f_matrix)
plt.show()
```

`ax.plot_surface` 函数适用于绘制曲面，而 `ax.plot` 函数更适用于绘制线。`AX.PLOT` 函数接受点列表，并绘制成曲线：

```
ax.plot(x_array, y_array, zs=z_array)
```

注意：

- `ax.plot` 处理矩阵时行为与 `ax.plot_surface` 不同，会绘制为多条曲线。
- `ax.plot` 调用时 `z_array` 必须使用 `keyword` 指明，因为第三个参数通常是格式化字符串

```python
fig = plt.gcf()
ax = p3.Axes3D(fig)

ax.plot([1,2,3],[1,2,3],'*',zs=[1,2,3])
plt.show()

fig = plt.gcf()
ax = p3.Axes3D(fig)
ax.plot([1,2,3],[1,2,3],'--',zs=[1,2,3])
plt.show()
```

## SAVE PDF & SET FIGURE SIZE

```python
from matplotlib.backends.backend_pdf import PdfPages

# set figure size
f0 = plt.gcf()
f0.set_size_inches(5,5)

ax = plt.subplot(111)
plt.plot(X,C)

pdf = PdfPages('test.pdf')
pdf.savefig(ax.get_figure())
pdf.close()
plt.show()
```

## CHINESE Characters

```
# get fonts list
print([f.name for f in matplotlib.font_manager.fontManager.ttflist])
# in macOS, recommand font: SFFangsong
plt.rcParams['font.sans-serif']=['STFangsong']
plt.rcParams['axes.unicode_minus']=False  # avoid minus sign using chinese char.
```

## Image Read / Save / Show

```python
# wget https://upload.wikimedia.org/wikipedia/commons/c/ca/Black_white_cat_on_fence.jpg -o cat.jpg
# pip install pillow

from matplotlib import pyplot as plt

img = plt.imread('cat.jpg')  # get a numpy 3d array.
plt.imshow(img)
plt.imsave("cat_saved.jpg", img)
```

