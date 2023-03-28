---
layout: mypost
title: Python Data Science Snippets
categories: [tech, snippet]
---

```py
# kw: nbhead

import numpy as np
import scipy as sp
from matplotlib import pyplot as plt
```

```py
# kw: ipyspark

# %%
from pyspark.sql import SparkSession
import pyspark
import pyspark.sql.functions as F
import pyspark.sql.types as T
spark = SparkSession.builder.appName("test").getOrCreate()

# %%
queue = spark.createDataFrame([
    {"hash": 1, "items": [{"itemid": 1}, {"itemid": 2}, {"itemid": 3}, {"itemid": 4}]},
], schema=T.StructType([
    T.StructField("hash", T.StringType()),
    T.StructField("items", T.ArrayType(T.StructType([
        T.StructField("itemid", T.IntegerType())
    ])))
]))
tracking = spark.createDataFrame([
    {"hash": 1, "itemid": 1, "operation": 1},
    {"hash": 1, "itemid": 1, "operation": 2},
    {"hash": 1, "itemid": 2, "operation": 1},
    {"hash": 1, "itemid": 3, "operation": 1},
    {"hash": 1, "itemid": 3, "operation": 1},
    {"hash": 1, "itemid": 3, "operation": 2},
])
```
