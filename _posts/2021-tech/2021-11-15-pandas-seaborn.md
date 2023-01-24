---
layout: mypost
title: Pandas & Seaborn Notes
categories: [tech, big-data]
---

Pandas 是一个类似于数据库或者 EXCEL 的表格数据处理工具。表格的每一行可以视为一个对象，每一列是一个字段。

Pandas 的基本数据结构为 `DataFrame`, `Series`，前者是一个完整的表格，后者是一个数据列。以下为基本使用。

```
import pandas as pd

# build a DataFrame =====
# different datatype in one series is allow but I think it's not a good idea.
city_names = pd.Series(['San Francisco', 'San Jose', 'Sacramento'])
population = pd.Series([852469, 1015785, 485199])
cities = pd.DataFrame({ 'City name': city_names, 'Population': population })

california_housing_dataframe = pd.read_csv("https://storage.googleapis.com/mledu-datasets/california_housing_train.csv", sep=",")

# explorer the frame =====
# get the first some line. default is 5 lines.
california_housing_dataframe.head(3)
# draw the distribution of one series. 
california_housing_dataframe.hist('housing_median_age')
# get some discribe information: min, max, etc.
california_housing_dataframe.describe()
# get some basic info: count, dtype, etc.
california_housing_dataframe.info()

# get data from frame =====
cities["City name"]  # get a column -> return Series
cities[["City name"]]  # get column(s) -> return DataFrame
cities[0:1]  # get some row. NOTE: must use slices grammar -> return DataFrame
cities["City name"][0]  # get a cell

# use frame with numpy =====
# you can use frame like numpy array
import numpy as np
np.log(population)
# apply lambda function over series
city["City name"].apply(lambda x: x[:3] == "San")

# index & reindex =====
city_name.index  # RangeIndex(start=0, stop=3, step=1)
city_name.reindex([2,1,0])

# operation =====
df = california_housing_dataframe
df.drop([City Name'], axis=1)  # drop columns
```

Seaborn 是一个绘图库。【等待整理】

