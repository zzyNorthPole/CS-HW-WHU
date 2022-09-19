# FFT

```C++
namespace FFT {
	int rev[N];
	void btfchg(int *A, int n) {
		rev[0] = 0;
		for (int i = 1; i < n; ++i) {
			rev[i] = rev[i >> 1] >> 1;
			if (i & 1) rev[i] |= (n >> 1);
		}
		for (int i = 0; i < n; ++i) {
			if (i < rev[i]) swap(A[i], A[rev[i]]);
		}
	}
	void FFT(int *A, int n, int IFFT) {
		btfchg(A, n);
		int g = IFFT ? ksm(3, mod - 2) : 3;
		for (int step = 1; (1 << step) <= n; ++step) {
			int wn = ksm(g, (mod - 1) >> step);
			for (int i = 0; i < n; i += (1 << step)) {
				int w = 1;
				for (int j = 0; j < (1 << (step - 1)); ++j) {
					int tmpx = A[i | j], tmpy = mul(w, A[i | j | (1 << (step - 1))]);
					A[i | j] = add(tmpx, tmpy);
					A[i | j | (1 << (step - 1))] = sub(tmpx, tmpy);
					w = mul(w, wn);
				}
			}
		}
		if (IFFT) {
			int invn = ksm(n, mod - 2);
			for (int i = 0; i < n; ++i) A[i] = mul(A[i], invn);
		}
	}
	void polymul(int *F, int *G, int len) {
		FFT(F, len, 0), FFT(G, len, 0);
		for (int i = 0; i < len; ++i) F[i] = mul(F[i], G[i]);
		FFT(F, len, 1);
	}
}
```

# 分治FFT

分治FFT本质上是使用了陈丹琦分治的思想，首先计算 $[l, mid]$ 区间内的答案，之后将 $[l, mid]$ 对 $[mid + 1, r]$ 的卷积和贡献提交到 $[mid + 1, r]$ 区间，之后再计算 $[mid + 1, r]$ 的答案。

接下来深入讨论一下FFT。首先，我们对多项式 $F(x)$ 和 $G(x)$ ，最高次项为 $n - 1$ 次。多项式乘法的全过程，本质上是要得到一个 $n$ 元一次方程组，然后求解 $n$ 个系数 $c_i \ (0 \leq i \leq n - 1)$ 。

同时有

$$c_i = \sum_{j = 0}^{i} a_{i - j}b_j $$

即多项式的每一个系数，都是满足 $x + y = i$ 的 $a_x$ 和 $b_y$ 的卷积和。

因此，我们可以利用多项式乘法，来计算所需要的卷积和，或者卷积和的一部分。具体的做法是构造对应的两个序列，然后对它们做多项式乘法，其对应的系数就是相应的卷积和。特别需要注意的是控制变量的范围。

再回到对分治FFT的讨论中。由上述讨论得到的性质可知，我们可以分别构造多个序列，分段求出卷积和，再提交到对应的位置获得答案。

```C++
int tmpF[N], tmpG[N];
void cdqmul(int *F, int *G, int l, int r) {
	if (l == r) return;
	int mid = (l + r) >> 1;
	cdqmul(F, G, l, mid);
	int len = 1;
	while (len < r - l + 1) len <<= 1;
	for (int i = l; i <= mid; ++i) tmpF[i - l] = F[i];
	for (int i = mid + 1 - l; i < len; ++i) tmpF[i] = 0;
	for (int i = 0; i < r - l + 1; ++i) tmpG[i] = G[i];
	for (int i = r - l + 1; i < len; ++i) tmpG[i] = 0;
	polymul(tmpF, tmpG, len);
	for (int i = mid + 1; i <= r; ++i) F[i] = add(F[i], tmpF[i - l]);
	cdqmul(F, G, mid + 1, r);
}
```
