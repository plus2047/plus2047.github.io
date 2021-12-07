---
layout: mypost
title: PySpark + unittest + pdb = 🚀
categories: [data, lang]
---

（我终于不摸鱼了，终于有技术文章更新了。。虽然很短。。）

在使用 pyspark 开发时一直有一个问题困扰我：python + vscode 的静态类型检查能力非常弱，所以写好的脚本如果不进行本地调试，提交到集群之后常常存在巨量 bug, 集群每次运行耗时很长，于是调试-修改的流程就会很慢。可如果要进行本地调试，模拟各种数据源会非常麻烦。

最近学到了一条原则：模块化不仅是为了复用，甚至主要不是为了复用，而是为了划分不同的抽象层等。模块化非常重要的一点就是方便测试。对于 pyspark 代码，如果有良好的模块化，单元测试可以覆盖除了输入输出之外的大部分，这足以覆盖大部分 bug. 另外，相较于在本地写几个数据文件直接运行 pyspark 脚本进行测试，使用单元测试可以用 python 代码创建假数据，会更加方便。

以下是一个简单的项目的例子。

```py
# project structure:
# --------
# avg_item_num.py
# test/
#     __init__.py
#     test_avg_item_num.py
# --------

# average_item_num ======
from pyspark.sql import SparkSession
import pyspark.sql.functions as F

def get_avg_item_num(df):
    """df: (query, items:array[itemid])"""
    return df.agg(
        F.avg(F.size("items")).alias("avg")
    ).collect()[0]["avg"]

if __name__ == "__main__":
    with SparkSession.builder.appName("test").getOrCreate() as spark:
        tracking = spark.read.json("tracking.json")
        print(get_avg_item_num(tracking))

# test/test_avg_item_num.py ======
import unittest
from avg_item_num import *


class TestAvgItemNum(unittest.TestCase):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.spark = SparkSession.builder.appName("test").getOrCreate()
    
    def test_get_avg_item_num(self):
        df = self.spark.createDataFrame([
            {"query": 1, "itemid": 1},
            {"query": 1, "itemid": 2},
            {"query": 2, "itemid": 3},
            {"query": 2, "itemid": 4},
            {"query": 2, "itemid": 5},
            {"query": 2, "itemid": 6},
        ]).groupBy("query").agg(
            F.collect_list("itemid").alias("items"))

        self.assertAlmostEqual(get_avg_item_num(df), 3)
```

创建完成以上目录结构，只需要在根目录下运行 `python -m unittest` 即可启动单元测试。

注意，对于一般的模块，子目录（子模块）的文件中是不能直接 `import` 上级目录（上级模块）中的内容的，但对于单元测试，`test` 目录的根目录可以 `import` 项目根目录，`unittest` 模块会自动把项目根目录添加到 `sys.path` 中。

测试过程中发现 bug, 想要打断点怎么办？当然可以使用 IDE 的断点调试，但 IDE 有时候不方便跟命令行配合。可以直接在想要打断点的地方插入一行，

```py
import pdb; pdb.set_trace()
```

即可在没有 IDE 支援的情况下，在任何环境中启动断点调试。特别是启动断点调试后可以方便的检查数据格式等等。

断点调试有时候能够很神奇的替代 jupyter notebook，两者都能创建一个具有上下文的环境以供尝试，断点调试的优势是代码可复用性更好，并且不需要把想要调试的代码粘贴到 jupyter, 然后再粘贴回来。但断点调试也有问题，单元测试运行到指定位置也是需要时间的，特别是使用了 pyspark 这类比较复杂的框架后更慢。
