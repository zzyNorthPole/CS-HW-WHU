# Link/Cut Tree

lct这种数据结构，维护的是一棵树的连通性，因此在维护图的连通性时，需要对之进行相应的修改。

首先要明确，lct是另一种形式上的树链剖分，即实链剖分。对于每一个父亲而言，其左右儿子与之处于同一条实链中；而对于每一个儿子而言，其父亲不一定与之处于同一条实链中。我们通过动态修改这种实链与虚链，来维护结构，寻找答案。

其次，在同一棵splay中维护的数据，左儿子对应的是原树中的祖先节点，右儿子对应的是原树中实链上的后继节点，这是lct维护的根本内容。明确这一点是理解lct各种操作的前提。

为了适配lct，我们需要对splay树操作中的rot和splay操作进行适当的修改。

回忆原先的splay树中，我们对于rot操作，需要控制每一个被操作的对象不为0.在lct中，对于x的儿子节点这一点不变，对于x的爷爷节点则有变化。因为此时splay树顶端的不一定为0，可能为另一棵splay上的一个结点，因此我们应该使用 $nrt(x)$ 操作来进行判断，具体的方法如下所示：

```C
#define nrt(x) (x == ls(fa[x]) || x == rs(fa[x]))
```

接下来就是lct中的特色操作 $access(x)$ 。这一操作的目的在于，完成实链和虚链的变化，更为详细的表述是，使当前节点 $x$ 处于实链中。

其具体的过程也是比较简单的，其本质上有两部分，首先断开 $x$ 的后继节点，这也是 $w = 0$ 的原因，其次是每一次将当前节点旋转到该splay树的根节点，与父亲节点建立实父子关系，然后逐步上跳，直至顶端。

```C
void access(int x) {
	int w = 0;
	while (x) {
		splay(x);
		rs(x) = w, upd(x);
		w = x, x = fa[x];
	}
}
```

接下来是根据lct的基础操作进行的一些实际操作：

首先是 $link(u, v)$ ：

连接操作进行时，首先要把 $u$ 变换成根节点，我们将它简单的写为 $mkrt(u)$ 操作。

这个操作的具体过程比较简单，首先将 $u$ 放置在实链中，之后将之旋转到根节点。之后就有一个比较重要的处理，即需要翻转左右子树。

前文中提及，左子树是根节点在原树上的祖先。但是当前需要把根节点变为原树上的根，相当于原来的整棵树从根节点一直到根倒置过来，根据树上up-down-dp的有关知识类推，我们可以知道只有祖先所在的链需要翻转，其余部分的关系并没有发生变化，因此我们只需要简单的在splay树上打上 $rev$ 懒标记即可。

我们在两种情况下需要下传 $rev$ 标记，第一种情况是当从上向下搜索时，第二种情况是进行splay操作时。情况一较好理解，下传才能使我们正确读取相应的信息；情况二稍微复杂一些，因为splay操作与该节点为父亲节点的左儿子/右儿子有重要关系，因此我们需要提前下传该链所在的 $rev$ 信息，具体是通过维护一个栈来实现。

在处理完 $u$ 节点后，我们对 $v$ 进行处理，我们将 $v$ 节点放置到实链中，使之旋转到根节点，之后在其左子树中查找 $u$ ，如果没有找到，则说明未连接，我们将 $u$ 接到 $v$ 上，简单的接为一条虚边即可。

接下来讨论一下 $cut(u, v)$ ：

其前置过程与 $link(u, v)$ 几乎相同，在 $v$ 成为根节点后，存在如下的几种可能

1. $u$ 与 $v$ 不连通
2. $u$ 与 $v$ 连通但不直接连通
3. $u$ 与 $v$ 直接连通

只有情况3我们需要进行 $cut$ 操作。

我们考虑一下判断情况。首先 $fdrt(v) == u
$ 即可排除情况1。

接下来我们考虑连通的左子树情况。因为 $u$ 是根节点，因此如果 $u$ 和 $v$ 直接相连，那么左子树有且仅有 $u$ 一个节点，故判断条件可以写作 $fa[u] == v \&\& rs(u) == 0
$ 。

再讨论 $qry(u, v)$ ：

其前置过程与 $link(u, v)$ 依然相同，因为此时 $u$ 节点已经为根，其不存在祖先节点，那么左子树的答案加上根节点 $v$ 的答案就是查询的结果。

```C++
namespace lct {
	int fa[N], son[N][2], sum[N], val[N], rev[N];
	#define ls(x) son[x][0]
	#define rs(x) son[x][1]
	#define idf(x) (x == rs(fa[x]))
	#define nrt(x) (x == ls(fa[x]) || x == rs(fa[x]))
	void upd(int x) {
		sum[x] = sum[ls(x)] ^ sum[rs(x)] ^ val[x];
	}
	void spd(int x) {
		if (rev[x]) {
			rev[x] = 0;
			swap(ls(x), rs(x));
			ls(x) && (rev[ls(x)] ^= 1);
			rs(x) && (rev[rs(x)] ^= 1);
		}
	}
	void rot(int x) {
		int v = fa[x], u = fa[v], tmp = idf(x), w = son[x][tmp ^ 1];
		son[v][tmp] = w, w && (fa[w] = v);
		nrt(v) && (son[u][idf(v)] = x), fa[x] = u;
		son[x][tmp ^ 1] = v, fa[v] = x;
		upd(v), upd(x);
	}
	void splay(int x) {
		stack <int> stk;
		while (nrt(x)) stk.push(x), x = fa[x];
		stk.push(x);
		while (!stk.empty()) x = stk.top(), stk.pop(), spd(x);
		while (nrt(x)) {
			int v = fa[x];
			if (nrt(v)) rot(idf(v) == idf(x) ? v : x);
			rot(x);
		}
	}
	void access(int x) {
		int w = 0;
		while (x) {
			splay(x);
			rs(x) = w, upd(x);
			w = x, x = fa[x];
		}
	}
	void mkrt(int x) {
		access(x), splay(x), rev[x] ^= 1;
	}
	int fdrt(int x) {
		spd(x);
		while (son[x][0]) x = son[x][0], spd(x);
		return x;
	}
	void link(int u, int v) {
		mkrt(u);
		access(v);
		splay(v);
		if (fdrt(v) == u) return;
		fa[u] = v;
	}
	void cut(int u, int v) {
		// no connect
		// connect but not neighbour
		// connect directly
		mkrt(u);
		access(v);
		splay(v);
		if (fdrt(v) == u && fa[u] == v && rs(u) == 0) {
			fa[u] = ls(v) = 0, upd(u);
		}
	}
	void chg(int x, int key) {
		mkrt(x);
		val[x] = key, upd(x);
	}
	int qry(int u, int v) {
		mkrt(u);
		access(v);
		splay(v);
		return sum[ls(v)] ^ val[v];
	}
}
```
