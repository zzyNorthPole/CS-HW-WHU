# 一些取模运算的处理方法

```C++
int add(int x, int y) {
	return (x + y) % mod;
}
int sub(int x, int y) {
	return x > y ? x - y : x - y + mod;
}
int mul(int x, int y) {
	return 1ll * x * y % mod;
}
```