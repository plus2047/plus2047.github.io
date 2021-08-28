---
layout: mypost
title: PySpark + unittest + pdb = 🚀
categories: [data, lang]
---

首先庆祝，我终于不摸鱼了，终于有技术文章更新了！

- UnitTest 可以不覆盖全部流程，而是把关键处理逻辑测试好
- 因此，关键处理逻辑模块化（组织成函数）不仅是为了重用，也可以方便单元测试

```py
# project structure:
# --------
# hello.py
# test/
#     __init__.py
#     test_hello.py
# --------

# hello.py
def hello():
    print("hello")
    import pdb; pdb.set_trace()
    return "hello"

# test_hello.py
import unittest
import hello

class TestHello(unittest.TestCase):

    def test_hello(self):
        self.assertEqual(hello.hello(), "hello")
```