---
layout: mypost
title: C++ Contest Snippets
categories: [tech, snippet]
---

```cpp
// kw: boardbfs
int di[4][2] = { {0, -1}, {0, 1}, {1, 0}, {-1, 0} };
for(int i = 0; i < 4; i++) {
    int dx = di[i][0], dy = di[i][1];
}
```

```cpp
// help: speed up iostream
#include<iostream>
std::ios::sync_with_stdio(false);
```
