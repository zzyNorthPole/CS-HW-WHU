# combination_FFT_hdu7191

## 题目大意

有 $n$ 个环，从每个环中选出若干条不相邻的边，问选出 $k$ 条边一共有多少种选法

## 解题方法

首先考虑 $k$ 个数中任何两个数不相邻的组合，可以将问题转化，即从 $n - k + 1$ 个数中选出 $k$ 个，然后再向这 $k$ 个数中间插入 $k - 1$ 个数，即可保证两两不相邻。再考虑环的答案。环与链的不同仅仅在于 $1$ 和 $n$ 也不能相邻。我们考虑正难则反的思想，钦定 $1$ 和 $n$ 必须被选择，如此 $2$ 和 $n - 1$ 必定不能被选择，问题转化为 $n = n - 4$ 和 $k - 2$ 的情况，故答案为：

$$ C_{n - k + 1}^{k} - C_{n - k - 1}^{k - 2} $$

之后我们使用dp的方法来统计答案，但是直接dp时间复杂度为 $O(nk)$ ，必定会超时。我们考虑分治FFT合并答案，每次FFT合并的时间复杂度为 $O(min(k, sz[i])log(min(k, sz[i]))$ ，总时间复杂度近似为 $O((\Sigma_{i = 1}^{n} sz[i]) log(n) log(k))$ 。给出部分合并代码：

```C
ll ans[21][2][N];
void divide(int l, int r, int k, int dep, int rson) {
	if (l == r) {
		ans[dep][rson][0] = 1;
		ans[dep][rson][1] = circle_sz[l];
		for (int i = 2; i <= min(circle_sz[l] >> 1, k); ++i) {
			ans[dep][rson][i] = (C(circle_sz[l] - i + 1, i) - C(circle_sz[l] - i - 1, i - 2) + MOD) % MOD;
		}
		ans_sz[dep][rson] = min(circle_sz[l] >> 1, k);
		return;
	}
	int mid = (l + r) >> 1;
	divide(l, mid, k, dep + 1, 0);
	divide(mid + 1, r, k, dep + 1, 1);
	FFT::Work(ans[dep + 1][0], ans[dep + 1][1], ans_sz[dep + 1][0], ans_sz[dep + 1][1], ans[dep][rson]);
	ans_sz[dep][rson] = min(k, ans_sz[dep + 1][1] + ans_sz[dep + 1][0]);
}
```

tips：在本题中，使用了一个比较大的数组来存储每一层的答案以反馈给上一层的FFT使用。需要注意的是，因为同一层的数组被反复复用，因此当进行FFT时，假设当前数组的宽度是 $n$ ，卷积和的长度是 $len$ ，我们需要对 $n + 1$ 到 $len$ 的内容进行清零，防止导致答案错误。
