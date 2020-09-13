// Disjoint set union algorithm for joining and testing whether two are in same set
// Beware of possible stack overflows, may need a large stack memory
// by ttrkaya
// 01 oct 2015

#include <iostream>
#include <vector>

namespace disj{

using namespace std;

int n;
vector<int> dsu;

int find(int x) { return x == dsu[x] ? x : dsu[x] = find(dsu[x]); }
void join(int x, int y) { dsu[find(x)] = find(y); }

void test(int testId, int x, int y){
	cout << "Test #" << testId << ": " << (find(x) == find(y) ? "IN" : "OUT") << endl;
}
	
}

int mainDisj(){
	using namespace disj;

	int curTestId = 1;

	n = 2;
	dsu.resize(n);
	for (int i = 0; i < n; i++) dsu[i] = i;
	test(curTestId++, 0, 1);

	n = 2;
	dsu.resize(n);
	for (int i = 0; i < n; i++) dsu[i] = i;
	join(0, 1);
	test(curTestId++, 0, 1);

	n = 3;
	dsu.resize(n);
	for (int i = 0; i < n; i++) dsu[i] = i;
	join(0, 1);
	join(1, 2);
	test(curTestId++, 0, 2);

	n = 4;
	dsu.resize(n);
	for (int i = 0; i < n; i++) dsu[i] = i;
	join(0, 1);
	join(2, 3);
	test(curTestId++, 0, 3);

	n = 1000;
	dsu.resize(n);
	for (int i = 0; i < n; i++) dsu[i] = i;
	for (int i = 0; i < n / 2; i++) join(i, i + 1);
	for (int i = n / 2 + 1; i < n - 1; i++) join(i, i + 1);
	test(curTestId++, n / 2, n / 2 + 1);

	n = 1000;
	dsu.resize(n);
	for (int i = 0; i < n; i++) dsu[i] = i;
	for (int i = 0; i < n / 2; i++) join(i, i + 1);
	for (int i = n / 2 + 1; i < n - 1; i++) join(i, i + 1);
	join(n / 2, n / 2 + 1);
	test(curTestId++, 0, n - 1);

	return 0;
}