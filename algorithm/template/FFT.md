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
					ll tmpx = A[i + j], tmpy = w * A[i + j + (1 << (step - 1))] % MOD;
					A[i + j] = (tmpx + tmpy) % MOD;
					A[i + j + (1 << (step - 1))] = (tmpx - tmpy + MOD) % MOD;
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
