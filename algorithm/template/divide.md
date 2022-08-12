# 几种二分情况的总结

*在单调递增的队列中考虑*

## [ ) 型

寻找 $\geq x$ 的数中，最小值的位置。

首先确定区间的范围。

左闭右开，那么区间的左端点应该为数组起始位置，右端点为数组终止位置 $+1$ 。

之后确定二分行为。

当 $a[mid] < x$ 时，不在区间范围内，故 $l = mid + 1$ ；

当 $a[mid] > x$ 时，在区间范围内，故 $r = mid$ ；

当 $a[mid] = x$ 时，在区间范围内，故 $r = mid$ 。

最后确定 $mid$ 取法。

考虑到 $r - l == 1$ 时， $l$ 的修改是向上增一， $r$ 的修改是维持不变，我们应该选用向下取整的 $mid$ 选择方法，即 $mid = (l + r) >> 1$ 

```C
int erfenl(vector <int> a, int x) {
	int l = 0, r = a.size(), mid;
	while (l < r) {
		mid = (l + r) >> 1;
		if (a[mid] >= x) r = mid;
		else l = mid + 1;
	}
	return l;
}

```

## ( ] 型

寻找 $\leq x$ 的数中，最大值的位置。

左开右闭，那么区间的左端点应该为数组起始位置 $-1$ ，右端点为数组终止位置。

之后确定二分行为。

当 $a[mid] < x$ 时，在区间范围内，故 $l = mid$ ；

当 $a[mid] > x$ 时，不在区间范围内，故 $r = mid - 1$ ；

当 $a[mid] = x$ 时，在区间范围内，故 $l = mid$ 。

最后确定 $mid$ 取法。

考虑到 $r - l == 1$ 时， $l$ 的修改是维持不变， $r$ 的修改是向下减一，我们应该采用向上取整的 $mid$ 选择方法，即 $mid = (l + r + 1) >> 1$ 

```C
int erfenr(vector <int> a, int x) {
	int l = -1, r = a.size() - 1, mid;
	while (l < r) {
		mid = (l + r + 1) >> 1;
		if (a[mid] <= x) l = mid;
		else r = mid - 1;
	}
	return r;
}
```

## 二分答案

```C
int erfen(int l, int r) {
	int mid, ans = 0;
	while (l <= r) {
		mid = (l + r) >> 1;
		if (judge(mid)) ans = mid, l = mid + 1;
		else r = mid - 1;
	}
	return ans;
}
```

## 实数域上二分

在实数域上二分， $r - l$ 的差值一般取精度 $-2$ 。

```C
double erfen(double l, double r) {
	double mid;
	while (r - l > 1e-8) {
		mid = (l + r) / 2.0;
		if (judge(mid)) l = mid;
		else r = mid;
	}
	return l;
}
```
