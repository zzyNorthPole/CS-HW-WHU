# combination_FFT_nowcodermultiaddraceL

## 题目大意

有一个 multiset $S$ ，对 $S$ 中的数做排列，得到序列集合 $A$ ，求
$$\sum_{b \in A} \sum_{1 \leq l \leq r \leq n} f_b(l, r)$$ 。其中 $f_b(l, r) = mex\{b_l, ... , b_r\}$ ，即自然数中没有在该序列中出现过的最小值。

## 解题方法

首先我们观察到，我们可以统计每一个 $b$ 的贡献值。具体贡献如下：

对于每一个 $b$ ，它的结果都是 $mex_b$ ，它的个数有 $\frac{(\sum{b_i}!)}{\prod{b_i!}}$ 该序列之外的序列有 $\frac{(n - \sum{b_i})!}{\prod{(a_i - b_i)!}}$ 个。将 $b$ 插入进去的方式有 $(n - \sum{b_i} + 1)$ 种。总共的个数有 $$\frac{(\sum{b_i}!)}{\prod{b_i!}} * \frac{(n - \sum{b_i})!}{\prod{(a_i - b_i)!}} * (n - \sum{b_i} + 1) = \frac{(\sum{b_i})!(n - \sum{b_i} + 1)!}{\prod(b_i(a_i - b_i))!}$$

接下来考虑求解答案。要求解所有满足这个的答案，我们考虑生成函数的思想。首先经过观察我们可以先将 $(\sum{b_i})!(n - \sum{b_i} + 1)!$ 分离出来，我们单独求解 $$\sum{\frac{mex_b \prod{x^{b_i}}}{\prod(b_i(a_i - b_i))!}}$$

我们考虑直接枚举 $mex_b$ ，计算答案。
当 $mex_b = k$ 时，对应的答案贡献为 $$\frac{\prod{x^{b_i}} · k}{\prod_{1 \leq b_i \leq a_i, i < k}(b_i!(a_i - b_i)!) · \prod_{0 \leq b_i \leq a_i, i > k}(b_i!(a_i - b_i)!)}$$

我们记
$$\sum_{0 \leq b_i \leq a_i}{\frac{x^{b_i}}{(b_i!(a_i - b_i)!)}} = f_i(x)$$
那么所有 $mex = k$ 的答案贡献就为 $$k(f_0(x) - \frac{1}{a_0!})···(f_{k - 1}(x) - \frac{1}{a_{k - 1}!})f_{k + 1}(x)···f_n(x)$$

我们发现这个 $k$ 对于答案的统计很不方便，于是就看能否将 $k$ 的贡献拆分成 $k$ 份分别提交到前面的答案贡献中，以 $0$ 为例子就是 $$(f_0(x) - \frac{1}{a_0!})f_2(x)···f_n(x) + ··· + (f_0(x) - \frac{1}{a_0!})···(f_{n - 1}(x) - \frac{1}{a_{n - 1}!})$$

这个式子看起来不好合并，于是我们给它添一项 $$(f_0(x) - \frac{1}{a_0!})···((f_n(x) - \frac{1}{a_n!}))$$

那么答案就变成了 $$(f_0(x) - \frac{1}{a_0!})f_1(x)···f_n(x)$$
 
思考添加的这一项的组合含义，表示每一个 $b_i$ 都大于 $0$ ，这样就有 $n + 1$ 项，这种情况的个数为 $0$ 所以对答案无影响。

因此，总的答案就变为了
$$\sum_k{((f_0(x) - \frac{1}{a_0!}))···((f_k(x) - \frac{1}{a_k!}))f_{k + 1}(x)···f_n(x)}$$

这个式子非常的恶心，我们考虑一个简单版本怎么求 
$$f_0(x)···f_n(x)$$ ，直接分治处理然后用 $FFT$ 合并即可。

那么我们看看这个式子是否具有局部性。令 $f_i(x) - \frac{1}{a_i!} = g_i(x)$

$$
\begin{split}
LHS &= \sum_{k = l}^{r}g_l(x)···g_k(x)f_{k + 1}(x)···f_r(x) \\\\
&= (\sum_{k = l}^{mid}g_l(x)···g_k(x)f_{k + 1}(x)···f_{mid}(x))f_{mid + 1}(x)···f_r(x) \\\\
&+ g_l(x)···g_{mid}(x)(\sum_{k = mid + 1}^{r}g_{mid + 1}(x)···g_k(x)f_{k + 1}(x)···f_r(x)) \\\\
\end{split}
$$

于是我们可以每次计算的时候维护四个多项式的值，分别是 $f_{mid + 1}···f_r$ 、 $g_l···g_{mid}$ 、 $\sum{g_l···g_kf_{k + 1}f_{mid}}$ 、 $\sum{g_{mid + 1}···g_kf_{k + 1}f_{r}}$ 然后用 $FFT$ 合并得到答案。

这题是一道进阶多项式题，虽然很纷繁，但是走向答案的路是光明的。