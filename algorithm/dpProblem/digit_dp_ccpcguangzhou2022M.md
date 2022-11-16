# greedy_dp_nowcodermulti4A

## 题目大意

$$0 \leq a_i \leq m$$

$$\sum_{i = 1}^k \sum_{j = 1}^{i - 1}a_i \oplus a_j$$

$$1 \leq k \leq 18, 0 \leq n \leq 10^{15}, 1 \leq m \leq 10^{12}$$

统计 $\{a_i\}$ 的组数。

## 解题方法

首先看到异或，我们就考虑按位处理。考虑每一位的贡献值。观察后容易发现，当出现一对 $(0, 1)$ 时，才对答案有贡献。每一位的贡献值自然就是 $(0, 1)$ 对的个数乘以 $2^i$ 。 $(0, 1)$ 的个数比较好求解，即每个 $1$ 的贡献和相加。不难得到最终贡献值为 $num_1 * (k - num_1) * 2^i$ 。

接下来的问题比较明显，非常像一个背包模型。动态规划的结构呼之欲出。

接下来就是经典的数位dp。数位dp的两个维度比较显然，处理的当前位和 $n$ 的剩余值。如果没有 $m$ 的限制，那么这个dp是比较easy的。如果有 $m$ 的限制，那么我们就需要将数分为两类，一类是卡住上界的数，一类是在低于上界的数。两者的处理方法不同。对于后者，可以是 $1/0$ 。对于前者，如果 $m$ 当前位是 $1$ 那么可以是 $1/0$ ，反之只能是 $0$ 。我们枚举当前两者选择为 $1$ 的个数，进行转移。

```cpp
map <long long, int> f[42][20];
int dfs(int cur, int high, long long ren) {
	if (DEBUG) printf("%d %d %lld\n", cur, high, ren);
	if (cur == 0 && ren == 0) return 1;
	if (cur <= 0) return 0;
	if (ren < 0) return 0;
	if (((1ll << cur) - 1) * k / 2 * (k - k / 2) < ren) return 0;
	if (f[cur][high].count(ren)) return f[cur][high][ren];
	int ans = 0;
	if (m & (1ll << cur - 1)) {
		for (int i = 0; i <= k - high; ++i) {
			for (int j = 0; j <= high; ++j) {
				int tmp_ans = dfs(cur - 1, j, ren - (1ll << cur - 1) * (i + j) * (k - i - j));
				ans = add(ans, mul(tmp_ans, mul(C(high, j), C(k - high, i))));
			}
		}
	}
	else {
		for (int i = 0; i <= k - high; ++i) {
			int tmp_ans = dfs(cur - 1, high, ren - (1ll << cur - 1) * i * (k - i));
			ans = add(ans, mul(tmp_ans, C(k - high, i)));
		}
	}
	f[cur][high][ren] = ans;
	return ans;
}
```

总结：

数位dp的转移过程并不复杂，如果同时有上下界，我们可以枚举卡住上界、卡住下界、两者之间的数位数，进行转移。