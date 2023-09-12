---
layout: mypost
title: SQL Data Science Snippets
categories: [tech, snippet]
---

```sql
# kw: sqlauc

select
	(ry - 0.5*n1*(n1+1))/n0/n1 as auc
from(
	select
		sum(if(y=0, 1, 0)) as n0,
		sum(if(y=1, 1, 0)) as n1,
		sum(if(y=1, r, 0)) as ry
	from(
		select y, row_number() over(order by score asc) as r
		from(
			select y, score
			from some.table
		)
	)
)
```
