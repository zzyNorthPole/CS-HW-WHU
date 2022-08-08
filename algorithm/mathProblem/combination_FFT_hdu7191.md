# combination_FFT_hdu7191

## 题目大意

有n个环，从每个环中选出若干条不相邻的边，问选出k条边一共有多少种选法

## 解题方法

首先考虑$k$个数中任何两个数不相邻的组合，可以将问题转化，即从$n - k + 1$个数中选出$k$个，然后再向这$k$个数中间插入$k - 1$个数，即可保证两两不相邻。再考虑环的答案。环与链的不同仅仅在于$1$和$n$也不能相邻。我们考虑正难则反的思想，钦定$1$和$n$必须被选择，如此$2$和$n - 1$必定不能被选择，问题转化为$n = n - 4$和$k - 2$的情况，故答案为：

$$\left( \begin{array}{c} n - k + 1 \\ k \end{array} \right) - \left( \begin{array}{c} n - k - 1 \\ k - 2 \end{array} \right)$$

