# FFT

```C
ll ksm(ll x, ll n, ll mod) {
	ll ans = 1;
	for (; n; n >>= 1, x = x * x % mod) {
		if (n & 1) ans = ans * x % mod;
	}
	return ans;
}
namespace FFT {
	int rev[N];
	void butterflychange(ll *A, int n) {
		rev[0] = 0;
		for (int i = 0; i < n; ++i) {
			rev[i] = rev[i >> 1] >> 1;
			if (i & 1) rev[i] |= (n >> 1);
		}
		for (int i = 0; i < n; ++i) {
			if (i < rev[i]) swap(A[i], A[rev[i]]);
		}
	}

	void FFT(ll *A, ll n, int IFFT) {
		butterflychange(A, n);
		ll g = IFFT ? ksm(3, MOD - 2, MOD) : 3ll;
		for (int step = 1; (1 << step) <= n; ++step) {
			ll wn = ksm(g, (MOD - 1) >> step, MOD);
			for (int i = 0; i < n; i += (1 << step)) {
				ll w = 1;
				for (int j = 0; j < (1 << (step - 1)); ++j) {
					ll tmpx = A[i | j], tmpy = w * A[i | j | (1 << (step - 1))] % MOD;
					A[i | j] = (tmpx + tmpy) % MOD;
					A[i | j | (1 << (step - 1))] = (tmpx - tmpy + MOD) % MOD;
					w = w * wn % MOD;
				}
			}
		}
		if (IFFT) {
			ll invn = ksm(n, MOD - 2, MOD);
			for (int i = 0; i < n; ++i) A[i] = A[i] * invn % MOD;
		}
	}

	void Work(ll *F, ll *G, int n, int m, ll *Ans) {
		int len = 1;
		while (n + m + 1 > len) len <<= 1;
		for (int i = n + 1; i < len; ++i) F[i] = 0;
		for (int i = m + 1; i < len; ++i) G[i] = 0;
		FFT(F, len, 0), FFT(G, len, 0);
		for (int i = 0; i < len; ++i) Ans[i] = F[i] * G[i] % MOD;
		FFT(Ans, len, -1);
	}
};
```

# 分治FFT

分治FFT本质上是使用了陈丹琦分治的思想，首先计算 $[l, mid]$ 区间内的答案，之后将 $[l, mid]$ 对 $[mid + 1, r]$ 的卷积和贡献提交到 $[mid + 1, r]$ 区间，之后再计算 $[mid + 1, r]$ 的答案。

接下来深入讨论一下FFT。首先，我们对多项式 $F(x)$ 和 $G(x)$ ，最高次项为 $n - 1$ 次。多项式乘法的全过程，本质上是要得到一个 $n$ 元一次方程组，然后求解 $n$ 个系数 $c_i \ (0 \leq i \leq n - 1)$ 。

同时有

$$c_i = \sum_{j = 0}^{i} a_{i - j}b_j $$

即多项式的每一个系数，都是满足 $x + y = i$ 的 $a_x$ 和 $b_y$ 的卷积和。

因此，我们可以利用多项式乘法，来计算所需要的卷积和，或者卷积和的一部分。具体的做法是构造对应的两个序列，然后对它们做多项式乘法，其对应的系数就是相应的卷积和。特别需要注意的是控制变量的范围。

再回到对分治FFT的讨论中。由上述讨论得到的性质可知，我们可以分别构造多个序列，分段求出卷积和，再提交到对应的位置获得答案。
